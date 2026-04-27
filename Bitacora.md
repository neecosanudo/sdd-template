# Bitacora — Conversation Log

> **Purpose**: Capture the ongoing dialogue between you (the user) and the AI agent. This is the *informal* history of your collaboration — decisions made, context shared, motivations explained.
>
> **Difference from DECISION_LOG.md**: `DECISION_LOG.md` records formal architectural decisions with full rationale and consequences. `Bitacora.md` captures the *conversation* — the back-and-forth that led to those decisions. When a Bitacora entry becomes significant enough, it SHOULD be promoted to `DECISION_LOG.md`.

## How to Use This File

### Who writes here?
- **Both user and agent**. The agent SHOULD log significant decisions after reaching agreement. The user MAY add context, corrections, or additional thoughts.

### When to write?
- After any significant technical discussion
- When requirements change or clarify
- When constraints or assumptions are revealed
- When the user says "remember this" or "note that"

### Entry format

```markdown
### YYYY-MM-DD — Brief Title

**Context:** What was the situation or question?
**Decision:** What was agreed or decided?
**Motivation:** Why was this the right choice?
**Participants:** @user, @agent (optional)
```

## Entries

### 2026-04-27 — Project Discovery and Template Initialization

**Context:** The sdd-template was positioned only as an SDD framework. The user wants it to also serve as a project discovery tool for initial client dialogue.
**Decision:** Strengthen the template with: comprehensive README (discovery + SDD), Bitacora.md for conversation logging, LEARNINGS_MAP.md for cross-project insights, and WORKING_STANDARD.md documenting the full analysis→design→tasks→apply→verify cycle.
**Motivation:** A project doesn't start with code — it starts with understanding. The template should guide users through that understanding BEFORE entering the SDD cycle. This makes the template useful from day zero.
**Participants:** @user, @agent

---

*Add new entries above this line. Keep the most recent entry at the top.*
