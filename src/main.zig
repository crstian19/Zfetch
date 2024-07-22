const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const os_name = try getOSName();
    const kernel_version = try getKernelVersion();
    const memory_info = try getMemoryInfo();

    try stdout.print(
        "\x1b[1;32mSistema Operativo:\x1b[0m {}\n\x1b[1;34mKernel:\x1b[0m {}\n\x1b[1;35mMemoria:\x1b[0m {}\n",
        .{os_name, kernel_version, memory_info}
    );
}

fn getOSName() ![]const u8 {
    const os_release = try std.fs.cwd().openFile("/etc/os-release", .{});
    defer os_release.close();

    const contents = try os_release.readToEndAlloc(std.heap.page_allocator, std.math.maxInt(usize));
    defer std.heap.page_allocator.free(contents);

    const os_name_line = try std.mem.tokenize(contents, "\n")[0]; 
    const os_name = std.mem.tokenize(os_name_line, "=")[1]; 

    return os_name;
}

fn getKernelVersion() ![]const u8 {
    var version_buf: [128]u8 = undefined;
    const read_len = try std.os.readlinkZ("/proc/sys/kernel/osrelease", &version_buf);
    return version_buf[0..read_len];
}

fn getMemoryInfo() ![]const u8 {
    const meminfo = try std.fs.cwd().openFile("/proc/meminfo", .{});
    defer meminfo.close();

    const contents = try meminfo.readToEndAlloc(std.heap.page_allocator, std.math.maxInt(usize));
    defer std.heap.page_allocator.free(contents);

    const mem_total_line = try std.mem.tokenize(contents, "\n")[0]; 
