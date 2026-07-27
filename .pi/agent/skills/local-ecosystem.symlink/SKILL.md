---
name: local-ecosystem
description: >
  Machine-local augmentation for ty ecosystem workflows. Use alongside the ruff
  repository's ecosystem-summary or ecosystem-minimization skills when analyzing
  ecosystem reports, reproducing primer differences, investigating regressions,
  comparing PR and base revisions, or testing ty behavior and performance on
  real-world Python projects. Prefer the local `eco` wrapper for project
  reproduction, including comparisons against feature-branch bases using
  isolated jj workspaces.
---

# Local ecosystem analyzer run

Use this skill for local ecosystem-analyzer runs, ty ecosystem report analysis,
primer differences, real-world inference regressions, performance comparisons,
and comparisons between a PR and any base revision.

## Augment repository-provided ecosystem skills

When a repository-provided ecosystem-summary or ecosystem-minimization skill
also applies, read and follow that skill as well. Its requirements govern the
investigation; this skill supplies the preferred machine-specific mechanism for
running project comparisons. Try `eco` before constructing custom reproduction
workflows, building comparison binaries manually, or setting up project clones
by hand.

The ecosystem-analyzer version used by `eco` is normally close to the version
pinned by ty. Do not reject `eco` merely because it does not explicitly pin that
version. If `eco` cannot reproduce a reported difference, investigate whether
the analyzer version, project revision, dependency cutoff, Python version, or
other run configuration differs, and then fall back to the repository skill's
stricter exact-run procedure when necessary.

## Inputs

Determine the project name from conversation context whenever possible (for example: if the user already mentioned `scipy`, use it directly).

Only ask a clarifying question when the project is missing or ambiguous.

Derive everything else automatically:
- Output path: `$HOME/.pi/tmp/<project>-ecosystem.json`

## Preconditions

- Run from the root directory of a `jj` workspace.
- `eco` is available at `$HOME/bin/eco` (usually already on `PATH` as `eco`).
- Snapshot the workspace immediately before every `eco` invocation by running
  `jj status`. `eco` passes `--ignore-working-copy` to its Jujutsu commands, so
  it otherwise builds the previously snapshotted revision and silently omits
  current working-directory changes.

## Run

Execute:

```sh
mkdir -p "$HOME/.pi/tmp"
jj status
eco -o "$HOME/.pi/tmp/<project>-ecosystem.json" <project>
```

This command builds and runs `ty` from the current commit and writes diagnostics
JSON to the supplied persistent output path. Always pass `-o`; do not rely on
`eco`'s `/tmp` default.

### Compare against an arbitrary feature-branch base

For PRs whose base is not `main`, create a separate Jujutsu workspace at the
exact base commit and run `eco` without `-m` from each workspace:

```sh
base_workspace="$HOME/.pi/tmp/eco-base-<pr-number>"
output_dir="$HOME/.pi/tmp/eco-<pr-number>"
mkdir -p "$output_dir"

jj workspace add \
    --revision "$BASE_COMMIT" \
    --message '[π] Reproduce ecosystem baseline' \
    "$base_workspace"

(
    cd "$base_workspace"
    jj status
    eco -o "$output_dir/<project>-base.json" <project>
)

jj status
eco -o "$output_dir/<project>-pr.json" <project>
```

Run the second command from the PR workspace. Reuse both workspaces and choose
separate output files for each additional project. Compare the resulting JSON
as the diagnostic or performance oracle before minimizing examples.

## Post-run analysis

After the run succeeds, choose follow-up steps based on the user’s request and context.

Possible follow-ups include:

- Timing-focused checks:
  ```sh
  rg -n "time_s" "$HOME/.pi/tmp/<project>-ecosystem.json" | tail -n 5
  ```
  `time_s` is type-check time only (does not include overhead such as compiling `ty`).

- Diagnostics-focused checks:
  read and summarize relevant diagnostics from
  `$HOME/.pi/tmp/<project>-ecosystem.json`.

- Compare results with another ecosystem run, typically results for the same project between `main` (see `-m` option below) and the current feature branch

- Other analyses:
  inspect whichever JSON fields are relevant to the user’s stated goal.

- Code inspection: if you need to inspect the Python code, it will be cloned
  into `~/.cache/ecosystem-analyzer`.

## Optional flags

- `-o <path>`: write diagnostics JSON to a persistent location under
  `$HOME/.pi/tmp` instead of the default `/tmp` path.
- `-m`: run `ty` from `main` instead of the current checked-out commit. Do not
  use this when a PR targets a different feature-branch base.
- `-t <profile>`: use a custom cargo profile (rarely needed; default `profiling` is usually correct).

## Notes

- `eco` intentionally runs its Jujutsu commands with `--ignore-working-copy`.
  It does not snapshot changes for you: always run `jj status` immediately
  beforehand, even if a previous invocation already snapshotted the workspace.
- `eco` bridges Jujutsu workspaces to ecosystem-analyzer's Git-based repository
  handling. Its internal Git operations are intentional and permitted; use the
  wrapper rather than invoking Git directly.
- `eco` may clone projects into `~/.cache/ecosystem-analyzer`; inspect that cache
  when project source code is needed.
- Do not assume the report's purpose; infer whether the user wants timing,
  diagnostics, regression categorization, or other analysis from context.
