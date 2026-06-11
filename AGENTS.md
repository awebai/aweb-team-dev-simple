# Creating a team from this blueprint

This repository is a **team blueprint** — the simple one. It is not the
user's team and it is not the place where identities should be created.

If a human points you at this repo and asks you to create a team in a repo
they own:

1. Read `resource-pack.yaml` to discover the souls, roles, skills, and docs.
2. Load and follow `skills/create-team/SKILL.md`.
3. Treat `resources/souls/*` as durable agent bodies that are copied into
   the target repo and committed there — they are living state and grow with
   the team.
4. Treat `skills/spawn-instance`, `skills/retire-instance`, and
   `skills/self-maintenance` as procedures the finished team uses; copy them
   into the target's `.agents/skills/`.
5. Use explicit aweb primitives and explicit filesystem/git steps. Do not
   run a monolithic bootstrap command, and do not copy `.aw` state.

The product motion is:

> Human chooses this blueprint; their agent copies the identity-free souls,
> roles, docs, and skills into the target repo and commits them, connects the
> coordinator with explicit aweb primitives, publishes the shared
> instructions/roles, and hands the team to the human. The team then adds
> and removes teammates itself, when work needs them.

The agent applying this blueprint has no role in the finished team.

When the team outgrows this blueprint (per-commit review protocol, reviewer
skill suites), the upgrade is `aweb-team-coord-worktrees` — same souls, same
layout, more machinery.
