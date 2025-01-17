//
//  SampleView.swift
//  CrossUI
//
//  Created by Noah Moller on 30/12/2024.
//

import CrossUI

struct ContentView: View {
    @State private var text = "Hello, World!"
    
    var body: some View {
        VStack {
            Text(text)
            TextField($text, title: "Enter text")
        }
    }
}
