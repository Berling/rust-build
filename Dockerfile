FROM rust:latest

RUN apt update && apt install -y jq \
    rustup component add clippy llvm-tools-preview && \
    rustup +nightly component add miri rust-src && \
    cargo install cargo-binutils

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
