const engine = @import("engine.zig");
const std = @import("std");

const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_render.h");
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

pub fn createRect(allocator: std.mem.Allocator, col: color, pos: vec2, height: u32, width: u32) !void {
    if (vertecies.len < used + 6) {
        vertecies = try allocator.realloc(vertecies, used + 90);
    }
    const topleft = vec2{ .x = pos.x - @as(f32, @floatFromInt(width)) / 2, .y = pos.y - @as(f32, @floatFromInt(height)) / 2 };
    const topright = vec2{ .x = pos.x + @as(f32, @floatFromInt(width)) / 2, .y = pos.y - @as(f32, @floatFromInt(height)) / 2 };
    const bottomleft = vec2{ .x = pos.x - @as(f32, @floatFromInt(width)) / 2, .y = pos.y + @as(f32, @floatFromInt(height)) / 2 };
    const bottomright = vec2{ .x = pos.x + @as(f32, @floatFromInt(width)) / 2, .y = pos.y + @as(f32, @floatFromInt(height)) / 2 };
    createVertex(&vertecies[used], topleft, col);
    createVertex(&vertecies[used + 1], bottomleft, col);
    createVertex(&vertecies[used + 2], bottomright, col);

    createVertex(&vertecies[used + 3], topleft, col);
    createVertex(&vertecies[used + 4], topright, col);
    createVertex(&vertecies[used + 5], bottomright, col);
    used += 6;
}

pub fn render(App: engine.app) !void {
    const texture: ?*c.SDL_Texture = null;
    if (c.SDL_RenderGeometry(App.renderer, texture, @ptrCast(vertecies), @intCast(used), null, 0) == -1) {
        std.debug.print("{s}\n", .{c.SDL_GetError()});
        return engine.SDL_Error.render;
    }
}

pub fn init(allocator: std.mem.Allocator) !void {
    vertecies = try allocator.alloc(c.SDL_Vertex, 90);
}

pub fn clear() void {
    used = 0;
}

pub fn deinit(allocator: std.mem.Allocator) void {
    allocator.free(vertecies);
}
