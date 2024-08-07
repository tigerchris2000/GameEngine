const engine = @import("engine.zig");
const std = @import("std");

const c = @cImport({
    @cInclude("SDL.h");
    @cInclude("SDL_render.h");
    @cInclude("stdio.h");
});

pub const vec2 = struct {
    x: f32,
    y: f32,
};

pub const color = struct {
    red: u8,
    green: u8,
    blue: u8,
    opacity: u8,
};

var vertecies: []c.SDL_Vertex = undefined;
var used: usize = 0;

fn createVertex(vert: *c.SDL_Vertex, pos: vec2, col: color) void {
    vert.* = .{
        .color = .{ .r = col.red, .g = col.green, .b = col.blue, .a = col.opacity },
        .position = .{ .x = pos.x, .y = pos.y },
        .tex_coord = .{ .x = 1, .y = 1 },
    };
}

pub fn createTriangle(allocator: std.mem.Allocator, col: color, pos: [3]vec2) !void {
    if (vertecies.len < used + 3) {
        vertecies = try allocator.realloc(vertecies, used + 3);
    }
    for (0..3) |i| {
        createVertex(&vertecies[used + i], pos[i], col);
    }
    used += 3;
}

pub fn render(App: engine.app) !void {
    const texture: ?*c.SDL_Texture = null;
    if (c.SDL_RenderGeometry(App.renderer, texture, @ptrCast(vertecies), @intCast(used), null, 0) == -1) {
        std.debug.print("{s}\n", .{c.SDL_GetError()});
        return engine.SDL_Error.render;
    }
}

pub fn init(allocator: std.mem.Allocator) !void {
    vertecies = try allocator.alloc(c.SDL_Vertex, 3);
}

pub fn deinit(allocator: std.mem.Allocator) void {
    allocator.free(vertecies);
}
