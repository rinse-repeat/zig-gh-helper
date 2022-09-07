# zig-gh-helper
Zig GH Helper

Portable Zig GitHub Helper

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

