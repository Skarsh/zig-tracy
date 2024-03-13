const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tracy_module = b.addModule("tracy", .{
        .root_source_file = .{ .path = "src/tracy.zig" },
        .target = target,
        .optimize = optimize,
    });

    const tracy_lib = b.addSharedLibrary(.{
        .name = "tracy",
        .root_source_file = .{ .path = "src/tracy.zig" },
        .target = target,
        .optimize = optimize,
    });

    tracy_lib.root_module.addImport("tracy", tracy_module);

    b.installArtifact(tracy_lib);
}
