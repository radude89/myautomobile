//
//  AccessibilityID.swift
//  MyAutomobile
//
//  Created by Radu Dan on 06.06.2025.
//

import Foundation

// MARK: - Vehicle List View
public enum VehicleListViewElements: AccessibilityIdentifiable {
    public enum AddButton: AccessibilityIdentifiable {}
}

// MARK: - Vehicle Add View
public enum VehicleAddViewElements: AccessibilityIdentifiable {
    public enum View: AccessibilityIdentifiable {
        public enum ColorPicker: AccessibilityIdentifiable {}
    }
}

// MARK: - Vehicle Detail View
public enum VehicleDetailViewElements: AccessibilityIdentifiable {
    public enum AddFieldButton: AccessibilityIdentifiable {}
    public enum CustomFieldName: AccessibilityIdentifiable {}
    public enum CustomFieldValue: AccessibilityIdentifiable {}
}

// MARK: - Events
public enum EventListViewElements: AccessibilityIdentifiable {
    public enum AddButton: AccessibilityIdentifiable {}
    public enum AddView: AccessibilityIdentifiable {
        public enum VehiclePicker: AccessibilityIdentifiable {}
        public enum DatePicker: AccessibilityIdentifiable {}
        public enum LocalCalendarToggle: AccessibilityIdentifiable {}
        public enum RecurrencePicker: AccessibilityIdentifiable {}
    }
}

// MARK: - Menu
public enum MenuViewElements: AccessibilityIdentifiable {
    public enum ExpenseTrackingItem: AccessibilityIdentifiable {}
    public enum FuelCalculatorItem: AccessibilityIdentifiable {}
}

// MARK: - Expenses
public enum ExpensesViewElements: AccessibilityIdentifiable {
    public enum Selector: AccessibilityIdentifiable {
        public enum List: AccessibilityIdentifiable {}
        public enum Chart: AccessibilityIdentifiable {}
    }
    public enum ChartView: AccessibilityIdentifiable {
        public enum Segment: AccessibilityIdentifiable {}
    }
}

// MARK: - Fuel calculator
public enum FuelCalculatorViewElements: AccessibilityIdentifiable {
    public enum CalculateButton: AccessibilityIdentifiable {}
}
