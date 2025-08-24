# Firebase Setup for Flow iQ

## Overview
Flow iQ uses Firebase as its backend-as-a-service platform, providing comprehensive cloud services including authentication, database, storage, analytics, and more.

## Firebase Project Details
- **Project Name**: Flow iQ
- **Project ID**: flow-iq-app
- **Console URL**: https://console.firebase.google.com/project/flow-iq-app

## Configured Services
- ✅ **Firebase Authentication**: User login/signup with Google and Apple Sign-In
- ✅ **Cloud Firestore**: NoSQL database for user data, mood tracking, and analytics
- ✅ **Firebase Storage**: File storage for user uploads and exported data
- ✅ **Firebase Analytics**: App usage and performance analytics
- ✅ **Firebase Crashlytics**: Crash reporting and debugging
- ✅ **Firebase Performance Monitoring**: App performance tracking
- ✅ **Firebase Hosting**: Web hosting for Flutter web build

## Platform Configuration
The app is configured for all Flutter platforms:
- ✅ **Android**: `android/app/google-services.json`
- ✅ **iOS**: `ios/Runner/GoogleService-Info.plist`  
- ✅ **macOS**: `macos/Runner/GoogleService-Info.plist`
- ✅ **Web**: Configured in `lib/firebase_options.dart`
- ✅ **Windows**: Configured in `lib/firebase_options.dart`

## Configuration Files
- `lib/firebase_options.dart` - Auto-generated Firebase configuration for all platforms
- `firestore.rules` - Firestore security rules
- `storage.rules` - Firebase Storage security rules
- `firestore.indexes.json` - Firestore composite indexes
- `firebase.json` - Firebase CLI configuration and hosting settings

## Security Rules

### Firestore Rules
The Firestore security rules ensure users can only access their own data:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // User's cycles data
      match /cycles/{cycleId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // User's daily logs
      match /dailyLogs/{logId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // User's settings and preferences
      match /settings/{settingId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Community and shared data (read-only for authenticated users)
    match /community/{docId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.createdBy;
    }
    
    // Export data (user-specific)
    match /exports/{userId}/{exportId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Anonymous analytics (read-only)
    match /analytics/{docId} {
      allow read: if request.auth != null;
    }
  }
}
```

### Storage Rules
The Storage security rules control file access:

```javascript
rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {
    // Users can only access their own files
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId
        && request.resource.size < 50 * 1024 * 1024 // 50MB limit
        && request.resource.contentType.matches('image/.*|application/pdf|text/.*');
    }
    
    // Export files (user-specific)
    match /exports/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId
        && request.resource.size < 100 * 1024 * 1024; // 100MB limit for exports
    }
    
    // Profile images
    match /avatars/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId
        && request.resource.size < 5 * 1024 * 1024 // 5MB limit
        && request.resource.contentType.matches('image/.*');
    }
    
    // Community shared files (read access for authenticated users)
    match /community/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && request.resource.size < 10 * 1024 * 1024 // 10MB limit
        && request.resource.contentType.matches('image/.*');
    }
  }
}
```

## Database Structure

### Users Collection
```
/users/{userId}
├── displayName: string
├── email: string
├── avatar: string?
├── createdAt: timestamp
├── lastActive: timestamp
├── preferences: {
│   ├── theme: string
│   ├── locale: string
│   ├── notifications: boolean
│   └── privacy: object
│   }
└── metadata: object
```

### Cycles Collection
```
/users/{userId}/cycles/{cycleId}
├── startDate: timestamp
├── endDate: timestamp?
├── length: number
├── flow: array
├── symptoms: array
├── mood: array
├── notes: string?
├── createdAt: timestamp
└── updatedAt: timestamp
```

### Daily Logs Collection
```
/users/{userId}/dailyLogs/{logId}
├── date: timestamp
├── mood: number
├── energy: number
├── sleep: object
├── symptoms: array
├── activities: array
├── notes: string?
├── createdAt: timestamp
└── updatedAt: timestamp
```

## Authentication Setup

### Supported Sign-in Methods
1. **Email/Password**
   - Standard email-based authentication
   - Password reset functionality

2. **Google Sign-In**
   - OAuth 2.0 integration
   - Automatic profile information sync

3. **Apple Sign-In**
   - iOS/macOS native integration
   - Privacy-focused authentication

### Authentication Flow
```dart
// Initialize Firebase
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Use Firebase Auth
final auth = FirebaseAuth.instance;
final user = auth.currentUser;

