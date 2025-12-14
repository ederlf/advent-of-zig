const std = @import("std");

const Range = struct {
    start: usize,
    end: usize,

    pub fn in_range(self: *Range, number: usize) bool {
        return (number >= self.start and number <= self.end); 
    }
};

fn part1(input: []u8) !void {
    var lines = std.mem.splitAny(u8, input, "\n");
    var fresh_ingredients = std.ArrayList(Range).empty;
    defer fresh_ingredients.deinit(std.heap.page_allocator);
    while(lines.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var range = std.mem.splitAny(u8, line, "-");
        const start = try std.fmt.parseInt(usize, range.next().?, 10);
        const end = try std.fmt.parseInt(usize, range.next().?, 10);
        try fresh_ingredients.append(std.heap.page_allocator, Range{ .start = start, .end = end });
    }
    var fresh: usize = 0;
    while(lines.next()) |line| {
        if (line.len == 0) {
            break;
        }
        const ingredient = try std.fmt.parseInt(usize, line, 10);
        for (fresh_ingredients.items) |*range| {
            if (range.in_range(ingredient)) {
                fresh += 1;
                break;
            }
        }
    }
    std.debug.print("Part 1: {d}\n", .{fresh});
}

fn ranges_overlap(a: Range, b: Range) bool {
    return (a.start <= b.end and b.start <= a.end);
}

fn merge_ranges(a: Range, b: Range) Range {
    return Range{
        .start = if (a.start < b.start) a.start else b.start,
        .end = if (a.end > b.end) a.end else b.end,
    };
} 


fn part2(input: []u8) !void {
    var lines = std.mem.splitAny(u8, input, "\n");
    var fresh_ingredients = std.ArrayList(Range).empty;
    defer fresh_ingredients.deinit(std.heap.page_allocator);
    while(lines.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var range = std.mem.splitAny(u8, line, "-");
        const start = try std.fmt.parseInt(usize, range.next().?, 10);
        const end = try std.fmt.parseInt(usize, range.next().?, 10);
        try fresh_ingredients.append(std.heap.page_allocator, Range{ .start = start, .end = end });
    }
    var current : usize = 0;
    var processed: usize = 0;
    const all_items = fresh_ingredients.items.len;
    while(processed < all_items) {
        var merged = false;
        for (current + 1..fresh_ingredients.items.len) |i| {    
            if (ranges_overlap(fresh_ingredients.items[current], fresh_ingredients.items[i])) {
                fresh_ingredients.items[current] = merge_ranges(fresh_ingredients.items[current], fresh_ingredients.items[i]);
                _ = fresh_ingredients.swapRemove(i);
                processed += 1;
                merged = true;
                break;
            } 
        }
        if (!merged) {
            processed += 1;
            current += 1;
        }
    }

    var fresh_count: usize = 0;
    for (fresh_ingredients.items) |range| {
        fresh_count += range.end - range.start + 1;
    }
    std.debug.print("Part 2: {d}\n", .{fresh_count});
}


pub fn solve(input: []u8) void {
    std.debug.print("Solving 04/25\n", .{});
    part1(input) catch |err| {
        std.debug.print("Failed to solve problem part 1 {}.", .{err});
        return;
    };
    part2(input) catch |err| {
        std.debug.print("Failed to solve problem part 1 {}.", .{err});
        return;
    };
}
