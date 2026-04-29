# Tasks: Template Glossary

## Phase 1: Create Glossary (Foundation)

- [ ] 1.1 Create `.atl/glossary.md` with YAML frontmatter and H1 heading "Glosario del Template"
- [ ] 1.2 Add Section 1 — "SDD Phases (Canonical)" with table: Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive, each with name, description, agent, output
- [ ] 1.3 Add Section 2 — "Terminology Mapping" with table normalizing Discovery/Analysis/Explore/Analyse to canonical terms, plus Batch-Verify definition
- [ ] 1.4 Add Section 3 — "Decision Recording" with comparison table: Bitacora (informal) → DECISION_LOG (architectural) → ADR (structural), including promotion path and format requirements
- [ ] 1.5 Add Section 4 — "Language Conventions" stating: Documentation Spanish (AR), Code English, comments explain WHY; explicitly override navigation.spec.md language claim
- [ ] 1.6 Add Section 5 — "Key Template Terms" defining: Pattern, Standard, Governance, Rule, Prototype vs Production, Migration terms
- [ ] 1.7 Add cross-reference footer linking to ENGINEERING_MANIFEST.md, WORKING_STANDARD.md, AGENT_BEHAVIOR.md

## Phase 2: Rescue and Remove (Security Migration)

- [ ] 2.1 Read `.atl/patterns/agnostic-fundamentals.md` § Security by Design (lines 32-47) and extract Least Privilege, Input Validation, Security-First Refactoring content
- [ ] 2.2 Insert Rule #11 "Security by Design" into `.atl/governance/ENGINEERING_MANIFEST.md` after line 90 (after Rule #10), with three subsections: 11.1 Least Privilege, 11.2 Input Validation (Never Trust), 11.3 Security-First Refactoring
- [ ] 2.3 Delete `.atl/patterns/agnostic-fundamentals.md` via `git rm`
- [ ] 2.4 Update `README.md` — verify no reference to `.atl/patterns/agnostic-fundamentals.md` exists (confirm clean)

## Phase 3: Update Cross-References (Wiring)

- [ ] 3.1 Update `README.md` SDD Cycle section (lines 142-161): keep one-line cycle summary, replace Batch-Verify and Iteration details with reference to `.atl/glossary.md`
- [ ] 3.2 Update `.atl/standards/WORKING_STANDARD.md`: replace inline SDD Phase Mapping table (lines 270-293) with link to `.atl/glossary.md`; normalize "Analysis" → "Explore" in title and Phase 1 heading
- [ ] 3.3 Update `.atl/agent/AGENT_BEHAVIOR.md`: add `.atl/glossary.md` to trigger-matching table (Section 2.2); normalize "Analyse" → "Explore" in migration process table (lines 79-86)
- [ ] 3.4 Run `rg "agnostic-fundamentals"` across repo; update any remaining references except archived files in `openspec/changes/archive/`

## Phase 4: Verification

- [ ] 4.1 Verify `.atl/glossary.md` contains all 5 sections: SDD Phases, Terminology Mapping, Decision Recording, Language Conventions, Key Template Terms
- [ ] 4.2 Verify no broken references: `rg "WORKING_STANDARD|glossary|ENGINEERING_MANIFEST"` shows valid paths
- [ ] 4.3 Verify `.atl/governance/ENGINEERING_MANIFEST.md` has Rule #11 with three subsections (11.1, 11.2, 11.3)
- [ ] 4.4 Verify `.atl/patterns/agnostic-fundamentals.md` does not exist; verify no inline SDD cycle blocks remain outside glossary via `rg "Explore\|Analysis\|Analyse\|Propose\|Spec\|Verify" .atl/`
