# Flow iQ - Revolutionary Clinical Period Intelligence

<div align="center">

[![App Store](https://img.shields.io/badge/App%20Store-Download-blue?style=for-the-badge&logo=apple)](https://apps.apple.com)
[![Version](https://img.shields.io/badge/version-2.0.3-brightgreen?style=for-the-badge)](https://github.com/ronospace/Flow-iQ)
[![License](https://img.shields.io/badge/license-Proprietary-red?style=for-the-badge)](LICENSE)

Flow iQ is the AI engine behind ZyraFlow, delivering personalized menstrual cycle predictions, symptom tracking, and health insights powered by clinical-grade intelligence.

[Features](#-features) • [Getting Started](#-getting-started) • [Documentation](#-documentation) • [Support](#-support)

</div>

---

## 🌟 About Flow iQ

Flow iQ is a revolutionary clinical-grade period tracking platform that combines cutting-edge AI with comprehensive health analytics. Built with Flutter, it offers a beautiful, intuitive experience focused on privacy and reproductive wellness.

### 🎯 Key Features

#### Clinical-Grade Intelligence
- 🧠 **AI-Powered Insights** backed by medical research (ACOG, NIH, NEJM)
- 📊 **Advanced Cycle Prediction** using machine learning
- 🔍 **Comprehensive Symptom Tracking** and pattern recognition
- 📚 **Evidence-Based Recommendations** with medical citations
- ⚕️ **Medical Compliance** - positioned as wellbeing analytics tool

#### Comprehensive Health Tracking
- 🩸 Period flow, symptoms, and mood tracking
- 💊 Medication and supplement logging
- 😴 Sleep quality and exercise monitoring
- 🍎 Nutritional insights and recommendations
- 📸 Photo journaling and notes

#### Smart Predictions
- 📅 Accurate cycle forecasting
- 🌸 Fertility window calculations
- ⚡ PMS symptom predictions
- 🔄 Ovulation tracking
- 🔔 Personalized health alerts

#### Privacy & Security
- 🔐 End-to-end encryption
- 🏥 HIPAA-ready infrastructure
- ✅ Complete data control
- 🤝 Optional healthcare provider sync
- ☁️ Secure cloud backup

#### Beautiful Design
- 🎨 Modern, clean interface
- 🌙 Auto/Light/Dark mode support
- 🎭 Customizable themes
- 📈 Easy-to-read charts and visualizations
- 👆 Gesture-based navigation

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- iOS 13.0+ / Android 5.0+
- Xcode 14+ (for iOS development)
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ronospace/Flow-iQ.git
   cd Flow-iQ
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` (Android) to `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`

4. **Run the app**
   ```bash
   # iOS
   flutter run -d "iPhone 15 Pro"
   
   # Android
   flutter run -d "Android Emulator"
   
   # Web
   flutter run -d chrome
   ```

### Demo Account

Use these credentials to explore the app:
- **Email:** demo@flowiq.health
- **Password:** FlowIQ2024Demo!

---

## 📱 Build & Deploy

### iOS Release
```bash
flutter build ipa --release
```

See [IOS_EXPORT_GUIDE.md](IOS_EXPORT_GUIDE.md) for detailed instructions.

### Android Release
```bash
flutter build appbundle --release
```

See [ANDROID_RELEASE_GUIDE.md](ANDROID_RELEASE_GUIDE.md) for detailed instructions.

---

## 📚 Documentation

- **[App Store Metadata](docs/APP_STORE_METADATA.md)** - Complete App Store submission guide
- **[Screenshot Guide](docs/SCREENSHOT_GUIDE.md)** - Creating professional screenshots
- **[Clinical Compliance](docs/CLINICAL_COMPLIANCE_ROADMAP.md)** - Medical compliance and regulatory requirements
- **[Medical Sources](docs/MEDICAL_SOURCES.md)** - Research citations and references
- **[Rejection Fix Guide](APP_STORE_REJECTION_FIX.md)** - Latest App Store submission updates
- **[Compliance Checklists](compliance/)** - Version-specific compliance documentation (PDF & Markdown)

---

## 🏗️ Architecture

### Tech Stack
- **Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **State Management:** Provider
- **Backend:** Firebase (Auth, Firestore, Analytics, Crashlytics)
- **Local Storage:** Shared Preferences
- **Design System:** Custom Flow iQ Visual System

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── screens/                  # UI screens
│   ├── auth_screen.dart
│   ├── home_screen.dart
│   ├── tracking_screen.dart
│   ├── insights_screen.dart
│   ├── health_diagnosis_screen.dart
│   └── settings_screen.dart
├── services/                 # Business logic
│   ├── enhanced_auth_service.dart
│   ├── flow_iq_sync_service.dart
│   ├── enhanced_ai_service.dart
│   ├── ml_prediction_service.dart
│   └── theme_service.dart
├── widgets/                  # Reusable components
├── themes/                   # Visual system & themes
└── models/                   # Data models
```

---

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart

# Analyze code
flutter analyze
```

---

## 🛣️ Roadmap

### v2.0.3 (Current) ✅
- Fixed app crash issues
- Enhanced Provider dependency management
- Added theme service with persistent storage
- Medical compliance improvements
- App Store submission ready

### v2.1.0 (Coming Soon)
- Integration with wearable devices (Apple Watch, Fitbit)
- Advanced data visualization
- Social features and community
- Offline-first architecture
- Custom themes and branding

### v2.2.0
- Advanced AI health coaching
- Third-party integrations
- Advanced export formats (PDF reports)
- Multi-language support
- Healthcare provider portal

---

## 🤝 Contributing

This is a proprietary project owned by ZyraFlow Inc. For collaboration inquiries, please contact us through official channels.

### About Flow iQ and Flow Ai

**Flow iQ** and **Flow Ai** are developed and maintained by ZyraFlow Inc.™ (© 2025 ZyraFlow Inc. All rights reserved.)

These applications work together as a comprehensive menstrual health ecosystem:
- **Flow iQ** - Consumer-facing AI-powered period tracking app
- **Flow Ai** - Professional healthcare platform for clinical integration

Both applications share core technology and are part of the ZyraFlow health intelligence platform.

---

## 📄 License

This project is proprietary software.

© 2025 ZyraFlow Inc.™ All rights reserved.

Unauthorized copying, modification, distribution, or use of this software, via any medium, is strictly prohibited without explicit written permission from ZyraFlow Inc.

---

## 💬 Support

### Get Help
- 📧 **Email:** support@zyraflow.com
- 🐛 **Issues:** [GitHub Issues](https://github.com/ronospace/Flow-iQ/issues)
- 📖 **Documentation:** [Full Docs](https://github.com/ronospace/Flow-iQ/wiki)

### Connect With Us
- 🌐 **Website:** [Coming Soon]
- 💼 **LinkedIn:** [ZyraFlow Inc.](https://linkedin.com/company/zyraflow)
- 🐦 **Twitter:** [@ZyraFlow](https://twitter.com/zyraflow)

---

## 🏆 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend infrastructure
- Medical research contributors (ACOG, NIH, NEJM)
- Open source community
- All beta testers and early users

---

## 🔒 Privacy

Flow iQ is committed to protecting your privacy. We implement:
- End-to-end encryption for sensitive data
- HIPAA-compliant infrastructure
- No data sharing without explicit consent
- Complete user data control and deletion rights

Read our full [Privacy Policy](https://ronospace.github.io/Flow-iQ/privacy-policy.html)

---

## ⚕️ Medical Disclaimer

Flow iQ is designed as a clinical decision support tool and wellbeing analytics platform. It is **not intended to diagnose, treat, cure, or prevent any disease**. Always consult with a qualified healthcare professional for medical advice, diagnosis, or treatment.

---

<div align="center">

**Made with ❤️ by ZyraFlow Inc.**

*Empowering wellness through intelligent insights*

© 2025 ZyraFlow Inc.™ All rights reserved.

[⬆ Back to top](#flow-iq---revolutionary-clinical-period-intelligence)

</div>
