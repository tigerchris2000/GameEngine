const std = @import("std");
const engine = @import("engine.zig");
const geo = @import("geometry.zig");

pub const geometricSprite = struct {
    transform: *engine.transform,
    vertecies: []geo.vec2,
    color: []geo.color,
};

pub const sprite = struct {};

const RENDER_ERROR = error{
    memory,
};

const gSprites = std.ArrayList(geometricSprite).init(std.heap.page_allocator);

pub fn addSprite(Sprite: sprite) !void {
    _ = Sprite;
}

pub fn addGeometricSprite(Sprite: geometricSprite) !void {
    try gSprites.append(Sprite);
}

pub fn removeGeometricSprite(Sprite: geometricSprite) !void {
    const idx = for (gSprites.items, 0..) |val, i| {
        if (std.mem.eql(geometricSprite, val, Sprite)) {
            break i;
        }
    } else null;
    if (idx) |i| {
        try gSprites.swapRemove(i);
    } else {
        return RENDER_ERROR.memory;
    }
}

pub fn render() void {
    // Draw the geometrics
    geo.clear();
    // Draw the sprites
}
