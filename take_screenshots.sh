#!/bin/bash

echo "Taking App Store Screenshots..."

# iPhone 16 Pro Max (6.7" display = 6.5" category)
IPHONE_ID="07BA7B7E-0A42-421D-A366-8724901FC36C"
# iPad Pro 13" 
IPAD_ID="2FA0CC39-1421-4B7D-B1A3-4339F31050F9"

echo "Booting iPhone 16 Pro Max..."
xcrun simctl boot $IPHONE_ID 2>/dev/null || echo "iPhone already booted"
sleep 5

echo "Installing and launching app on iPhone..."
xcrun simctl install $IPHONE_ID build/ios/iphonesimulator/*.app 2>/dev/null || echo "Using profile build..."

# Take iPhone screenshots
for i in 1 2 3 4 5; do
  sleep 2
  xcrun simctl io $IPHONE_ID screenshot screenshots/iphone/screenshot_$i.png
  echo "Saved iPhone screenshot $i"
done

echo "Booting iPad Pro 13\"..."
xcrun simctl boot $IPAD_ID 2>/dev/null || echo "iPad already booted"
sleep 5

# Take iPad screenshots
for i in 1 2 3; do
  sleep 2
  xcrun simctl io $IPAD_ID screenshot screenshots/ipad/screenshot_$i.png
  echo "Saved iPad screenshot $i"
done

echo "✅ Screenshots saved to screenshots/ folder"
open screenshots/

