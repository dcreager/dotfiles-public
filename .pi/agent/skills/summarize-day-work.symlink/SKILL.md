---
name: summarize-day-work
description: >
  Build an evidence-backed bullet summary of the user's work for a requested day
  from their GitHub profile and pi session activity. Use when the user asks what
  they worked on today, yesterday, or on a specific date; requests a daily
  status update, standup summary, work log, or end-of-day recap; or wants GitHub
  and pi session activity merged into a concise report.
---

# Summarize Day Work

Produce a concise work summary from GitHub and pi session activity. Prefer
concrete implementation, investigation, review, triage, technical discussion,
meetings, and planning signals. Filter unrelated chatter.

## Workflow

1. Resolve the reporting window.
   - Convert relative dates such as "yesterday" into an exact local calendar
     date. State the date and timezone in the result.
   - Convert local midnight boundaries to UTC when filtering GitHub events.

2. Collect GitHub activity.
   - Read the authenticated GitHub profile. When `gh` is available, run
     `gh api user` to confirm the active public account. The connected app
     profile and the public profile used for open-source work may differ.
   - Use the public events endpoint for the active profile:

     ```bash
     gh api 'users/<login>/events?per_page=100&page=<n>'
     ```

   - Page until the requested UTC window is covered. Filter events to the exact
     local-day boundaries.
   - Search commits in the same UTC window when useful:

     ```bash
     gh api -X GET search/commits \
       -H 'Accept: application/vnd.github+json' \
       -f q='author:<login> committer-date:<UTC_START>..<UTC_END>' \
       -f per_page=100
     ```

   - Inspect linked or authored pull requests when needed to understand status,
     review context, or unresolved work. For landed or reviewed PRs, report only
     the linked PR name by default. Do not restate the change, review
     disposition, tests, coverage, or closed issue unless it adds materially
     distinct context.
   - Count a pull request as reviewed only when GitHub evidence confirms that
     the user posted a review or review comments. A Codex thread that analyzes
     or drafts a review does not qualify by itself; exclude it from review
     bullets unless the review was actually submitted to GitHub.
   - Count an issue as triaged only when GitHub evidence confirms that the user
     posted a comment or changed the issue on GitHub. A Codex thread that
     analyzes or drafts issue triage does not qualify by itself; exclude it from
     triage bullets unless the user actually interacted with the issue on
     GitHub.
   - Treat public GitHub events as partial coverage. Disclose that limitation
     when private repository activity may be missing.

5. Collect pi session thread activity.
   - Treat an explicit request to summarize the user's own work as consent to
     inspect recent pi session data.
   - Prefer session titles, user requests, completed outcomes, generated
     artifacts, code changes, investigations, blockers, and follow-ups. Ignore
     exploratory dead ends unless they explain a real blocker or decision.
   - Include work completed only in a local pi session and not published
     externally (including review, triage, or implementation work) only when the
     thread shows multi-turn user engagement: more than one substantive user
     turn. Exclude unpublished work from a single prompt-and-response exchange.
     When included, explicitly label it as local unpublished work.
   - Use pi activity as supporting evidence and de-duplicate it against GitHub.
     Do not report session IDs or internal turn mechanics by default.

6. Synthesize the day.
   - Merge GitHub events and pi sessions that describe the same work. 
   - Prefer short, outcome-focused bullets: landed fixes, active investigations,
     reviews, issue triage, technical decisions, planning, and workflow
     feedback.
   - Mention important measurements, validation results, blockers, and
     follow-ups for investigations, in-progress implementation, or unresolved
     work. Omit routine validation details for landed or reviewed PRs.
   - Distinguish shipped work from discussion and inference.
   - Do not report branch creation, branch deletion, routine merge bookkeeping,
     or unrelated social chatter as separate work items.

## Output

Use this shape:

```markdown
**Work summary: YYYY-MM-DD**
- <outcome-focused bullet with relevant links>
- <additional work items>

Coverage note: <sources, timezone, material gaps, and filtering caveat>
```

Change the name of the current pi session to `Work summary: YYYY-MM-DD`.

Keep the summary compact: short bullets, one line when practical, and usually
3-5 bullets. Group closely related work and routine meetings into one bullet.
For issue and PR links, prefer the issue or PR name (or a concise shortened
name) as the link text rather than an opaque number. A number-only link is
acceptable when the bullet already separately describes the nature of the issue
or PR. For landed or reviewed PRs, the linked name is usually the entire
description: write `Landed <linked names>` or `Reviewed <linked names>` and move
on. Do not add routine implementation, test, or coverage details such as mdtest
coverage. Use GitHub links for concrete artifacts. Mention pi session activity
in the coverage note.
