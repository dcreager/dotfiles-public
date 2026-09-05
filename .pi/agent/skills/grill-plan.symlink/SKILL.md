---
name: grill-plan
description: >
  Collaboratively pressure-tests and refines feature, implementation, migration,
  refactoring, and technical design plans. Use when drafting or improving a plan,
  resolving requirements, design alternatives, dependencies, sequencing, or open
  decisions, or when the user asks to grill, interrogate, critique, or work through
  a proposed plan.
---

# Grill a plan

Develop a shared, detailed understanding by walking the design tree and resolving
decisions in dependency order.

1. Load the `feature-plan` skill and use its workflow to locate an existing plan or
   determine whether a new workspace-scoped plan is appropriate. Read applicable
   project instructions and only the source, documentation, tests, and library
   notes relevant to the design. Investigate questions answerable from the
   codebase instead of asking the user.

2. Identify unresolved requirements, assumptions, constraints, alternatives,
   dependencies, implementation phases, validation needs, and risks. Begin with
   decisions that determine which later questions remain relevant.

3. Ask exactly one substantive question at a time. For each question:
   - Explain the context and why the decision matters.
   - Describe viable options and tradeoffs, with examples when useful.
   - Recommend an answer and briefly justify it.
   - Wait for the user's decision before proceeding.

4. Track each agreed decision and its implications for dependencies, phases, open
   questions, and validation. Do not record unresolved assumptions as decisions.

5. Continue down every affected branch of the design tree, resolving prerequisites
   before dependent choices, until the plan is concrete and both parties share the
   same understanding.

Persist plan changes only at the meaningful checkpoints defined by the
`feature-plan` skill: initial creation or explicitly approved substantial
replanning during this workflow. Batch related decisions rather than writing a
vault revision after every question. If the user requests brainstorming only or
prohibits updates, do not modify the plan or knowledge library.
