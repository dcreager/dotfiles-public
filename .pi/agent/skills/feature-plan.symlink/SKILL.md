---
name: feature-plan
description: >
  Manages workspace-scoped feature implementation and handoff plans. Use before
  substantive agent-led feature planning or implementation, and when creating,
  locating, reading, reviewing, validating, resuming, checkpointing, replanning,
  or archiving a feature plan. Does not start implementation without authorization.
---

# Manage a workspace-scoped feature plan

Feature plans are the ground truth for active implementation phases and handoff
between sequential agents. Store them in the private memory vault, outside project
implementation diffs.

## Decide whether a plan is appropriate

Assume that a task does not use a workspace plan unless the user's instructions
clearly indicate that an agent will lead the substantive implementation of a
feature. Do not create one merely because the user asks questions, requests
diagnosis or review, or authorizes an isolated implementation task without
establishing an agent-led feature workflow.

Do not infer that a worktree is human-centric. When the user explicitly identifies
one as human-centric, record confirmed findings, decisions, validation results,
and revision anchors as factual notes rather than phases for an agent to execute.
Do not create a phased implementation plan there merely because the user asks
questions.

Prefer a dedicated feature workspace whose name aligns with its feature bookmark.
Do not rename or otherwise modify an existing workspace solely to enforce that
preference.

## Find the current plan

1. Load the `persistent-memory` skill for the vault's generic recall and mutation
   protocol, then read `~/.pi/memory/INDEX.md`.
2. Identify the stable logical project through `projects/INDEX.md` and its aliases;
   never invent a path-based project identity.
3. Determine the current Jujutsu workspace, for example:

   ```sh
   jj log --ignore-working-copy -r @ --no-graph \
     -T 'working_copies.map(|workspace| workspace.name()).join("\n") ++ "\n"'
   ```

4. Look for the plan at:

   ```text
   ~/.pi/memory/plans/<project>/<workspace>/PLAN.md
   ```

5. If no external plan exists, use an existing project-root `PLAN.md` only as a
   legacy fallback. Do not create new plans in project working copies or migrate
   an existing plan merely to adopt the external layout. If both locations contain
   a plan, ask which is authoritative.

If project identity, workspace, or feature bookmark is ambiguous, determine it or
ask instead of guessing. Plan discovery and inspection are read-only and require
neither a vault lock nor a new revision.

If the user asks only to read or review and no plan exists, report that and stop.
When the user's instructions clearly establish a new agent-led feature workflow,
develop an approved plan before editing source; load `grill-plan` when design
decisions need to be drafted or pressure-tested.

## Required plan content

A plan must contain enough context for another agent to resume safely:

- the problem, scope, agreed design, and meaningful rejected alternatives;
- dependencies, assumptions, risks, unresolved decisions, and relevant source or
  documentation pointers;
- ordered, self-contained implementation phases with clear completion markers;
- validation requirements and handoff instructions; and
- stable Jujutsu change IDs and exact commit IDs for completed phases.

Each implementation phase belongs in its own project Jujutsu revision.
Documentation and tests are cross-cutting requirements, not separate phases. The
full required test suite must pass at the end of every phase.

If a later phase is required for ultimately correct behavior, do not comment out
or ignore a currently failing test. Update its expectation to the currently
observed behavior and add a clear `TODO` describing the expected correct behavior.

## Verify rather than assume

Read the complete plan, applicable `AGENTS.md`, relevant project-library notes,
and only the source, tests, documentation, benchmarks, or design references needed
to understand the active phase and its prerequisites.

Verify claimed completed phases against implementation, tests, and Jujutsu
history. Inspect recorded change IDs, commit IDs, revision descriptions, and
`jj diff --git` output when useful. Rebasing may change a commit ID without
invalidating its stable change ID, but report meaningful discrepancies.

Summarize:

- the feature goal and agreed design;
- completed, active, and remaining phases;
- dependencies, limitations, risks, and unresolved decisions;
- discrepancies between the plan and actual code or tests; and
- the next actionable phase or requested investigation.

## Respect the requested mode

**Read, inspect, catch up, or review:** Stop after the requested summary or
critique. Do not implement, modify the plan, or fix discovered problems.

**Resume or continue:** Verify and summarize first. State the exact next phase and
proposed scope, then obtain confirmation unless the user already authorized that
precise work.

**Implement an approved phase:** Before editing source, create a new project
revision as required by global instructions. Do not skip incomplete prerequisites
or broaden the agreed phase silently.

If a failure or discovery appears to require a substantial change to the agreed
architecture, scope, sequencing, or approach, stop. Explain the evidence and
tradeoffs, load `grill-plan` to work through the alternatives, and wait for user
approval before replanning or proceeding.

## Checkpoint meaningful changes only

Change a feature plan only for:

1. Initial creation of an approved plan.
2. Successful completion of an implementation phase and its required full test
   suite.
3. Substantial replanning explicitly approved by the user.
4. Archival explicitly requested by the user.

Do not create plan revisions for incidental progress or leave a shared vault
revision open during project implementation.

Every plan mutation follows the generic exclusive-lock and Jujutsu transaction in
the `persistent-memory` skill. Its revision description must be:

```text
[π] <feature-branch-or-bookmark>: <specific plan update>
```

If the branch or bookmark is ambiguous, determine it or ask before writing.

After a phase succeeds, snapshot its project revision and obtain its identifiers:

```sh
jj log --ignore-working-copy -r @ --no-graph \
  -T 'change_id ++ "\n" ++ commit_id ++ "\n"'
```

Then, in a separate new vault revision, record both identifiers and mark the phase
complete. Never mix plan checkpoint edits into the project's implementation
revision.

Archive a plan only on explicit request, normally during feature-workspace
cleanup, at:

```text
~/.pi/memory/archive/plans/<project>/<workspace>/PLAN.md
```

Do not infer that completed phases or an upstream merge authorize archival or
workspace removal.
