//
//  main.swift
//  CrossUI
//
//  Created by You on 30/12/2024.
//

import Foundation
import CrossUI

#if os(Windows)
let nativePlatform = Platform.windows
#elseif os(macOS)
let nativePlatform = Platform.macOS
#else
let nativePlatform = Platform.linux
#endif

let args = CommandLine.arguments

guard args.count > 1 else {
    print("""
    Usage:
      cross new <projectName>    Create a new CrossUI project
      cross build                Generate and/or build all platform projects
    """)
    exit(1)
}

let command = args[1]

switch command {

case "new":
    guard args.count > 2 else {
        print("Usage: cross new <projectName>")
        exit(1)
    }
    let projectName = args[2]
    
    do {
        try createNewProject(named: projectName)
        print("New CrossUI project created: \(projectName)")
    } catch {
        print("Error creating project: \(error)")
        exit(1)
    }
    exit(0)

case "build":
    struct ContentView {
        let body: some View = VStack {
            Text("Hello from CrossUI!")
            Text("Hello again from CrossUI!")
        }
    }
    let rootView = ContentView().body
    do {
        try generateMacOSProject(appName: "MyCrossUIApp", rootView: rootView)
        print("Generated macOS project in Build/macOS")
    } catch {
        print("Error generating macOS project: \(error)")
    }
    
    do {
        try generateWindowsProject(appName: "MyCrossUIApp", rootView: rootView)
        print("Generated Windows project in Build/windows")
    } catch {
        print("Error generating Windows project: \(error)")
    }
    
    do {
        try generateLinuxProject(appName: "MyCrossUIApp", rootView: rootView)
        print("Generated Linux project in Build/linux")
    } catch {
        print("Error generating Linux project: \(error)")
    }

    do {
        try compileNativePlatform(appName: "MyCrossUIApp", platform: nativePlatform)
    } catch {
        print("Native build failed: \(error)")
    }
    
    exit(0)

default:
    print("Unknown command: \(command)")
    exit(1)
}
