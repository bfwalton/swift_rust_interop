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
    
    var body: some View {
        List {
            ForEach(people) { person in
                HStack {
                    Text(person.name)
                    Spacer()
                    Text(person.age, format: .number)
                }
            }
        }
    }
}

extension Person: Identifiable {
    
    public var id: String { name }
}

#Preview {
    ContentView()
}
