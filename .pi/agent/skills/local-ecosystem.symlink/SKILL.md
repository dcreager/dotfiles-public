---
name: local-ecosystem
description: >
  Uses ecosystem-analyzer to run ty locally against a Python project.
  Collects timing information and type checker diagnostics into a JSON file for further analysis,
  and comparison against other ecosystem-analyzer runs.
  Use when developing ty,
  to test new feature behavior or performance characteristics on real-world Python code.
---

# Local ecosystem analyzer run

Use this skill when the user asks to run an ecosystem-analyzer job locally
against a specific project, or otherwise indicates that they want to locally
test the current ty build on a real-world Python project.

## Inputs

Determine the project name from conversation context whenever possible (for example: if the user already mentioned `scipy`, use it directly).

Only ask a clarifying question when the project is missing or ambiguous.

Derive everything else automatically:
- Output path: `/tmp/<project>-ecosystem.json`

## Preconditions

- Run from the root directory of a `jj` workspace.
- `eco` is available at `$HOME/bin/eco` (usually already on `PATH` as `eco`).

## Run

Execute:

```sh
eco -o /tmp/<project>-ecosystem.json <project>
```

This command builds and runs `ty` from the current commit and writes diagnostics JSON to `/tmp/<project>-ecosystem.json`.

## Post-run analysis

After the run succeeds, choose follow-up steps based on the user’s request and context.

Possible follow-ups include:

- Timing-focused checks:
  ```sh
  rg -n "time_s" /tmp/<project>-ecosystem.json | tail -n 5
  ```
  `time_s` is type-check time only (does not include overhead such as compiling `ty`).

- Diagnostics-focused checks:
  read and summarize relevant diagnostics from `/tmp/<project>-ecosystem.json`.

- Compare results with another ecosystem run, typically results for the same project between `main` (see `-m` option below) and the current feature branch

- Other analyses:
  inspect whichever JSON fields are relevant to the user’s stated goal.

- Code inspection: if you need to inspect the Python code, it will be cloned
  into `~/.cache/ecosystem-analyzer`.

## Optional flags

- `-m`: run `ty` from `main` instead of the current checked-out commit.
- `-t <profile>`: use a custom cargo profile (rarely needed; default `profiling` is usually correct).

## Notes

- `eco` may clone projects into `~/.cache/ecosystem-analyzer`.
- Do not assume the report’s purpose; infer whether the user wants timing, diagnostics, or other analysis from context.
