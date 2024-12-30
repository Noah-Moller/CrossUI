//
//  File.swift
//  CrossUI
//
//  Created by Noah Moller on 30/12/2024.
//

import Foundation

public func renderWinUIRoot(_ view: View) -> String {
    let content = view.render(platform: .windows)
    return """
    <Page
        x:Class="MainPage"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        mc:Ignorable="d">
        <Grid>
            \(content)
        </Grid>
    </Page>
    """
}

