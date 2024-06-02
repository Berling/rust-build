FROM rust:latest

RUN rustup component add clippy llvm-tools-preview && \
    rustup +nightly component add miri rust-src && \
    cargo install cargo-binutils

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
