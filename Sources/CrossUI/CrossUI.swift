import Foundation

public protocol View {
    func render(platform: Platform) -> String
}

/// An enum for platforms you support.
/// This can help you dispatch the correct rendering logic.
public enum Platform {
    case macOS, linux, windows
}

/// Example UI components:

public struct Text: View {
    let content: String
    
    public init(_ content: String) {
        self.content = content
    }
    
    public func render(platform: Platform) -> String {
        switch platform {
        case .windows:
            // Return WinUI XAML snippet or some placeholder for now
            return "<TextBlock Text=\"\(content)\" />"
        case .macOS:
            // For SwiftUI, maybe do: "Text(\"\(content)\")"
            return "Text(\"\(content)\")"
        case .linux:
            // Some other representation
            return "GtkLabel(\"\(content)\")"
        }
    }
}

public struct Button: View {
    let title: String
    let action: () -> Void
    
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public func render(platform: Platform) -> String {
        switch platform {
        case .windows:

            return "<TextBlock Text=\"\(title)\" />"
        case .macOS:
            
            return """
            Button {

            } label: {
            Text(\(title)
            }
"""
            
        case .linux:
            // Some other representation
            return "GTKButton(\"\(title)\")"
        }
    }
}

public struct VStack: View {
    let children: [View]
    
    public init(@ViewBuilder _ content: () -> [View]) {
        self.children = content()
    }
    
    public func render(platform: Platform) -> String {
        switch platform {
        case .windows:
            // WinUI stack:
            // <StackPanel Orientation="Vertical"> ... </StackPanel>
            let childXaml = children
                .map { $0.render(platform: .windows) }
                .joined(separator: "\n")
            return """
            <StackPanel Orientation="Vertical">
                \(childXaml)
            </StackPanel>
            """
        case .macOS:
            // SwiftUI stack:
            // VStack { ... }
            let childLines = children
                .map { $0.render(platform: .macOS) }
                .joined(separator: "\n")
            return """
            import SwiftUI
            
            struct ContentView: View {
                var body: some View {
                    VStack {
                        \(childLines)
                    }
                }
            }
            """
        case .linux:
            // Some Linux representation, e.g. "GtkVBox() { ... }"
            let childLines = children
                .map { $0.render(platform: .linux) }
                .joined(separator: ", ")
            return "GtkBox(orientation: .vertical, children: [\(childLines)])"
        }
    }
}

/// A custom result builder to allow SwiftUI-like syntax
@resultBuilder
public struct ViewBuilder {
    public static func buildBlock(_ components: View...) -> [View] {
        components
    }
}
