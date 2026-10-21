# Q-Slope Calculator

[![Google Play](https://img.shields.io/badge/Google_Play-Get_it_on_Play_Store-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=in.sg.q_slope_calculator)
[![Flutter](https://img.shields.io/badge/Flutter-Pinned%20FVM-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.7.0%20%3C4.0.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Tests](https://img.shields.io/badge/Tests-126%20Passing%20(100%25)-success?style=for-the-badge&logo=checkmarx&logoColor=white)]()
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-blue?style=for-the-badge)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

An advanced, cross-platform geotechnical engineering application for rock slope stability assessment and rock mass characterization using the empirical **Q-slope** method (Bar & Barton, 2017).

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=in.sg.q_slope_calculator">
    <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Get it on Google Play" height="80">
  </a>
</p>

---

## 🌟 Key Features (Version 2.0.0)

### 1. ⚡ Comprehensive Q-Slope Calculation Engine
* **Full Parameter Integration**:
  * Rock Quality Designation ($RQD$) via Direct Core Recovery or Volumetric Joint Count ($J_v$).
  * Joint Set Number ($J_n$) with automated set/random derivation.
  * Joint Roughness ($J_r$) & Alteration ($J_a$) ratings.
  * Orientation Adjustment Factor ($O$-factor) via Direct Value or Romana SMR continuous adjustment ($F_1, F_2, F_3$).
  * Environmental and Geological Discontinuity Condition ($J_{wice}$).
  * Slope Active Stress Reduction Factor ($SRF_{slope} = \max(SRFa, SRFb, SRFc)$).
* **Kinematic Failure Mode Support**: Planar failure, Wedge failure (independent primary and secondary joint quotients), and Toppling failure.

### 2. 📊 Slope Stability Classification & Safety Margins
* **Empirical Stability Boundary**: Real-time evaluation against the empirical stable slope relationship:
  $$\beta = 20 \log_{10}(Q_{slope}) + 65^\circ$$
* **Safety Margin ($\Delta\beta$)**: Quantifies stability margin in degrees ($\Delta\beta = \beta_{allowable} - \beta_{actual}$):
  * 🟢 **Stable**: Actual angle $\le \beta_{allowable} - 2.5^\circ$ (Safety margin $\ge +2.5^\circ$)
  * 🟡 **Uncertain**: Boundary / transitional zone within $\pm 2.5^\circ$
  * 🔴 **Unstable**: Actual angle $> \beta_{allowable} + 2.5^\circ$ (Oversteepened)
* **Interactive Stability Badges**: Real-time visual status badges on home calculation cards with searchable filter chips.

### 3. 🧭 Kinematic Stereonet & Compass
* **Interactive Equal-Angle Stereonet**: Real-time lower-hemisphere stereographic projection.
* **Discontinuity Plotting**: Visualizes slope faces, joint planes (great circles & poles), and friction cones ($\phi$).
* **Kinematic Daylighting Analysis**: Automatic daylight envelope calculations and risk evaluation for Planar sliding, Wedge intersecting lines, and Flexural Toppling.

### 4. 📍 Field Outcrop Imagery & GPS Geotagging
* **Outcrop Photo Gallery**: In-app photo capture and local attachment with interactive full-screen zoom viewer.
* **Automatic GPS Acquisition**: One-tap acquisition of field latitude, longitude, and elevation.

### 5. 📁 Seamless Field Data Portability & Reporting
* **Geologist-Friendly CSV Engine**: Clean import and export formatted specifically for geological field databases, with conflict resolution strategies (skip, overwrite, import as new).
* **Multi-Tab Excel Spreadsheets**: Comprehensive multi-tab export containing summary tables, raw parameter logs, and calculation records.
* **Professional Geotechnical PDF Reports**: Multi-page engineering reports including site metadata, GPS coordinates, stability badges, stereonet diagrams, and embedded outcrop imagery.

---

## 📐 Mathematical Formulation

### 1. Primary Q-Slope Equation
$$Q_{slope} = \left(\frac{RQD}{J_n}\right) \times \left(\frac{J_r}{J_a}\right)_0 \times \left(\frac{J_{wice}}{SRF_{slope}}\right)$$

Where:
* **$\left(\frac{RQD}{J_n}\right)$**: Rock block size quotient ($RQD$: $0\text{--}100\%$, $J_n$: $0.5\text{--}20$).
* **$\left(\frac{J_r}{J_a}\right)_0$**: Joint shear strength quotient modified by orientation:
  * For **Planar Failure**: $\left(\frac{J_r}{J_a}\right) \times O_1$
  * For **Wedge Failure**: $\left(\frac{J_{r1}}{J_{a1}} \times O_1\right) \times \left(\frac{J_{r2}}{J_{a2}} \times O_2\right)$
* **$\left(\frac{J_{wice}}{SRF_{slope}}\right)$**: Active stress and environmental quotient ($J_{wice}$: $0.05\text{--}1.0$, $SRF$: $1\text{--}200$).

### 2. Empirical Slope Angle ($\beta$)
$$\beta = 20 \log_{10}(Q_{slope}) + 65^\circ$$

---

## 💻 Cross-Platform Support

| Platform | Support | Storage / Export | File / Camera Integration |
|---|---|---|---|
| **Android** | Native Release | Local App Storage / Downloads | Camera & File Picker |
| **iOS** | Native Release | Documents Directory / Files App | Native Camera & Photo Library |
| **Windows** | Native Desktop (Win32) | `%USERPROFILE%\Documents` | Windows File Picker & Dialogs |
| **macOS** | Native Desktop | `~/Documents` / Native Save | macOS Sandbox File Picker |
| **Linux** | Native Desktop | `~/.local/share` | Linux Native File Chooser |
| **Web** | Modern Browsers | Browser IndexedDB / Blob Downloads | In-browser File & Image Handling |

---

## 🛠️ Tools and Technologies

* **Framework**: [Flutter](https://flutter.dev) (managed via [FVM](https://fvm.app/))
* **Language**: [Dart](https://dart.dev) (v3.7.0+)
* **State Management**: `flutter_bloc` / Cubit & Reactive ValueNotifiers
* **Local Persistence**: `shared_preferences` & Local File System
* **Export Engines**: `pdf`, `printing`, `excel`, `csv`
* **Geospatial & Hardware**: `geolocator`, `image_picker`, `file_picker`, `url_launcher`
* **Responsive Layout**: `responsive_framework` (Mobile, Tablet, Desktop)

---

## 🚀 Getting Started

### Prerequisites
1. Ensure **Dart** and **Git** are installed on your system.
2. Install **FVM** (Flutter Version Management):
   ```sh
   dart pub global activate fvm
   ```
3. Verify your Flutter environment:
   ```sh
   fvm flutter doctor
   ```

### Setup & Installation
1. **Clone the Repository**:
   ```sh
   git clone https://github.com/saarthak08/q-slope-calculator.git
   cd q-slope-calculator
   ```

2. **Configure Environment**:
   * Create a `.env` file in the root directory:
     ```sh
     cp .env.sample .env
     ```

3. **Install Pinned Dependencies**:
   ```sh
   fvm install
   fvm flutter pub get
   fvm dart run husky install
   ```

### Running the App
* **Web or Windows Desktop**:
  ```sh
  fvm flutter run -t lib/main.dart
  ```
* **Android (Dev Flavor)**:
  ```sh
  fvm flutter run -t lib/main.dart --flavor dev
  ```
* **macOS / Linux**:
  ```sh
  fvm flutter run -d macos
  # or
  fvm flutter run -d linux
  ```

---

## 🧪 Testing & Code Quality

The codebase enforces strict static analysis and includes a comprehensive automated test suite covering geotechnical algorithms, UI workflows, data roundtrips, and backward compatibility across legacy data schemas.

* **Run Static Analysis** (0 warnings / errors):
  ```sh
  fvm flutter analyze
  ```
* **Run Test Suite** (139 / 139 passing):
  ```sh
  fvm flutter test
  ```
* **Run Backward Compatibility Verification**:
  ```sh
  fvm flutter test test/unit/backward_compatibility_test.dart
  ```

---

## 📚 Scientific References

1. **Bar, N., & Barton, N. (2017)**. *The Q-slope method for rock slope engineering*. Rock Mechanics and Rock Engineering, 50(12), 3307-3345.
2. **Barton, N., & Choubey, V. (1977)**. *The shear strength of rock joints in theory and practice*. Rock Mechanics, 10(1-2), 1-54.
3. **Goodman, R. E. (1980)**. *Introduction to Rock Mechanics*. John Wiley & Sons, New York.
4. **Hoek, E., & Bray, J. D. (1981)**. *Rock Slope Engineering*. Institution of Mining and Metallurgy, London.
5. **Palmström, A. (1982)**. *The volumetric joint count—a useful and simple measure of the degree of rock jointing*. In 4th Congress of the International Association of Engineering Geology, New Delhi.
6. **Romana, M. (1985)**. *New adjustment ratings for application of Bieniawski's classification to slopes*. In International Symposium on the Role of Rock Mechanics, Zacatecas.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
