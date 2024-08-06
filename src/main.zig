const c = @cImport({
    @cInclude("SDL.h");
    @cInclude("SDL_render.h");
    @cInclude("stdio.h");
});
const std = @import("std");

const SDLError = error{
    initialize,
};

const width: i32 = 640;
const height: i32 = 480;
const name = "Game Engine";

const app = struct {
    renderer: ?*c.SDL_Renderer,
    window: ?*c.SDL_Window,
};

var App = app{ .window = null, .renderer = null };

const vec2 = struct {
    x: f32,
    y: f32,
};

const color = struct {
    red: u8,
    green: u8,
    blue: u8,
    opacity: u8,
};

const RED = color{ .red = 255, .blue = 0, .green = 0, .opacity = 255 };

fn initSDL() !void {
    const rendererFlags: u32 = c.SDL_RENDERER_ACCELERATED | c.SDL_RENDERER_PRESENTVSYNC;
    const windowFlags: u32 = 0;
    if (c.SDL_Init(c.SDL_INIT_VIDEO) < 0) {
        return SDLError.initialize;
    }
    App.window = c.SDL_CreateWindow(name, c.SDL_WINDOWPOS_UNDEFINED, c.SDL_WINDOWPOS_UNDEFINED, width, height, windowFlags);
    if (App.window == null) {
        return SDLError.initialize;
    }
    _ = c.SDL_SetHint(c.SDL_HINT_RENDER_SCALE_QUALITY, "linear");
    App.renderer = c.SDL_CreateRenderer(App.window, -1, rendererFlags);
    if (App.renderer == null) {
        return SDLError.initialize;
    }
}

fn deinitSDL() void {
    c.SDL_DestroyWindow(App.window);
    c.SDL_DestroyRenderer(App.renderer);
    c.SDL_Quit();
}

fn createVertex(vert: *c.SDL_Vertex, pos: vec2, col: color) void {
    vert.* = .{
        .color = .{ .r = col.red, .g = col.green, .b = col.blue, .a = col.opacity },
        .position = .{ .x = pos.x, .y = pos.y },
        .tex_coord = .{ .x = 1, .y = 1 },
    };
}

fn createTriangle(allocator: std.mem.Allocator) ![]c.SDL_Vertex {
    const verts = try allocator.alloc(c.SDL_Vertex, 3);
    const pos = [_]vec2{
        .{ .x = 10, .y = 10 },
        .{ .x = 20, .y = 20 },
        .{ .x = 10, .y = 20 },
    };
    for (verts, 0..) |*vert, i| {
        createVertex(vert, pos[i], RED);
    }
    return verts;
}

fn prepareScene() !void {
    _ = c.SDL_RenderClear(App.renderer);
    const verts = try createTriangle(std.heap.page_allocator);
    defer std.heap.page_allocator.free(verts);
    const texture: ?*c.SDL_Texture = undefined;
    _ = c.SDL_SetRenderDrawColor(App.renderer, 0, 0, 0, 255);
    _ = c.SDL_RenderGeometry(App.renderer, texture, @ptrCast(verts), 3, null, 0);
}

fn presentScene() void {
    c.SDL_RenderPresent(App.renderer);
}
pub fn main() !void {
    try initSDL();
    defer deinitSDL();
    try prepareScene();
    presentScene();
    c.SDL_Delay(3000);
}
