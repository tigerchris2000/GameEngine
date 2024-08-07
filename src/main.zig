const c = @cImport({
    @cInclude("SDL.h");
    @cInclude("SDL_render.h");
    @cInclude("stdio.h");
});

const std = @import("std");
const geo = @import("geometry.zig");
const colors = @import("color.zig");
const engine = @import("engine.zig");
const input = @import("input.zig");

const width: i32 = 640;
const height: i32 = 480;
const name = "Game Engine";

pub fn main() !void {
    try engine.initSDL(name, width, height);
    defer engine.deinitSDL();
    try engine.prepareScene();
    engine.presentScene();
    c.SDL_Delay(3000);
    var event: c.SDL_Event = undefined;
    _ = c.SDL_PollEvent(&event);
    _ = input.getKeyDown('a');
}
