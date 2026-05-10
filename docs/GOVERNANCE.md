# GOVERNANCE.md

Consolidated governance for new projects.

## 1. Project Language

**Spanish (AR)**. All documentation, commits, and comments in Spanish (Argentina). Technical terms (backend, Golang, Docker, PostgreSQL) remain in English.

## 2. Branching Strategy

**GitFlow Lightweight** — two main branches:

| Branch | Purpose | Protection |
|-------|---------|------------|
| `main` | Production-ready | Protected — PR required |
| `dev` | Integration for development | Protected — PR required |

**Prefixes:**
- `feature/*` — new functionality
- `fix/*` — bug fixes
- `hotfix/*` — urgent production fixes
- `release/*` — release preparation

**Naming:** `<type>/<ticket-id>-<short-description>`

## 3. Workflow

```bash
# 1. Start from dev
git checkout dev && git pull origin dev
git checkout -b feature/42-user-auth

# 2. Make commits following gitmoji convention
git commit -m ":sparkles: feat(auth): agregar autenticación"

# 3. Rebase regularly
git fetch origin && git rebase origin/dev

# 4. PR to dev
gh pr create --base dev --head feature/42-user-auth --title "feat: nueva feature"

# 5. Merge dev → main for release
gh pr create --base main --head dev --title "Release: vX.Y.Z"
git tag vX.Y.Z && git push origin vX.Y.Z
```

## 4. Commit Conventions

**Format:** `:emoji: type(scope): description`

| Type | Emoji | Description |
|------|-------|-------------|
| `feat` | :sparkles: | Nueva funcionalidad |
| `fix` | :bug: | Corrección de bug |
| `docs` | :memo: | Documentación |
| `style` | :art: | Formateo, espacios |
| `refactor` | :recycle: | Refactorización sin cambio de comportamiento |
| `test` | :white_check_mark: | Tests |
| `chore` | :construction: | Configuración, build, deps |
| `security` | :lock: | Seguridad |

**Rules:**
- Atomicity: one commit = one task
- No AI attribution (prohibido "Co-Authored-By")
- Descriptions in Spanish (AR)

## 5. Versioning

**SemVer 2.0.0:** `MAJOR.MINOR.PATCH`

- **MAJOR:** Breaking API changes
- **MINOR:** New functionality (backward compatible)
- **PATCH:** Bug fixes (backward compatible)

**Release process:**
1. PR to `main` via merge
2. Tag with version: `git tag -a v1.2.3 -m "Release v1.2.3"`
3. Push tag → triggers release pipeline

## 6. Git Hooks

Local protection via `.githooks/`:

```bash
git config core.hooksPath .githooks
```

- `commit-msg` — enforces gitmoji conventional format

## 7. GitHub CLI Commands

**PR creation:**
```bash
gh pr create --title "feat: titulo" --body "Descripcion"
gh pr status
gh pr review feature/branch --approve
```

**Merge strategy (squash):**
```bash
gh api repos/:owner/:repo --method PATCH \
  --field allow_squash_merge=true \
  --field allow_merge_commit=false \
  --field allow_rebase_merge=false
```

## 8. ADR System

Architectural decisions documented in `docs/decisions/NNNN-name.md`. See `docs/decisions/` for existing ADRs.

---

*Replaces: .atl/governance/COMMIT_CONVENTIONS.md, .atl/governance/CONTRIBUTING.md, .atl/governance/VERSIONING.md, .atl/governance/ENGINEERING_MANIFEST.md, .atl/decisions/DECISION_LOG.md, .atl/decisions/README.md, CONTRIBUTING.md*
