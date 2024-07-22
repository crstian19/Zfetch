const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const exe = b.addExecutable("neofetch-zig", "src/main.zig");
    exe.setBuildMode(mode);
    exe.setTarget(target);

    exe.install();
}
