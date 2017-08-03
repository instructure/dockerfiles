# Introduction

Your one-stop-shop for Instructure official Docker/Rust love. If you need rust
in Docker you're in the right place. Drop your app in (/usr/src/app)
and start hacking.

## What do I get?

With this image you get Rust working right out of the box. We won't pre-install
any crates (such as rustfmt), or extensions like clippy. However, this image is
does come with openssl, and some basic building tools (gcc, and the like).

If you're looking to build static binaries (i.e. binaries you can just drag/drop)
you'll want to take a look at the `instructure/rust-musl` images instead.

## Example

```
FROM instructure/rust:1.19

COPY . .
RUN cargo build --release

CMD ./target/release/myapp
```
