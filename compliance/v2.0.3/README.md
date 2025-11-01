# Compliance Checklist - v2.0.3

© 2025 ZyraFlow Inc.™ All rights reserved.

---

## Files in this Directory

- **compliance-checklist-v2.0.3.md** - Markdown version of compliance checklist
- **Flow-iQ-Compliance-Checklist-v2.0.3.pdf** - PDF version (to be generated)

## Generating PDF

To generate the PDF version of this compliance checklist:

```bash
# From project root
./scripts/generate_compliance_pdf.sh 2.0.3
```

### Prerequisites

```bash
brew install pandoc
brew install --cask wkhtmltopdf  # Optional, for better PDFs
```

### Alternative: Manual PDF Generation

If you don't have pandoc installed, you can generate the PDF manually:

1. **Using VS Code**:
   - Install "Markdown PDF" extension
   - Open `compliance-checklist-v2.0.3.md`
   - Right-click → Markdown PDF: Export (pdf)

2. **Using Online Tools**:
   - Upload to https://www.markdowntopdf.com/
   - Or use https://dillinger.io/

3. **Using macOS Print**:
   - Open markdown file in any markdown viewer
   - Press Cmd+P
   - Save as PDF

## Version Information

- **Version**: 2.0.3
- **Build**: 1
- **Release Date**: November 1, 2025
- **Bundle ID**: com.flowai.health.flowAi
- **Target**: iOS 13.0+

## Compliance Status

**Overall**: 70% Complete (Pending manual testing & screenshots)

### ✅ Verified
- Release build configuration
- Privacy policy accessibility
- HealthKit disclosure
- HTTPS enforcement
- SDK versions current
- App description compliance
- Medical disclaimer present

### ⚠️ Pending
- Demo account full testing
- Delete account verification
- Screenshot creation (iPhone & iPad)
- Multi-device testing

## Quick Reference

**Demo Account**:
- Email: demo@flowiq.health
- Password: FlowIQ2024Demo!

**Privacy Policy**: https://ronospace.github.io/Flow-iQ/privacy-policy.html

**Repository**: https://github.com/ronospace/Flow-iQ

---

**Prepared by**: ZyraFlow Inc.™ Compliance Team  
**© 2025 ZyraFlow Inc.™ All rights reserved.**
