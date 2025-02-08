uniffi::setup_scaffolding!();

use nlprule::{Rules, Tokenizer, tokenizer_filename, rules_filename};

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

#[uniffi::export]
fn generate_suggestion(input: String) -> Vec<String>{
    let mut tokenizer_bytes: &'static [u8] = include_bytes!(concat!(
        env!("OUT_DIR"),
        "/",
        tokenizer_filename!("en")
    ));
    let mut rules_bytes: &'static [u8] = include_bytes!(concat!(
        env!("OUT_DIR"),
        "/",
        rules_filename!("en")
    ));

    let tokenizer = Tokenizer::from_reader(&mut tokenizer_bytes).expect("tokenizer binary is valid");
    let rules = Rules::from_reader(&mut rules_bytes).expect("rules binary is valid");
    
    // let mut suggestions: [String] = [];
    let mut suggestions: Vec<String> = Vec::new();

    // let correct_str = "She was not been here since Monday.";
    // println!("String to correct: {}", correct_str);
    for s in rules.suggest(&input, &tokenizer) {
        // println!("Suggestion: {}", s.message());

        // let corrected_text = rules.correct(correct_str, &tokenizer);
        // println!("Corrected: {}", corrected_text);
        // return Some(s.message().to_string());
        
        suggestions.push(s.message().to_string());
    }

    return suggestions;
}

#[uniffi::export]
fn generate_correction(input: String) -> String {
    let mut tokenizer_bytes: &'static [u8] = include_bytes!(concat!(
        env!("OUT_DIR"),
        "/",
        tokenizer_filename!("en")
    ));
    let mut rules_bytes: &'static [u8] = include_bytes!(concat!(
        env!("OUT_DIR"),
        "/",
        rules_filename!("en")
    ));

    let tokenizer = Tokenizer::from_reader(&mut tokenizer_bytes).expect("tokenizer binary is valid");
    let rules = Rules::from_reader(&mut rules_bytes).expect("rules binary is valid");
    
    let corrected_text = rules.correct(&input, &tokenizer);

    return corrected_text;
}
