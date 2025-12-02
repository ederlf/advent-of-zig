const std = @import("std");
const advent_of_zig = @import("advent_of_zig");

const Date = struct {
    year: [:0]const u8, 
    day: [:0]const u8,
};

fn parse_args() !Date {
    const allocator = std.heap.page_allocator;
    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.next(); // skip executable name

    const year = args.next() orelse return error.MissingYear;
    const day  = args.next() orelse return error.MissingDay;

    return .{ .year = year, .day = day };
}

pub fn main() !void {
    const date = parse_args() catch |err| {
        switch (err) {
            error.MissingYear => std.debug.print("Missing year argument\n", .{}),
            error.MissingDay  => std.debug.print("Missing day argument\n", .{}),
        }
        return; // exit gracefully
    };

    std.debug.print("Year: {s}, Day: {s}\n", .{ date.year, date.day });
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}
