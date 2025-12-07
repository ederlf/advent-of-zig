const std = @import("std");

fn part1(input: []u8) !void {
   var it = std.mem.splitAny(u8, input, "\n");
   var dial: i16 = 50;
   var zeroes: i16 = 0;
   while (it.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        const direction = line[0];
        const offset = try std.fmt.parseInt(i16, line[1..], 10);
        if (direction == 'L') {
            dial -= offset;
        } else {
            dial += offset;
        }
        dial = @mod(dial, 100);
        if (dial == 0) {
            zeroes += 1;
        }
    }
    std.debug.print("Part 1: {d}\n", .{zeroes});
}

fn count_zero_clicks(dial: *i16, offset: usize, op: u8) i16 {
    var zeroes: i16 = 0;
    for (0..offset) |_| {
        if (dial.* > 99) {
            dial.* = 0;
        }
        if (dial.* < 0) {
            dial.* = 99;
        }
        if (dial.* == 0) {
            zeroes += 1;
        }
        if (op == 'L') {
            dial.* -= 1;
        } else {
            dial.* += 1;
        }
    }
   return zeroes;
}

fn part2(input: []u8) !void {
   var it = std.mem.splitAny(u8, input, "\n");
   var dial: i16 = 50;
   var zeroes: i16 = 0;
   while (it.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        const direction = line[0];
        const offset = try std.fmt.parseInt(usize, line[1..], 10);
        zeroes += count_zero_clicks(&dial, offset, direction);
    }
    std.debug.print("Part 2: {d}\n", .{zeroes});
}

pub fn solve(input: []u8) void {
    std.debug.print("Solving 01/25\n", .{});
    part1(input) catch |err| {
        std.debug.print("Failed to solve problem part 1 {}.", .{err});
        return;
    };
    part2(input) catch |err| {
        std.debug.print("Failed to solve problem part 1 {}.", .{err});
        return;
    };
}
