# Flow-Ai Improvement Notes

## UI/UX Enhancements

### Theme Switcher - Settings Screen
**Priority:** Medium  
**Date Added:** October 28, 2025

**Current State:**
- Theme switcher is currently positioned lower in the settings screen

**Proposed Improvement:**
- Add a **prominent theme switcher button at the top of the settings screen**
- Design specifications:
  - Three options: **Auto**, **Light**, **Dark**
  - Layout: **Horizontal glass card** design
  - Positioning: Top of settings screen (high visibility)
  - Style: Modern glass morphism effect for premium feel

**Benefits:**
- Improved discoverability of theme switching feature
- Better user experience with immediate access
- Modern, polished UI following current design trends
- Matches iOS/Android settings app patterns

**Implementation Notes:**
- Location: `lib/screens/settings_screen.dart`
- Consider using segmented control design pattern
- Add smooth animation transitions between theme modes
- Ensure glass card has proper blur effect and border
- Test in both light and dark modes for visibility

---

## Additional Notes
- Theme persistence is already working via `ThemeService`
- Current theme options work correctly, just need UI repositioning
- Consider adding theme preview icons for each mode
