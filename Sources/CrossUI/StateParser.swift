import Foundation

public struct StateVariable {
    let declaration: String
    let isPrivate: Bool
    let name: String
    let type: String
    let initialValue: String?
    
    public static func parse(_ line: String) -> StateVariable? {
        // Match pattern like "@State private var someVar = 0" or "@State var someVar: Int"
        let pattern = #"@State\s+(private\s+)?var\s+(\w+)(\s*:\s*([^=]+))?(\s*=\s*(.+))?"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []),
              let match = regex.firstMatch(in: line, options: [], range: NSRange(line.startIndex..., in: line)) else {
            return nil
        }
        
        let nsLine = line as NSString
        let isPrivate = match.range(at: 1).location != NSNotFound
        let name = nsLine.substring(with: match.range(at: 2))
        let type = match.range(at: 4).location != NSNotFound ? nsLine.substring(with: match.range(at: 4)).trimmingCharacters(in: .whitespaces) : nil
        let initialValue = match.range(at: 6).location != NSNotFound ? nsLine.substring(with: match.range(at: 6)) : nil
        
        return StateVariable(
            declaration: line,
            isPrivate: isPrivate,
            name: name,
            type: type ?? "Any",
            initialValue: initialValue
        )
    }
    
    public func toSwiftUI() -> String {
        // For SwiftUI, we can just return the original declaration since it's the same
        declaration
    }
    
    public func toWinUI() -> String {
        // Convert to WinUI/XAML state management
        // This would be implemented based on WinUI state management patterns
        "// TODO: Implement WinUI state"
    }
} 
