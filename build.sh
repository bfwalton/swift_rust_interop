#!/bin/bash

# Steps to run
# Install Rust with https://rustup.rs/#
# Install mac target: `rustup target add aarch64-apple-ios`
# Install mac target: `rustup target add aarch64-apple-darwin`
# Install ios sim target: `rustup target add aarch64-apple-ios-sim`

cd myCrate

NAME="my_crate"
HEADERPATH="out/${NAME}FFI.h"
TARGETDIR="target"
OUTDIR="../frameworks"
RELDIR="release"
STATIC_LIB_NAME="lib${NAME}.a"
NEW_HEADER_DIR="out/include"

# Build and generate bindings for aarch64-apple-ios
cargo build --target aarch64-apple-ios --release
cargo run --bin uniffi-bindgen generate --library target/aarch64-apple-ios/release/lib${NAME}.a --language swift --out-dir out

# Build and generate bindings for aarch64-apple-darwin (In theory apple silicon simulator?)
cargo build --target aarch64-apple-darwin --release
cargo run --bin uniffi-bindgen generate --library target/aarch64-apple-darwin/release/lib${NAME}.a --language swift --out-dir out

# Build and generate bindings for aarch64-apple-ios-sim (In theory apple silicon simulator?)
cargo build --target aarch64-apple-ios-sim --release
cargo run --bin uniffi-bindgen generate --library target/aarch64-apple-ios-sim/release/lib${NAME}.a --language swift --out-dir out

# Copy Module Map
mkdir -p "${NEW_HEADER_DIR}"
cp "${HEADERPATH}" "${NEW_HEADER_DIR}/"
cp "out/${NAME}FFI.modulemap" "${NEW_HEADER_DIR}/module.modulemap"

#Remove Framework if one is already created
rm -rf "${OUTDIR}/${NAME}_framework.xcframework"

# Generate framework for both targets
xcodebuild -create-xcframework \
    -library "${TARGETDIR}/aarch64-apple-ios/${RELDIR}/${STATIC_LIB_NAME}" \
    -headers "${NEW_HEADER_DIR}" \
    -library "${TARGETDIR}/aarch64-apple-darwin/${RELDIR}/${STATIC_LIB_NAME}" \
    -headers "${NEW_HEADER_DIR}" \
    -library "${TARGETDIR}/aarch64-apple-ios-sim/${RELDIR}/${STATIC_LIB_NAME}" \
    -headers "${NEW_HEADER_DIR}" \
    -output "${OUTDIR}/${NAME}_framework.xcframework"

# Clear header dir
rm -rf "${NEW_HEADER_DIR}"

# Copy Swift File to Project
pwd
ls
cp "out/${NAME}.swift" "../swift_rust_interop/${NAME}.swift"
cd ../swift_rust_interop
ls
