const std = @import("std");

fn part1(input: []u8) !void {
    var ranges = std.mem.splitAny(u8, input, ","); 
    var invalidNumSum: u64 = 0;
    while (ranges.next()) |range| {
        if (range.len == 0) continue;
        var parsedRange = std.mem.splitAny(u8, std.mem.trim(u8, range, "\n"), "-");
        const start = try std.fmt.parseInt(u64, parsedRange.next().?, 10);
        const end = try std.fmt.parseInt(u64, parsedRange.next().?, 10);

        var invalidNumbers: std.ArrayList(usize) = .empty;
        defer invalidNumbers.deinit(std.heap.page_allocator);
        for (start..end+1) |number| {
            const numStr = try std.fmt.allocPrint(std.heap.page_allocator, "{d}", .{number});
            defer std.heap.page_allocator.free(numStr);
            if (numStr.len % 2 == 0) {
                const half = numStr.len / 2;
                if (std.mem.eql(u8, numStr[0..half], numStr[half..])) {
                    invalidNumSum += number;
                    try invalidNumbers.append(std.heap.page_allocator, number);
                }
            }
        }
    }
    std.debug.print("Part 1: {d}\n", .{invalidNumSum});
}

fn has_sequence(number: usize) !bool {
    const numStr = try std.fmt.allocPrint(std.heap.page_allocator, "{d}", .{number});
    if (numStr.len < 2) {
        return false;
    }

    var possibleSequences: std.ArrayList(usize) = .empty;
    defer possibleSequences.deinit(std.heap.page_allocator);
    const first_char = numStr[0];
    var i: usize = 1;
    while (i < numStr.len) : (i += 1) {
        if (numStr[i] != first_char) {
            break;
        }
    }
    if (i == numStr.len) {
        return true;
    }

    var max_sequence = numStr.len / 2;
    while (max_sequence > 1) {
        if (numStr.len % max_sequence == 0) {
            try possibleSequences.append(std.heap.page_allocator, max_sequence);
        }
        max_sequence -= 1;
    }
    for (possibleSequences.items) |sequence_size| {
        const expected_sequence = numStr[0..sequence_size];
        var current_start: usize = sequence_size;
        while (current_start <= numStr.len-sequence_size) {
            if (!std.mem.eql(u8, expected_sequence, numStr[current_start..current_start+sequence_size])) {
                break;
            }
            current_start += sequence_size;
        }
        if (current_start == numStr.len) {
            return true;
        }

    }
    return false;
}

fn part2(input: []u8) !void {
    var ranges = std.mem.splitAny(u8, input, ","); 
    var invalidNumSum: u64 = 0;
    while (ranges.next()) |range| {
        if (range.len == 0) continue;
        var parsedRange = std.mem.splitAny(u8, std.mem.trim(u8, range, "\n"), "-");
        const start = try std.fmt.parseInt(u64, parsedRange.next().?, 10);
        const end = try std.fmt.parseInt(u64, parsedRange.next().?, 10);
        var invalidNumbers: std.ArrayList(usize) = .empty;
        defer invalidNumbers.deinit(std.heap.page_allocator);
        for (start..end+1) |number| {
            if (try has_sequence(number)) {
                invalidNumSum += number;
            }
        }
    }
    std.debug.print("Part 2: {d}\n", .{invalidNumSum});
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
