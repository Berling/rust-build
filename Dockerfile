FROM rust:latest

RUN rustup component add clippy && \
    rustup +nightly component add miri

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
