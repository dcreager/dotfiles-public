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

1. Read the existing plan, applicable project instructions, and relevant source
   code, documentation, and tests. If the answer to a potential question can be
   discovered from the codebase, investigate it instead of asking the user.

2. Identify unresolved requirements, assumptions, constraints, alternatives,
   dependencies, implementation phases, validation needs, and risks. Start with
   decisions that determine which later questions are relevant.

3. Ask exactly one substantive question at a time. For each question:
   - Explain the relevant context and why the decision matters.
   - Describe the viable options and their tradeoffs, with examples when useful.
   - Recommend an answer and briefly explain the recommendation.
   - Wait for the user's decision before moving to the next question.

4. After each answer, update the plan with the agreed decision and any resulting
   changes to dependencies, phases, open questions, or validation. Follow the
   repository's conventions for plan files, revision management, phase status,
   documentation, and tests. Do not record an unresolved assumption as an agreed
   decision.

5. Continue down each affected branch of the design tree, resolving prerequisite
   decisions before dependent ones, until the plan is concrete and both parties
   share the same understanding.
