const std = @import("std");

pub fn readFile(path: []const u8) ![]u8 {
    var file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();
    const contents = try file.readToEndAlloc(std.heap.page_allocator, 32768);
    return contents;
}
