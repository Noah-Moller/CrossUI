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
    associatedtype EntryView: View
    static var entryView: EntryView { get }
}

public enum Platform {
    case macOS, linux, windows
}

public protocol RenderableView: View {
    func renderContent(platform: Platform) -> String
}

extension RenderableView {
    public func render(platform: Platform) -> String {
        renderContent(platform: platform)
    }
}

public struct Text: RenderableView {
    let content: String

    public init(_ content: String) {
        self.content = content
    }

    public func renderContent(platform: Platform) -> String {
        switch platform {
        case .macOS:
            return "Text(\"\(content)\")"
        case .windows:
            return "<TextBlock Text=\"\(content)\" />"
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

public struct VStack: RenderableView {
    let children: [View]

    public init(@ViewBuilder _ content: () -> [View]) {
        self.children = content()
    }

    public func renderContent(platform: Platform) -> String {
        switch platform {
        case .macOS:
            return """
            VStack {
                \(children.map { $0.render(platform: .macOS) }.joined(separator: ", "))
            }
            """
        case .windows:
            return """
            <StackPanel Orientation="Vertical">
                \(children.map { $0.render(platform: .windows) }.joined(separator: "\n"))
            </StackPanel>
            """
        case .linux:
            return """
            GtkVBox {
                \(children.map { $0.render(platform: .linux) }.joined(separator: ", "))
            }
            """
        }
    }
}

@resultBuilder
public struct ViewBuilder {
    public static func buildBlock(_ components: View...) -> [View] {
        components
    }
}
