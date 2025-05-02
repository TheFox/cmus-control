const std = @import("std");
const LazyPath = std.Build.LazyPath;
const print = std.debug.print;
const allocPrint = std.fmt.allocPrint;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSmall,
    });
    const build_all = b.option(bool, "buildall", "Enable build-all mode") orelse false;
    const sdk_path_n = b.option([]const u8, "sdk", "SDK path");

    print("target arch: {s}\n", .{@tagName(target.result.cpu.arch)});
    print("target cpu: {s}\n", .{target.result.cpu.model.name});
    print("target os: {s}\n", .{@tagName(target.result.os.tag)});
    print("optimize: {s}\n", .{@tagName(optimize)});
    print("build all: {any}\n", .{build_all});

    if (sdk_path_n) |sdk_path| {
        print("SDK: {s}\n", .{sdk_path});
    }

    var target_name: []u8 = undefined;
    if (build_all) {
        target_name = allocPrint(
            b.allocator,
            "cmuscontrold-{s}-{s}",
            .{
                @tagName(target.result.cpu.arch),
                target.result.cpu.model.name,
            },
        ) catch @panic("failed to allocate target name");
    } else {
        target_name = allocPrint(b.allocator, "cmuscontrold", .{}) catch @panic("failed to allocate target name");
    }

    const exe = b.addExecutable(.{
        .name = target_name,
        .target = target,
        .optimize = optimize,
        .strip = true,
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

    if (sdk_path_n) |sdk_path| {
        const sdk_path_l: LazyPath = .{
            .cwd_relative = sdk_path,
        };
        exe.addFrameworkPath(sdk_path_l);
    }

    const options = b.addOptions();
    options.addOption(bool, "buildall", build_all);
    exe.root_module.addOptions("config", options);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
