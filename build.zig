const std = @import("std");
const print = std.debug.print;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "cmuscontrold",
        .target = target,
        .optimize = optimize,
        .root_source_file = b.path("src/main.zig"),
    });

    exe.addCSourceFiles(.{
        .files = &[_][]const u8{
            "src/main.m",
            "src/CCApplication.m",
        },
        .flags = &.{
            "-fobjc-arc",
        },
        .language = .objective_c,
    });

    exe.linkFramework("AppKit");
    exe.linkFramework("Foundation");

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
