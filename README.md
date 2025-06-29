# Smart Parking Access

## Overview

Smart Parking Access is a comprehensive solution for university staff to access parking lots easily and securely, eliminating the need for physical remotes and expensive camera installations. The system leverages a mobile app, a custom ESP32-based hardware module, a desktop control application, and a local computer vision service for vehicle detection.

---

## Features

- **Mobile App (Flutter, Android/iOS):**  
  Staff can open the barrier via a secure app with Firebase authentication.
- **Custom Hardware (ESP32):**  
  Controls the barrier by simulating button press upon receiving a signal from the cloud.
- **Desktop Control App (Flutter Desktop):**  
  Manages access logs, staff registration, and generates Excel reports.
- **Vision Service (Python, YOLOv3):**  
  Detects vehicle entry/exit using video stream and ROI-based logic.
- **Cloud Database (Firebase):**  
  Stores user data, access logs, and synchronizes signals between components.

---

## Architecture

![Architecture Diagram](docs/architecture.png) <!-- Add your diagram here -->

1. **User** requests access via the mobile app.
2. **Signal** is sent to Firebase with user credentials.
3. **ESP32 module** listens for open commands and triggers the barrier.
4. **Desktop app** monitors video feed, detects vehicle movement using YOLOv3, and logs events.
5. **Excel reports** are generated for security staff.

---

## Getting Started

### Prerequisites

- Flutter SDK (for mobile and desktop apps)
- Python 3.x (for vision service)
- ESP32 Wrover board
- Firebase account

### Installation

#### 1. Mobile App

```bash
cd mobile_app
flutter pub get
flutter run
```

#### 2. Desktop App

```bash
cd desktop_app
flutter pub get
flutter run
```

#### 3. Vision Service

```bash
cd vision_service
pip install -r requirements.txt
python main.py
```

#### 4. ESP32 Firmware

- Flash the provided firmware to your ESP32 board

---

## Usage

1. Register staff in the desktop app.
2. Staff logs in via the mobile app and requests access.
3. ESP32 module opens the barrier.
4. Vision service detects vehicle movement and logs the event.
5. Security staff can export access logs to Excel.

---

## Folder Structure

```
mobile_app/      # Flutter mobile app
desktop_app/     # Flutter desktop app
vision_service/  # Python YOLOv3 service
hardware/        # ESP32 firmware and wiring diagrams
docs/            # Documentation and diagrams
examples/        # Example reports and screenshots
```

---

## Screenshots

<!-- Add screenshots here -->
![Mobile App](docs/screenshots/mobile_app.png)
![Desktop App](docs/screenshots/desktop_app.png)
![Excel Report](docs/screenshots/excel_report.png)

---

## License

MIT License

---

## Contact

For questions or collaboration, contact [your.email@example.com](mailto:your.email@example.com)