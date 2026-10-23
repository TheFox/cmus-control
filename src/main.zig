const build_options = @import("build_options");
const std = @import("std");
const File = std.Io.File;
const Writer = std.Io.Writer;
const Allocator = std.mem.Allocator;
const eql = std.mem.eql;
extern fn nsapp_main(argc: c_int, argv: [*]const [:0]const u8) c_int;

const usage =
    \\Usage: cmuscontrold [-h|--help]
    \\
    \\Options:
    \\-h, --help           Print this help.
;

const ArgError = error{
    InvalidArgs,
    HelpRequested,
} || Allocator.Error;

const ArgsStatus = struct {
    arg: []const u8 = "",
};
var args_status: ArgsStatus = .{};

fn parseArgs(argv: std.process.Args) ArgError!void {
    var args_iter = argv.iterate();
    defer args_iter.deinit();
    _ = args_iter.next();

    while (args_iter.next()) |arg| {
        args_status.arg = arg;

        if (eql(u8, arg, "-h") or eql(u8, arg, "--help")) {
            return error.HelpRequested;
        } else return error.InvalidArgs;
    }
}

pub fn main(init: std.process.Init) !u8 {
    const minimal = init.minimal;
    const gpa = init.arena.allocator();
    const io = init.io;

    const stdout_buffer = try gpa.alloc(u8, 1024);
    defer gpa.free(stdout_buffer);
    var stdout_writer = File.stdout().writer(io, stdout_buffer);
    const stdout = &stdout_writer.interface;

    const stderr_buffer = try gpa.alloc(u8, 1024);
    defer gpa.free(stderr_buffer);
    var stderr_writer = std.Io.File.stderr().writer(io, stderr_buffer);
    const stderr = &stderr_writer.interface;

    try stdout.print("CmusControl " ++ build_options.VERSION ++ "\n", .{});
    try stdout.print("Copyright (C) 2015 Christian Mayer <https://fox21.at>\n", .{});
    try stdout.flush();

    parseArgs(init.minimal.args) catch |err| switch (err) {
        error.HelpRequested => {
            try stdout.print(usage ++ "\n", .{});
            try stdout.flush();
            return 0;
        },
        error.InvalidArgs => {
            try stderr.print("ERROR: unrecognized argument: {s}\n", .{args_status.arg});
            try stderr.flush();
            return 1;
        },
        else => return err,
    };

    const argv = try minimal.args.toSlice(gpa);
    const argc: c_int = @intCast(argv.len);
    return @intCast(nsapp_main(argc, argv.ptr));
}
