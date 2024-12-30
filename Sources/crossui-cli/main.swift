//
//  main.swift
//  CrossUI
//
//  Created by Noah Moller on 30/12/2024.
//

import Foundation
import CrossUI

// #if canImport(Glibc) or #if os(Windows) checks might be used for platform detection
#if os(Windows)
let currentPlatform = Platform.windows
#elseif os(macOS)
let currentPlatform = Platform.macOS
#else
let currentPlatform = Platform.linux
#endif

// A simple parse of command-line arguments:
let args = CommandLine.arguments

guard args.count > 1 else {
    print("Usage: cross <command>\nCommands: build")
    exit(1)
}

let command = args[1]

// Switch on the subcommand
switch command {
case "build":
    // In a real tool, you'd parse more options,
    // like `--platform windows` or `--platform macos`.
    // For now, let's just do a simplified approach.
    
    // 1) Load user project code
    //    - In a real scenario, you might dynamically load a Swift package,
    //      or the user might define some known entry point.
    //    - For demonstration, let's define a quick inline "ContentView".

    struct ContentView {
        let body: some View = VStack {
            Text("Hello from CrossUI!")
            Text("Hello again from CrossUI!")
        }
    }
    let rootView = ContentView().body
    
    // 2) Render the UI code for the detected platform
    switch currentPlatform {
    case .windows:
        let xamlOutput = renderWinUIRoot(rootView)
        do {
            try xamlOutput.write(toFile: "MainPage.xaml", atomically: true, encoding: .utf8)
            print("Generated MainPage.xaml (WinUI)")
            // Optionally run a Windows build step here
        } catch {
            print("Error writing XAML file: \(error)")
            exit(1)
        }
        
    case .macOS:
        // For demonstration, let's pretend we generate SwiftUI code
        // and write it to a file (not typical, but as an example):
        let swiftUIOutput = rootView.render(platform: .macOS)
        do {
            try swiftUIOutput.write(toFile: "MacUI.swift", atomically: true, encoding: .utf8)
            print("Generated MacUI.swift (SwiftUI)")
            // Optionally compile with Xcode, etc.
        } catch {
            print("Error writing MacUI.swift: \(error)")
            exit(1)
        }
        
    case .linux:
        // In the future: generate some Linux code, e.g. Gtk or something else
        let linuxUIOutput = rootView.render(platform: .linux)
        do {
            try linuxUIOutput.write(toFile: "LinuxUI.swift", atomically: true, encoding: .utf8)
            print("Generated LinuxUI.swift (Linux UI)")
        } catch {
            print("Error writing LinuxUI.swift: \(error)")
            exit(1)
        }
    }

    // Done building
    exit(0)

default:
    print("Unknown command: \(command)")
    exit(1)
}
