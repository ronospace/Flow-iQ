# Flow iQ Compliance Documentation

© 2025 ZyraFlow Inc.™ All rights reserved.

---

## Overview

This directory contains compliance checklists and regulatory documentation for each Flow iQ release. These documents ensure adherence to App Store guidelines, medical compliance standards, and privacy regulations.

## Directory Structure

```
compliance/
├── README.md                          # This file
├── v2.0.3/                           # Version-specific compliance
│   ├── Flow-iQ-Compliance-Checklist-v2.0.3.pdf
│   └── compliance-checklist-v2.0.3.md
├── v2.1.0/                           # Future releases
└── ...
```

## Generating Compliance PDFs

For each new release, generate a compliance checklist PDF:

```bash
# Generate for current version (from pubspec.yaml)
./scripts/generate_compliance_pdf.sh

# Generate for specific version
./scripts/generate_compliance_pdf.sh 2.0.3
```

### Prerequisites

Install required tools:

```bash
# Install pandoc (required)
brew install pandoc

# Install wkhtmltopdf (optional, for better PDFs)
brew install --cask wkhtmltopdf
```

## Release Process

### 1. Before Each Release

- [ ] Update `FINAL_PRE_SUBMISSION_CHECKLIST.md` with current version info
- [ ] Complete all checklist items
- [ ] Document any known issues or limitations
- [ ] Update copyright year if needed

### 2. Generate Compliance PDF

```bash
./scripts/generate_compliance_pdf.sh
```

This creates:
- `compliance/v{VERSION}/Flow-iQ-Compliance-Checklist-v{VERSION}.pdf`
- `compliance/v{VERSION}/compliance-checklist-v{VERSION}.md`

### 3. Review and Commit

```bash
# Review generated PDF
open compliance/v2.0.3/Flow-iQ-Compliance-Checklist-v2.0.3.pdf

# Commit to repository
git add compliance/
git commit -m "Add compliance checklist for v2.0.3"
```

### 4. Tag Release

```bash
git tag -a v2.0.3 -m "Release v2.0.3 - App Store submission"
git push origin v2.0.3
git push origin main
```

## Compliance Checklist Items

Each release checklist includes verification of:

### Technical Compliance
- ✅ Release build configuration
- ✅ No debug banners or artifacts
- ✅ HTTPS enforcement
- ✅ SDK versions up to date
- ✅ Proper code signing

### Privacy & Security
- ✅ Privacy policy accessible
- ✅ HealthKit disclosure
- ✅ Data encryption
- ✅ Account deletion function
- ✅ HIPAA-ready infrastructure

### Content Compliance
- ✅ App description plain text (no emoji in body)
- ✅ Medical disclaimer visible
- ✅ Non-diagnostic positioning
- ✅ Citation sources included
- ✅ Age-appropriate content

### Functional Testing
- ✅ Demo account working
- ✅ All features tested
- ✅ Offline functionality
- ✅ Multi-device compatibility
- ✅ No crashes or critical bugs

## App Store Submission

Each compliance PDF should be referenced during App Store submission:

1. **App Review Notes**: Include reference to compliance checklist
2. **Demo Account**: Credentials documented in checklist
3. **Medical Claims**: All claims backed by citations in compliance docs
4. **Privacy Policy**: URL verified and accessible

## Version History

### v2.0.3 (November 1, 2025)
- Initial compliance checklist system
- Fixed app crash issues
- Enhanced Provider dependency management
- Medical compliance improvements
- App Store rejection resolution

### v2.1.0 (Upcoming)
- Wearable device integration
- Advanced data visualization
- Enhanced AI transparency
- Offline-first architecture

## Related Documentation

- **App Store Metadata**: `docs/APP_STORE_METADATA.md`
- **Screenshot Guide**: `docs/SCREENSHOT_GUIDE.md`
- **Clinical Compliance**: `docs/CLINICAL_COMPLIANCE_ROADMAP.md`
- **Medical Sources**: `docs/MEDICAL_SOURCES.md`
- **Privacy Policy**: https://ronospace.github.io/Flow-iQ/privacy-policy.html

## Contact

For compliance-related inquiries:

- **Email**: compliance@zyraflow.com
- **Support**: support@zyraflow.com
- **Legal**: legal@zyraflow.com

---

## Regulatory Framework

Flow iQ complies with:

- **Apple App Store Guidelines**: Section 2.1, 2.3, 5.1
- **Health App Requirements**: Medical device positioning, citations
- **Privacy Regulations**: GDPR, CCPA, HIPAA-ready
- **Medical Standards**: ACOG, NIH, NEJM guidelines referenced

## Audit Trail

Each compliance PDF serves as:
- Documentation for regulatory review
- Evidence of due diligence
- Historical record of compliance efforts
- Reference for future submissions

## Best Practices

1. **Update Before Each Release**: Never reuse old compliance checklists
2. **Complete All Items**: Don't skip manual testing sections
3. **Document Issues**: Note any known limitations or workarounds
4. **Version Control**: Keep all compliance docs in git
5. **Review History**: Learn from previous submissions

---

**Maintained by:** ZyraFlow Inc.™ Compliance Team  
**Last Updated:** November 1, 2025  
**© 2025 ZyraFlow Inc.™ All rights reserved.**
