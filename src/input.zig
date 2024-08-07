const std = @import("std");
const c = @cImport({
    @cInclude("SDL.h");
    @cInclude("SDL_render.h");
    @cInclude("stdio.h");
});

pub fn getKeyDown(key: u8) bool {
    _ = key;
    const keys = c.SDL_GetKeyboardState(null);
    if (keys[c.SDL_SCANCODE_A] > 0) {
        std.debug.print("pressed\n", .{});
    }
    return false;
}

pub fn getKey(key: u8) bool {
    _ = key;
    return false;
}

pub fn getKeyUp(key: u8) bool {
    _ = key;
    return false;
}
