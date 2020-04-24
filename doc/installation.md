# Installation

## Linux (debian based) install

### Prerequisites

Install Haskell (ghc 8.6.5):

```
$ sudo apt install cabal-install ghc
$ cabal new-update
```

Install rust using rustup (nightly-2019-08-05 is prescribed by mir-json):

```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ rustup toolchain install nightly-2019-08-05 --force
$ rustup default nightly-2019-08-05
```

Install mir-json:

```
$ git clone git clone git@github.com:GaloisInc/mir-json.git
$ cd mir-json
$ RUSTC_WRAPPER=./rustc-rpath.sh cargo install --locked
```

### Building mir-verifier:

```
$ git clone git@github.com:GaloisInc/mir-verifier.git
$ cd mir-verifier
$ git submodule update --init
$ cabal v2-build
$ ./translate_libs.sh
```
