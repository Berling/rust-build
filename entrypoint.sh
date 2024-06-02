#!/bin/sh

set -x

cd /github/workspace

cargo build --verbose
cargo clippy --all-targets --all-features -- -A dead-code -D warnings -W clippy::pedantic
cargo +nightly miri test
RUSTFLAGS="-C instrument-coverage" cargo test --tests
cargo profdata -- merge -sparse default_*.profraw -o merged.profdata
cargo cov -- export \
  $( \
    for file in \
      $( \
        RUSTFLAGS="-C instrument-coverage" \
        RUSTDOCFLAGS="-C instrument-coverage -Z unstable-options --persist-doctests target/debug/doctestbins" \
          cargo test --no-run --message-format=json \
            | jq -r "select(.profile.test == true) | .filenames[]" \
            | grep -v dSYM - \
      ) \
      target/debug/doctestbins/*/rust_out; \
    do \
      [[ -x $file ]] && printf "%s %s " -object $file; \
    done \
  ) \
  --instr-profile=merged.profdata --ignore-filename-regex=/.cargo/registry --ignore-filename-regex=/rust --format=lcov > coverage.txt
