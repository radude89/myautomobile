### **Product Requirements Document: CarChum Localized UI Test Suite**

**Version:** 2.0
**Goal:** To define a suite of UI tests for the "CarChum" app using the native `XCUITest` framework. The suite will programmatically generate screenshots for the App Store across multiple languages and verify key application flows. The tests will be data-driven, highly maintainable, and will not rely on external tools like `fastlane`.

### **1. Core Technical Strategy**

#### **1.1. Framework & Target**
*   **Framework:** All tests will be written in Swift using Apple's `XCUITest`.
*   **Target:** Tests will reside in the existing `MyAutomobileUITests` target.

#### **1.2. Screenshot Generation**
Screenshots will be captured programmatically within each test function. The standard method is to use `XCUIScreen.main.screenshot()`.

```swift
// Example of taking a screenshot within a test
let screenshot = XCUIScreen.main.screenshot()
let attachment = XCTAttachment(screenshot: screenshot)
attachment.name = "01_VehicleListScreen_EN" // Naming convention is crucial
attachment.lifetime = .keepAlways // Ensures the screenshot is saved with the test results
add(attachment)
```

#### **1.3. Accessibility Identifiers**
A robust testing strategy relies on stable identifiers. The existing `AccessibilityIdentifiable` SPM will be the single source of truth for all identifiers.

*   **Protocol:** `AccessibilityIdentifiable`
*   **Implementation:** All identifiers will be defined as nested enums within the SPM, as per your specification. This ensures type-safe, non-stringly-typed references in both the app and test code.

**Example `AccessibilityIdentifiable` Enum Structure:**
```swift
// In the AccessibilityIdentifiable SPM
public enum VehicleListView {
    public enum AddButton: AccessibilityIdentifiable {}
    public enum VehicleCell: AccessibilityIdentifiable {} // For identifying cells by type
}

public enum VehicleDetailView {
    public enum AddFieldButton: AccessibilityIdentifiable {}
    public enum CustomFieldNameTextField: AccessibilityIdentifiable {}
    public enum CustomFieldValueTextField: AccessibilityIdentifiable {}
}
```

#### **1.4. Data-Driven Testing & Mocking**
The app will be launched in a special test mode to ensure predictable and clean state for every test run. This is managed via `XCUIApplication` Launch Environment variables.

1.  **Test Setup Function:** A helper function `launchApp(for locale: String)` will be created within the test suite. This function will:
    *   Instantiate `XCUIApplication()`.
    *   Set `app.launchEnvironment["UITesting"] = "true"`. The main app must observe this and configure itself for a test run (e.g., use an in-memory database, disable animations).
    *   Set `app.launchEnvironment["AppLocale"] = locale` (e.g., "en", "fr", "de", "es", "ro").
    *   Load all required JSON data (`vehicles.json`, `events.json`, etc.), serialize it to a string, and pass it via the launch environment.
        *   `app.launchEnvironment["VehicleData"] = ...`
        *   `app.launchEnvironment["EventData"] = ...`
        *   `app.launchEnvironment["ExpenseData"] = ...`
        *   `app.launchEnvironment["LocalizedStringData"] = ...`
        *   `app.launchEnvironment["LandmarkData"] = ...`
    *   Call `app.launch()`.

2.  **Running for Locales:** To generate screenshots for all languages, the main test functions will be called from a loop or separate test plan configurations within Xcode.

---

### **2. Data Model Specifications**

The following JSON files must be created if needed and added to the `MyAutomobileUITests` target.

#### **2.1. `vehicles.json`**
Contains vehicle data for all supported locales.

```json
{
  "en": [ /* As specified */ ],
  "fr": [ /* As specified */ ],
  "de": [
    { "plate": "B-MW-2023", "state": "Berlin", "make": "BMW", "model": "M3", "color": "#0066B2" }
    // ... more German vehicles
  ],
  "es": [
    { "plate": "2023-SEAT", "region": "Cataluña", "make": "SEAT", "model": "León", "color": "#E53D2C" }
    // ... more Spanish vehicles
  ],
  "ro": [
    { "plate": "B-23-DAC", "region": "București", "make": "Dacia", "model": "Logan", "color": "#FFFFFF" }
    // ... more Romanian vehicles
  ]
}
```

#### **2.2. `events.json`**
Defines relative events. The test runner will calculate absolute dates at runtime. The main app will parse this and create the event list.

```json
[
  { "description_key": "event_brake_inspection", "vehicle": "first", "recurrence_key": "recurrence_quarterly", "date": "1_week_from_now" },
  { "description_key": "event_oil_change", "vehicle": "first", "recurrence_key": "recurrence_onetime", "date": "today" },
  { "description_key": "event_change_tires", "vehicle": "second", "recurrence_key": "recurrence_yearly", "date": "3_months_from_now" }
]
```

#### **2.3. `expenses.json`**
Defines expenses to be visualized in the chart.

```json
[
  { "category_key": "expense_repair", "amount": 230.00 },
  { "category_key": "expense_fuel", "amount": 150.55 },
  { "category_key": "expense_insurance", "amount": 110.00 },
  { "category_key": "expense_other", "amount": 100.00 }
]
```

#### **2.4. `landmarks.json`**
Provides locale-specific coordinates for the Parking map.

