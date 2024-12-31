//
//  CrossUI.swift
//  CrossUI
//
//  Created by Noah Moller on 30/12/2024.
//

import Foundation

public protocol View {
    func render(platform: Platform) -> String
}

public protocol Project {
    associatedtype ViewType: View
    static var entryView: ViewType { get }
}

public enum Platform {
    case macOS, linux, windows
}

public struct Text: View {
    let content: String
    
    public init(_ content: String) {
        self.content = content
    }
    
    public func render(platform: Platform) -> String {
        switch platform {
        case .windows:
            return "<TextBlock Text=\"\(content)\" />"
        case .macOS:
            return "Text(\"\(content)\")"
        case .linux:
            return "GtkLabel(\"\(content)\")"
        }
    }
}

//public struct TextField: View {
//    var text: String
//    let title: String
//    
//    public init(_ text: String, title: String) {
//        self.text = text
//        self.title = title
//    }
//    
//    public func render(platform: Platform) -> String {
//        switch platform {
//        case .windows:
//            return "<TextBlock Text=\"\(content)\" />"
//        case .macOS:
//            return """
//        TextField("\(title)", text: $\(text)
//        """
//        case .linux:
//            return "GtkLabel(\"\(content)\")"
//        }
//    }
//}

public struct VStack: View {
    let children: [View]
    
    public init(@ViewBuilder _ content: () -> [View]) {
        self.children = content()
    }
    
    public func render(platform: Platform) -> String {
        switch platform {
        case .windows:
            let childXaml = children
                .map { $0.render(platform: .windows) }
                .joined(separator: "\n")
            return """
            <StackPanel Orientation="Vertical">
                \(childXaml)
            </StackPanel>
            """
        case .macOS:
            let childLines = children
                .map { $0.render(platform: .macOS) }
                .joined(separator: "\n")
            return """
                    VStack {
                        \(childLines)
                    }
            """
        case .linux:
            let childLines = children
                .map { $0.render(platform: .linux) }
                .joined(separator: ", ")
            return "GtkBox(orientation: .vertical, children: [\(childLines)])"
        }
    }
}

@resultBuilder
public struct ViewBuilder {
    public static func buildBlock(_ components: View...) -> [View] {
        components
    }
}
