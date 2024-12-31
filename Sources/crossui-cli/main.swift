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
    let buildDir = "\(projectDir)/Build"

    // Find and validate the `main.swift` file
    guard let mainFile = try findMainSwiftFile(in: sourcesDir) else {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "main.swift not found in Sources."])
    }

    print("Found main.swift at: \(mainFile)")

    // Dynamically compile and execute the main.swift file
    let entryViewDescription = try extractEntryViewDescription(from: mainFile, sourcesDir: sourcesDir)

    print("Extracted entry view description: \(entryViewDescription)")

    // Generate platform-specific files
    try generatePlatformFiles(from: entryViewDescription, buildDir: buildDir)
    print("Build complete!")
}

// Locate `main.swift`
func findMainSwiftFile(in sourcesDir: String) throws -> String? {
    let mainFilePath = "\(sourcesDir)/main.swift"
    return FileManager.default.fileExists(atPath: mainFilePath) ? mainFilePath : nil
}

// Compile and execute `main.swift` to extract the entry view
func extractEntryViewDescription(from mainFile: String, sourcesDir: String) throws -> String {
    let tempExecutablePath = "\(sourcesDir)/tempExecutable"

    // Compile the `main.swift` file using swiftc
    let compileProcess = Process()
    compileProcess.executableURL = URL(fileURLWithPath: "/usr/bin/swiftc")
    compileProcess.arguments = ["-o", tempExecutablePath, mainFile]

    try compileProcess.run()
    compileProcess.waitUntilExit()

    guard compileProcess.terminationStatus == 0 else {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to compile \(mainFile)."])
    }

    // Execute the compiled binary to extract the entry view description
    let executeProcess = Process()
    executeProcess.executableURL = URL(fileURLWithPath: tempExecutablePath)

    let pipe = Pipe()
    executeProcess.standardOutput = pipe

    try executeProcess.run()
    executeProcess.waitUntilExit()

    guard executeProcess.terminationStatus == 0 else {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to execute compiled \(mainFile)."])
    }

    // Capture the output from the executable
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let output = String(data: data, encoding: .utf8) else {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to capture output from \(tempExecutablePath)."])
    }

    // Cleanup: Remove the temporary executable
    try FileManager.default.removeItem(atPath: tempExecutablePath)

    return output.trimmingCharacters(in: .whitespacesAndNewlines)
}

// Generate platform-specific files from the entry view description
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

// Render the entry view description for a specific platform
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
