uniffi::setup_scaffolding!();

#[derive(uniffi::Enum)]
enum Fruits {
  Watermelon,
  Cranberry,
  Cherry
}

#[derive(uniffi::Record)]
struct Person {
  name: String,
  age: u8
}

#[uniffi::export]
fn add(a: u32, b: u32) -> u32 {
    a + b
}
