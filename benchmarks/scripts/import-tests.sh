#!/usr/bin/env bash

mkdir -p tests

git clone https://github.com/soarlab/rust-benchmarks.git temp-rust-benchmarks

# Flatten the tests
find temp-rust-benchmarks/benchmarks/ -name '*.rs' | xargs mv -t tests

rm -rf temp-rust-benchmarks

# Add the crux_test annotation to the tests
sed -i '/fn main()/ i #[cfg_attr(crux, crux_test)]' tests/*.rs
