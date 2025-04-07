const std = @import("std");

extern fn nsapp_main(argc: c_int, argv: [*][:0]u8) c_int;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("CmusControl 2.0.0-dev\n", .{});
    try stdout.print("Copyright (C) 2015 Christian Mayer <https://fox21.at>\n", .{});

    const allocator = std.heap.page_allocator;

    const args = std.process.argsAlloc(allocator) catch unreachable;
    const argc: c_int = @intCast(args.len);
    const argv = args.ptr;

    _ = nsapp_main(argc, argv);
}
