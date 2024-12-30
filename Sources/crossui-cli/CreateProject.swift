//
//  CreateProject.swift
//  CrossUI
//
//  Created by Noah Moller on 30/12/2024.
//

import Foundation

func createNewProject(named projectName: String) throws {
    let fm = FileManager.default

    try fm.createDirectory(atPath: projectName, withIntermediateDirectories: true, attributes: nil)

    let packageSwiftContent = """
    // swift-tools-version:5.7
    import PackageDescription

    let package = Package(
        name: "\(projectName)",
        platforms: [
            .macOS(.v10_15)
        ],
        dependencies: [
            // Adjust the URL and version/range for your actual CrossUI repo
            .package(url: "https://github.com/YourGitHubUser/CrossUI.git", from: "1.0.0")
        ],
        targets: [
            .executableTarget(
                name: "\(projectName)",
                dependencies: [
                    .product(name: "CrossUI", package: "CrossUI")
                ]
            )
        ]
    )
    """
    
    let packageSwiftPath = "\(projectName)/Package.swift"
    try packageSwiftContent.write(toFile: packageSwiftPath, atomically: true, encoding: .utf8)

    let sourcesDir = "\(projectName)/Sources/\(projectName)"
    try fm.createDirectory(atPath: sourcesDir, withIntermediateDirectories: true, attributes: nil)

    let contentViewContent = """
    import CrossUI

    struct ContentView {
        let body: some View = VStack {
            Text("Hello, CrossUI!")
            Text("Welcome to your new project.")
        }
    }
    """
    let contentViewPath = "\(sourcesDir)/ContentView.swift"
    try contentViewContent.write(toFile: contentViewPath, atomically: true, encoding: .utf8)

    let mainSwiftContent = """
    import CrossUI
    import Foundation

    // A simple main that prints out what ContentView would render on each platform
    #if os(Windows)
    let currentPlatform = Platform.windows
    #elseif os(macOS)
    let currentPlatform = Platform.macOS
    #else
    let currentPlatform = Platform.linux
    #endif

    // In a real scenario, you might build a crossui-cli command to do the generation,
    // but here is a quick demonstration of how you might render your UI inline:

    @main
    struct \(projectName)Main {
        static func main() {
            let view = ContentView().body
            let rendered = view.render(platform: currentPlatform)
            print("Rendered UI for \\(currentPlatform):\\n\\(rendered)")
        }
    }
    """
    let mainSwiftPath = "\(sourcesDir)/main.swift"
    try mainSwiftContent.write(toFile: mainSwiftPath, atomically: true, encoding: .utf8)
    
    print("Successfully created new CrossUI project: \(projectName)")
    print("Next steps:")
    print("  cd \(projectName)")
    print("  cross build   # to generate macOS/Windows/Linux project files")
}
