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
    let projectDir = "\(macOSDir)/\(appName).xcodeproj"
    let sourceDir = "\(macOSDir)/\(appName)"
    
    // Create necessary directories
    try FileManager.default.createDirectory(atPath: sourceDir, withIntermediateDirectories: true, attributes: nil)
    try FileManager.default.createDirectory(atPath: projectDir, withIntermediateDirectories: true, attributes: nil)
    
    // Generate source files
    let contentViewPath = "\(sourceDir)/ContentView.swift"
    let swiftUISource = """
    import SwiftUI
    
    struct ContentView: View {
        var body: some View {
            \(rootView.render(platform: .macOS))
        }
    }
    """
    try swiftUISource.write(toFile: contentViewPath, atomically: true, encoding: .utf8)
    
    let appSwiftPath = "\(sourceDir)/\(appName)App.swift"
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
    
    // Generate Info.plist
    let infoPlistPath = "\(sourceDir)/Info.plist"
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
    </dict>
    </plist>
    """
    try infoPlistContent.write(toFile: infoPlistPath, atomically: true, encoding: .utf8)
    
    // Generate project.pbxproj
    let pbxprojPath = "\(projectDir)/project.pbxproj"
    let pbxprojContent = """
    // !$*UTF8*$!
    {
        archiveVersion = 1;
        classes = {
        };
        objectVersion = 56;
        objects = {
            /* Begin PBXBuildFile section */
            13B07FBC1A68108700A75B9A /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 13B07FB71A68108700A75B9A /* ContentView.swift */; };
            13B07FBD1A68108700A75B9A /* \(appName)App.swift in Sources */ = {isa = PBXBuildFile; fileRef = 13B07FB61A68108700A75B9A /* \(appName)App.swift */; };
            /* End PBXBuildFile section */
            
            /* Begin PBXFileReference section */
            13B07F961A680F5B00A75B9A /* \(appName).app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = \(appName).app; sourceTree = BUILT_PRODUCTS_DIR; };
            13B07FB61A68108700A75B9A /* \(appName)App.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; name = "\(appName)App.swift"; path = "\(appName)/\(appName)App.swift"; sourceTree = SOURCE_ROOT; };
            13B07FB71A68108700A75B9A /* ContentView.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; name = ContentView.swift; path = \(appName)/ContentView.swift; sourceTree = SOURCE_ROOT; };
            13B07FB51A68108700A75B9A /* Info.plist */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = text.plist.xml; name = Info.plist; path = \(appName)/Info.plist; sourceTree = SOURCE_ROOT; };
            /* End PBXFileReference section */
            
            /* Begin PBXFrameworksBuildPhase section */
            13B07F8C1A680F5B00A75B9A /* Frameworks */ = {
                isa = PBXFrameworksBuildPhase;
                buildActionMask = 2147483647;
                files = (
                );
                runOnlyForDeploymentPostprocessing = 0;
            };
            /* End PBXFrameworksBuildPhase section */
            
            /* Begin PBXGroup section */
            83CBB9F61A601CBA00E9B192 = {
                isa = PBXGroup;
                children = (
                    13B07FB71A68108700A75B9A /* ContentView.swift */,
                    13B07FB61A68108700A75B9A /* \(appName)App.swift */,
                    13B07FB51A68108700A75B9A /* Info.plist */,
                    83CBBA001A601CBA00E9B192 /* Products */,
                );
                sourceTree = "<group>";
            };
            83CBBA001A601CBA00E9B192 /* Products */ = {
                isa = PBXGroup;
                children = (
                    13B07F961A680F5B00A75B9A /* \(appName).app */,
                );
                name = Products;
                sourceTree = "<group>";
            };
            /* End PBXGroup section */
            
            /* Begin PBXNativeTarget section */
            13B07F861A680F5B00A75B9A /* \(appName) */ = {
                isa = PBXNativeTarget;
                buildConfigurationList = 13B07F931A680F5B00A75B9A /* Build configuration list for PBXNativeTarget "\(appName)" */;
                buildPhases = (
                    13B07F871A680F5B00A75B9A /* Sources */,
                    13B07F8C1A680F5B00A75B9A /* Frameworks */,
                    13B07F8E1A680F5B00A75B9A /* Resources */,
                );
                buildRules = (
                );
                dependencies = (
                );
                name = \(appName);
                productName = \(appName);
                productReference = 13B07F961A680F5B00A75B9A /* \(appName).app */;
                productType = "com.apple.product-type.application";
            };
            /* End PBXNativeTarget section */
            
            /* Begin PBXProject section */
            83CBB9F71A601CBA00E9B192 /* Project object */ = {
                isa = PBXProject;
                attributes = {
                    LastUpgradeCheck = 1500;
                    ORGANIZATIONNAME = "";
                    TargetAttributes = {
                        13B07F861A680F5B00A75B9A = {
                            LastSwiftMigration = 1500;
                        };
                    };
                };
                buildConfigurationList = 83CBB9FA1A601CBA00E9B192 /* Build configuration list for PBXProject "\(appName)" */;
                compatibilityVersion = "Xcode 14.0";
                developmentRegion = en;
                hasScannedForEncodings = 0;
                knownRegions = (
                    en,
                    Base,
                );
                mainGroup = 83CBB9F61A601CBA00E9B192;
                productRefGroup = 83CBBA001A601CBA00E9B192 /* Products */;
                projectDirPath = "";
                projectRoot = "";
                targets = (
                    13B07F861A680F5B00A75B9A /* \(appName) */,
                );
            };
            /* End PBXProject section */
            
            /* Begin PBXResourcesBuildPhase section */
            13B07F8E1A680F5B00A75B9A /* Resources */ = {
                isa = PBXResourcesBuildPhase;
                buildActionMask = 2147483647;
                files = (
                );
                runOnlyForDeploymentPostprocessing = 0;
            };
            /* End PBXResourcesBuildPhase section */
            
            /* Begin PBXSourcesBuildPhase section */
            13B07F871A680F5B00A75B9A /* Sources */ = {
                isa = PBXSourcesBuildPhase;
                buildActionMask = 2147483647;
                files = (
                    13B07FBC1A68108700A75B9A /* ContentView.swift in Sources */,
                    13B07FBD1A68108700A75B9A /* \(appName)App.swift in Sources */,
                );
                runOnlyForDeploymentPostprocessing = 0;
            };
            /* End PBXSourcesBuildPhase section */
            
            /* Begin XCBuildConfiguration section */
            13B07F941A680F5B00A75B9A /* Debug */ = {
                isa = XCBuildConfiguration;
                buildSettings = {
                    ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
                    CLANG_ENABLE_MODULES = YES;
                    CURRENT_PROJECT_VERSION = 1;
                    ENABLE_PREVIEWS = YES;
                    INFOPLIST_FILE = \(appName)/Info.plist;
                    LD_RUNPATH_SEARCH_PATHS = (
                        "$(inherited)",
                        "@executable_path/../Frameworks",
                    );
                    MACOSX_DEPLOYMENT_TARGET = 10.15;
                    OTHER_LDFLAGS = (
                        "$(inherited)",
                    );
                    PRODUCT_BUNDLE_IDENTIFIER = "com.crossui.\(appName.lowercased())";
                    PRODUCT_NAME = \(appName);
                    SWIFT_OPTIMIZATION_LEVEL = "-Onone";
                    SWIFT_VERSION = 5.0;
                };
                name = Debug;
            };
            13B07F951A680F5B00A75B9A /* Release */ = {
                isa = XCBuildConfiguration;
                buildSettings = {
                    ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
                    CLANG_ENABLE_MODULES = YES;
                    CURRENT_PROJECT_VERSION = 1;
                    ENABLE_PREVIEWS = YES;
                    INFOPLIST_FILE = \(appName)/Info.plist;
                    LD_RUNPATH_SEARCH_PATHS = (
                        "$(inherited)",
                        "@executable_path/../Frameworks",
                    );
                    MACOSX_DEPLOYMENT_TARGET = 10.15;
                    OTHER_LDFLAGS = (
                        "$(inherited)",
                    );
                    PRODUCT_BUNDLE_IDENTIFIER = "com.crossui.\(appName.lowercased())";
                    PRODUCT_NAME = \(appName);
                    SWIFT_VERSION = 5.0;
                };
                name = Release;
            };
            83CBBA201A601CBA00E9B192 /* Debug */ = {
                isa = XCBuildConfiguration;
                buildSettings = {
                    ALWAYS_SEARCH_USER_PATHS = NO;
                    CLANG_ANALYZER_NONNULL = YES;
                    CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
                    CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
                    CLANG_ENABLE_MODULES = YES;
                    CLANG_ENABLE_OBJC_ARC = YES;
                    CLANG_ENABLE_OBJC_WEAK = YES;
                    CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
                    CLANG_WARN_BOOL_CONVERSION = YES;
                    CLANG_WARN_COMMA = YES;
                    CLANG_WARN_CONSTANT_CONVERSION = YES;
                    CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
                    CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
                    CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
                    CLANG_WARN_EMPTY_BODY = YES;
                    CLANG_WARN_ENUM_CONVERSION = YES;
                    CLANG_WARN_INFINITE_RECURSION = YES;
                    CLANG_WARN_INT_CONVERSION = YES;
                    CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
                    CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
                    CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
                    CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
                    CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
                    CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
                    CLANG_WARN_STRICT_PROTOTYPES = YES;
                    CLANG_WARN_SUSPICIOUS_MOVE = YES;
                    CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
                    CLANG_WARN_UNREACHABLE_CODE = YES;
                    CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
                    COPY_PHASE_STRIP = NO;
                    DEBUG_INFORMATION_FORMAT = dwarf;
                    ENABLE_STRICT_OBJC_MSGSEND = YES;
                    ENABLE_TESTABILITY = YES;
                    GCC_C_LANGUAGE_STANDARD = gnu11;
                    GCC_DYNAMIC_NO_PIC = NO;
                    GCC_NO_COMMON_BLOCKS = YES;
                    GCC_OPTIMIZATION_LEVEL = 0;
                    GCC_PREPROCESSOR_DEFINITIONS = (
                        "DEBUG=1",
                        "$(inherited)",
                    );
                    GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
                    GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
                    GCC_WARN_UNDECLARED_SELECTOR = YES;
                    GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
                    GCC_WARN_UNUSED_FUNCTION = YES;
                    GCC_WARN_UNUSED_VARIABLE = YES;
                    MACOSX_DEPLOYMENT_TARGET = 10.15;
                    MTL_ENABLE_DEBUG_INFO = YES;
                    ONLY_ACTIVE_ARCH = YES;
                    SDKROOT = macosx;
                    SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
                    SWIFT_OPTIMIZATION_LEVEL = "-Onone";
                };
                name = Debug;
            };
            83CBBA211A601CBA00E9B192 /* Release */ = {
                isa = XCBuildConfiguration;
                buildSettings = {
                    ALWAYS_SEARCH_USER_PATHS = NO;
                    CLANG_ANALYZER_NONNULL = YES;
                    CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
                    CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
                    CLANG_ENABLE_MODULES = YES;
                    CLANG_ENABLE_OBJC_ARC = YES;
                    CLANG_ENABLE_OBJC_WEAK = YES;
                    CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
                    CLANG_WARN_BOOL_CONVERSION = YES;
                    CLANG_WARN_COMMA = YES;
                    CLANG_WARN_CONSTANT_CONVERSION = YES;
                    CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
                    CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
                    CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
                    CLANG_WARN_EMPTY_BODY = YES;
                    CLANG_WARN_ENUM_CONVERSION = YES;
                    CLANG_WARN_INFINITE_RECURSION = YES;
                    CLANG_WARN_INT_CONVERSION = YES;
                    CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
                    CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
                    CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
                    CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
                    CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
                    CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
                    CLANG_WARN_STRICT_PROTOTYPES = YES;
                    CLANG_WARN_SUSPICIOUS_MOVE = YES;
                    CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
                    CLANG_WARN_UNREACHABLE_CODE = YES;
                    CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
                    COPY_PHASE_STRIP = YES;
                    DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
                    ENABLE_NS_ASSERTIONS = NO;
                    ENABLE_STRICT_OBJC_MSGSEND = YES;
                    GCC_C_LANGUAGE_STANDARD = gnu11;
                    GCC_NO_COMMON_BLOCKS = YES;
                    GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
                    GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
                    GCC_WARN_UNDECLARED_SELECTOR = YES;
                    GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
                    GCC_WARN_UNUSED_FUNCTION = YES;
                    GCC_WARN_UNUSED_VARIABLE = YES;
                    MACOSX_DEPLOYMENT_TARGET = 10.15;
                    MTL_ENABLE_DEBUG_INFO = NO;
                    SDKROOT = macosx;
                    SWIFT_COMPILATION_MODE = wholemodule;
                    SWIFT_OPTIMIZATION_LEVEL = "-O";
                    VALIDATE_PRODUCT = YES;
                };
                name = Release;
            };
            /* End XCBuildConfiguration section */
            
            /* Begin XCConfigurationList section */
            13B07F931A680F5B00A75B9A /* Build configuration list for PBXNativeTarget "\(appName)" */ = {
                isa = XCConfigurationList;
                buildConfigurations = (
                    13B07F941A680F5B00A75B9A /* Debug */,
                    13B07F951A680F5B00A75B9A /* Release */,
                );
                defaultConfigurationIsVisible = 0;
                defaultConfigurationName = Release;
            };
            83CBB9FA1A601CBA00E9B192 /* Build configuration list for PBXProject "\(appName)" */ = {
                isa = XCConfigurationList;
                buildConfigurations = (
                    83CBBA201A601CBA00E9B192 /* Debug */,
                    83CBBA211A601CBA00E9B192 /* Release */,
                );
                defaultConfigurationIsVisible = 0;
                defaultConfigurationName = Release;
            };
            /* End XCConfigurationList section */
        };
        rootObject = 83CBB9F71A601CBA00E9B192 /* Project object */;
    }
    """
    try pbxprojContent.write(toFile: pbxprojPath, atomically: true, encoding: .utf8)
    
    // Create schemes directory and shared scheme
    let schemesDir = "\(projectDir)/xcshareddata/xcschemes"
    try FileManager.default.createDirectory(atPath: schemesDir, withIntermediateDirectories: true, attributes: nil)
    
    let schemePath = "\(schemesDir)/\(appName).xcscheme"
    let schemeContent = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Scheme
       LastUpgradeVersion = "1500"
       version = "1.7">
       <BuildAction
          parallelizeBuildables = "YES"
          buildImplicitDependencies = "YES">
          <BuildActionEntries>
             <BuildActionEntry
                buildForTesting = "YES"
                buildForRunning = "YES"
                buildForProfiling = "YES"
                buildForArchiving = "YES"
                buildForAnalyzing = "YES">
                <BuildableReference
                   BuildableIdentifier = "primary"
                   BlueprintIdentifier = "13B07F861A680F5B00A75B9A"
                   BuildableName = "\(appName).app"
                   BlueprintName = "\(appName)"
                   ReferencedContainer = "container:\(appName).xcodeproj">
                </BuildableReference>
             </BuildActionEntry>
          </BuildActionEntries>
       </BuildAction>
       <TestAction
          buildConfiguration = "Debug"
          selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
          selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
          shouldUseLaunchSchemeArgsEnv = "YES"
          shouldAutocreateTestPlan = "YES">
       </TestAction>
       <LaunchAction
          buildConfiguration = "Debug"
          selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
          selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
          launchStyle = "0"
          useCustomWorkingDirectory = "NO"
          ignoresPersistentStateOnLaunch = "NO"
          debugDocumentVersioning = "YES"
          debugServiceExtension = "internal"
          allowLocationSimulation = "YES">
          <BuildableProductRunnable
             runnableDebuggingMode = "0">
             <BuildableReference
                BuildableIdentifier = "primary"
                BlueprintIdentifier = "13B07F861A680F5B00A75B9A"
                BuildableName = "\(appName).app"
                BlueprintName = "\(appName)"
                ReferencedContainer = "container:\(appName).xcodeproj">
             </BuildableReference>
          </BuildableProductRunnable>
       </LaunchAction>
       <ProfileAction
          buildConfiguration = "Release"
          shouldUseLaunchSchemeArgsEnv = "YES"
          savedToolIdentifier = ""
          useCustomWorkingDirectory = "NO"
          debugDocumentVersioning = "YES">
          <BuildableProductRunnable
             runnableDebuggingMode = "0">
             <BuildableReference
                BuildableIdentifier = "primary"
                BlueprintIdentifier = "13B07F861A680F5B00A75B9A"
                BuildableName = "\(appName).app"
                BlueprintName = "\(appName)"
                ReferencedContainer = "container:\(appName).xcodeproj">
             </BuildableReference>
          </BuildableProductRunnable>
       </ProfileAction>
       <AnalyzeAction
          buildConfiguration = "Debug">
       </AnalyzeAction>
       <ArchiveAction
          buildConfiguration = "Release"
          revealArchiveInOrganizer = "YES">
       </ArchiveAction>
    </Scheme>
    """
    try schemeContent.write(toFile: schemePath, atomically: true, encoding: .utf8)
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
