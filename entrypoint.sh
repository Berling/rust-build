#!/bin/sh

cd /github/workspace || exit

cargo build --verbose
cargo clippy --all-targets --all-features -- -A dead-code -D warnings -W clippy::pedantic
cargo +nightly miri test
cargo test --verbose
