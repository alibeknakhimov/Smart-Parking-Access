## 📂 Firebase Credentials

1. **`google-services.json`**

   * For Android mobile app.
   * Download from Firebase Console → `Project Settings` → `Your Apps` → Android.
   * Place it in: `mobile_app/android/app/google-services.json`

2. **`GoogleService-Info.plist`**

   * For iOS mobile app.
   * Download from Firebase Console → `Project Settings` → `Your Apps` → iOS.
   * Place it in: `mobile_app/ios/Runner/GoogleService-Info.plist`

3. **`kbtu-4554c-firebase-adminsdk.json`**

   * Admin SDK key for Vision Service or Guard Desktop.
   * Download from Firebase Console → `Project Settings` → `Service Accounts` → `Generate new private key`.
   * Place it in: `vision_service/firebase-adminsdk.json`

---

## 🧠 YOLO Model Files

1. **`yolov3.cfg`** and **`yolov3.weights`**

   * Used by the Python Vision Service to detect vehicles.
   * Recommended: store them in `vision_service/` folder.
   * Example structure:

     ```
     vision_service/
     ├─ detect.py
     ├─ yolov3.cfg
     └─ yolov3.weights
     ```
   * You can download the official YOLOv3 weights from [pjreddie.com/darknet/yolo](https://pjreddie.com/darknet/yolo/).

