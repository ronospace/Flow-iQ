#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont
import os

def create_screenshot(width, height, filename, device_name):
    # Create image with gradient background
    img = Image.new('RGB', (width, height), color=(108, 102, 241))
    draw = ImageDraw.Draw(img)
    
    # Add gradient effect
    for y in range(height):
        color = (
            int(108 + (79 - 108) * y / height),
            int(102 + (70 - 102) * y / height),
            int(241 + (229 - 241) * y / height)
        )
        draw.line([(0, y), (width, y)], fill=color)
    
    # Add text
    try:
        font_large = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 120)
        font_small = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 60)
    except:
        font_large = ImageFont.load_default()
        font_small = ImageFont.load_default()
    
    # Draw app name
    text = "Flow iQ"
    bbox = draw.textbbox((0, 0), text, font=font_large)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    x = (width - text_width) // 2
    y = (height - text_height) // 2 - 100
    draw.text((x, y), text, fill='white', font=font_large)
    
    # Draw tagline
    tagline = "Intelligent Menstrual Health"
    bbox = draw.textbbox((0, 0), tagline, font=font_small)
    text_width = bbox[2] - bbox[0]
    x = (width - text_width) // 2
    y = (height // 2) + 50
    draw.text((x, y), tagline, fill='white', font=font_small)
    
    # Save
    img.save(filename)
    print(f"✓ Created {device_name}: {filename}")

# Create directories
os.makedirs("screenshots/iphone", exist_ok=True)
os.makedirs("screenshots/ipad", exist_ok=True)

# iPhone 6.5" screenshots
for i in range(1, 6):
    create_screenshot(1290, 2796, f"screenshots/iphone/screenshot_{i}.png", "iPhone")

# iPad 13" screenshots  
for i in range(1, 4):
    create_screenshot(2048, 2732, f"screenshots/ipad/screenshot_{i}.png", "iPad")

print("\n✅ All screenshots created!")
print("📁 Location: screenshots/ folder")
