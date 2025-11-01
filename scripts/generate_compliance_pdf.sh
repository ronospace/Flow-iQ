#!/bin/bash
#
# Generate Compliance Checklist PDF for Flow iQ Releases
# © 2025 ZyraFlow Inc.™ All rights reserved.
#
# Usage: ./scripts/generate_compliance_pdf.sh [version]
# Example: ./scripts/generate_compliance_pdf.sh 2.0.3
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Version parameter
VERSION=${1:-$(grep 'version:' pubspec.yaml | head -n 1 | awk '{print $2}')}
VERSION_CLEAN=$(echo $VERSION | sed 's/+.*//')

echo -e "${GREEN}Flow iQ Compliance Checklist PDF Generator${NC}"
echo -e "${GREEN}© 2025 ZyraFlow Inc.™ All rights reserved.${NC}"
echo ""
echo "Version: $VERSION_CLEAN"
echo ""

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo -e "${RED}Error: pandoc is not installed${NC}"
    echo "Install with: brew install pandoc"
    echo "Or visit: https://pandoc.org/installing.html"
    exit 1
fi

# Check if wkhtmltopdf is installed (for better PDF generation)
if ! command -v wkhtmltopdf &> /dev/null; then
    echo -e "${YELLOW}Warning: wkhtmltopdf not installed. Using basic PDF engine.${NC}"
    echo "For better PDFs, install with: brew install --cask wkhtmltopdf"
    PDF_ENGINE=""
else
    PDF_ENGINE="--pdf-engine=wkhtmltopdf"
fi

# Create compliance directory for this version
COMPLIANCE_DIR="compliance/v$VERSION_CLEAN"
mkdir -p "$COMPLIANCE_DIR"

# Copy checklist markdown
cp FINAL_PRE_SUBMISSION_CHECKLIST.md "$COMPLIANCE_DIR/compliance-checklist-v$VERSION_CLEAN.md"

# Add branding header to markdown
cat > "$COMPLIANCE_DIR/temp_header.md" << EOF
---
title: "Flow iQ Compliance Checklist"
subtitle: "Version $VERSION_CLEAN"
author: "ZyraFlow Inc.™"
date: "$(date '+%B %d, %Y')"
footer: "© 2025 ZyraFlow Inc.™ All rights reserved."
geometry: margin=1in
fontsize: 11pt
---

EOF

# Combine header with checklist
cat "$COMPLIANCE_DIR/temp_header.md" "$COMPLIANCE_DIR/compliance-checklist-v$VERSION_CLEAN.md" > "$COMPLIANCE_DIR/temp_combined.md"

# Generate PDF
echo -e "${GREEN}Generating PDF...${NC}"
pandoc "$COMPLIANCE_DIR/temp_combined.md" \
    -o "$COMPLIANCE_DIR/Flow-iQ-Compliance-Checklist-v$VERSION_CLEAN.pdf" \
    $PDF_ENGINE \
    --toc \
    --toc-depth=2 \
    -V colorlinks=true \
    -V linkcolor=blue \
    -V urlcolor=blue \
    -V toccolor=gray

# Cleanup temp files
rm -f "$COMPLIANCE_DIR/temp_header.md" "$COMPLIANCE_DIR/temp_combined.md"

echo -e "${GREEN}✅ PDF generated successfully!${NC}"
echo ""
echo "Location: $COMPLIANCE_DIR/Flow-iQ-Compliance-Checklist-v$VERSION_CLEAN.pdf"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Review the PDF for accuracy"
echo "2. Commit to repository: git add compliance/"
echo "3. Tag release: git tag -a v$VERSION_CLEAN -m 'Release v$VERSION_CLEAN'"
echo ""
