const std = @import("std");

const  Point  = struct {
    x: i32,
    y: i32,
};

fn readGrid(input: []u8) !std.AutoArrayHashMap(Point, u8) {
    var grid = std.AutoArrayHashMap(Point, u8).init(std.heap.page_allocator);
    var row: i32 = 0;
    var col: i32 = 0;

    var it = std.mem.splitAny(u8, input, "\n");
    while (it.next()) |line| {
        col = 0;
        for (line) |char| {
            _ = try grid.put(Point{ .x = col, .y = row }, char);
            col += 1;
        }
        row += 1;
    }
    return grid;
}

fn isBlocked(grid: std.AutoArrayHashMap(Point, u8), point: Point) bool {
    const directions = [_]Point{
        .{ .x = -1, .y = -1 }, 
        .{ .x = 0, .y = -1 }, 
        .{ .x = 1, .y = -1 },
        .{ .x = -1, .y = 0 },                    
        .{ .x = 1, .y = 0 },
        .{ .x = -1, .y = 1 },  
        .{ .x = 0, .y = 1 },  
        .{ .x = 1, .y = 1 },
    };

    var blocked: usize = 0;
    for (directions) |dir| {
        const neighbor_point = Point{
            .x = point.x + dir.x,
            .y = point.y + dir.y,
        };
        if (grid.get(neighbor_point) ) |value| {
            if (value == '@' ) {
                blocked += 1;
            }
        }
    }
    return blocked >= 4;
}

fn part1(input: []u8) !void {
    var grid = try readGrid(input);
    defer grid.deinit();
    var unblocked_count: usize = 0;
    var it = grid.iterator();
    while (it.next()) |entry| {
        const point = entry.key_ptr.*;
        const value = entry.value_ptr.*;
        if (value == '@' ) {
            if (!isBlocked(grid, point)) {
                unblocked_count += 1;
            }
        }
    }
    std.debug.print("Part 1: {d}\n", .{unblocked_count});
}

fn part2(input: []u8) !void {
    var grid = try readGrid(input);
    defer grid.deinit();
    var removed: usize = 0;
    while (true) {
        var it = grid.iterator();
        var to_remove = std.ArrayList(Point).empty;
        while (it.next()) |entry| {
            const point = entry.key_ptr.*;
            const value = entry.value_ptr.*;
            if (value == '@' ) {
                if (!isBlocked(grid, point)) {
                    _ = try to_remove.append(std.heap.page_allocator, point);    
                }
            }
        }
        if (to_remove.items.len == 0) {
            break;
        }
        removed += to_remove.items.len;
        for (to_remove.items) |point| {
            _ = grid.orderedRemove(point);
        }
    }


    std.debug.print("Part 2 solution goes here. {any}\n", .{removed});
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
