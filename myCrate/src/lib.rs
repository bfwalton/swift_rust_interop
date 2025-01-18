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

#[uniffi::export]
fn fibonacci(n: f64) -> f64 {
    if n == 0.0 {
        0.0
    } else if n == 1.0 {
        1.0
    } else {
        let mut a = 0.0;
        let mut b = 1.0;
        let mut temp;

        for _ in 2..=(n as i32) {
            temp = a + b;
            a = b;
            b = temp;
        }
        b
    }
}
