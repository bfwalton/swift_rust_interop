//
//  ContentView.swift
//  swift_rust_interop
//
//  Created by Brandon Walton on 1/18/25.
//

import SwiftUI

struct ContentView: View {
    
    // `Person` Declared in rust package
    let people = [Person(name: "John", age: 28)]
    
    @State var rust_startTime: Date?
    @State var rust_endTime: Date?
    @State var rust_fib: Float64?
    
    @State var swift_startTime: Date?
    @State var swift_endTime: Date?
    @State var swift_fib: Float64?
    
    @State var grammer = ""
    @State private var suggestions: [String] = []
    @State private var correction: String?
    
    let n_th: Float64 = 10000000
    
    var body: some View {
        List {
            Section("Calculating") {
                Text(n_th, format: .number)
            }
            Section("Swift") {
                if let swift_fib, let swift_startTime, let swift_endTime {
                    Text(swift_fib, format: .number)
                    Text(swift_startTime.timeIntervalSince1970, format: .number)
                    Text(swift_endTime.timeIntervalSince1970, format: .number)
                    Text(swift_endTime.timeIntervalSince1970 - swift_startTime.timeIntervalSince1970, format: .number)
                }
            }
            Section("Rust") {
                if let rust_fib, let rust_startTime, let rust_endTime {
                    Text(rust_fib, format: .number)
                    Text(rust_startTime.timeIntervalSince1970, format: .number)
                    Text(rust_endTime.timeIntervalSince1970, format: .number)
                    Text(rust_endTime.timeIntervalSince1970 - rust_startTime.timeIntervalSince1970, format: .number)
                }
            }
            Section("Grammer") {
                TextField("Correct This", text: $grammer)
                    .onSubmit {
                        correction = nil
                        suggestions = generateSuggestion(input: grammer)
                        correction = generateCorrection(input: grammer)
                        print(correction ?? "")
                        print(suggestions)
                    }
                if !suggestions.isEmpty {
                    Text(correction ?? "No correction available")
                    ForEach(suggestions, id: \.self) { suggestion in
                        Text(suggestion)
                    }
                } else {
                    Text("No Notes")
                }
            }
            Section {
                Button(action: {
                    rust_startTime = .now
                    rust_fib = CGFloat(fibonacci(n: n_th))
                    rust_endTime = .now
                }, label: {
                    Text("Trigger Rust")
                })
                
                Button(action: {
                    swift_startTime = .now
                    swift_fib = CGFloat(fibonacci_swift(n: n_th))
                    swift_endTime = .now
                }, label: {
                    Text("Trigger Swift")
                })
            }
        }
    }
    
    func fibonacci_swift(n: Float64) -> Float64 {
        guard n > 1 else { return n }
        
        var a: Float64 = 0.0
        var b: Float64 = 1.0
        
        for _ in 2...Int(n) {
            let temp = a + b
            a = b
            b = temp
        }
        
        return b
    }
}

extension Person: Identifiable {
    
    public var id: String { name }
}

#Preview {
    ContentView()
}
