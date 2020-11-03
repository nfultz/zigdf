
test : dataframe
	zig test dataframe.zig


dataframe : dataframe.zig
	zig build-exe dataframe.zig
