---
name: review-pr
description: >
  Reviews a pull request from its locally checked-out feature branch. Use when
  the user asks to review, inspect, evaluate, or summarize a PR or feature-branch
  diff; explain the implemented behavior or code flow; or recommend an order for
  reading the changed files. Especially relevant when the current directory is
  a Jujutsu workspace containing the PR branch.
---

# Review a pull request

Review the complete diff of a locally checked-out PR feature branch. Do not
modify the branch unless the user explicitly asks for changes.

## Determine the PR diff

Unless the user says otherwise, assume the current directory is a Jujutsu
workspace containing the PR feature branch. Use `jj`, not `git`, to inspect the
branch and its history.

The built-in `trunk()` revset function resolves to the latest revision on
`main`. The custom `common_ancestor()` function resolves to the latest revision
that is an ancestor of both `main` and the current revision—that is, the PR's
base revision.

Inspect the complete PR diff with:

```sh
jj diff --git -f 'common_ancestor()'
```

Also inspect relevant nearby source, tests, documentation, and history as needed
to understand the intended behavior and validate potential findings. If the
local PR checkout or comparison target is missing or ambiguous, infer it from
conversation and workspace context when possible; otherwise ask the user.

## Summarize the change

Before presenting review findings:

- Explain what behavior the diff appears to implement or change.
- For a new feature, explain the implemented code flow.
- Recommend the best order for manually examining the changed files. Put files
  introducing the core logic or concepts first and ancillary or orthogonal
  changes last.

## Review the diff

Check correctness and maintainability, including:

- Whether the new code matches the style of nearby code.
- Whether anything could be implemented more efficiently without greatly
  sacrificing readability.
- Whether the code is organized well. Define small items close to where they
  are used—certainly in the same file and ideally near related types. A larger
  group of related items may deserve its own file, especially instead of adding
  more content to a truly large file (over 5,000 lines).
- Whether superfluous changes should be extracted into a separate PR.
- Whether there are obvious layering violations.
- Whether the problem is solved at the right level, rather than introducing a
  narrow workaround where a more holistic solution is appropriate.

Report actionable findings in priority order with precise file and line
references. Distinguish confirmed defects from questions or optional
suggestions. If there are no findings, say so explicitly and mention any
important validation gaps or residual risks.
