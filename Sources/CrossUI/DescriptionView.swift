import Foundation

public struct DescriptionView: View {
    let description: String
    let stateVariables: [StateVariable]
    
    public init(description: String, stateVariables: [StateVariable] = []) {
        self.description = description
        self.stateVariables = stateVariables
    }
    
    public var body: some View {
        self
    }
    
    public func render(platform: Platform) -> String {
        let stateDeclarations = stateVariables.map { variable -> String in
            switch platform {
            case .macOS:
                return variable.toSwiftUI()
            case .windows:
                return variable.toWinUI()
            case .linux:
                return "// Linux state management not implemented"
            }
        }.joined(separator: "\n    ")
        
        switch platform {
        case .macOS:
            return """
            struct ContentView: View {
                \(stateDeclarations)
                
                var body: some View {
                    \(description)
                }
            }
            """
        default:
            return description
        }
    }
} 
