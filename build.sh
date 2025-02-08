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

export RUSTONIG_DYNAMIC_LIBONIG=1
export RUST_BACKTRACE=1
export CARGO_FEATURE_NO_NEON=1
export IPHONEOS_DEPLOYMENT_TARGET="12.0"
export SDKROOT=''
my_targets=("aarch64-apple-ios-sim" "aarch64-apple-darwin" "aarch64-apple-ios")
printf "Generating for Targets: \n"
printf "* %s\n" "${my_targets[@]}"

for target in "${my_targets[@]}"
do
    printf "Generating for target: %s\n" "${target}"

    printf "Building for target: %s\n" "${target}"
    cargo build --target "${target}" --release

    printf "Genereating bindings for target: %s\n" "${target}"
    cargo run --bin uniffi-bindgen generate --library "target/${target}/release/libmy_crate.a" --language swift --out-dir out
done

# Copy Module Map
printf "Copying Module Map\n"

mkdir -p "${NEW_HEADER_DIR}"
cp "${HEADERPATH}" "${NEW_HEADER_DIR}/"
cp "out/${NAME}FFI.modulemap" "${NEW_HEADER_DIR}/module.modulemap"

printf "Clearing Old Framework\n"

# Remove Framework if one is already created
rm -rf "${OUTDIR}/${NAME}_framework.xcframework"

# Generate framework for all targets
printf "Generating Framework\n"

xcodebuild -create-xcframework \
    $(for target in "${my_targets[@]}"; do
        echo -library "${TARGETDIR}/${target}/${RELDIR}/${STATIC_LIB_NAME}" -headers "${NEW_HEADER_DIR}"
    done) \
    -output "${OUTDIR}/${NAME}_framework.xcframework"

# Clear header dir
rm -rf "${NEW_HEADER_DIR}"

# Copy Swift File to Project
pwd
ls
cp "out/${NAME}.swift" "../swift_rust_interop/${NAME}.swift"
cd ../swift_rust_interop
ls