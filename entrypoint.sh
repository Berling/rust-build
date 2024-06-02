#!/bin/sh

cd /github/workflow || exit

cargo build --verbose
cargo clippy --all-targets --all-features -- -A dead-code -D warnings -W clippy::pedantic
cargo +nightly miri test
cargo test --verbose
