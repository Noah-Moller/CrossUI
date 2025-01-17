//
//  CrossUI.swift
//  CrossUI
//
//  Created by Noah Moller on 30/12/2024.
//

import Foundation

public protocol View {
    func render(platform: Platform) -> String
    associatedtype Body: View
    var body: Body { get }
}

public protocol Project {
    associatedtype EntryView: View
    static var entryView: EntryView { get }

    static func entryViewDescription() -> String
}

extension Project {
    public static func entryViewDescription() -> String {
        return entryView.render(platform: .macOS)
    }
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

public struct Text: View {
    let content: String
    
    public init(_ content: String) {
        self.content = content
    }
    
    public init(_ binding: Binding<String>) {
        self.content = binding.wrappedValue
    }
    
    public var body: some View {
        self
    }
    
    public func render(platform: Platform) -> String {
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

public struct TextField: View {
    var text: Binding<String>
    let title: String
    
    public init(_ text: Binding<String>, title: String) {
        self.text = text
        self.title = title
    }
    
    public var body: some View {
        self
    }
    
    public func render(platform: Platform) -> String {
        switch platform {
        case .windows:
            return "<TextBox Text=\"{Binding \(text.wrappedValue)}\" PlaceholderText=\"\(title)\" />"
        case .macOS:
            return """
            TextField("\(title)", text: \(text.wrappedValue))
            """
        case .linux:
            return "GtkEntry(text: \"\(text.wrappedValue)\", placeholder: \"\(title)\")"
        }
    }
}

public struct VStack: View {
    let children: [any View]

    public init(@ViewBuilder _ content: () -> [any View]) {
        self.children = content()
    }
    
    public var body: some View {
        self
    }

    public func render(platform: Platform) -> String {
        switch platform {
        case .macOS:
            return """
            VStack {
                \(children.map { $0.render(platform: .macOS) }.joined(separator: "\n"))
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
    public static func buildBlock(_ components: any View...) -> [any View] {
        components
    }
}
