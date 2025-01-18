#  Swift / Rust Interop

## Environment Setup

Ensure that rust is installed, and install the targets for your platform(s)
* Install Rust with https://rustup.rs/#
* Install mac target: `rustup target add aarch64-apple-ios`
* Install mac target: `rustup target add aarch64-apple-darwin`
* Install ios sim target: `rustup target add aarch64-apple-ios-sim`

## Project Setup

Run the script to generate the rust framework and ensure its configured to match the project

* Run the top level `build.sh` script `./build.sh`
* From the XCode settings (Targets > [Your Target] > General > Frameworks, Libraries, and Embedded Content settings, add the framework to your target
* Add the generated swift file from the "out" folder generated by the rust framework to your target

## Run!

