const VERSION = "2.1.1";
const std = @import("std");
const File = std.fs.File;
const Writer = std.Io.Writer;
const process = std.process;
const eql = std.mem.eql;

extern fn nsapp_main(argc: c_int, argv: [*][:0]u8) c_int;

pub fn main() !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("CmusControl " ++ VERSION ++ "\n", .{});
    try stdout.print("Copyright (C) 2015, 2025 Christian Mayer <https://fox21.at>\n", .{});
    try stdout.flush();

    const allocator = std.heap.page_allocator;

    const args = std.process.argsAlloc(allocator) catch unreachable;
    const argc: c_int = @intCast(args.len);
    const argv = args.ptr;

    var args_iter = try std.process.argsWithAllocator(allocator);
    defer args_iter.deinit();
    _ = args_iter.next();

    while (args_iter.next()) |arg| {
        if (eql(u8, arg, "-h") or eql(u8, arg, "--help")) {
            try print_help(stdout);
            return;
        }
    }

    _ = nsapp_main(argc, argv);
}

fn print_help(stdout: *Writer) !void {
    const help =
        \\Usage: cmuscontrold [-h|--help]
        \\
        \\Options:
        \\-h, --help           Print this help.
    ;
    try stdout.print(help ++ "\n", .{});
    try stdout.flush();
}
