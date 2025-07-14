# CarChum - Your Friendly Vehicle Helper

![CarChum App](applogo.png)

## About

CarChum is an all-in-one vehicle management solution that helps you organize your vehicles, track important events, and manage expenses. No more juggling multiple apps - CarChum puts everything at your fingertips.

## Features

- **Complete Vehicle Customization**: Tailor every detail from license plates to color with unlimited custom fields
- **Event Tracking**: Never miss insurance renewals, inspections, or maintenance with smart reminders
- **Calendar Integration**: Seamlessly sync your vehicle events with your local calendar
- **Parking Spot Marking**: Easily mark and find your parking spot on the map
- **Fuel Calculator**: Calculate travel distances, fuel usage, and consumption for every journey

## Languages

English, French, German, Italian, Romanian, Spanish

## Privacy

CarChum does not collect any data from the app.

## Pricing

- **Base App**: Free
- **In-App Purchases**:
  - One Vehicle Pack: $2.99
  - No Limit Pack: $8.99

## Development

This repository contains the source code for the iOS app "CarChum" (formerly "My Automobile").

### Requirements

- **iPhone/iPad**: iOS/iPadOS 17.0 or later
- **Mac**: macOS 14.0 or later (requires Apple M1 chip or later)
- **Apple Vision**: visionOS 1.0 or later

### Architecture

- **SwiftUI** with MVVM architecture
- **EventKit** integration for calendar synchronization
- **StoreKit** for in-app purchases
- **MapKit** for parking location features
- **Swift Charts** for expense visualization

### Getting Started

1. Clone the repository
2. Open `MyAutomobile/MyAutomobile.xcodeproj` in Xcode
3. Build and run the project

For detailed development information, see [CLAUDE.md](CLAUDE.md).

### Building

```bash
# Open project in Xcode
open MyAutomobile/MyAutomobile.xcodeproj

# Build for iOS Simulator
xcodebuild -project MyAutomobile/MyAutomobile.xcodeproj -scheme MyAutomobile -destination 'platform=iOS Simulator,name=iPhone 15'

# Run tests
xcodebuild test -project MyAutomobile/MyAutomobile.xcodeproj -scheme MyAutomobile -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Links

- [App Store](https://apps.apple.com/us/app/carchum/id6465991938)
- [Privacy Policy](https://apps.apple.com/us/app/carchum/id6465991938)
- [Support](https://apps.apple.com/us/app/carchum/id6465991938)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Copyright

© Radu Dan
