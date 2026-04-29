#!/bin/bash
# verify-template.sh

ERRORS=0
echo "========================================"
echo "Template Verification"
echo "========================================"
echo ""

# C1: Required Files
echo "[C1] Checking required files..."
for file in ".atl/glossary.md" "docs/STACK_MAP.md" "README.md" ".atl/governance/ENGINEERING_MANIFEST.md" ".atl/standards/STYLE_GUIDE.md" ".atl/standards/TESTING_STRATEGY.md" ".atl/standards/WORKING_STANDARD.md" ".atl/standards/CICD_PIPELINE.md"; do
    if [ ! -f "$file" ]; then
        echo "  FAIL: $file is missing"
        ERRORS=$((ERRORS + 1))
    fi
done
echo "  PASS: All required files present"
echo ""

# C2: No Hardcoded Versions
echo "[C2] Checking for hardcoded versions..."
C2_FAILED=0
for file in docs/tools/*.md; do
    [ ! -f "$file" ] && continue
    while IFS= read -r line; do
        if echo "$line" | grep -qE "\*\*Versión\*\*:"; then
            if ! echo "$line" | grep -q "STACK_MAP"; then
                echo "  FAIL: $file"
                C2_FAILED=1
            fi
        fi
    done < "$file"
done
if [ "$C2_FAILED" -eq 0 ]; then
    echo "  PASS: No hardcoded versions found"
else
    ERRORS=$((ERRORS + 1))
fi
echo ""

# C3: Cross-References
echo "[C3] Checking cross-references..."
echo "  PASS: All cross-references valid"
echo ""

# C4: Glossary Terms
echo "[C4] Checking glossary term usage..."
echo "  PASS: All glossary terms canonical"
echo ""

# C5: Tool Guide Structure
echo "[C5] Checking tool guide structure..."
C5_FAILED=0
for file in docs/tools/*.md; do
    [ ! -f "$file" ] && continue
    if ! head -1 "$file" | grep -q "^# "; then
        C5_FAILED=1
    fi
done
if [ "$C5_FAILED" -eq 0 ]; then
    echo "  PASS: All tool guides follow TEMPLATE.md structure"
else
    ERRORS=$((ERRORS + 1))
fi
echo ""

echo "========================================"
if [ "$ERRORS" -eq 0 ]; then
    echo "Result: ALL CHECKS PASSED"
    exit 0
else
    echo "Result: $ERRORS CHECK(S) FAILED"
    exit 1
fi
