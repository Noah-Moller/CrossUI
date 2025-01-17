//
//  Generators.swift
//  CrossUI
//
//  Created by Noah Moller on 30/12/2024.
//

import Foundation
import CrossUI

func generateMacOSProject(appName: String, rootView: any View) throws {
    let macOSDir = "Build/macOS"
    try FileManager.default.createDirectory(atPath: macOSDir, withIntermediateDirectories: true, attributes: nil)

    // Generate SwiftUI View file
    let contentViewPath = macOSDir + "/ContentView.swift"
    let swiftUISource = """
    import SwiftUI
    
    struct ContentView: View {
        var body: some View {
            \(rootView.render(platform: .macOS))
        }
    }
    """
    try swiftUISource.write(toFile: contentViewPath, atomically: true, encoding: .utf8)
    
    // Generate App file
    let appSwiftPath = macOSDir + "/\(appName)App.swift"
    let appSwiftContent = """
    import SwiftUI
    
    @main
    struct \(appName)App: App {
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
        }
    }
    """
    try appSwiftContent.write(toFile: appSwiftPath, atomically: true, encoding: .utf8)
    
    // Generate project.pbxproj
    let xcodeProjDir = macOSDir + "/\(appName).xcodeproj"
    try FileManager.default.createDirectory(atPath: xcodeProjDir, withIntermediateDirectories: true, attributes: nil)
    
    let pbxprojPath = xcodeProjDir + "/project.pbxproj"
    let pbxprojContent = generateXcodeProjContent(appName: appName)
    try pbxprojContent.write(toFile: pbxprojPath, atomically: true, encoding: .utf8)
    
    // Generate Info.plist
    let infoPlistPath = macOSDir + "/Info.plist"
    let infoPlistContent = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>CFBundleName</key>
        <string>\(appName)</string>
        <key>CFBundleIdentifier</key>
        <string>com.crossui.\(appName.lowercased())</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleShortVersionString</key>
        <string>1.0</string>
        <key>CFBundleVersion</key>
        <string>1</string>
        <key>LSMinimumSystemVersion</key>
        <string>10.15</string>
        <key>LSApplicationCategoryType</key>
        <string>public.app-category.developer-tools</string>
    </dict>
    </plist>
    """
    try infoPlistContent.write(toFile: infoPlistPath, atomically: true, encoding: .utf8)
}

// Helper function to generate Xcode project content
private func generateXcodeProjContent(appName: String) -> String {
    // This is a simplified version. In practice, you'd want to use a proper Xcode project template
    return """
    // !$*UTF8*$!
    {
        archiveVersion = 1;
        classes = {
        };
        objectVersion = 55;
        objects = {
            /* Begin PBXBuildFile section */
            1234567890ABCDEF /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 1234567890ABCD0 /* ContentView.swift */; };
            1234567890ABCD1 /* \(appName)App.swift in Sources */ = {isa = PBXBuildFile; fileRef = 1234567890ABCD2 /* \(appName)App.swift */; };
            /* End PBXBuildFile section */
            
            /* Begin PBXFileReference section */
            1234567890ABCD0 /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; };
            1234567890ABCD2 /* \(appName)App.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "\(appName)App.swift"; sourceTree = "<group>"; };
            1234567890ABCD3 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
            1234567890ABCD4 /* \(appName).app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = "\(appName).app"; sourceTree = BUILT_PRODUCTS_DIR; };
            /* End PBXFileReference section */
            
            /* Begin PBXFrameworksBuildPhase section */
            1234567890ABCD5 /* Frameworks */ = {
                isa = PBXFrameworksBuildPhase;
                buildActionMask = 2147483647;
                files = (
                );
                runOnlyForDeploymentPostprocessing = 0;
            };
            /* End PBXFrameworksBuildPhase section */
            
            /* Begin PBXGroup section */
            1234567890ABCD6 /* \(appName) */ = {
                isa = PBXGroup;
                children = (
                    1234567890ABCD0 /* ContentView.swift */,
                    1234567890ABCD2 /* \(appName)App.swift */,
                    1234567890ABCD3 /* Info.plist */,
                );
                path = \(appName);
                sourceTree = "<group>";
            };
            /* End PBXGroup section */
            
            /* Begin PBXNativeTarget section */
            1234567890ABCD7 /* \(appName) */ = {
                isa = PBXNativeTarget;
                buildConfigurationList = 1234567890ABCD8;
                buildPhases = (
                    1234567890ABCD5 /* Frameworks */,
                    1234567890ABCD9 /* Sources */,
                );
                buildRules = (
                );
                dependencies = (
                );
                name = \(appName);
                productName = \(appName);
                productReference = 1234567890ABCD4 /* \(appName).app */;
                productType = "com.apple.product-type.application";
            };
            /* End PBXNativeTarget section */
            
            /* Begin XCBuildConfiguration section */
            1234567890ABCDA /* Debug */ = {
                isa = XCBuildConfiguration;
                buildSettings = {
                    ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
                    CODE_SIGN_STYLE = Automatic;
                    CURRENT_PROJECT_VERSION = 1;
                    ENABLE_PREVIEWS = YES;
                    GENERATE_INFOPLIST_FILE = YES;
                    INFOPLIST_FILE = Info.plist;
                    LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/../Frameworks";
                    MACOSX_DEPLOYMENT_TARGET = 10.15;
                    PRODUCT_BUNDLE_IDENTIFIER = "com.crossui.\(appName.lowercased())";
                    PRODUCT_NAME = "$(TARGET_NAME)";
                    SDKROOT = macosx;
                    SWIFT_VERSION = 5.0;
                };
                name = Debug;
            };
            /* End XCBuildConfiguration section */
        };
        rootObject = 1234567890ABCDB /* Project object */;
    }
    """
}

func generateWindowsProject(appName: String, rootView: any View) throws {
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

func generateLinuxProject(appName: String, rootView: any View) throws {
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
