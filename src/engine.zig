const std = @import("std");
const geo = @import("geometry.zig");
const input = @import("input.zig");
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

var startTime: u64 = undefined;
var endTime: u64 = undefined;
var deltaTime: u64 = undefined;

var xpos: f32 = 0;
var ypos: f32 = 0;

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
    xpos = @as(f32, @floatFromInt(width)) / @as(f32, @floatFromInt(2));
    ypos = @as(f32, @floatFromInt(height)) / @as(f32, @floatFromInt(2));
    //var dm: c.SDL_DisplayMode = undefined;
    //_ = c.SDL_GetDesktopDisplayMode(0, &dm);
    //std.debug.print("w:{}, h:{}\n", .{ dm.w, dm.h });
    //c.SDL_SetWindowPosition(App.window, @divFloor(dm.w, @as(c_int, 4)), @divFloor(dm.h, @as(c_int, 3)));
    c.SDL_SetWindowPosition(App.window, (1920 / 2) - @divFloor(width, 2), (1080 / 2) - @divFloor(height, 2));
}

pub fn deinitSDL() void {
    geo.deinit(std.heap.page_allocator);
    c.SDL_DestroyWindow(App.window);
    c.SDL_DestroyRenderer(App.renderer);
    c.SDL_Quit();
}

fn prepareScene() !void {
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
    if (input.getKey(input.keycode.KEYCODE_W)) {
        ypos -= 1;
    }
    if (input.getKey(input.keycode.KEYCODE_S)) {
        ypos += 1;
    }
    if (input.getKey(input.keycode.KEYCODE_D)) {
        xpos += 1;
    }
    if (input.getKey(input.keycode.KEYCODE_A)) {
        xpos -= 1;
    }
    try geo.createRect(alloc, color.BLUE, .{ .x = xpos, .y = ypos }, 30, 50);
    try geo.render(App);
}

fn presentScene() void {
    c.SDL_RenderPresent(App.renderer);
}

pub fn update() !bool {
    startTime = c.SDL_GetTicks64();
    var event: c.SDL_Event = undefined;
    while (c.SDL_PollEvent(&event) > 0) {
        if (event.type == c.SDL_QUIT) {
            return false;
        }
    }
    try prepareScene();
    presentScene();
    endTime = c.SDL_GetTicks64();
    deltaTime = endTime - startTime;
    c.SDL_Delay(@intCast(deltaTime));
    return true;
}
