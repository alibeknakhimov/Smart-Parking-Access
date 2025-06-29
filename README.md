# Smart Parking Access 🚗🔐

A **real-world IoT + Computer Vision system** for automating barrier gate access for university staff. The project replaces lost RF remotes and costly wired LPR cameras with a mobile app, a custom ESP32 PCB module, and an AI vision service.

![System Architecture](docs/diagram.png)

---

## 📱 Try the App

Available on Google Play → [**Install here**](https://play.google.com/store/apps/details?id=com.web.kbtu&pcampaignid=web_share)

---

## ⚡ How it works

* **Mobile App (Flutter)**: Checks geolocation, authenticates via Firebase, and sends an `open_barrier` signal.
* **Firebase (RTDB + Auth)**: Stores barrier state, verifies user identity, and forwards commands securely.
* **Custom PCB (ESP32)**: Listens for open commands and switches relay contacts to trigger the gate.
* **Vision Service (YOLOv3)**: Monitors video feed, detects vehicle direction, and logs entry/exit.
* **Guard Desktop (Flutter + Python)**: CRUD for users, live status, and export to XLS.

---

## 🗂️ Project structure

```
Smart-Parking-Access/
├─ mobile_app/        # Flutter Android/iOS app
├─ desktop_app/       # Guard Desktop app
├─ firmware/          # ESP32 (PlatformIO)
├─ vision_service/    # Python + YOLOv3 detection
├─ docs/diagram.png   # System Architecture
```

---

## 🔒 Security Notes

* Firebase Auth protects all gate commands (`open_barrier`).
* RTDB rules validate `uid`.
* ESP32 uses secure HTTPS requests.

---

## ✅ Highlights

* Full working deployment: **tested hardware, AI tracking, and mobile app in store**.
* Clear data flow: user → cloud → edge module → gate.


