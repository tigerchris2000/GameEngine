const std = @import("std");
const geo = @import("geometry.zig");
const color = @import("color.zig");
const alloc = std.heap.page_allocator;

const c = @cImport({
    @cInclude("SDL.h");
    @cInclude("SDL_render.h");
    @cInclude("stdio.h");
});

pub const SDL_Error = error{
    initialize,
    render,
};

pub const app = struct {
    renderer: ?*c.SDL_Renderer,
    window: ?*c.SDL_Window,
    width: i32,
    height: i32,
};

var App = app{ .window = null, .renderer = null, .width = undefined, .height = undefined };

pub fn initSDL(name: []const u8, width: i32, height: i32) !void {
    const rendererFlags: u32 = c.SDL_RENDERER_ACCELERATED | c.SDL_RENDERER_PRESENTVSYNC;
    const windowFlags: u32 = 0;
    if (c.SDL_Init(c.SDL_INIT_VIDEO) < 0) {
        std.debug.print("{s}\n", .{c.SDL_GetError()});
        return SDL_Error.initialize;
    }
    App.window = c.SDL_CreateWindow(@ptrCast(name), c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, width, height, windowFlags);
    if (App.window == null) {
        std.debug.print("{s}\n", .{c.SDL_GetError()});
        return SDL_Error.initialize;
    }
    _ = c.SDL_SetHint(c.SDL_HINT_RENDER_SCALE_QUALITY, "linear");
    App.renderer = c.SDL_CreateRenderer(App.window, -1, rendererFlags);
    if (App.renderer == null) {
        std.debug.print("{s}\n", .{c.SDL_GetError()});
        return SDL_Error.initialize;
    }

    App.width = width;
    App.height = height;
}

pub fn deinitSDL() void {
    geo.deinit(std.heap.page_allocator);
    c.SDL_DestroyWindow(App.window);
    c.SDL_DestroyRenderer(App.renderer);
    c.SDL_Quit();
}

pub fn prepareScene() !void {
    if (c.SDL_RenderClear(App.renderer) == -1) {
        std.debug.print("Can't clear render\n", .{});
        std.debug.print("{s}\n", .{c.SDL_GetError()});
        return SDL_Error.render;
    }
    geo.clear();

    if (c.SDL_SetRenderDrawColor(App.renderer, 0, 0, 0, 255) == -1) {
        std.debug.print("Can't render background color\n", .{});
        std.debug.print("{s}\n", .{c.SDL_GetError()});
        return SDL_Error.render;
    }
    for (0..10) |i| {
        try geo.createTriangle(alloc, color.RED, .{
            .{ .x = @floatFromInt(i * 10), .y = 0 },
            .{ .x = @floatFromInt((i + 1) * 10), .y = @floatFromInt(App.height) },
            .{ .x = @floatFromInt(i * 10), .y = @floatFromInt(App.height) },
        });
    }
    try geo.createRect(alloc, color.BLUE, .{ .x = 200, .y = 200 }, 30, 50);
    try geo.render(App);
}

pub fn presentScene() void {
    c.SDL_RenderPresent(App.renderer);
}
