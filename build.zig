const std = @import("std");
const LazyPath = std.Build.LazyPath;
const print = std.debug.print;
const aprint = std.fmt.allocPrint;

pub fn build(b: *std.Build) !void {
    const version: std.SemanticVersion = .{ // VERSION
        .major = 2,
        .minor = 2,
        .patch = 0,
        .pre = "dev.1",
    };
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSmall,
    });
    const build_all = b.option(bool, "buildall", "Enable build-all mode") orelse false;

    const target_name = try if (build_all)
        aprint(b.allocator, "cmuscontrold-{s}-{s}", .{ @tagName(target.result.cpu.arch), target.result.cpu.model.name })
    else
        aprint(b.allocator, "cmuscontrold", .{});

    print("target arch: {s}\n", .{@tagName(target.result.cpu.arch)});
    print("target cpu: {s}\n", .{target.result.cpu.model.name});
    print("target os: {s}\n", .{@tagName(target.result.os.tag)});
    print("target name: {s}\n", .{target_name});
    print("optimize: {s}\n", .{@tagName(optimize)});
    print("build all: {any}\n", .{build_all});

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .strip = optimize != .Debug,
    });
    exe_mod.addCSourceFiles(.{
        .files = &[_][]const u8{
            "src/main.m",
            "src/CCApplication.m",
        },
        .flags = &.{
            "-fobjc-arc",
        },
        .language = .objective_c,
    });
    exe_mod.linkFramework("AppKit", .{});
    exe_mod.linkFramework("Foundation", .{});

    const exe = b.addExecutable(.{
        .name = target_name,
        .version = version,
        .root_module = exe_mod,
    });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
