# 📸 How to Take App Store Screenshots

## iPhone 16 Pro Max is Running!

The simulator should be open with your Flow iQ app running.

---

## 📱 Take iPhone Screenshots (6.5" Display)

### Method 1: Using Keyboard Shortcut
1. Navigate to different screens in your app
2. Press **Cmd + S** in the Simulator to take a screenshot
3. Screenshots save to Desktop by default

### Method 2: Using Simulator Menu
1. Navigate to a screen you want to capture
2. Go to **File → Save Screen** in Simulator menu
3. Choose location and save

### Method 3: Using Terminal Command
Run this command to take a screenshot:
```bash
xcrun simctl io 07BA7B7E-0A42-421D-A366-8724901FC36C screenshot ~/Desktop/flowiq_iphone_1.png
```

---

## 📋 Recommended Screenshots (Take 5-10)

Capture these screens to showcase your app:

1. **Splash/Welcome Screen** - First impression
2. **Login/Demo Screen** - Show authentication
3. **Home/Dashboard** - Main interface with data
4. **Calendar View** - Cycle tracking calendar
5. **Tracking Screen** - Symptom/mood tracking
6. **Insights/Analytics** - AI-powered insights
7. **Settings** - App configuration
8. **Profile** - User profile view

---

## 🖼️ Screenshot Requirements

**iPhone 6.5" (iPhone 16 Pro Max)**
- **Resolution:** 1290 x 2796 pixels
- **Format:** PNG or JPG
- **Minimum:** 1 screenshot required
- **Maximum:** 10 screenshots
- **Order:** Screenshots appear in App Store in the order you upload

---

## 📱 iPad Screenshots

After iPhone screenshots, run:
```bash
# Shutdown iPhone simulator
xcrun simctl shutdown 07BA7B7E-0A42-421D-A366-8724901FC36C

# Boot iPad Pro 13"
xcrun simctl boot 2FA0CC39-1421-4B7D-B1A3-4339F31050F9
open -a Simulator

# Run app
flutter run -d 2FA0CC39-1421-4B7D-B1A3-4339F31050F9
```

Then take 1-3 iPad screenshots using the same methods.

**iPad 13" Requirements:**
- **Resolution:** 2048 x 2732 pixels
- **Format:** PNG or JPG
- **Minimum:** 1 screenshot required

---

## 💡 Tips for Great Screenshots

1. **Use Light Mode** - Usually looks better in App Store
2. **Hide Status Bar** - Optional, looks cleaner
3. **Show Real Data** - Use demo account to show actual content
4. **Consistent Theme** - Use same color scheme across all screenshots
5. **Highlight Features** - Show your best features first

---

## 📁 Organize Your Screenshots

Create folders for easy management:
```bash
mkdir -p ~/Desktop/AppStore_Screenshots/iPhone
mkdir -p ~/Desktop/AppStore_Screenshots/iPad

# Move screenshots to folders
mv ~/Desktop/flowiq_*.png ~/Desktop/AppStore_Screenshots/iPhone/
```

---

## ✅ When Done

1. You should have:
   - 5-10 iPhone screenshots (1290 x 2796)
   - 1-3 iPad screenshots (2048 x 2732)

2. Upload to App Store Connect:
   - Go to your app version
   - Scroll to "App Preview and Screenshots"
   - Click "+" to add screenshots
   - Drag and drop your screenshots

---

## 🎨 Optional: Enhance Screenshots Later

Tools to add frames/text to screenshots:
- **Screenshots.pro** (free frames)
- **Figma** (design overlays)
- **Canva** (add text/graphics)
- **Apple's Design Resources** (device frames)

---

**Quick Commands Reference:**

```bash
# Take screenshot
xcrun simctl io DEVICE_ID screenshot ~/Desktop/screenshot.png

# iPhone 16 Pro Max ID
07BA7B7E-0A42-421D-A366-8724901FC36C

# iPad Pro 13" ID  
2FA0CC39-1421-4B7D-B1A3-4339F31050F9
```
