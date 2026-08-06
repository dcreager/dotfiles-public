---
name: grill-plan
description: >
  Collaboratively pressure-tests and refines feature, implementation, migration,
  refactoring, and technical design plans. Use when drafting or improving a plan,
  resolving requirements, design alternatives, dependencies, sequencing, or open
  decisions, or when the user asks to grill, interrogate, critique, or work
  through a proposed plan.
---

# Grill a plan

Develop a shared, detailed understanding of the plan by walking the design tree
and resolving decisions in dependency order.

1. Load the `persistent-memory` skill and locate the current feature plan at
   `~/.pi/memory/plans/<project>/<workspace>/PLAN.md`. Use an existing
   in-repository `PLAN.md` only as a legacy fallback, and ask if both locations
   contain a plan. Read the applicable project instructions and relevant source,
   documentation, and tests. Investigate questions answerable from the codebase
   instead of asking the user.

2. Identify unresolved requirements, assumptions, constraints, alternatives,
   dependencies, implementation phases, validation needs, and risks. Start with
   decisions that determine which later questions are relevant.

3. Ask exactly one substantive question at a time. For each question:
   - Explain the relevant context and why the decision matters.
   - Describe the viable options and their tradeoffs, with examples when useful.
   - Recommend an answer and briefly explain the recommendation.
   - Wait for the user's decision before moving to the next question.

4. Track each agreed decision and its implications for dependencies, phases,
   open questions, and validation. Persist changes to a workspace plan only at
   meaningful checkpoints: initial plan creation or explicitly approved
   substantial replanning. Batch related decisions rather than creating a memory
   revision for every question. Follow the persistent-memory locking and revision
   rules, and do not record unresolved assumptions as agreed decisions. If the
   user asks only to brainstorm or explicitly prohibits updates, do not modify
   the plan or memory.

5. Continue down each affected branch of the design tree, resolving prerequisite
   decisions before dependent ones, until the plan is concrete and both parties
   share the same understanding.
