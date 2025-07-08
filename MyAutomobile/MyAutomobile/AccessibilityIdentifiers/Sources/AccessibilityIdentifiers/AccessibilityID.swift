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
    public enum VehicleCell: AccessibilityIdentifiable {}
    public enum VehicleList: AccessibilityIdentifiable {}
}

// MARK: - Vehicle Add View
public enum VehicleAddViewElements: AccessibilityIdentifiable {
    public enum View: AccessibilityIdentifiable {}
    public enum PlateTextField: AccessibilityIdentifiable {}
    public enum StateTextField: AccessibilityIdentifiable {}
    public enum MakeTextField: AccessibilityIdentifiable {}
    public enum ModelTextField: AccessibilityIdentifiable {}
    public enum ColorPickerRow: AccessibilityIdentifiable {}
    public enum ColorPicker: AccessibilityIdentifiable {}
    public enum DoneButton: AccessibilityIdentifiable {}
    public enum CancelButton: AccessibilityIdentifiable {}
}

// MARK: - Vehicle Detail View
public enum VehicleDetailViewElements: AccessibilityIdentifiable {
    public enum AddFieldButton: AccessibilityIdentifiable {}
    public enum CustomFieldNameTextField: AccessibilityIdentifiable {}
    public enum CustomFieldValueTextField: AccessibilityIdentifiable {}
    public enum CustomFieldRow: AccessibilityIdentifiable {}
    public enum ExpensesButton: AccessibilityIdentifiable {}
    public enum EditButton: AccessibilityIdentifiable {}
}

// MARK: - Events View
public enum EventsViewElements: AccessibilityIdentifiable {
    public enum EventsList: AccessibilityIdentifiable {}
    public enum EventRow: AccessibilityIdentifiable {}
    public enum AddEventButton: AccessibilityIdentifiable {}
    public enum EventGroupHeader: AccessibilityIdentifiable {}
}

// MARK: - Events Add View
public enum EventAddViewElements: AccessibilityIdentifiable {
    public enum DescriptionTextField: AccessibilityIdentifiable {}
    public enum VehicleSelector: AccessibilityIdentifiable {}
    public enum DatePicker: AccessibilityIdentifiable {}
    public enum RecurrenceSelector: AccessibilityIdentifiable {}
    public enum SaveButton: AccessibilityIdentifiable {}
    public enum CancelButton: AccessibilityIdentifiable {}
}

// MARK: - Parking View
public enum ParkingViewElements: AccessibilityIdentifiable {
    public enum MapView: AccessibilityIdentifiable {}
    public enum ParkingMarker: AccessibilityIdentifiable {}
    public enum SetLocationButton: AccessibilityIdentifiable {}
    public enum ClearLocationButton: AccessibilityIdentifiable {}
}

// MARK: - More View
public enum MoreViewElements: AccessibilityIdentifiable {
    public enum FuelCalculatorRow: AccessibilityIdentifiable {}
    public enum ExpenseTrackingRow: AccessibilityIdentifiable {}
    public enum VehicleSelectionRow: AccessibilityIdentifiable {}
    public enum TermsRow: AccessibilityIdentifiable {}
    public enum EmailRow: AccessibilityIdentifiable {}
}

// MARK: - Fuel Calculator View
public enum FuelCalculatorViewElements: AccessibilityIdentifiable {
    public enum DistanceTextField: AccessibilityIdentifiable {}
    public enum UsageTextField: AccessibilityIdentifiable {}
    public enum ConsumptionTextField: AccessibilityIdentifiable {}
    public enum CalculateButton: AccessibilityIdentifiable {}
    public enum ResultLabel: AccessibilityIdentifiable {}
}

// MARK: - Expense Tracking View
public enum ExpenseTrackingViewElements: AccessibilityIdentifiable {
    public enum ExpensesList: AccessibilityIdentifiable {}
    public enum ExpenseRow: AccessibilityIdentifiable {}
    public enum AddExpenseButton: AccessibilityIdentifiable {}
    public enum ChartView: AccessibilityIdentifiable {}
    public enum TotalAmountLabel: AccessibilityIdentifiable {}
    public enum ChartSegmentedControl: AccessibilityIdentifiable {}
}

// MARK: - Expense Add View
public enum ExpenseAddViewElements: AccessibilityIdentifiable {
    public enum AmountTextField: AccessibilityIdentifiable {}
    public enum CategorySelector: AccessibilityIdentifiable {}
    public enum DatePicker: AccessibilityIdentifiable {}
    public enum VehicleSelector: AccessibilityIdentifiable {}
    public enum SaveButton: AccessibilityIdentifiable {}
    public enum CancelButton: AccessibilityIdentifiable {}
}

// MARK: - Tab Bar
public enum TabBarElements: AccessibilityIdentifiable {
    public enum VehiclesTab: AccessibilityIdentifiable {}
    public enum EventsTab: AccessibilityIdentifiable {}
    public enum ParkingTab: AccessibilityIdentifiable {}
    public enum MoreTab: AccessibilityIdentifiable {}
}
