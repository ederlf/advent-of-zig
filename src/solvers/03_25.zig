const std = @import("std");

const Digit = std.meta.Tuple(&.{ u8, usize});

fn findLargestDigit(numbers: []const u8, first: usize, last: usize) !Digit {
    var stop_index: usize = first;
    var largest: u8 = 0;
    for (first..last) |index| {
        const n = try std.fmt.charToDigit(numbers[index], 10); 
        if (n > largest) {
            largest = n;
            stop_index = index;
        }
    }
    return .{largest, stop_index};

}

fn findLargestNumber(numbers: []const u8, num_digits: usize) !usize {
    var num: usize = 0;
    var pos: usize = 0;
    var power = num_digits;
    var last = numbers.len - num_digits + 1;
    for (0..num_digits) |_|{
        power -= 1;
        const digit = try findLargestDigit(numbers, pos, last);
        pos = digit.@"1" + 1;
        last += 1;
        num += digit.@"0" * std.math.pow(usize, 10, power);
    }
    return num;
}


fn part1(input: []u8) !void {
    var lines = std.mem.splitAny(u8, input, "\n");
    var sum: usize = 0;
    while (lines.next()) |line| {
       if (line.len == 0) {
           continue;
       }
       sum += try findLargestNumber(line, 2);
    }
    std.debug.print("Part 1: {d}\n", .{sum});
}

fn part2(input: []u8) !void {
    var lines = std.mem.splitAny(u8, input, "\n");
    var sum: usize = 0;
    while (lines.next()) |line| {
       if (line.len == 0) {
           continue;
       }
       sum += try findLargestNumber(line, 12);
    }
    std.debug.print("Part 1: {d}\n", .{sum});
}

pub fn solve(input: []u8) void {
    std.debug.print("Solving 03/25\n", .{});
    part1(input) catch |err| {
        std.debug.print("Failed to solve problem part 1 {}.", .{err});
        return;
    };
    part2(input) catch |err| {
        std.debug.print("Failed to solve problem part 1 {}.", .{err});
        return;
    };
}
