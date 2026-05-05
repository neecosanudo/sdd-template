# Tasks: SDD v2.1.0 Operation Rules

## Phase 1: Core Configuration

- [ ] 1.1 Create `.atl/ENTRY.md` with 4 sections: Start Here, SDD Cycle, Rules, Patterns
- [ ] 1.2 Add links to key files in ENTRY.md (sdd-workflow.md, patterns/README.md)
- [ ] 1.3 Define execution modes in ENTRY.md (engram-only, auto, interactive)
- [ ] 1.4 Document Archive closing protocol in ENTRY.md

## Phase 2: Workflow Updates

- [ ] 2.1 Update `.atl/specs/sdd-workflow.md` — change default persistence to `engram`
- [ ] 2.2 Update `.atl/specs/sdd-workflow.md` — change default flow to `auto`
- [ ] 2.3 Add Verify automatic loop section with max 3 retries
- [ ] 2.4 Document behavior before Archive (interactive confirmation)

## Phase 3: Config & Docs

- [ ] 3.1 Update `openspec/config.yaml` — add default_mode: engram + auto
- [ ] 3.2 Add verify loop rule to config (auto retry up to 3)
- [ ] 3.3 Add TDD assertion validation rule to config
- [ ] 3.4 Update `README.md` — version bump to v2.1.0
- [ ] 3.5 Add reference to `.atl/ENTRY.md` in README.md

## Phase 4: Document Rewrite

- [ ] 4.1 Rewrite `.atl/agent/AGENT_BEHAVIOR.md` — reduce to essential rules only
- [ ] 4.2 Rewrite `.atl/governance/ENGINEERING_MANIFEST.md` — reduce to core principles
- [ ] 4.3 Rewrite `.atl/standards/WORKING_STANDARD.md` — reduce to phase flow

## Phase 5: Archive Protocol

- [ ] 5.1 Add auto-commit step to Archive workflow
- [ ] 5.2 Verify git status clean after commit
- [ ] 5.3 Generate final report (archive-report.md)