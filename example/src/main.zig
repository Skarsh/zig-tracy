const std = @import("std");
const tracy = @import("tracy");

pub fn main() !void {
    tracy.hello();
    while (true) {}
}
