# Delta for Cross-Project Learning

## MODIFIED Requirements

### Requirement: Learning Entry Structure

Each learning entry MUST map: ID, Learning, Source Project, Source Files (full paths), Template Target, and Status. All entries MUST default to Status `identified` when first added. Source Files MUST be full paths relative to the source project root.

(Previously: fields were Learning, Source Project, Files, and Template Impact — without full paths or Status field.)

#### Scenario: Orchestrator adds a learning from exploration

- GIVEN an exploration has identified a learning in another project
- WHEN the orchestrator adds the entry to LEARNINGS_MAP.md
- THEN the entry SHALL have a unique ID in format `LEARN-NNNN`
- AND it SHALL have a "Learning" field describing the insight
- AND it SHALL have a "Source Project" field naming the originating project
- AND it SHALL have a "Source Files" field with full paths to source files in the originating project
- AND it SHALL have a "Template Target" field specifying which template file or directory receives the integration
- AND it SHALL have a "Status" field set to `identified`

## ADDED Requirements

### Requirement: Real Entries Presence

LEARNINGS_MAP.md MUST contain 18 real entries sourced from the `sdd/learnings-map-update/explore` discovery, spanning the initial three projects explored (personal-web-page, components-designer, godot-tetris-minimalist). Each entry MUST include full source file paths and Status set to `identified`.

#### Scenario: Agent reads LEARNINGS_MAP.md after initialization

- GIVEN the template has been initialized with SDD
- WHEN an agent reads `.atl/meta/LEARNINGS_MAP.md`
- THEN it SHALL find 18 entries (LEARN-0001 through LEARN-0018)
- AND every entry SHALL have non-empty values for all six fields
- AND all 18 Status fields SHALL read `identified`

#### Scenario: Entry is missing a required field

- GIVEN an entry in LEARNINGS_MAP.md
- WHEN that entry has an empty or missing field for Source Files or Template Target
- THEN the entry SHALL be considered incomplete
- AND the orchestrator SHALL NOT mark it ready for integration

### Requirement: Orchestrator Maintenance

The orchestrator agent SHALL maintain LEARNINGS_MAP.md as the single source of truth for cross-project learnings. The user SHALL read the file and command integration by saying `integrate LEARN-XXXX`.

#### Scenario: User reviews learnings after exploration

- GIVEN the orchestrator has populated LEARNINGS_MAP.md with 18 identified entries
- WHEN the user opens `.atl/meta/LEARNINGS_MAP.md`
- THEN they SHALL see a table with all entries, source projects, and file paths
- AND they SHALL see a "How to Use" section explaining the `integrate LEARN-XXXX` command
- AND the instructions SHALL state that the user decides which learnings to integrate

### Requirement: Integration Workflow

When a user says `integrate LEARN-XXXX`, the system MUST locate the corresponding entry, read the source files from the referenced project, and apply the learning to the template target path specified in the entry. After successful integration, Status SHALL advance to `integrated`.

#### Scenario: User commands integration of a specific learning

- GIVEN the user has reviewed LEARNINGS_MAP.md
- WHEN they say "integrate LEARN-0001"
- THEN the agent SHALL locate the entry with ID LEARN-0001
- AND the agent SHALL read the source files from the Source Project
- AND the agent SHALL apply the pattern or learning to the Template Target path
- AND the agent SHALL update the entry Status to `integrated`

#### Scenario: User commands integration for an entry with incomplete paths

- GIVEN a LEARN-XXXX entry has missing or invalid Source Files paths
- WHEN the user says "integrate LEARN-XXXX"
- THEN the agent SHALL report the missing paths
- AND the agent SHALL NOT attempt integration
- AND the entry Status SHALL remain `identified`
