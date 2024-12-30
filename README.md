
# CrossUI

**CrossUI** is a multi-platform UI framework and command-line tool that allows you to write Swift code once and generate native UI code for **macOS** (SwiftUI), **Windows** (WinUI), and **Linux** (e.g. GTK, future support). By using a simple Swift DSL (similar to SwiftUI), you can target multiple platforms from a single codebase.

## Features

- **CrossUI DSL**:  
  Write Swift views using types like `Text`, `VStack`, etc.  

  ```swift
  struct ContentView {
      let body: some View = VStack {
          Text("Hello from CrossUI!")
          Text("Hello again from CrossUI!")
      }
  }
  ```
  
- **CLI Tool**:  
  - `cross new <projectName>`: Creates a new CrossUI project with a minimal SwiftPM setup.  
  - `cross build`: Generates platform-specific project files in a `Build/` folder (e.g. Xcode project for macOS, `.sln` for Windows, etc.) and optionally compiles on the native platform.

## Table of Contents

1. [Requirements](#requirements)  
2. [Installation](#installation)  
3. [Usage](#usage)  
   - [Creating a New Project](#creating-a-new-project)  
   - [Building All Platforms](#building-all-platforms)  
4. [Project Layout](#project-layout)  
5. [How It Works](#how-it-works)  
6. [Roadmap](#roadmap)  
7. [License](#license)

---

## Requirements

- **Swift 5.7** or later.  
- A Swift toolchain on your platform of choice (macOS, Windows, or Linux).  
- (Optional) Xcode for macOS builds, Visual Studio/MSBuild for Windows builds, and a Swift toolchain or other toolkits on Linux.

---

## Installation

1. **Clone** this repository or download it:
   ```bash
   git clone https://github.com/YourUserName/CrossUI.git
   cd CrossUI
   ```

2. **Build** the CLI tool (`cross`):
   ```bash
   swift build --product cross --configuration release
   ```

3. **Install** the `cross` executable (on macOS or Linux):
   ```bash
   sudo mkdir -p /usr/local/bin
   sudo cp .build/release/cross /usr/local/bin/cross
   ```
   - On Windows, you can copy `cross.exe` somewhere on your `PATH` or reference it directly from the `.build\release\` folder.

Now you can run `cross` from anywhere on your system.

---

## Usage

### Creating a New Project

You can quickly scaffold a new CrossUI project:

```bash
cross new MyCrossUIApp
```

This creates a **`MyCrossUIApp/`** folder containing:

- **`Package.swift`**: A minimal SwiftPM manifest referencing `CrossUI`.  
- **`Sources/MyCrossUIApp/`**: Contains `ContentView.swift` and a simple `main.swift`.

Then:

```bash
cd MyCrossUIApp
```

### Building All Platforms

Inside your newly created project (or any CrossUI-based project), run:

```bash
cross build
```

The `cross build` command will:

1. Generate a **macOS** Xcode project (SwiftUI) in `Build/macOS/`.  
2. Generate a **Windows** solution (WinUI) in `Build/windows/`.  
3. Generate a **Linux** project (currently a stub or GTK) in `Build/linux/`.  

By default, it may attempt to **compile** for the *native* platform (depending on whether you have the necessary compilers installed). However, **cross-compiling** for other platforms typically requires additional setup (e.g., Docker containers or specialized toolchains).

---

## Project Layout

In the **CrossUI** repository:

```
CrossUI/
├─ Package.swift             // Defines the library + CLI product
├─ Sources/
│  ├─ CrossUI/               // The library code (DSL, platform-specific renderers)
│  │  ├─ CrossUI.swift
│  │  ├─ WindowsUI.swift
│  └─ crossui-cli/           // The CLI tool code
│     └─ main.swift
└─ Tests/
   └─ CrossUITests/
```

In a **user project** created by `cross new MyCrossUIApp`:

```
MyCrossUIApp/
├─ Package.swift
├─ Sources/
│   └─ MyCrossUIApp/
│       ├─ ContentView.swift
│       └─ main.swift
└─ ...
```

After running `cross build`, you’ll see a **`Build/`** directory with subfolders for each platform’s generated code.

---

## How It Works

1. **DSL**: You write UI code like:
   ```swift
   struct ContentView {
       let body: some View = VStack {
           Text("Hello, CrossUI!")
       }
   }
   ```
   The DSL includes components such as `Text` and `VStack`, each with a `render(platform:)` method.

2. **Rendering**: When you run `cross build`, the CLI calls renderer functions to produce:
   - **XAML** for Windows (WinUI).
   - **SwiftUI** code for macOS.
   - **GTK** or other stubs for Linux.

3. **Project Generation**: The CLI writes out a minimal Xcode project (macOS), `.sln/.csproj` (Windows), or Makefile/CMake (Linux) in a `Build/` folder.

4. **Compilation**:
   - On macOS, it may invoke `xcodebuild` to produce a `.app`.
   - On Windows, it may call MSBuild to produce an `.exe`.
   - On Linux, it runs `make` to produce a binary.

For true cross-compilation (e.g., building Windows `.exe` on macOS), you’d need specialized cross-toolchains or Docker. By default, the generated projects can be **copied** to the respective platform and built natively.

---

## Roadmap

- **More Components**: Support `Button`, `TextField`, images, event handling, etc.
- **Improved Project Templates**: Provide fully functional Xcode/Visual Studio solution skeletons.
- **Cross Compilation**: Integrate Docker or toolchains for building all platforms from a single environment.
- **Configuration**: `crossui.toml` or similar for advanced settings.

---

## License

```
MIT License
© 2024 Tetrix Technology
Permission is hereby granted...
```

---

## Contributing

Contributions are welcome! Please open a GitHub issue or pull request if you’d like to discuss improvements, report bugs, or submit new features.

---

### Thank You!

Thanks for checking out **CrossUI**. If you have any questions, feel free to open an issue on GitHub. Enjoy building truly cross-platform Swift interfaces!
