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
      cross build                Build all platform files
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
    do {
        try buildProject()
    } catch {
        print("Error building project: \(error)")
        exit(1)
    }
    exit(0)

default:
    print("Unknown command: \(command)")
    exit(1)
}

func buildProject() throws {
    print("Building project...")
    
    let projectDir = FileManager.default.currentDirectoryPath
    let sourcesDir = "\(projectDir)/Sources"
    
    guard let mainFile = try findMainSwiftFile(in: sourcesDir, projectDirectory: projectDir) else {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "main.swift not found in Sources."])
    }
    
    print("Found main.swift at: \(mainFile)")
    
    let (entryViewDescription, stateVariables) = try extractEntryViewDescription(from: mainFile, sourcesDir: sourcesDir)
    
    print("Extracted entry view description: \(entryViewDescription)")
    
    let projectName = projectDir.split(separator: "/").last ?? "CrossUIApp"
    let wrapperView = DescriptionView(description: entryViewDescription, stateVariables: stateVariables)
    
    // Generate platform-specific files
    try generateMacOSProject(appName: String(projectName), rootView: wrapperView)
    try generateWindowsProject(appName: String(projectName), rootView: wrapperView)
    try generateLinuxProject(appName: String(projectName), rootView: wrapperView)
    
    #if os(macOS)
    // Build and run the Xcode project on macOS
    print("Building and running macOS app...")
    try buildAndRunMacOSApp(appName: String(projectName))
    #endif
    
    print("Build complete!")
}

#if os(macOS)
func buildAndRunMacOSApp(appName: String) throws {
    let buildFolderRemover = Process()
    
    buildFolderRemover.executableURL = URL(fileURLWithPath: "/usr/bin/rm")
    buildFolderRemover.arguments = ["-rf", "Build/macOS/build"]
    try buildFolderRemover.run()
    buildFolderRemover.waitUntilExit()
    
    let macOSDir = "Build/macOS"
    let buildDir = "\(macOSDir)/build"  // Local build directory
    
    // Clean and build the app using xcodebuild
    let buildProcess = Process()
    buildProcess.executableURL = URL(fileURLWithPath: "/usr/bin/xcodebuild")
    buildProcess.arguments = [
        "-project", "\(macOSDir)/\(appName).xcodeproj",
        "-scheme", appName,
        "-configuration", "Debug",
        "-derivedDataPath", buildDir,
        "clean", "build"
    ]
    
    try buildProcess.run()
    buildProcess.waitUntilExit()
    
    if buildProcess.terminationStatus != 0 {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to build macOS app"])
    }
    
    // The app should be in a known location now
    let appPath = "\(buildDir)/Build/Products/Debug/\(appName).app"
    print("Launching app at: \(appPath)")
    
    guard FileManager.default.fileExists(atPath: appPath) else {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "App not found at path: \(appPath)"])
    }
    
    // Open the app using 'open' command
    let openProcess = Process()
    openProcess.executableURL = URL(fileURLWithPath: "/usr/bin/open")
    openProcess.arguments = [appPath]
    
    try openProcess.run()
    openProcess.waitUntilExit()
    
    if openProcess.terminationStatus != 0 {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to launch macOS app"])
    }
}
#endif

func findMainSwiftFile(in sourcesDir: String, projectDirectory: String) throws -> String? {
    let fileManager = FileManager.default

    let enumerator = fileManager.enumerator(atPath: sourcesDir)
    while let element = enumerator?.nextObject() as? String {
        if element.hasSuffix("main.swift") {
            return "\(projectDirectory)/Sources/\(element)"
        }
    }

    return nil
}

func extractEntryViewDescription(from mainFile: String, sourcesDir: String) throws -> (String, [StateVariable]) {
    let projectDir = FileManager.default.currentDirectoryPath
    
    let fileContents = try String(contentsOfFile: mainFile, encoding: .utf8)
    let lines = fileContents.components(separatedBy: .newlines)
    
    var stateVariables: [StateVariable] = []
    var inContentView = false
    var bodyContent = ""
    
    // Parse state variables and body content
    for line in lines {
        let trimmedLine = line.trimmingCharacters(in: .whitespaces)
        
        if trimmedLine.contains("struct ContentView: View {") {
            inContentView = true
            continue
        }
        
        if inContentView {
            if trimmedLine.hasPrefix("@State") {
                if let stateVar = StateVariable.parse(trimmedLine) {
                    stateVariables.append(stateVar)
                }
            } else if trimmedLine.contains("var body: some View {") {
                // Start capturing body content
                bodyContent = try String(contentsOfFile: mainFile, encoding: .utf8)
                break
            }
        }
    }
    
    // Build and run to get the rendered body content
    let buildProcess = Process()
    buildProcess.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
    buildProcess.arguments = ["build", "--package-path", projectDir]
    
    try buildProcess.run()
    buildProcess.waitUntilExit()
    
    let executableName = projectDir.split(separator: "/").last ?? "Main"
    let executablePath = "\(projectDir)/.build/debug/\(executableName)"
    
    let runProcess = Process()
    runProcess.executableURL = URL(fileURLWithPath: executablePath)
    
    let pipe = Pipe()
    runProcess.standardOutput = pipe
    
    try runProcess.run()
    runProcess.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    
    return (output, stateVariables)
}

func generatePlatformFiles(from entryViewDescription: String, buildDir: String) throws {
    let platforms: [Platform] = [.macOS, .windows, .linux]

    for platform in platforms {
        let outputDir = "\(buildDir)/\(platform)"
        try FileManager.default.createDirectory(atPath: outputDir, withIntermediateDirectories: true)

        let renderedOutput = renderEntryView(description: entryViewDescription, platform: platform)
        let outputFile: String

        switch platform {
        case .macOS:
            outputFile = "\(outputDir)/Main.swift"
        case .windows:
            outputFile = "\(outputDir)/MainPage.xaml"
        case .linux:
            outputFile = "\(outputDir)/Main.swift"
        }

        try renderedOutput.write(toFile: outputFile, atomically: true, encoding: .utf8)
        print("Generated \(platform) file at: \(outputFile)")
    }
}

func renderEntryView(description: String, platform: Platform) -> String {
    switch platform {
    case .macOS:
        return """
        import SwiftUI

        @main
        struct MyApp: App {
            var body: some Scene {
                WindowGroup {
                    \(description)
                }
            }
        }
        """
    case .windows:
        return """
        <Page
            xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
            xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
            <Grid>
                \(description)
            </Grid>
        </Page>
        """
    case .linux:
        return """
        import Gtk

        func main() {
            let app = Gtk.Application(applicationId: "com.example.MyApp")
            app.run { builder in
                builder.build { \(description) }
            }
        }
        """
    }
}
