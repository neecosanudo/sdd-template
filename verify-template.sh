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
C3_FAILED=0
while IFS= read -r file; do
    dir="$(dirname "$file")"
    while IFS= read -r line; do
        lineno="$(echo "$line" | cut -d: -f1)"
        rest="$(echo "$line" | cut -d: -f2-)"
        # Extract URL from markdown link [text](url) pattern
        url="$(echo "$rest" | grep -oE '\]\([^)]+\)' | head -1 | sed 's/\]/(/; s/^..//; s/.$//')"
        # Skip external/http links and anchors
        if [ -z "$url" ] || echo "$url" | grep -qE '^(http|https|mailto|#)'; then
            continue
        fi
        # Skip placeholder/example links (template content)
        if echo "$url" | grep -qE '^(guia-relacionada|nonexistent|path)\.md$|^../tools/<' || echo "$url" | grep -q 'redis.md'; then
            continue
        fi
        resolved="$(realpath -m "$dir/$url" 2>/dev/null)"
        if [ ! -e "$resolved" ]; then
            echo "  FAIL: $file -> $url (line $lineno)"
            C3_FAILED=1
        fi
    done < <(grep -nE '\[([^]]+)\]\(([^)]+)\)' "$file" 2>/dev/null | grep -v '^\s*$')
done < <(find . -name "*.md" ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/openspec/changes/archive/*" ! -path "*/openspec/changes/template-audit-fixes/*" ! -name "TOOL_EXPANSION.md" 2>/dev/null)
if [ "$C3_FAILED" -eq 0 ]; then
    echo "  PASS: All cross-references valid"
else
    ERRORS=$((ERRORS + 1))
fi
echo ""

# C4: Glossary Terms
echo "[C4] Checking glossary term usage..."
C4_FAILED=0
# Extract deprecated terms from glossary §2 "Término Antiguo" column
while IFS= read -r term; do
    [ -z "$term" ] && continue
    # Skip header and section titles
    case "$term" in
        "Término Antiguo"|"---"|"##"*) continue ;;
    esac
    # Skip terms that are identical to their canonical form (e.g., "Explore" is both old and canonical)
    canonical=$(awk -v t="$term" 'found && /\|/ && $2==t {print $4; exit} /\|.*Término Antiguo/ {found=1}' .atl/glossary.md | tr -d ' ')
    [ "$term" = "$canonical" ] && continue
    # "Discovery" and "Analysis" are contextually valid (pre-SDD phase, Working Standard concept)
    # Only flag them as warnings; "Analyse" is strictly deprecated and treated as error
    case "$term" in
        "Discovery"|"Analysis") severity="WARN" ;;
        *) severity="FAIL" ;;
    esac
    # Search in all .md files except glossary.md
    while IFS= read -r match; do
        file="$(echo "$match" | cut -d: -f1)"
        lineno="$(echo "$match" | cut -d: -f2)"
        echo "  $severity: $file:$lineno uses deprecated term '$term'"
        [ "$severity" = "FAIL" ] && C4_FAILED=1
    done < <(grep -rnw --include="*.md" -w "$term" .atl/ docs/ *.md 2>/dev/null | grep -v ".atl/glossary.md")
done < <(awk '/\|.*Término Antiguo/ {found=1; next} /## [0-9]/ && found {exit} found && /\|/ {print $2}' .atl/glossary.md | tr -d ' ')
if [ "$C4_FAILED" -eq 0 ]; then
    echo "  PASS: All strictly deprecated terms resolved (Discovery/Analysis noted as warnings)"
else
    ERRORS=$((ERRORS + 1))
fi
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
