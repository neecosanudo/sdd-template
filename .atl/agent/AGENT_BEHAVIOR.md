# Agent Behavior Rules (AGENT_BEHAVIOR.md)

This document defines how AI agents must operate within this project. These rules establish the executor boundary and ensure consistent, safe, and auditable behavior.

## 1. Delegation Protocol

### 1.1 Executor-Only Boundary
- **No sub-agent spawning:** Agents in this project are EXECUTORS, not orchestrators. You MUST NOT call `delegate`, `task`, or any equivalent mechanism that spawns additional agents.
- **Direct execution:** All work must be performed directly by the executing agent. Do not bounce work to other agents.
- **Single-threaded execution:** Work sequentially, not in parallel, unless explicitly requested by the user.

### 1.2 Task Boundaries
- Complete assigned tasks fully before reporting completion.
- Do not partially implement and delegate remaining work.
- If a task is too large, report back with a blocker and request subdivision.

## 2. Skill Usage

### 2.1 Load-Before-Code Rule
- **Trigger detection:** When a task matches a known skill context (e.g., "Go tests" → `go-testing`), you MUST load the corresponding skill BEFORE writing any code.
- **Skill precedence:** If multiple skills match, apply them in order of specificity. When uncertain, load all potentially relevant skills.
- **Skill binding:** Once loaded, follow the skill's instructions strictly. Do not improvise outside the skill's patterns.

### 2.2 Trigger-Matching Precedence
| Trigger Context | Skill to Load |
|-----------------|---------------|
| Go tests, Bubbletea TUI testing | `go-testing` |
| Creating new AI skills | `skill-creator` |
| Spec-driven development phases | Phase-specific SDD skill |
| Discovery/analysis phase guidance | Working standard (Analysis phase in `.atl/standards/WORKING_STANDARD.md`) |

## 3. Manual Write Review

### 3.1 Read-First Requirement
- Before modifying any existing file, you MUST read its current contents.
- Before creating a new file, verify it does not already exist.
- For critical files (config.yaml, manifests), read relevant sections before making changes.

### 3.2 Verify-After Requirement
- After writing code, run relevant verification (compilation, linting, tests).
- Confirm all file operations succeeded before reporting completion.
- For file creations, verify with `git status` or `ls` that the file exists.

## 4. Delegation Restriction

### 4.1 Phase Agent Scope
- Phase agents (sdd-apply, sdd-spec, sdd-design, etc.) are EXECUTORS per the SDD phase common protocol.
- Executors do NOT delegate. They implement tasks directly.
- Only the orchestrator may spawn or coordinate sub-agents.

### 4.2 Exception Handling
- If a task requires expertise outside the agent's scope, do NOT delegate. Instead:
  1. Report the limitation to the orchestrator
  2. Request explicit permission to consult external resources
  3. Document the limitation in the task output

---

## 5. Code Migration Protocol

### 5.1 Trigger Condition

When user says **"migrate from X"**, **"bring code from Y"**, or similar — agent MUST:

1. Read `.atl/patterns/code-migration.md` BEFORE any implementation
2. Follow the 5-step migration process (Analyze → Map → Rewrite → Test First → Verify)
3. Treat React prototypes as disposable reference (extract logic, discard UI)
4. Write tests BEFORE implementation (TDD mandatory)

### 5.2 Prohibited Actions

During migration tasks:
- ❌ **No incremental migration from React prototypes** — React code is reference only, not source
- ❌ **No copy-paste + syntax adaptation** — must rewrite in destination idioms
- ❌ **No skipping tests** — TDD is mandatory for migrated business logic

### 5.3 Migration Process Reference

| Step | Action |
|------|--------|
| 1. Analyze | Separate business logic from framework plumbing |
| 2. Map | Use destination mapping tables (§3 in code-migration.md) |
| 3. Rewrite | Apply `.atl/patterns/` idioms for target stack |
| 4. Test First | Write failing tests before implementation |
| 5. Verify | Confirm behavior parity with original |

---

*This document is consumed by AI agents. Human collaborators should refer to `.atl/governance/` for project rules.*
