# Simple dev team blueprint

The simplest aweb team for a repo: a **coordinator**, **developers** in git
worktrees, and a fresh-eyes **reviewer**. Point your agent at this repo and
say:

> Create a team in my repo from this blueprint.

The agent copies the identity-free souls, roles, and skills into your repo,
commits them, connects the coordinator, and hands you the running team.

## The model in one paragraph

A **soul** (`agents/souls/<role>/`, committed) is an agent's durable body —
its operating doc plus whatever it learns. An **instance**
(`agents/instances/<name>/`, gitignored) is a runnable copy of a soul with
its own aweb identity. The coordinator runs against your main checkout;
each developer gets its own git worktree on its own branch; reviewers look
at branches with fresh eyes. The team adds and removes teammates itself
with two skills: `spawn-instance` and `retire-instance`.

## Fastest path: one command

```bash
git clone https://github.com/awebai/aweb-team-dev-simple.git
cd /path/to/your/repo
AWEB_API_KEY=...  ../aweb-team-dev-simple/scripts/create-team.py .
```

It asks how many of each soul you want (and a hosted username if there is
no `AWEB_API_KEY` in the environment), then installs the resources, creates
every identity with explicit `aw` commands shown as they run, and prints
the launch command for each instance. A whole team takes seconds.

## Or: agent-driven

In your repo, tell your agent:

> Use `https://github.com/awebai/aweb-team-dev-simple` as the blueprint for
> this repo. Read its `AGENTS.md`, follow its `skills/create-team/SKILL.md`,
> and set up the coordinator first.

Then run the team yourself:

```bash
cd agents/instances/coordinator
claude
```

Ask the coordinator for what you want; it spawns developers when work needs
them.

## What this repo contains

```text
resource-pack.yaml             Manifest
resources/instructions.md      Team-wide operating instructions
resources/roles/*.md           Role playbooks published to aweb roles
resources/souls/*              Durable agent bodies (soul.yaml + AGENTS.md)
resources/docs/                One-page team architecture doc
skills/create-team/            The procedure your agent follows to create the team
skills/spawn-instance/         Add a teammate: new identity + home (+ worktree for developers)
skills/retire-instance/        Remove a teammate: identity, home, worktree, branch
skills/self-maintenance/       How agents grow their souls
adapters/*                     Harness notes for Claude Code, Codex, and Pi
scripts/install-local.sh       Explicit filesystem install helper; no .aw mutation
scripts/build-roles-bundle.py  Builds a roles JSON bundle from Markdown roles
```

## What lands in your repo

```text
agents/
  souls/{coordinator,developer,reviewer}/
  roles/{coordinator,developer,reviewer}.md
  instructions.md
  docs/team-architecture.md
  roles-bundle.json
  instances/            <- gitignored; created as the team runs
.agents/skills/{spawn-instance,retire-instance,self-maintenance}/
.claude/skills -> .agents/skills    (Claude Code only)
```

## Boundaries

This repo contains no `.aw`, keys, DIDs, certificates, aliases, tokens, or
instance directories. Copying files and creating identities are separate,
visible steps; identities are created with explicit aweb commands you can
read before running.

## When you outgrow it

`aweb-team-coord-worktrees` is the full version of this team — same souls
and layout, plus a per-commit review loop and reviewer skill suites.
Graduating is adding skills, not migrating.

## License

MIT. Fork freely and adapt the blueprint to your team.
