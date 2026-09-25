# Assignment 1: Flutter Salary Calculator App

A modern, cross-platform mobile application built with **Flutter** and **Material 3** designed to compute salary metrics including **Gross Monthly Salary**, **Income Tax**, **Total Deductions**, and **Net Monthly Take-Home Income**.

---

## 📌 Project Overview & Features

This application serves as an interactive financial tool allowing users to enter earnings and deduction parameters to view a breakdown of their net income.

### Key Features
- **Material 3 UI Design**: Styled using modern Material 3 cards, dynamic color schemes generated from a seed color, and typography standards.
- **State Management**: Built using `StatefulWidget` and `setState` to seamlessly manage input changes, dynamic calculation outputs, and UI resets.
- **Robust Form Validation**: Uses `GlobalKey<FormState>` and `TextFormField` validators to prevent invalid, empty, non-numeric, or negative value inputs.
- **Real-Time Financial Calculations**: Computes salary figures with accuracy, formatted to 2 decimal places.
- **Clear Breakdown & Summary**: Displays net salary in a visual summary card alongside an itemized list showing tax and total deduction subtotals.
- **Responsive Layout**: Wrapped in a `SingleChildScrollView` to prevent pixel overflows when soft keyboards open.

---

## 🧮 Formulae Used

The app applies standard income calculation formulae:

1. **Gross Monthly Salary**:
   $$\text{Gross Salary} = \text{Basic Salary} + \text{Allowances}$$

2. **Income Tax Amount**:
   $$\text{Tax Amount} = \text{Gross Salary} \times \left(\frac{\text{Tax Rate \%}}{100}\right)$$

3. **Total Deductions**:
   $$\text{Total Deductions} = \text{Tax Amount} + \text{Other Deductions}$$

4. **Net Monthly Take-Home Income**:
   $$\text{Net Monthly Income} = \text{Gross Salary} - \text{Total Deductions}$$

5. **Annual Net Projection**:
   $$\text{Annual Net Income} = \text{Net Monthly Income} \times 12$$

---

## ⚙️ How to Run the App (Flutter CLI Commands)

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (v3.0 or higher recommended)
- [Dart SDK](https://dart.dev/get-dart) installed
- An Android Emulator, iOS Simulator, or Web Browser

### Commands

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/student_card_assignment.git
   cd student_card_assignment
   ```

2. **Get Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Analyze Code**:
   ```bash
   flutter analyze
   ```

4. **Run Unit / Widget Tests**:
   ```bash
   flutter test
   ```

5. **Run the Application**:
   ```bash
   # List available devices
   flutter devices

   # Run on default connected device/emulator
   flutter run

   # Run specifically on Chrome (Web)
   flutter run -d chrome
   ```

---

## 📱 Screenshots

> *Replace the placeholder images below with actual app screenshots before submission.*

| Input Form | Calculation Results | Validation Error |
| :---: | :---: | :---: |
| ![Form Input](https://via.placeholder.com/300x600?text=Form+Input) | ![Calculation Results](https://via.placeholder.com/300x600?text=Calculation+Results) | ![Validation Error](https://via.placeholder.com/300x600?text=Validation+Error) |

---

## 🎓 Code Architecture & Pedagogical Explanations

The source code in `lib/main.dart` is annotated with detailed inline comments explaining 5 primary concepts:

1. **Material 3 UI Layout**: Demonstrates `ThemeData(useMaterial3: true)`, card layout hierarchy, and responsive text styles.
2. **State Management**: Uses `StatefulWidget` lifecycle methods and `setState` for reactive UI updates.
3. **Controllers**: Utilizes `TextEditingController` for reading input values and properly cleaning up resources in `dispose()`.
4. **Form Validation**: Implements `GlobalKey<FormState>` to execute unified validation across multiple input fields.
5. **Tax & Financial Calculations**: Contains clean, deterministic mathematical functions that handle parsing edge cases safely.

---

## 📄 License
This project is completed as part of **Assignment 1** for educational purposes.