```json
{
  "en": { "latitude": 51.5072, "longitude": -0.1276, "zoom": 15.0 }, // London, UK
  "fr": { "latitude": 48.8584, "longitude": 2.2945, "zoom": 16.0 }, // Paris, FR
  "de": { "latitude": 52.5163, "longitude": 13.3777, "zoom": 16.0 }, // Berlin, DE
  "es": { "latitude": 41.4036, "longitude": 2.1744, "zoom": 16.0 }, // Barcelona, ES
  "ro": { "latitude": 44.4268, "longitude": 26.1025, "zoom": 15.0 }  // Bucharest, RO
}
```

#### **2.5. `localizedStrings.json`**
A central repository for all translatable strings used in mock data. This decouples test logic from UI copy.

```json
{
  "en": {
    "custom_field_fuel": "Fuel", "custom_value_gas": "Gas",
    "event_brake_inspection": "Brake Inspection", "recurrence_quarterly": "Every quarter", /* ... */
    "expense_repair": "Repair", /* ... */
  },
  "fr": {
    "custom_field_fuel": "Carburant", "custom_value_gas": "Essence",
    "event_brake_inspection": "Inspection des freins", "recurrence_quarterly": "Chaque trimestre", /* ... */
    "expense_repair": "Réparation", /* ... */
  }
  // ... entries for "de", "es", "ro"
}
```

---

### **3. UI Test Cases**

Tests are combined into logical user flows to minimize app launches.

#### **Test Flow 1: `test01_AddAndDetailVehicleFlow()`**
This single test captures multiple screenshots during the vehicle creation and editing process.

1.  **Given:** The app is launched using `launchApp(for: "en")`.
2.  **Vehicle List Screen:**
    *   **Action:** Wait for the `VehicleListView` to appear.
    *   **Assert:** The list is populated with vehicles from `vehicles.json`.
    *   **Capture Screenshot:** `01_VehicleListScreen`
3.  **Add New Vehicle Screen:**
    *   **Action:** Tap the `VehicleListView.AddButton`.
    *   **Action:** Fill the text fields using data for a new vehicle (e.g., the first vehicle from the "en" block).
    *   **Capture Screenshot:** `02_AddVehicleScreen`
4.  **Color Picker:**
    *   **Action:** Tap the "Vehicle's color" row.
    *   **Assert:** The color picker popover/view is visible.
    *   **Capture Screenshot:** `03_ColorPickerScreen`
    *   **Action:** Select a color and dismiss the picker.
5.  **Save and View Details:**
    *   **Action:** Tap the "Done" button to save the vehicle.
    *   **Action:** Tap the newly added vehicle cell in the `VehicleListView`.
    *   **Assert:** The `VehicleDetailView` is displayed.
    *   **Capture Screenshot:** `04_VehicleDetailsScreen`
6.  **Add Custom Field:**
    *   **Action:** Tap the `VehicleDetailView.AddFieldButton`.
    *   **Action:** Type the localized "Fuel" string (from `localizedStrings.json`) into `CustomFieldNameTextField`.
    *   **Action:** Type the localized "Gas" string into `CustomFieldValueTextField`.
    *   **Action:** Save the field.
    *   **Assert:** The new "Fuel: Gas" row is visible in the details view.

#### **Test Flow 2: `test02_EventsFlow()`**

1.  **Given:** App launched via `launchApp(for: "en")` with `EventData` and `LocalizedStringData`.
2.  **Action:** Tap the "Events" tab bar item.
3.  **Assert & Capture:**
    *   Assert events with `vehicle: "first"` are grouped under the first vehicle's plate.
    *   Assert events with `vehicle: "second"` are grouped under the second vehicle's plate.
    *   Assert the localized descriptions and recurrence strings match the UI.
    *   Assert dates are correctly calculated (e.g., "today" matches the current date).
    *   **Capture Screenshot:** `05_EventsScreen`

#### **Test Flow 3: `test03_ParkingFlow()`**

1.  **Given:** App launched via `launchApp(for: "fr")` with `LandmarkData`.
2.  **Action:** Tap the "Parking" tab bar item.
3.  **Assert & Capture:**
    *   Allow a brief moment for the map to load (`sleep(2)` may be necessary).
    *   Assert the map is centered near the coordinates for Paris from `landmarks.json`.
    *   Assert the "Parking Spot" annotation is visible.
    *   **Capture Screenshot:** `06_ParkingMapScreen_FR` (Note the locale-specific suffix).

#### **Test Flow 4: `test04_FuelCalculatorFlow()`**

1.  **Given:** App launched via `launchApp(for: "en")`.
2.  **Action:** Navigate to More -> Fuel Calculator.
3.  **Action:** Enter "100" for distance and "5" for usage.
4.  **Assert & Capture:**
    *   Assert the consumption field updates to "20".
    *   **Capture Screenshot:** `07_FuelCalculatorScreen`

#### **Test Flow 5: `test05_ExpensesFlow()`**

1.  **Given:** App launched via `launchApp(for: "de")` with `ExpenseData`.
2.  **Action:** Navigate to the first vehicle's details screen.
3.  **Action:** Tap the "Expenses" link/button.
4.  **Assert & Capture:**
    *   Ensure the "Chart" view is active.
    *   Assert the total amount matches the sum of amounts in `expenses.json`.
    *   Assert the chart contains slices corresponding to the categories in the JSON.
    *   **Capture Screenshot:** `08_ExpensesChartScreen_DE`
