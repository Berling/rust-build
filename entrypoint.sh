#!/bin/sh

cd /github/workspace || exit

cargo build --verbose || exit
cargo clippy --all-targets --all-features -- -A dead-code -D warnings -W clippy::pedantic || exit
cargo +nightly miri test || exit
cargo test --verbose || exit
