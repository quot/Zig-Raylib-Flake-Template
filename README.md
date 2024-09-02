# Zig/Raylib Nix Flake Template

A starting point for developing Zig with Raylib with Nix or in NixOS.

---

Based on: https://github.com/nix-community/templates/tree/main/zig

Using Raylib-Zig: https://github.com/Not-Nik/raylib-zig

---

Building raylib-zig in NixOS throws errors caused by missing libraries.

```
error: unable to find dynamic system library 'GL' using strategy 'paths_first'.
...
error: unable to find dynamic system library 'X11' using strategy 'paths_first'.
```

This flake sets up a development environment with those missing dependencies so you don't have to install them on your base OS.

## How to use

Currently, the flake is only setup to use `nix develop`. You can use `nix develop --command bash -c "zig build run; exit;"` if you want to do a one-time run without staying in the develp environment.

