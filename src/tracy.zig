const std = @import("std");

pub fn hello() void {
    std.debug.print("hello from tracy client lib", .{});
}
