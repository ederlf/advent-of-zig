const std = @import("std");
const day01_year25 = @import("solvers/01_25.zig");
const day02_year25 = @import("solvers/02_25.zig");
const day03_year25 = @import("solvers/03_25.zig");
const file = @import("helpers/file.zig");

const Date = struct {
    year: [:0]const u8, 
    day: [:0]const u8,
};

fn equal_date(a: Date, b: Date) bool {
    return std.mem.eql(u8, a.year, b.year) and std.mem.eql(u8, a.day, b.day);
}

fn parse_args() !Date {
    const allocator = std.heap.page_allocator;
    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.next(); // skip executable name

    const day  = args.next() orelse return error.MissingDay;
    const year = args.next() orelse return error.MissingYear;

    return .{ .year = year, .day = day };
}

const Solver = struct {
    date: Date,
    solve: *const fn ([]u8) void,
};


pub const solvers = [_]Solver{
    .{ .date = .{ .day = "01", .year = "2025"}, .solve = day01_year25.solve },
    .{ .date = .{ .day = "02", .year = "2025"}, .solve = day02_year25.solve },
    .{ .date = .{ .day = "03", .year = "2025"}, .solve = day03_year25.solve },
};

pub fn main() !void {
    const date = parse_args() catch |err| {
        switch (err) {
            error.MissingYear => std.debug.print("Missing year argument. e.g, 2025 \n", .{}),
            error.MissingDay  => std.debug.print("Missing day argument. e.g, 01 \n", .{}),
        }
        return;
    };

    if (findSolver(date)) |solver| {
        const input_file = getInputPath(date.year, date.day);
        const input = file.readFile(input_file) catch |err| {
            std.debug.print("Failed to read input file: {s} {}\n", .{input_file, err});
            return;
        };
        defer std.heap.page_allocator.free(input);
        solver(input);
    } else {
        std.debug.print("No solver\n", .{});
    }

}

fn getInputPath(year: [:0]const u8, day: [:0]const u8) []const u8 {
    return std.fmt.allocPrint(std.heap.page_allocator, "inputs/day{s}_year{s}.txt", .{day, year}) catch unreachable;
}

fn findSolver(date: Date) ?*const fn([]u8) void {
    inline for (solvers) |s| {
        if (equal_date(s.date, date))
            return s.solve;
    }
    return null;
}
