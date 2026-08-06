---
name: feature-plan
description: >
  Reads, reviews, validates, summarizes, or resumes a workspace-scoped feature
  implementation plan. Use when the user says "read the plan", "review the
  plan", "resume the plan", "continue the plan", "catch me up", "what is the
  current phase?", or asks what a previous agent completed, what remains, or
  whether a feature plan matches the current implementation. Finds plans in
  persistent memory, supports legacy in-repository plans, and does not start
  implementing without authorization.
---

# Read, review, or resume a feature plan

Treat the current feature's plan as the implementation and handoff ground
truth. Determine whether the user wants only an investigation and summary, a
critical review, or to resume a confirmed implementation phase.

## Find the current plan

1. Load the `persistent-memory` skill and read `~/.pi/memory/INDEX.md`.
2. Identify the stable logical project from `projects/INDEX.md`, using its
   documented aliases instead of inventing a path-based project identity.
3. Determine the current Jujutsu workspace, for example:

   ```sh
   jj log --ignore-working-copy -r @ --no-graph \
     -T 'working_copies.map(|workspace| workspace.name()).join("\n") ++ "\n"'
   ```

4. Look for the feature plan at:

   ```text
   ~/.pi/memory/plans/<project>/<workspace>/PLAN.md
   ```

5. If no external plan exists, an existing `PLAN.md` at the project root is a
   legacy fallback. Do not create, move, migrate, archive, or modify either plan
   merely because the user asked to read or review it. If both locations exist,
   ask which plan is authoritative. If neither exists, explain that and ask how
   to proceed.

Plan discovery and inspection are read-only; they require neither the memory
lock nor a new memory revision.

## Verify rather than assume

Read the complete plan, applicable project `AGENTS.md` instructions, and the
existing user/project memory relevant to the feature. Follow only the source,
test, documentation, benchmark, or design references needed to understand the
current phase and its prerequisites.

Check each claimed completed phase against the actual implementation and
available tests. Inspect recorded project change IDs, commit IDs, revision
descriptions, and relevant `jj diff --git` output when useful. A changed commit
ID after rebasing does not invalidate its stable change ID, but report
meaningful discrepancies rather than silently trusting stale status markers.

Summarize:

- the feature's goal and agreed design;
- completed, active, and remaining phases;
- important dependencies, known limitations, and unresolved decisions;
- discrepancies between the plan and actual code/tests; and
- the next actionable phase or the specific investigation the user requested.

## Respect the requested mode

**Read, inspect, catch up, or review:** Stop after the requested summary or
critique. Do not implement the next phase, change the plan, fix discovered
problems, or treat a review as permission to start work. If the user wants to
pressure-test design choices, also follow the `grill-plan` skill.

**Resume or continue:** Verify and summarize first, describe the exact next
phase and proposed scope, and obtain confirmation before implementing unless the
user has already explicitly approved that precise work. Do not skip incomplete
prerequisites or broaden the agreed plan without approval.

If a failing test, unexpected result, or other discovery suggests a substantial
change to the plan, stop implementation. Explain the evidence and likely cause,
propose alternatives with their tradeoffs, and await the user's decision.

## Checkpoint only meaningful plan changes

A feature plan changes only when it is initially created, an implementation
phase finishes successfully, the user approves substantial replanning, or the
user explicitly requests archival. Each update follows the persistent-memory
skill's shared exclusive-lock and Jujutsu transaction requirements.

At the end of a completed implementation phase:

1. Finish all required documentation, tests, and validation.
2. Snapshot the phase's project Jujutsu revision.
3. Record its stable change ID and exact commit ID in the plan.
4. Mark the phase complete in one new, locked memory-vault revision.

Do not create plan revisions for incidental progress. Keep plans active until
the user explicitly requests archival, normally as part of feature-workspace
cleanup.
