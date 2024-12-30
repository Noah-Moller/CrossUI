//
//  File.swift
//  CrossUI
//
//  Created by Noah Moller on 30/12/2024.
//

import Foundation

#if os(macOS)
    import SwiftUI
#else
#endif

struct Content {
#if os(macOS)
    var view: NSView
#elseif os(Windows)
    var view: String
#elseif os(Linux)
    var view: String
#else
#endif
}