// Sign in with Google
final googleUser = await GoogleSignIn().signIn();
final googleAuth = await googleUser?.authentication;
final credential = GoogleAuthProvider.credential(
  accessToken: googleAuth?.accessToken,
  idToken: googleAuth?.idToken,
);
await auth.signInWithCredential(credential);
```

## Analytics Setup

### Tracked Events
- **User Engagement**: App opens, screen views, session duration
- **Feature Usage**: Button clicks, feature adoption, user flows
- **Health Data**: Mood entries, cycle logging, symptom tracking
- **Performance**: App crashes, error rates, loading times

### Custom Events
```dart
// Log custom analytics events
FirebaseAnalytics.instance.logEvent(
  name: 'mood_logged',
  parameters: {
    'mood_score': 7,
    'date': DateTime.now().toString(),
    'user_id': userId,
  },
);
```

## Deployment Commands

### Deploy Security Rules
```bash
# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only storage

# Deploy all Firebase services
firebase deploy
```

### Update Indexes
```bash
# Deploy Firestore indexes
firebase deploy --only firestore:indexes
```

### Hosting Deployment
```bash
# Build Flutter web app
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

## Environment Setup

### Development Environment
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize project (if not already done)
firebase init

# Use Flow iQ project
firebase use flow-iq-app
```

### FlutterFire CLI
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Flutter project
flutterfire configure --project=flow-iq-app
```

## Testing Firebase Integration

### Unit Tests
Run the Firebase configuration tests:
```bash
flutter test test/firebase_test.dart
```

### Integration Tests
Test Firebase functionality in the app context:
```bash
flutter test integration_test/firebase_integration_test.dart
```

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Ensure SHA-1/SHA-256 certificates are configured for Android
   - Verify Bundle ID matches Firebase project settings for iOS

2. **Firestore Permission Denied**
   - Check security rules are deployed
   - Verify user is authenticated before accessing data

3. **Storage Upload Failures**
   - Check file size limits in storage rules
   - Verify file type restrictions

4. **Build Errors**
   - Ensure all Firebase configuration files are in place
   - Run `flutter clean && flutter pub get`

### Debug Commands
```bash
# Check Firebase project status
firebase projects:list

# Validate Firestore rules
firebase firestore:rules:test --test-suite=test/firestore-test.js

# View logs
firebase logs --project=flow-iq-app
```

## Performance Optimization

### Best Practices
1. **Firestore Queries**
   - Use pagination for large data sets
   - Create appropriate indexes for complex queries
   - Limit results with `limit()` clause

2. **Storage Operations**
   - Compress images before upload
   - Use appropriate file formats
   - Implement progress indicators for uploads

3. **Real-time Listeners**
   - Remove listeners when not needed
   - Use `get()` instead of `snapshots()` for one-time reads

## Security Best Practices

1. **Authentication**
   - Implement proper session management
   - Use secure storage for tokens
   - Implement logout functionality

2. **Data Validation**
   - Validate data on both client and server side
   - Sanitize user inputs
   - Use proper data types in Firestore

3. **Access Control**
   - Follow principle of least privilege
   - Regularly review security rules
   - Monitor access patterns

## Monitoring and Alerts

### Firebase Console Monitoring
- Monitor authentication metrics
- Track database usage and performance
- Review storage usage and costs
- Monitor hosting traffic

### Custom Alerts
Set up alerts for:
- High error rates
- Unusual authentication patterns  
- Storage quota approaching limits
- Performance degradation

---

## Next Steps

1. **Production Setup**: Review and tighten security rules for production
2. **Performance Monitoring**: Set up detailed performance tracking
3. **Cost Optimization**: Monitor usage and optimize for cost efficiency
4. **Backup Strategy**: Implement automated backup solutions
5. **Disaster Recovery**: Plan for service outages and data recovery

For more detailed information, visit the [Firebase Console](https://console.firebase.google.com/project/flow-iq-app).
