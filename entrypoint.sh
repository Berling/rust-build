#!/bin/sh

cd /github/workspace

cargo build --verbose || exit
cargo clippy --all-targets --all-features -- -A dead-code -D warnings -W clippy::pedantic || exit
cargo +nightly miri test || exit
RUSTFLAGS="-C instrument-coverage" cargo test --tests || exit
cargo profdata -- merge -sparse default_*.profraw -o merged.profdata || exit
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
  --instr-profile=merged.profdata --ignore-filename-regex=/.cargo/registry --ignore-filename-regex=/rust --format=lcov > coverage.txt || exit
