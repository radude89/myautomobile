# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Building and Testing
```bash
# Open project in Xcode
open MyAutomobile/MyAutomobile.xcodeproj

# Build for iOS Simulator
xcodebuild -project MyAutomobile/MyAutomobile.xcodeproj -scheme MyAutomobile -destination 'platform=iOS Simulator,name=iPhone 15'

# Run tests
xcodebuild test -project MyAutomobile/MyAutomobile.xcodeproj -scheme MyAutomobile -destination 'platform=iOS Simulator,name=iPhone 15'

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
└── Supporting files/   # Assets, localization, StoreKit config
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