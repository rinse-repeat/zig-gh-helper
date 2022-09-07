# Zig Github Helper

Portable Zig GitHub Helper - Zig makes (some) Cross-Building a cinch!

This installs and caches the relevant Zig based on the used GitHub runner context.

- https://www.reddit.com/r/rust/comments/nii64t/zig_makes_rust_crosscompilation_just_work/
- https://actually.fyi/posts/zig-makes-rust-cross-compilation-just-work/
- https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html
- https://www.reddit.com/r/Zig/comments/tt7irl/how_does_zig_magically_cross_compile_without/

This re-usable workflow is both portable & Bash-based requiring no extensive TypeScript to maintain.

## Install / Check ZIG Cache

This is what you run once maybe once a week e.g. in matrix that has runner in os:

```yaml
jobs:
  install-zig:
    uses: rinse-repeat/zig-gh-helper/.github/workflows/zig_install.yml@main
    with:
      os: ubuntu-latest
      use-cache: true
      ext-cache: AAB
      zig-version: 0.9.1
```

Where the `with:` keys are:
| Key         | Type    | Default       | Description |
| :---        | :---    | :---          | :---        |
| os          | string  | ubuntu-latest | The GitHub [runner image label](https://github.com/actions/runner-images) to be used |
| use-cache   | boolean | true          | Cache the Zig ? _*Strongly recommended*_ |
| ext-cache   | string  | AAA           | Cache key suffix |
| zig-version | string  | 0.9.1         | Zig Version |

You can also install multiple Zig's in a matrix e.g. using [matrix.json](matrix.json) in this repo:

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

See this full: https://github.com/rinse-repeat/zig-gh-helper/blob/main/.github/workflows/zig_test.yml

The above will put GH runner-specific Zig(s) into into relevant cache key(s)

The zig(s) live in ~/zig and will translate in portable manner across all GH (e.g. windows/macos/ubuntu) runners

## Retrieve the cached ZIG

The below restores portable Zig into ~/zig in any of the available GitHub action runners.

```yaml
  - name: Pull ZIG From Cache
    uses: actions/cache@v3
    with:
      key: zig-${{ env.RUNNER_OS }}-0.9.1-AAB
      path: ~/zig
```

## GitHub Limitations

As with any other re-usable GitHub action the install has to run within `jobs:` context and cannot be used within `steps:` context.

Since the Install workflow should be separate anyways this should not be much of issue.

It is strongly recommended to run the Zig install once / check periodically and then just retrieve it always from the cache where ever it is required at which can be used in the context of `steps:`.

## TODO

Only Zig 0.9.1 is supported atm. Feel free to contribute more checksums if required - e.g. see example [zig-checksums-0.9.1.json](zig-checksums-0.9.1.json)

## Other Projects

- http://musl.cc/
- https://github.com/messense/cargo-zigbuild
- https://github.com/cross-rs/cross
