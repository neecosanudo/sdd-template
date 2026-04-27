# Specification: Cross-Project Learning

## Purpose
Define the LEARNINGS_MAP.md structure for capturing insights from other projects that can strengthen this template.

## Requirements

### Requirement: LEARNINGS_MAP File Location

A `LEARNINGS_MAP.md` file MUST exist in `.atl/meta/`.

#### Scenario: User wants to capture a learning from another project

- GIVEN a user has identified a pattern in another project
- WHEN they navigate to the template's meta directory
- THEN they SHALL find `.atl/meta/LEARNINGS_MAP.md`
- AND the `.atl/meta/` directory SHALL be created if it does not exist

### Requirement: Learning Entry Structure

Each learning entry MUST map: Learning, Source Project, Files, Template Impact.

#### Scenario: User adds a new learning

- GIVEN a user wants to record a learning
- WHEN they add an entry to LEARNINGS_MAP.md
- THEN the entry SHALL have a unique ID or sequential number
- AND it SHALL have a "Learning" field describing the insight
- AND it SHALL have a "Source Project" field naming the originating project
- AND it SHALL have a "Files" field listing relevant files in the source project
- AND it SHALL have a "Template Impact" field explaining how it strengthened the template

### Requirement: Scanning Instructions

LEARNINGS_MAP.md MUST include instructions for scanning other projects.

#### Scenario: User wants to scan their notebook for learnings

- GIVEN a user has multiple projects on their machine
- WHEN they read the "How to Update" section of LEARNINGS_MAP.md
- THEN they SHALL find instructions to scan directories for `.md` files
- AND it SHALL suggest looking for files that map "where info is" in projects
- AND it SHALL explain how to merge findings into the template

### Requirement: Learning Lifecycle

LEARNINGS_MAP.md MUST document the lifecycle of a learning.

#### Scenario: User wants to know when a learning is "done"

- GIVEN a learning has been recorded
- WHEN the user reads the lifecycle section
- THEN they SHALL see statuses: `identified` → `evaluated` → `integrated` → `verified`
- AND each status SHALL have a brief definition

## References
- `.atl/meta/LEARNINGS_MAP.md` — learning tracker
