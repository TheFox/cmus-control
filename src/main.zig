const build_options = @import("build_options");
const std = @import("std");
const File = std.Io.File;
const Writer = std.Io.Writer;
const Allocator = std.mem.Allocator;
const print = std.debug.print;
const eql = std.mem.eql;
extern fn nsapp_main(argc: c_int, argv: [*]const [:0]const u8) c_int;

const usage =
    \\Usage: cmuscontrold [-h|--help]
    \\
    \\Options:
    \\-h, --help           Print this help.
;

const ArgError = error{ InvalidArgs, HelpRequested } || Allocator.Error;

fn parseArgs(argv: std.process.Args) ArgError!void {
    var args_iter = argv.iterate();
    defer args_iter.deinit();
    _ = args_iter.next();

    while (args_iter.next()) |arg| {
        if (eql(u8, arg, "-h") or eql(u8, arg, "--help")) {
            return error.HelpRequested;
        } else {
            print("ERROR: unrecognized argument: {s}\n", .{arg});
            return error.InvalidArgs;
        }
    }
}

pub fn main(init: std.process.Init) !u8 {
    const minimal = init.minimal;
    const gpa = init.arena.allocator();

    const stdout_buffer = try gpa.alloc(u8, 1024);
    defer gpa.free(stdout_buffer);
    var stdout_writer = File.stdout().writer(init.io, stdout_buffer);
    const stdout = &stdout_writer.interface;

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
            return 1;
        },
        else => return err,
    };

    const argv = try minimal.args.toSlice(gpa);
    const argc: c_int = @intCast(argv.len);
    return @intCast(nsapp_main(argc, argv.ptr));
}
