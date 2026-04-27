# Agent Behavior Specification

## Purpose

Defines the behavioral contract for LLM agents and automated tooling operating within this project. These rules apply to all AI assistants, sub-agents, and automation systems.

## Requirements

### Requirement: Agent Delegation Protocol

Agents MUST NOT delegate tasks unless explicitly instructed. Delegation capability SHALL be reserved for the orchestrator phase.

#### Scenario: Agent performs own work

- GIVEN an agent receives a task within its capability boundary
- WHEN the agent begins execution
- THEN the agent SHALL execute the task directly without spawning sub-agents
- AND the agent SHALL NOT call `delegate` or `task` tools

#### Scenario: Agent cannot handle task

- GIVEN an agent receives a task outside its documented scope
- WHEN execution requires capabilities the agent lacks
- THEN the agent SHALL report the gap to the orchestrator
- AND the agent SHALL NOT attempt unauthorized delegation

### Requirement: Agent Skill Usage

Agents MUST load applicable skills BEFORE performing domain-specific work. Skill triggers defined in the registry take precedence over general heuristics.

#### Scenario: Domain-specific task starts

- GIVEN an agent is about to write Go tests
- WHEN the task matches the `go-testing` skill trigger
- THEN the agent MUST load the skill BEFORE writing any code
- AND the agent SHALL apply ALL patterns from the loaded skill

#### Scenario: No matching skill exists

- GIVEN an agent receives a domain-specific task
- WHEN no skill trigger matches the current context
- THEN the agent SHALL proceed with the general AGENTS.md instructions only

### Requirement: Manual Write Review

Every file modification MUST be preceded by reading the existing file. Agents SHALL NOT overwrite files without confirming content.

#### Scenario: Modifying existing file

- GIVEN a file exists at the target path
- WHEN the agent receives a write/edit instruction
- THEN the agent MUST read the file first to understand current content
- AND the agent MUST verify the write completed correctly after execution

#### Scenario: Creating new file

- GIVEN a file does NOT exist at the target path
- WHEN the agent creates a new file
- THEN the agent MUST verify the parent directory exists
- AND the agent SHALL confirm the file was written correctly after creation

### Requirement: Delegation Restriction Scope

Sub-agents within a phase SHALL NOT re-delegate or chain delegate. Phase agents are executors, not orchestrators.

#### Scenario: SDD phase agent execution

- GIVEN an SDD phase sub-agent (sdd-spec, sdd-design, etc.) is launched
- WHEN the agent encounters work within its phase
- THEN the agent MUST execute the phase work itself
- AND the agent SHALL NOT call `delegate` or sub-launch other agents
