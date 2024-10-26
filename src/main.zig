const std = @import("std");
const sdl2 = @cImport({
    @cInclude("SDL2/SDL.h");
});
const sdl_error = error{
    SDLInitError,
    SDLWindowCreateError,
    SDLSurfaceCreationError,
    SDLRendererCreationError,
    SDLSurfaceUpdateError,
    SDLRenderPresentError,
    SDLRenderFillRectError,
    SDLSetRenderDrawColorError,
    SDLRenderClearError,
    SDLRendererSetVSyncError,
};
const WINDOW_X = 640;
const WINDOW_Y = 480;

const Cube = struct {
    rect: sdl2.SDL_Rect,
    color: sdl2.SDL_Color,
};

pub fn main() !void {
    const init_flags: c_uint = sdl2.SDL_INIT_EVERYTHING;
    var err: c_int = sdl2.SDL_Init(init_flags);
    if (err != 0) {
        std.debug.print("{s}\n", .{sdl2.SDL_GetError()});
        return sdl_error.SDLInitError;
    }
    defer sdl2.SDL_Quit();

    const window_flags = sdl2.SDL_WINDOW_SHOWN;
    const window = sdl2.SDL_CreateWindow("Minecraft Texture Editor", sdl2.SDL_WINDOWPOS_UNDEFINED, sdl2.SDL_WINDOWPOS_UNDEFINED, WINDOW_X, WINDOW_Y, window_flags);
    if (window == null) {
        std.debug.print("{s}\n", .{sdl2.SDL_GetError()});
        return sdl_error.SDLWindowCreateError;
    }
    defer sdl2.SDL_DestroyWindow(window);
    sdl2.SDL_ShowWindow(window);
    const renderer = sdl2.SDL_CreateRenderer(window, -1, sdl2.SDL_RENDERER_ACCELERATED | sdl2.SDL_RENDERER_PRESENTVSYNC);
    if (renderer == null) {
        return sdl_error.SDLRendererCreationError;
    }
    var event: sdl2.SDL_Event = undefined;
    var quit: bool = false;
    const chosen_color: sdl2.SDL_Color = sdl2.SDL_Color{
        .r = 0,
        .g = 0,
        .b = 255,
        .a = 255,
    };
    var cube1 = Cube{ .rect = sdl2.SDL_Rect{
        .x = WINDOW_X / 2,
        .y = WINDOW_Y / 2,
        .w = 10,
        .h = 10,
    }, .color = chosen_color };
    while (!quit) {
        sdl2.SDL_RenderPresent(renderer);
        while (sdl2.SDL_PollEvent(&event) != 0) {
            switch (event.type) {
                sdl2.SDL_QUIT => {
                    quit = true;
                    break;
                },
                sdl2.SDL_MOUSEMOTION => {
                    cube1.rect.x = event.motion.x;
                    cube1.rect.y = event.motion.y;
                },
                sdl2.SDL_KEYDOWN => {
                    switch (event.key.keysym.sym) {
                        sdl2.SDLK_1 => {
                            err = sdl2.SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
                            if (err != 0) {
                                std.debug.print("{s}\n", .{sdl2.SDL_GetError()});
                                return error.SDLSetRenderDrawColorError;
                            }
                        },
                        sdl2.SDLK_2 => {
                            err = sdl2.SDL_SetRenderDrawColor(renderer, 255, 127, 0, 255);
                            if (err != 0) {
                                std.debug.print("{s}\n", .{sdl2.SDL_GetError()});
                                return error.SDLSetRenderDrawColorError;
                            }
                        },
                        sdl2.SDLK_3 => {
                            err = sdl2.SDL_SetRenderDrawColor(renderer, 255, 255, 0, 255);
                            if (err != 0) {
                                std.debug.print("{s}\n", .{sdl2.SDL_GetError()});
                                return error.SDLSetRenderDrawColorError;
                            }
                        },
                        sdl2.SDLK_4 => {
                            err = sdl2.SDL_SetRenderDrawColor(renderer, 0, 255, 0, 255);
                            if (err != 0) {
                                std.debug.print("{s}\n", .{sdl2.SDL_GetError()});
                                return error.SDLSetRenderDrawColorError;
                            }
                        },
                        sdl2.SDLK_5 => {
                            err = sdl2.SDL_SetRenderDrawColor(renderer, 0, 0, 255, 255);
                            if (err != 0) {
                                std.debug.print("{s}\n", .{sdl2.SDL_GetError()});
                                return error.SDLSetRenderDrawColorError;
                            }
                        },
                        sdl2.SDLK_6 => {
                            err = sdl2.SDL_SetRenderDrawColor(renderer, 255, 0, 255, 255);
                            if (err != 0) {
                                std.debug.print("{s}\n", .{sdl2.SDL_GetError()});
                                return error.SDLSetRenderDrawColorError;
                            }
                        },
                        sdl2.SDLK_UP => {
                            std.debug.print("UP!\n", .{});
                        },
                        sdl2.SDLK_SPACE => {
                            sdl2.SDL_RenderPresent(renderer);
                            err = sdl2.SDL_RenderFillRect(renderer, &cube1.rect);
                            if (err != 0) {
                                std.debug.print("{s}\n", .{sdl2.SDL_GetError()});
                                return error.SDLRenderFillRectError;
                            }
                            sdl2.SDL_RenderPresent(renderer);
                        },
                        sdl2.SDLK_r => {
                            for (0..10) |_| {
                                err = sdl2.SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
                                if (err != 0) {
                                    std.debug.print("{s}\n", .{sdl2.SDL_GetError()});
                                    return error.SDLSetRenderDrawColorError;
                                }
                                err = sdl2.SDL_RenderClear(renderer);
                                if (err != 0) {
                                    std.debug.print("{s}\n", .{sdl2.SDL_GetError()});
                                    return error.SDLRenderClearError;
                                }
                                sdl2.SDL_RenderPresent(renderer);
                            }
                        },
                        else => {},
                    }
                },
                else => {},
            }
        }
    }
    std.debug.print("Quitting the game\n", .{});
}
