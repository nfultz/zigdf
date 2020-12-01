const std = @import("std");
const mem = std.mem;
const Allocator = mem.Allocator;



pub fn NamedVector(comptime T: type) type {
  return struct {
    const Self = @This();
    data: std.ArrayList(T),
    name: std.ArrayList([] const u8),

    pub fn init(allocator: *Allocator) Self {

      return Self {
        .data = std.ArrayList(T).init(allocator),
        .name = std.ArrayList([] const u8).init(allocator),
      };

    }

    pub fn deinit(self: Self) void {
      self.data.deinit();
      self.name.deinit();

    }

  };
}

const IntVector = NamedVector(i32);
const FloatVector = NamedVector(f64);
const StringVector = NamedVector([]const u8);
const BoolVector = NamedVector(bool);
const PtrVector = NamedVector(usize);

const DataFrameColType = enum {
  int,
  float,
  string,
  bool,
  ptr,
};

const DataFrameCol = union(DataFrameColType) {
  int: IntVector,
  float: FloatVector,
  string: StringVector,
  bool: BoolVector,
  ptr: PtrVector,

  pub fn loc(self: DataFrameCol, idx: DataFrameCol) DataFrameCol {


      return self;
  }
};

const DataFrame = struct {

  cols: NamedVector(*DataFrameCol),

  pub fn init(allocator: *Allocator) DataFrame {
    return .{.cols= NamedVector(*DataFrameCol).init(allocator) };
  }

  pub fn deinit(self: DataFrame) void {
    self.cols.deinit();

  }

  pub fn append(self: *DataFrame, name: [] const u8, val: *DataFrameCol) !void {
    try self.cols.data.append(val);
    try self.cols.name.append(name);
  }
  

  pub fn foo(self: DataFrame) u8 {
    return 0;
  }

};


test "Make a data frame" {
  

  var x1  = IntVector.init(std.testing.allocator);
  defer x1.deinit();

  try x1.data.append(3);
  try x1.data.append(4);
  try x1.data.append(5);

  var y1  = FloatVector.init(std.testing.allocator);
  defer y1.deinit();

  try y1.data.append(3.0);
  try y1.data.append(4.0);
  try y1.data.append(5.0);

  const stdout = std.io.getStdOut().outStream();
  try stdout.print("x1 type, {}!\n", .{@typeName(@TypeOf(x1))});
  try stdout.print("x1 value, {}!\n", .{x1.data.items[0]});
  try stdout.print("y1 type, {}!\n", .{@typeName(@TypeOf(y1))});
  try stdout.print("y1 value, {}!\n", .{y1.data.items[0]});

  var df : DataFrame = DataFrame.init(std.testing.allocator);
  defer df.deinit();

  var dfc_x1 : DataFrameCol =  .{.int= x1};
  var dfc_y1 : DataFrameCol =  .{.float= y1};


  try df.append("x", &dfc_x1);
  try df.append("y", &dfc_y1);

  try stdout.print("df ncols, {}!\n", .{df.cols.data.items.len});


  try stdout.print("df[0,1] value, {}!\n", .{df.cols.data.items[1].float.data.items[0]});

  

}

pub fn main() !void {
}
