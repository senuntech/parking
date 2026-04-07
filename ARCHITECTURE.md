# Project Architecture

This document describes the technical structure and architectural patterns used in the **Parking** project.

## Technical Stack

- **Framework**: [Flutter](https://flutter.dev/) (Cross-platform UI).
- **State Management**: [Provider](https://pub.dev/packages/provider).
- **Database**: [SQLBrite](https://pub.dev/packages/sqlbrite) (A reactive wrapper around SQLite).
- **Design System**: [OneDS](file:///c:/Users/crist/Documents/ProjetosFlutter/one_ds) (Internal shared library for UI components and extensions).
- **Local Storage**: `localstorage` and `shared_preferences`.
- **Printing**: Bluetooth Thermal printing (`print_bluetooth_thermal`).

## Directory Structure

The project follows a modular structure prioritized by features:

### `lib/core`
Contains global configurations and shared infrastructure:
- `database`: SQLite initialization and table definitions.
- `enum`: System-wide enumerations (e.g., `TypeChargeEnum`, `VehicleEnum`).
- `extension`: Dart extensions for core types.
- `purchase`: Logic for in-app purchases.

### `lib/src/module`
Each subdirectory represents a distinct feature/module (e.g., `ticket`, `cash_register`, `reports`).
Modules are typically organized into:
- `data/model`: Data structures (POJOs/Models).
- `presenters/page`: View layer (Flutter Widgets).
- `presenters/controller`: Business logic and state management using `Provider`.
- `presenters/widgets`: Feature-specific UI components.

### `lib/src/utils` & `lib/src/widgets`
- `utils`: Global helper functions (e.g., `vehicle_utils.dart` for price calculations).
- `widgets`: Reusable UI components shared across multiple modules.

## Architectural Patterns

1.  **Modularization**: Features are encapsulated to avoid tight coupling.
2.  **Reactive Database**: `SQLBrite` allows the UI to automatically update when database records change.
3.  **Extension-Driven Logic**: Common logic (like rounding prices) is implemented via Dart extensions in the `one_ds` package to ensure consistency.
4.  **Layered Responsibility**:
    - **Models**: Responsible for serialization (`toMap`, `fromMap`).
    - **Controllers**: Responsible for data fetching and state updates.
    - **Pages**: Purely for layout and user interaction.

## External Dependencies

- `one_ds`: A sibling workspace providing the core design system and critical extensions (like `roundUp` for currency).
