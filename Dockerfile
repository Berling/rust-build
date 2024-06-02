FROM rust:latest

RUN rustup component add clippy && \
    rustup +nightly component add miri rust-src && \
    cargo install cargo-binutils

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
