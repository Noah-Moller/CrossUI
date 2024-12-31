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

    guard let mainFile = try findMainSwiftFile(in: sourcesDir) else {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "main.swift not found in Sources."])
    }

    print("Found main.swift at: \(mainFile)")

    let entryViewDescription = try extractEntryViewDescription(from: mainFile, sourcesDir: sourcesDir)

    print("Extracted entry view description: \(entryViewDescription)")

    try generatePlatformFiles(from: entryViewDescription as! View, buildDir: buildDir)
    print("Build complete!")
}

func findMainSwiftFile(in sourcesDir: String) throws -> String? {
    let fileManager = FileManager.default

    let enumerator = fileManager.enumerator(atPath: sourcesDir)
    while let element = enumerator?.nextObject() as? String {
        if element.hasSuffix("main.swift") {
            return "\(sourcesDir)/\(element)"
        }
    }

    return nil
}

func extractEntryViewDescription(from mainFile: String, sourcesDir: String) throws -> String {
    let projectDir = FileManager.default.currentDirectoryPath

    let buildProcess = Process()
    buildProcess.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
    buildProcess.arguments = ["build", "--package-path", projectDir]

    try buildProcess.run()
    buildProcess.waitUntilExit()

    guard buildProcess.terminationStatus == 0 else {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to build project at \(projectDir)."])
    }

    let executableName = projectDir.split(separator: "/").last ?? "Main"
    let executablePath = "\(projectDir)/.build/debug/\(executableName)"

    guard FileManager.default.fileExists(atPath: executablePath) else {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Executable not found at \(executablePath)."])
    }

    let executeProcess = Process()
    executeProcess.executableURL = URL(fileURLWithPath: executablePath)

    let pipe = Pipe()
    executeProcess.standardOutput = pipe

    try executeProcess.run()
    executeProcess.waitUntilExit()

    guard executeProcess.terminationStatus == 0 else {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to execute \(executablePath)."])
    }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let output = String(data: data, encoding: .utf8) else {
        throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to capture output from \(executablePath)."])
    }

    return output.trimmingCharacters(in: .whitespacesAndNewlines)
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
