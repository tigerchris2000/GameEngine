const sdl = @cImport({
    @cInclude("SDL.h");
});
const std = @import("std");

const SDLError = error{
    initialize,
};

pub fn main() !void {
    std.debug.print("Initializing SDL\n", .{});
    const err: c_int = sdl.SDL_Init(sdl.SDL_INIT_VIDEO | sdl.SDL_INIT_AUDIO);
    if (err == -1) {
        std.debug.print("Could not initialize SDL\n", .{});
        return SDLError.initialize;
    }
    std.debug.print("SDL initialized\n", .{});
    std.debug.print("Quitting SDL\n", .{});
    _ = sdl.SDL_Quit();
    std.debug.print("Quitting ...\n", .{});
}
