//
//  Generators.swift
//  CrossUI
//
//  Created by Noah Moller on 30/12/2024.
//

import Foundation
import CrossUI

func generateMacOSProject(appName: String, rootView: View) throws {
    let macOSDir = "Build/macOS"
    try FileManager.default.createDirectory(atPath: macOSDir, withIntermediateDirectories: true, attributes: nil)

    let swiftUIOutput = rootView.render(platform: .macOS)

    let contentViewPath = macOSDir + "/ContentView.swift"
    let swiftUISource = """
    import SwiftUI

    struct ContentView: View {
        var body: some View {
            \(swiftUIOutput)
        }
    }

    @main
    struct \(appName)App: App {
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
        }
    }
    """
    try swiftUISource.write(toFile: contentViewPath, atomically: true, encoding: .utf8)
    
    let xcodeProjDir = macOSDir + "/\(appName).xcodeproj"
    try FileManager.default.createDirectory(atPath: xcodeProjDir, withIntermediateDirectories: true, attributes: nil)

    let pbxprojPath = xcodeProjDir + "/project.pbxproj"
    let pbxprojContent = """
    // Placeholder PBX project
    // You would put an actual minimal PBX project file here
    """
    try pbxprojContent.write(toFile: pbxprojPath, atomically: true, encoding: .utf8)

    let infoPlistPath = macOSDir + "/Info.plist"
    let infoPlistContent = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>CFBundleName</key>
        <string>\(appName)</string>
    </dict>
    </plist>
    """
    try infoPlistContent.write(toFile: infoPlistPath, atomically: true, encoding: .utf8)
}

func generateWindowsProject(appName: String, rootView: View) throws {
    let windowsDir = "Build/windows"
    try FileManager.default.createDirectory(atPath: windowsDir, withIntermediateDirectories: true, attributes: nil)

    let xamlOutput = renderWinUIRoot(rootView)

    let mainPagePath = windowsDir + "/MainPage.xaml"
    try xamlOutput.write(toFile: mainPagePath, atomically: true, encoding: .utf8)
    
    let slnPath = windowsDir + "/\(appName).sln"
    let slnContent = """
    Microsoft Visual Studio Solution File, Format Version 12.00
    # Minimal or template solution
    # You'd actually generate the lines referencing your .csproj or .vcxproj
    """
    try slnContent.write(toFile: slnPath, atomically: true, encoding: .utf8)

    let csprojPath = windowsDir + "/\(appName).csproj"
    let csprojContent = """
    <Project Sdk="Microsoft.NET.Sdk">
      <PropertyGroup>
        <OutputType>WinExe</OutputType>
        <TargetFramework>net6.0-windows</TargetFramework>
        <UseWinUI>true</UseWinUI>
      </PropertyGroup>
      <ItemGroup>
        <Page Include="MainPage.xaml">
          <Generator>MSBuild:Compile</Generator>
          <SubType>Designer</SubType>
        </Page>
      </ItemGroup>
    </Project>
    """
    try csprojContent.write(toFile: csprojPath, atomically: true, encoding: .utf8)
    
    let appXamlPath = windowsDir + "/App.xaml"
    let appXamlContent = """
    <Application
        x:Class="\(appName).App"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        >
        <Application.Resources>
        </Application.Resources>
    </Application>
    """
    try appXamlContent.write(toFile: appXamlPath, atomically: true, encoding: .utf8)
    
    let appCsPath = windowsDir + "/App.xaml.cs"
    let appCsContent = """
    using Microsoft.UI.Xaml;

    namespace \(appName)
    {
        public partial class App : Application
        {
            public App()
            {
                this.InitializeComponent();
            }

            protected override void OnLaunched(Microsoft.UI.Xaml.LaunchActivatedEventArgs args)
            {
                m_window = new MainWindow();
                m_window.Activate();
            }

            private Window m_window;
        }
    }
    """
    try appCsContent.write(toFile: appCsPath, atomically: true, encoding: .utf8)
}

func generateLinuxProject(appName: String, rootView: View) throws {
    let linuxDir = "Build/linux"
    try FileManager.default.createDirectory(atPath: linuxDir, withIntermediateDirectories: true, attributes: nil)
    let linuxUIOutput = rootView.render(platform: .linux)

    let linuxUIPath = linuxDir + "/LinuxUI.swift"
    let swiftFile = """
    import Glibc
    
    // Hypothetical usage:
    // let window = GtkWindow()
    // ...
    // We'll just store the result for demonstration.
    let content = "\(linuxUIOutput)"
    print("Running Linux UI: \\(content)")
    """
    try swiftFile.write(toFile: linuxUIPath, atomically: true, encoding: .utf8)
    
    let makefilePath = linuxDir + "/Makefile"
    let makefileContent = """
    all:
    \tswiftc LinuxUI.swift -o \(appName)
    """
    try makefileContent.write(toFile: makefilePath, atomically: true, encoding: .utf8)
}

func compileNativePlatform(appName: String, platform: Platform) throws {
    switch platform {
    case .macOS:

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/xcodebuild")
        process.arguments = [
            "-project", "Build/macOS/\(appName).xcodeproj",
            "-scheme", appName,
            "build"
        ]
        try process.run()
        process.waitUntilExit()
        if process.terminationStatus != 0 {
            throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey : "xcodebuild failed"])
        }

    case .windows:
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "C:/Program Files/Microsoft Visual Studio/2022/BuildTools/MSBuild/Current/Bin/MSBuild.exe")
        process.arguments = ["Build/windows/\(appName).sln", "/t:Rebuild", "/p:Configuration=Release"]
        try process.run()
        process.waitUntilExit()
        if process.terminationStatus != 0 {
            throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey : "MSBuild failed"])
        }

    case .linux:
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/make")
        process.currentDirectoryURL = URL(fileURLWithPath: "Build/linux")
        try process.run()
        process.waitUntilExit()
        if process.terminationStatus != 0 {
            throw NSError(domain: "BuildError", code: 1, userInfo: [NSLocalizedDescriptionKey : "make failed"])
        }
    }
}
