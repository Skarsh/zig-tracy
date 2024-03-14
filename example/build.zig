const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tracy = b.dependency("tracy", .{
        .target = target,
        .optimize = optimize,
    });

    const install_dir = std.Build.Step.InstallArtifact.Options.Dir{ .override = .{ .bin = {} } };
    const install_tracy = b.addInstallArtifact(tracy.artifact("tracy"), .{
        .dest_dir = install_dir,
        .pdb_dir = install_dir,
    });
    b.getInstallStep().dependOn(&install_tracy.step);

    const exe = b.addExecutable(.{
        .name = "tracy-example",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addImport("tracy", tracy.module("tracy"));
    exe.linkLibrary(tracy.artifact("tracy"));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
