FROM rust:latest

RUN apt update && apt install -y jq && \
    rustup component add clippy llvm-tools-preview && \
    rustup +nightly component add miri rust-src && \
    cargo install cargo-binutils && \
    apt install -y pip && \
    pip install --break-system-packages lcov-cobertura

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
