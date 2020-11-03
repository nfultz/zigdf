const std = @import("std");


pub fn NamedVector(comptime T: type) type {
  return struct {
    const Self = @This();
    data: []const T,
    len:  usize,
    name: [*][]const u8,

    pub fn from(data: []const T, name: [*][]const u8) Self {

      return Self {
        .data = data,
        .len  = data.len,
        .name = name,
      };

    }

  };
}

test "Make a data frame" {

  var x  = [_]u8 {11,22,33,44};
  var n  = [_][]const u8 {"test 1", "test4", "test   6", "zz"};

  const c1 = NamedVector(u8).from(x[0..x.len], n[0..n.len]);

  const stdout = std.io.getStdOut().outStream();
  try stdout.print("Hello, {}!\n", .{@typeName(@TypeOf(c1))});

}

pub fn main() !void {
    const stdout = std.io.getStdOut().outStream();
    try stdout.print("Hello, {}!\n", .{"world"});
}
