//
//  CreateProject.swift
//  CrossUI
//
//  Created by Noah Moller on 30/12/2024.
//

import Foundation

func createNewProject(named projectName: String) throws {
    let fileManager = FileManager.default
    let projectDir = "\(fileManager.currentDirectoryPath)/\(projectName)"
    let sourcesDir = "\(projectDir)/Sources/\(projectName)"
    let testsDir = "\(projectDir)/Tests"

    try fileManager.createDirectory(atPath: sourcesDir, withIntermediateDirectories: true)
    try fileManager.createDirectory(atPath: testsDir, withIntermediateDirectories: true)

    let packageSwift = """
    // swift-tools-version:5.7
    import PackageDescription

    let package = Package(
        name: "\(projectName)",
        platforms: [
            .macOS(.v10_15)
        ],
        dependencies: [
            .package(url: "https://github.com/Noah-Moller/CrossUI.git", branch: "main")
        ],
        targets: [
            .executableTarget(
                name: "\(projectName)",
                dependencies: [
                    .product(name: "CrossUI", package: "CrossUI")
                ],
                path: "Sources/\(projectName)"
            )
        ]
    )
    """
    try packageSwift.write(toFile: "\(projectDir)/Package.swift", atomically: true, encoding: .utf8)

    let mainSwift = """
    import CrossUI

    struct TestProject: Project {
        static let entryView = ContentView()
    }

    print(TestProject.entryViewDescription())
    """
    try mainSwift.write(toFile: "\(sourcesDir)/main.swift", atomically: true, encoding: .utf8)

    let contentViewSwift = """
    import CrossUI

    struct ContentView: View {
        var body: some View {
            VStack {
                Text("Hello, CrossUI!")
                Text("This is your main content view.")
            }
        }

        func render(platform: Platform) -> String {
            body.render(platform: platform)
        }
    }
    """
    try contentViewSwift.write(toFile: "\(sourcesDir)/ContentView.swift", atomically: true, encoding: .utf8)

    print("New CrossUI project created at \(projectDir)")
}
