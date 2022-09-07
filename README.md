# Zig Github Helper

Portable Zig GitHub Helper - Zig makes Cross-Complications a cinch!

This installs and caches the relevant Zig based on the used GitHub runner context.

- https://www.reddit.com/r/rust/comments/nii64t/zig_makes_rust_crosscompilation_just_work/
- https://actually.fyi/posts/zig-makes-rust-cross-compilation-just-work/
- https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html
- https://www.reddit.com/r/Zig/comments/tt7irl/how_does_zig_magically_cross_compile_without/

## Install / Check ZIG Cache

This is what you run once maybe once a week e.g. in matrix that has runner in os:

```yaml
  install-zig:
    needs: [matrix]
    uses: rinse-repeat/zig-gh-helper/.github/workflows/zig_install.yml@main
    with:
      os: ${{ matrix.os }}
      use-cache: true
      ext-cache: AAB
      zig-version: 0.9.1
```

The above will put GH runner-specific Zig into into it's specific cache key.

The zig will live in ~/zig and will translate in portable manner across all GH (e.g. windows/macos/ubuntu) runners

## Retrieve the cached ZIG

The below restores portable ~/zig in all available GH runners.

```yaml
  - name: Pull ZIG From Cache
    uses: actions/cache@v3
    with:
    key: zig-${{ env.RUNNER_OS }}-0.9.1-AAB
    path: ~/zig
```

## Other Projects

- http://musl.cc/
- https://github.com/messense/cargo-zigbuild
- https://github.com/cross-rs/cross
