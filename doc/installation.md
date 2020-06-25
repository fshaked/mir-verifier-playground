# Installation

## Linux (debian based) install

### Prerequisites

Install Haskell (ghc 8.6.5):

``` shell
$ sudo apt install cabal-install ghc
$ cabal new-update
```

Install rust using rustup (nightly-2020-03-22 is prescribed by mir-json):

``` shell
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ rustup toolchain install nightly-2020-03-22 --force
$ rustup default nightly-2020-03-22
# The following line is missing from mir-json/README.md
$ rustup component add --toolchain nightly-2020-03-22 rustc-dev
```

Install mir-json (I'm using commit 043f01284618865bad2b56361ea1eb3a81726381):

``` shell
$ git clone git clone git@github.com:GaloisInc/mir-json.git
$ cd mir-json
$ RUSTC_WRAPPER=./rustc-rpath.sh cargo install --locked
```

Install Yices:

``` shell
$ git clone git@github.com:SRI-CSL/yices2.git
$ cd yices2
$ autoconf
# If you don't mind installing using sudo omit --prefix="$HOME"
$ ./configure --prefix="$HOME"
$ make
$ make install
# Make sure PATH includes $HOME/bin
```


### Building mir-verifier:

``` shell
$ git clone git@github.com:GaloisInc/mir-verifier.git
$ cd mir-verifier
$ git submodule update --init
$ cabal v2-build
$ ./translate_libs.sh
# For running on a Cargo project:
$ cabal v2-install crux-mir
```

**NOTE:** seems like `cabal v2-install` doesn't replace older install properly. I had to manually remove `~/.cabal/bin/crux-mir` and  `~/.cabal/store/ghc-8.6.5/mir-verifier-*` before issuing the `cabal v2-install crux-mir` command above.

### Testing

## Run the test suite

``` shell
$ cabal v2-test
[...]
All 254 tests passed (322.16s)
Test suite test: PASS
Test suite logged to:
[...]
1 of 1 test suites (1 of 1 test cases) passed.
```

## Running on a single file

``` shell
$ pwd
~/mir-verifeir
$ crux-mir test/conc_eval/prim/add1.rs
test add1/3a1fbbbh::crux_test[0]: returned 2, ok

[Crux] All goals discharged through internal simplification.
[Crux] Overall status: Valid.
```

I can't figure out how to run, from an arbitrary working directory, crux-mir directly on a single file.
The above works only when executed from the root directory of the mir-verifier source tree, though the test itself can be in an arbitrary location.
I think crux-mir uses a mir-json front-end that doesn't read `CRUX_RUST_LIBRARY_PATH`.
I'm not sure if this use case is intentionally not supported.

## Running on a Cargo project

First create a generic cargo project.  **Note that we use the `--lib` option**,
this has the effect of not generating src/main.rs, which for some reason causes
crux-test to fail (see error message below).

``` shell
$ cargo new test-crux-mir --lib
$ cd test-crux-mir
$ mkdir tests
```

Now copy a test to the tests directory:

``` shell
$ cp .../mir-verifeir/test/conc_eval/prim/add1.rs tests/
```

And run the crux tests:

``` shell
$ cargo crux-test
[...]
[Crux] Overall status: Valid.
     Running target/x86_64-unknown-linux-gnu/debug/deps/add1-acab9298bf59cf43
test add1/b3tss27z::crux_test[0]: returned 2, ok
[...]
```

Snippets from the error message when not using '--lib':

``` shell
[...]
error: linking with `cc` failed: exit code: 1
[...]
  = note: /usr/bin/ld: /home/sflur/workspace/mir-verifier-playground/test1/target/x86_64-unknown-linux-gnu/debug/deps/test1-c60fc49ddbb8e927.4oljyukxltnvj99u.rcgu.o: in function `core::ops::function::FnOnce::call_once':
          /home/sflur/workspace/mir-verifier/lib/libcore/ops/function.rs:232: undefined reference to `_Unwind_Resume'
          /usr/bin/ld: /home/sflur/workspace/mir-verifier/rlibs/libstd.rlib(std.std.3a1fbbbh-cgu.10.rcgu.o): in function `std::thread::park':
          std.3a1fbbbh-cgu.10:(.text._ZN3std6thread4park17he2d02e288b6ad7ffE+0x28): undefined reference to `_Unwind_Resume'
[...]
```
