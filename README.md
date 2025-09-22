# X Games

[![CI](https://github.com/andika-andriana/MySecondSubmission/actions/workflows/ci.yml/badge.svg)](https://github.com/andika-andriana/MySecondSubmission/actions/workflows/ci.yml)
[![Codecov](https://codecov.io/gh/andika-andriana/MySecondSubmission/branch/main/graph/badge.svg?token=4PM7RE41PV)](https://app.codecov.io/gh/andika-andriana/MySecondSubmission)

X Games is a SwiftUI catalogue that pulls live game data from the [RAWG](https://rawg.io/apidocs) API. It is intentionally small, modular, and easy to explore—every feature lives in its own Swift package so reuse and maintenance stay simple.

## Highlights

- **Straightforward SwiftUI screens** for Home, Favorites, About, and Detail
- **Core Data favorites** so bookmarked games stay available offline
- **Lightweight Swift packages** (`Common`, `Core`, `DataLayer`, `Features`) to keep responsibilities clear
- **Combine** pipelines for networking and persistence without blocking the UI
- **Calm automation** via GitHub Actions and Codecov, just enough to catch regressions early

## Module Layout

```
X Games
├─ MySecondSubmission.xcodeproj (app target)
│  ├─ App / DI / Presentation (TabsView, Swinject assemblies)
│  └─ Resources (Assets, Info.plist, build configs)
├─ Modules/
│  ├─ Common (remote SPM)     → shared UI, localisation, router, profile manager
│  ├─ Core (SPM)              → domain entities, repositories, generic use-cases
│  ├─ DataLayer (SPM)         → RAWG API client + Core Data repositories
│  └─ Features (SPM)          → Home / Detail / Favorites / About bundles
└─ MySecondSubmissionTests    → XCTest for domain use-cases
```

Dependencies flow only one way—Features → Core/Common → DataLayer—so it stays easy to reason about. Swinject ties everything together in the app target.

## Requirements

- Xcode 15.4 or newer (CI currently uses 16.4)
- iOS 15.0+ deployment target
- Swift 5.9+

## Getting Started

```bash
# Clone
git clone https://github.com/andika-andriana/MySecondSubmission.git
cd MySecondSubmission

# Resolve packages
xcodebuild -resolvePackageDependencies -project MySecondSubmission.xcodeproj

# Build & test with coverage
xcodebuild \
  -enableCodeCoverage YES \
  -skipPackagePluginValidation \
  -project MySecondSubmission.xcodeproj \
  -scheme MySecondSubmission \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6' \
  clean test
```

Open the project in Xcode and run on any iOS 15+ simulator. The Core Data model is bundled inside the `DataLayer` package and loads automatically.

## Continuous Integration

Workflow: `.github/workflows/ci.yml`

```yaml
- Checkout repository
- Select Xcode 16.4
- Cache SwiftPM artefacts
- Resolve packages
- xcodebuild clean test (iPhone 16 · iOS 18.6)
- Upload coverage + test results to Codecov
```

## Packages

- Common (remote): https://github.com/andika-andriana/Modularization-Common-Package.git
- Alamofire (networking)
- Swinject & SwinjectAutoregistration (dependency injection)
