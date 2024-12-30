//
//  main.swift
//  CrossUI
//
//  Created by Noah Moller on 30/12/2024.
//

import CrossUI
import Foundation

// For simplicity, define an example "root view" here.
// In reality, you might load a user-provided Swift file
// that references CrossUI. Or you might have an entire
// Swift module with the user's code.
struct ContentView {
    let body: some View = VStack {
        Text("Hello from CrossUI on Windows!")
    }
}

// Determine platform. In Swift, you can check #if os(Windows).
#if os(Windows)
let currentPlatform = Platform.windows
#elseif os(macOS)
let currentPlatform = Platform.macOS
#else
let currentPlatform = Platform.linux
#endif

// 1) Instantiate the user's content view
let contentView = ContentView().body

// 2) If windows, render to XAML
if currentPlatform == .windows {
    let xamlOutput = renderWinUIRoot(contentView)
    
    // 3) Write out MainPage.xaml
    let xamlFilePath = "MainPage.xaml"
    do {
        try xamlOutput.write(toFile: xamlFilePath, atomically: true, encoding: .utf8)
        print("Generated \(xamlFilePath) for Windows (WinUI).")
        
        // 4) Optionally call MSBuild or another step to compile your WinUI project
        //    Example (pseudocode):
        //
        // let buildProcess = Process()
        // buildProcess.executableURL = URL(fileURLWithPath: "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/MSBuild/Current/Bin/MSBuild.exe")
        // buildProcess.arguments = ["YourApp.sln", "/t:Rebuild", "/p:Configuration=Release"]
        // try buildProcess.run()
        // buildProcess.waitUntilExit()
        //
        // if buildProcess.terminationStatus == 0 {
        //     print("Build succeeded!")
        // } else {
        //     print("Build failed.")
        // }
        
    } catch {
        print("Error writing XAML file: \(error)")
    }
    
} else {
    // If not on Windows, do the equivalent for macOS or Linux
    // e.g., call a function to transform the DSL into SwiftUI or Gtk code, etc.
    print("Detected \(currentPlatform). Windows-specific build skipped.")
}
