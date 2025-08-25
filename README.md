# Flow iQ 🧠💙

An intelligent Flutter app for advanced mood and wellness analytics with AI-powered insights.

## 🌟 Features

### Core Functionality
- **AI-Powered Analytics**: Advanced mood pattern recognition and insights
- **Multi-Platform Support**: Runs seamlessly on iOS, Android, Web, macOS, and Windows
- **Real-Time Data Sync**: Firebase-powered cloud synchronization
- **Smart Notifications**: Intelligent reminders and wellness suggestions
- **Export & Sharing**: Comprehensive data export and sharing capabilities

### Advanced Analytics
- **Predictive Insights**: AI-driven predictions for mood and wellness trends
- **Correlation Analysis**: Discover patterns between lifestyle factors and wellbeing
- **Interactive Charts**: Beautiful, interactive data visualizations
- **Health Integration**: Connect with Apple Health and Google Fit (iOS/Android)
- **Report Generation**: Professional PDF reports for healthcare providers

### Security & Privacy
- **End-to-End Encryption**: All sensitive data is encrypted
- **GDPR Compliant**: Full compliance with privacy regulations
- **Local Authentication**: Biometric and PIN protection
- **Secure Cloud Storage**: Firebase with advanced security rules
- **Data Ownership**: Complete control over your personal data

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.24.5)
- Dart SDK (>=3.5.4)
- Firebase CLI
- Xcode (for iOS/macOS development)
- Android Studio (for Android development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flow-iq.git
   cd flow-iq
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   ```bash
   # Install Firebase CLI if not already installed
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Configure FlutterFire
   flutterfire configure
   ```

4. **Platform-Specific Setup**

   **iOS:**
   ```bash
   cd ios
   pod install
   cd ..
   ```

   **Android:**
   - Ensure `android/app/google-services.json` is in place
   - Update `android/app/build.gradle` with proper signing config

   **Web:**
   ```bash
   flutter build web
   ```

5. **Run the app**
   ```bash
   # Run on connected device
   flutter run
   
   # Run on specific platform
   flutter run -d chrome          # Web
   flutter run -d ios             # iOS
   flutter run -d android         # Android
   flutter run -d macos           # macOS
   flutter run -d windows         # Windows
   ```

## 🏗️ Architecture

Flow iQ follows a clean architecture pattern with the following structure:

```
lib/
├── l10n/                   # Internationalization
├── models/                 # Data models
├── providers/              # State management
├── screens/                # UI screens
├── services/               # Business logic
├── theme/                  # App theming
├── utils/                  # Helper utilities
├── widgets/                # Reusable components
└── main.dart              # App entry point
```

### Key Design Patterns
- **Provider Pattern**: For state management
- **Repository Pattern**: For data access
- **Service Locator**: For dependency injection
- **Observer Pattern**: For real-time updates

## 🔧 Configuration

### Firebase Configuration
The app uses Firebase for backend services:
- **Authentication**: User login/signup
- **Firestore**: Real-time database
- **Storage**: File storage
- **Analytics**: Usage analytics
- **Crashlytics**: Error reporting
- **Performance**: Performance monitoring

### Environment Variables
Create a `.env` file in the root directory:
```env
FIREBASE_PROJECT_ID=flow-iq-app
API_BASE_URL=https://api.flowiq.app
SENTRY_DSN=your-sentry-dsn
```

## 📱 Platform Support

| Platform | Status | Notes |
|----------|---------|-------|
| iOS | ✅ | Requires iOS 15.0+ |
| Android | ✅ | Requires API level 21+ |
| Web | ✅ | Progressive Web App |
| macOS | ✅ | Requires macOS 10.15+ |
| Windows | ✅ | Windows 10+ |

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Firebase Tests
```bash
flutter test test/firebase_test.dart
```

### Platform-Specific Testing
```bash
# Web
flutter test --platform chrome

# iOS Simulator
flutter test integration_test/ --device-id=ios-simulator

# Android Emulator
flutter test integration_test/ --device-id=android-emulator
```

## 🚀 Building for Production

### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Debug build
flutter build ios --debug --no-codesign

# Release build
flutter build ios --release
```

### Web
```bash
# Debug build
flutter build web --debug

# Release build
flutter build web --release
```

### macOS
```bash
# Debug build
flutter build macos --debug

# Release build
flutter build macos --release
```

### Windows
```bash
# Debug build
flutter build windows --debug

# Release build
flutter build windows --release
```

## 🌍 Internationalization

Flow iQ supports multiple languages:
- 🇺🇸 English
- 🇪🇸 Spanish
- 🇫🇷 French
- 🇩🇪 German
- 🇹🇿 Swahili
- 🇸🇦 Arabic

### Adding New Translations
1. Create new ARB files in `lib/l10n/`
2. Update `_getSafeLocales()` in `main.dart`
3. Run `flutter gen-l10n`

## 🔐 Security

### Data Encryption
- All sensitive data is encrypted using AES-256
- Biometric authentication for app access
- Secure key storage using platform-specific keychains

### Firebase Security Rules
```javascript
// Firestore Rules
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}

// Storage Rules
match /users/{userId}/{allPaths=**} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

## 📊 Analytics & Performance

### Firebase Analytics Events
- User engagement metrics
- Feature usage tracking
- Error and crash reporting
- Performance monitoring

### Performance Optimization
- Lazy loading of heavy components
- Image caching and optimization
- Database query optimization
- Memory management

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

### Code Style
- Follow Dart/Flutter conventions
- Use `flutter analyze` to check code quality
- Run `dart format` to format code
- Add documentation for public APIs

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

### Documentation
- [User Guide](docs/user-guide.md)
- [Developer Guide](docs/developer-guide.md)
- [API Documentation](docs/api.md)
- [Troubleshooting](docs/troubleshooting.md)

### Getting Help
- 📧 Email: support@flowiq.app
- 💬 Discord: [Flow iQ Community](https://discord.gg/flowiq)
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/flow-iq/issues)
- 📖 Wiki: [GitHub Wiki](https://github.com/yourusername/flow-iq/wiki)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend services
- The open-source community for incredible packages
- Our beta testers and contributors

## 📈 Roadmap

### v2.0.0 (Coming Soon)
- [ ] Advanced AI health coaching
- [ ] Integration with wearable devices
- [ ] Social features and community
- [ ] Advanced data visualization
- [ ] Machine learning insights

### v2.1.0
- [ ] Offline-first architecture
- [ ] Advanced export formats
- [ ] Third-party integrations
- [ ] Custom themes and branding

---

<p align="center">
  Made with ❤️ by the Flow iQ Team<br>
  <em>Empowering wellness through intelligent insights</em>
</p>
