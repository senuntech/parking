# Project Overview: Parking Management

This document provides a functional overview of the **Parking** application, its core features, and business rules.

## App Purpose

The application is designed to manage parking lots, tracking vehicle entry and exit, calculating dynamic prices based on time or fixed rates, and generating daily financial reports.

## Core Modules

### 1. Ticket Management (`lib/src/module/ticket`)
The heart of the app. It handles:
- **Vehicle Entrance**: Recording license plate, model, and arrival time.
- **Vehicle Exit**: Calculating total stay and final price based on the selected charge type.
- **Entry/Exit Coupons**: Generating print-ready receipts.

### 2. Cash Register (`lib/src/module/cash_register`)
Tracks all financial transactions for the current session:
- **Balance Control**: Monitoring income from tickets and other services.
- **Opening/Closing**: Managing the daily financial cycle.

### 3. Reports (`lib/src/module/reports`)
Provides historical data and analytics:
- **Ticket History**: List of all past stays.
- **Financial Summary**: Aggregated data on earnings.

### 4. Settings (`lib/src/module/settings`)
Configuration for the establishment:
- **Price List**: Defining hourly, daily, and fixed rates for different vehicle types.
- **Printing Preferences**: Configuring bluetooth thermal printers.

## Key Business Rules

### 1. Dynamic Pricing
Prices can be calculated in three ways based on `TypeChargeEnum`:
- **Fix**: A single flat rate regardless of time.
- **Day**: A rate per 24-hour period (starting a new day counts as a full day).
- **Hour**: A rate per 60 minutes, calculated proportionally per minute.

### 2. Currency Rounding (0.05 Logic)
To simplify cash transactions, all currency calculations are rounded UP to the nearest multiple of 0.05.
- **Logic**: `(this * 20).ceil() / 20` (from `one_ds/double_extension.dart`).
- **Example**: `1.03` becomes `1.05`; `1.06` becomes `1.10`.

### 3. Bluetooth Printing
The app supports ESC/POS thermal printers for fast receipt generation directly from the mobile device.

## Design System

The app uses the **OneDS** design system for a consistent look and feel, including theme-aware colors, standardized typography, and custom widgets.
