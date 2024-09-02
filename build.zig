const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-binary",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    // ########################################################################
    // ########################################################################
    // RAYLIB LIBRARY SETUP
    // Use "raylib-zig" dependency from `build.zig.zon` to create library that
    // will be used in `main.zig`.

    const raylib_dep = b.dependency("raylib-zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib"); // main raylib module
    const raygui = raylib_dep.module("raygui"); // raygui module
    const raylib_artifact = raylib_dep.artifact("raylib"); // raylib C library

    exe.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);
    exe.root_module.addImport("raygui", raygui);

    // ########################################################################
    // ########################################################################

    // run step
    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the binary");
    run_step.dependOn(&run_exe.step);

    // test step
    const test_targets = [_]std.Target.Query{
        .{}, //native
        // Add other test targets, for example x86_64 linux
        // .{
        //     .cpu_arch = .x86_64,
        //     .os_tag = .linux,
        // },
    };
    const test_step = b.step("test", "Run unit tests");
    for (test_targets) |test_target| {
        const unit_tests = b.addTest(.{
            .root_source_file = b.path("src/main.zig"),
            .target = b.resolveTargetQuery(test_target),
        });

        const run_unit_tests = b.addRunArtifact(unit_tests);
        // only run tests considered non-foreign.
        // -fqemu and -fwasmtime command-line arguments may affect which tests run
        run_unit_tests.skip_foreign_checks = true;
        test_step.dependOn(&run_unit_tests.step);
    }
}
