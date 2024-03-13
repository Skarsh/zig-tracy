const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tracy_src = b.dependency("tracy_src", .{});

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

    if (target.result.os.tag == .windows) {
        tracy_lib.linkSystemLibrary("dbghelp");
        tracy_lib.linkSystemLibrary("ws2_32");
    }
    tracy_lib.linkLibCpp();
    tracy_lib.addCSourceFile(.{
        .file = tracy_src.path("./public/TracyClient.cpp"),
        .flags = &.{},
    });

    tracy_lib.root_module.addImport("tracy", tracy_module);

    b.installArtifact(tracy_lib);
}
