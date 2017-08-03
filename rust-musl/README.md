# Introduction

Your one-stop-shop for Instructure official Docker/Rust love. If you need rust
in Docker you're in the right place. Drop your app in (/usr/src/app)
and start hacking.

## What do I get?

With this image you get Rust working right out of the box. We won't pre-install
any crates (such as rustfmt), or extensions like clippy. However, this image is
does come with openssl, and some basic building tools (gcc, and the like). It
also build everything with `libmusl`, so that way you can deploy static binaries.

If you don't need to build static binaries you should really look at building
with just the normal `instructure/rust` images.

## Example

```
FROM instructure/rust-musl:1.19

COPY . .
RUN cargo build --release

CMD ./target/release/myapp
```
