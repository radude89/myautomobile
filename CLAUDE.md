# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Building and Testing
```bash
# Open project in Xcode
open MyAutomobile/MyAutomobile.xcodeproj

# Build for iOS Simulator
xcodebuild -project MyAutomobile/MyAutomobile.xcodeproj -scheme MyAutomobile -destination 'platform=iOS Simulator,name=iPhone 15'

# Run unit tests
xcodebuild test -project MyAutomobile/MyAutomobile.xcodeproj -scheme MyAutomobile -destination 'platform=iOS Simulator,name=iPhone 15'

# Run UI tests only
xcodebuild test -project MyAutomobile/MyAutomobile.xcodeproj -scheme MyAutomobileUITests -destination 'platform=iOS Simulator,name=iPhone 15'

# Build for device (requires signing)
xcodebuild -project MyAutomobile/MyAutomobile.xcodeproj -scheme MyAutomobile -destination 'generic/platform=iOS'
```

## Architecture Overview

**CarChum** (formerly "My Automobile") is a SwiftUI-based iOS vehicle management app following **MVVM architecture** with these key characteristics:

### Core Architecture Patterns
- **MVVM** with `@MainActor` ViewModels and `ObservableObject` state management
- **Feature-based organization** where each major feature lives in `/Scenes/`
- **JSON file persistence** for vehicle data with automatic app backgrounding saves
- **EventKit integration** for two-way Calendar synchronization

### Key Data Models
- **Vehicle** - Primary entity with unlimited custom fields, events, and expenses
- **Event** - Calendar events with recurrence patterns (once, weekly, monthly, yearly)
- **Expense** - Financial tracking with predefined categories and chart visualization
- **Vehicles** (`ObservableObject`) - Manages vehicle collection with JSON persistence

### State Management Architecture
```
App Launch → Load vehicles.json → Vehicles ObservableObject
User Changes → ViewModel updates → Auto-save on app background
Calendar Events → EventStoreManager → iOS Calendar sync
IAP → PurchaseManager → StoreKit validation
```

### Project Structure
```
MyAutomobile/
├── Entities/           # Core data models (Vehicle, Event, Expense)
├── Helpers/            # Utilities, extensions, EventStoreManager
├── Scenes/             # Feature modules (Vehicle, Events, ParkLocation, More)
│   └── [Feature]/     # Each contains View, ViewModel, and supporting files
├── Supporting files/   # Assets, localization, StoreKit config
├── AccessibilityIdentifiers/ # Swift Package for UI element identification
└── MyAutomobileUITests/ # UI test suite with localized screenshot generation
    ├── MockData/       # Test vehicle data and configurations
    └── MyAutomobileUITests.swift # Main UI test implementation
```

### Important Integration Points
- **EventKit** - Requires Calendar permission, handles recurring events
- **StoreKit** - Freemium model with vehicle limits (configured in MainStoreKitConfig.storekit)
- **MapKit** - Parking location marking with custom annotations
- **Swift Charts** - Expense visualization with category breakdown

### Localization
- Supports 6 languages via `Localizable.xcstrings`
- Text keys follow snake_case convention
- String extraction should maintain existing key patterns

### IAP Business Logic
- Free tier: 1 vehicle limit
- One Vehicle Pack ($2.99): 2 vehicles total
- No Limit Pack ($8.99): Unlimited vehicles
- Purchase state managed via UserDefaults and PurchaseManager

### Testing Architecture
- **Unit Tests**: Basic XCTest framework with placeholder tests in MyAutomobileTests
- **UI Tests**: Comprehensive XCUITest suite for multi-locale screenshot generation
- **IAP Testing**: UI tests bypass purchase screens by setting `UITesting=true` environment variable
- **Mock Data**: UI tests use real vehicle data from `/specs/uitests/vehicles.json` loaded through UI interactions
- **AccessibilityIdentifiers**: Custom Swift package for type-safe UI element identification
- **Test Environments**: Launch environments control locale (`AppLocale`) and testing mode (`UITesting`)

### Key Implementation Details
- **Data Persistence**: JSON files saved to Documents directory with automatic app backgrounding
- **Custom Fields**: Unlimited vehicle customization through dynamic field system
- **Accessibility**: Custom AccessibilityIdentifiers package for reliable UI testing
- **Localization**: 6 languages supported through Localizable.xcstrings with snake_case keys
- **UI Testing Integration**: 
  - `Vehicles.swift:17-22` automatically sets 999 vehicle slots during UI testing
  - `PurchaseManager.swift:24-28` bypasses IAP by granting unlimited pack during UI testing
  - Test data organized by locale in `MyAutomobileUITests/MockData/vehicles.json`

### UI Test Implementation Notes
- **Test Organization**: 5 main test flows covering vehicle management, events, parking, and multi-locale scenarios
- **Screenshot Generation**: Automated capture with locale-specific naming (e.g., `01_EmptyVehicleList_FR`)
- **IAP Bypass**: Environment variable `UITesting=true` grants unlimited vehicle access
- **Real Data Testing**: Uses actual vehicle data from specs rather than mock objects
- **Multi-Locale Support**: Tests run in English, French, German with localized vehicle data