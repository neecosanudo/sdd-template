# Tool Expansion Workflow

Agent workflow for analyzing user projects and expanding template coverage with new tool guides.

---

## 1. Detect Stack from User Project

When user provides `go.mod`, `package.json`, or describes their stack:

```
a) Parse dependency files (go.mod, package.json, requirements.txt)
b) Identify tool categories: backend, frontend, database, devops, auth, testing
c) List detected tools with versions from dependency files
d) Cross-reference with existing docs/tools/*.md guides
```

**Output**: List of detected tools, marked as "mapped" (guide exists) or "unmapped" (needs new guide).

---

## 2. Map Tools to Existing Guides

For each detected tool:

| Status | Action |
|--------|--------|
| **Mapped** | Confirm guide exists, verify it covers the user's use case |
| **Unmapped** | Flag for new guide creation |
| **Partial** | Note gaps in existing guide |

Check against `docs/tools/`:
- go.md, gorm.md, postgresql.md, sqlite.md
- docker.md, sveltekit.md, react.md, tailwindcss.md
- swagger-openapi.md, jwt-auth.md, testing.md

---

## 3. Create TEMPLATE.md-Based Guide for Unmapped Tools

For each unmapped tool:

```
a) Copy docs/tools/TEMPLATE.md as docs/tools/<tool-name>.md
b) Fill sections using:
   - Tool's official documentation
   - User's described use case
   - Version from dependency file or STACK_MAP.md
c) Ensure cross-references to related tools
d) Add to STACK_MAP.md if tool is significant
```

**Output**: New `docs/tools/<tool>.md` ready to fill (see `docs/tools/TEMPLATE.md` for structure).

---

## 4. Update STACK_MAP.md

If new tool is significant:

```
a) Add entry to §1 Stack Principal table
b) Add version and notes
c) Document compatibility with existing stack
d) Add to §7 Referencias Cruzadas
e) Update matrix if compatibility changes
```

**Rule**: Only significant tools (>1 dependency) get STACK_MAP.md entries. Small utilities can stay in tool guide only.

---

## 5. Verify Cross-References

After creating new guide:

```
a) Run verify-template.sh (C3 check)
b) Ensure all [text](path.md) links resolve
c) Add references to related existing guides
d) Add new guide reference to related guides
```

**Example**: Adding `bun.md` → reference it from `docker.md` (frontend builds), update `react.md` if Bun replaces npm.

---

## 6. Document Agent Decision

After expansion:

```
a) Update openspec/changes/<change>/tasks.md with completed expansion tasks
b) Note: new tool added, guide created, STACK_MAP.md updated
c) Summarize for user: "Added Bun guide (docs/tools/bun.md), updated STACK_MAP.md"

---

## Examples

### Example: User has Bun in project

```
1. Detect: bun@1.0.0 in package.json
2. Map: No existing bun.md guide
3. Create: docs/tools/bun.md from TEMPLATE.md
4. Update: STACK_MAP.md §1 (Frontend Bun), §7 references
5. Verify: Run verify-template.sh
6. Document: "Created docs/tools/bun.md for Bun runtime"
```

### Example: User has Redis

```
1. Detect: go-redis/redis in go.mod
2. Map: No existing guide (cache is not covered)
3. Create: docs/tools/redis.md from TEMPLATE.md
4. Update: STACK_MAP.md, reference from gorm.md (caching layer)
5. Verify: Run verify-template.sh
6. Document: "Created docs/tools/redis.md for Redis caching"
```

---

*This workflow ensures the template grows organically based on real user needs while maintaining consistency.*