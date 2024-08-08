const std = @import("std");
const engine = @import("engine.zig");

const c = @cImport({
    @cInclude("SDL.h");
    @cInclude("SDL_render.h");
    @cInclude("stdio.h");
});

pub const keycode = enum {
    pub const KEYCODE_A = c.SDL_SCANCODE_A;
    pub const KEYCODE_B = c.SDL_SCANCODE_B;
    pub const KEYCODE_C = c.SDL_SCANCODE_C;
    pub const KEYCODE_D = c.SDL_SCANCODE_D;
    pub const KEYCODE_E = c.SDL_SCANCODE_E;
    pub const KEYCODE_F = c.SDL_SCANCODE_F;
    pub const KEYCODE_G = c.SDL_SCANCODE_G;
    pub const KEYCODE_H = c.SDL_SCANCODE_H;
    pub const KEYCODE_I = c.SDL_SCANCODE_I;
    pub const KEYCODE_J = c.SDL_SCANCODE_J;
    pub const KEYCODE_K = c.SDL_SCANCODE_K;
    pub const KEYCODE_L = c.SDL_SCANCODE_L;
    pub const KEYCODE_M = c.SDL_SCANCODE_M;
    pub const KEYCODE_N = c.SDL_SCANCODE_N;
    pub const KEYCODE_O = c.SDL_SCANCODE_O;
    pub const KEYCODE_P = c.SDL_SCANCODE_P;
    pub const KEYCODE_Q = c.SDL_SCANCODE_Q;
    pub const KEYCODE_R = c.SDL_SCANCODE_R;
    pub const KEYCODE_S = c.SDL_SCANCODE_S;
    pub const KEYCODE_T = c.SDL_SCANCODE_T;
    pub const KEYCODE_U = c.SDL_SCANCODE_U;
    pub const KEYCODE_V = c.SDL_SCANCODE_V;
    pub const KEYCODE_W = c.SDL_SCANCODE_W;
    pub const KEYCODE_X = c.SDL_SCANCODE_X;
    pub const KEYCODE_Y = c.SDL_SCANCODE_Y;
    pub const KEYCODE_Z = c.SDL_SCANCODE_Z;

    pub const KEYCODE_SPACE = c.SDL_SCANCODE_SPACE;

    pub const KEYCODE_LEFT = c.SDL_SCANCODE_LEFT;
    pub const KEYCODE_RIGHT = c.SDL_SCANCODE_RIGHT;
    pub const KEYCODE_UP = c.SDL_SCANCODE_UP;
    pub const KEYCODE_DOWN = c.SDL_SCANCODE_DOWN;
};

var prevKeys: [512]c_int = undefined;

pub fn savePrev() !void {
    var size: c_int = undefined;
    const keys = c.SDL_GetKeyboardState(&size);
    if (size != @as(c_int, @intCast(prevKeys.len))) {
        return engine.SDL_Error.input;
    }
    for (prevKeys, 0..) |_, i| {
        prevKeys[i] = keys[i];
    }
}

pub fn getKeyDown(key: c_int) bool {
    const keys = c.SDL_GetKeyboardState(null);
    return keys[@intCast(key)] > 0 and prevKeys[@intCast(key)] == 0;
}

pub fn getKey(key: c_int) bool {
    const keys = c.SDL_GetKeyboardState(null);
    return keys[@intCast(key)] > 0;
}

pub fn getKeyUp(key: c_int) bool {
    const keys = c.SDL_GetKeyboardState(null);
    return keys[@intCast(key)] == 0 and prevKeys[@intCast(key)] > 0;
}
