const build_options = @import("build_options");
const std = @import("std");
const File = std.Io.File;
const Writer = std.Io.Writer;
const process = std.process;
const eql = std.mem.eql;

extern fn nsapp_main(argc: c_int, argv: [*]const [:0]const u8) c_int;

pub fn main(init: std.process.Init) !void {
    const minimal = init.minimal;
    const gpa = init.arena.allocator();

    const stdout_buffer = try gpa.alloc(u8, 1024);
    defer gpa.free(stdout_buffer);
    var stdout_writer = File.stdout().writer(init.io, stdout_buffer);
    const stdout = &stdout_writer.interface;

    const stderr_buffer = try gpa.alloc(u8, 1024);
    defer gpa.free(stderr_buffer);
    var stderr_writer = File.stderr().writer(init.io, stderr_buffer);
    const stderr = &stderr_writer.interface;

    try stdout.print("CmusControl " ++ build_options.VERSION ++ "\n", .{});
    try stdout.print("Copyright (C) 2015 Christian Mayer <https://fox21.at>\n", .{});
    try stdout.flush();

    const args = try minimal.args.toSlice(gpa);
    const argc: c_int = @intCast(args.len);
    const argv = args.ptr;
    var args_iter = minimal.args.iterate();
    defer args_iter.deinit();
    _ = args_iter.next();

    while (args_iter.next()) |arg| {
        if (eql(u8, arg, "-h") or eql(u8, arg, "--help")) {
            try printHelp(stdout);
            return;
        } else {
            try stderr.print("ERROR: unknown argument: {s}\n", .{arg});
            try stderr.flush();
            return;
        }
    }

    _ = nsapp_main(argc, argv);
}

fn printHelp(stdout: *Writer) !void {
    const help =
        \\Usage: cmuscontrold [-h|--help]
        \\
        \\Options:
        \\-h, --help           Print this help.
    ;
    try stdout.print(help ++ "\n", .{});
    try stdout.flush();
}
