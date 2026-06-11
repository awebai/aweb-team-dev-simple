---
name: create-team
description: Use this when a human points you at this blueprint and asks you to create a simple coordinator/developer/reviewer aweb team in a repo they own.
---

# Create a team from this blueprint

You are creating a team from a **blueprint** into a human's repo: copy the
identity-free resources in, commit them, connect the coordinator, publish
the shared context, hand the team to the human. You are a transient
creator — **you will have no role in the finished team.**

**Fast path:** `scripts/create-team.py <target>` performs this whole
procedure in one go (it prompts for counts and team source, shows every
`aw` command it runs, and prints launch commands). Prefer it when the human
wants the standard setup; follow the manual steps below when they want to
adapt anything along the way. Either way, review and commit with the human
at the end.

Do not: create `.aw` state in this blueprint repo; copy `.aw`, keys,
certificates, tokens, or aliases from anywhere; overwrite existing target
paths without asking; create worktrees or branches now; run any monolithic
bootstrap command.

## 1. Confirm

Repeat back before mutating files: the target repo path, the team source
(existing hosted team or new dashboard team), and the harness for the
coordinator (Claude Code, Codex, Pi).

## 2. Install the resources

You may run `scripts/install-local.sh <target>` (it refuses to overwrite),
or copy manually to this shape:

```text
agents/
  souls/<role>/...          from resources/souls/
  roles/<role>.md           from resources/roles/
  instructions.md           from resources/instructions.md
  docs/team-architecture.md from resources/docs/
  roles-bundle.json         built by scripts/build-roles-bundle.py
.agents/skills/{spawn-instance,retire-instance,self-maintenance}/
```

Souls are living state — they belong in the team's repo, committed and
reviewed. Do not copy this `create-team` skill into the target.

For Claude Code, link the skills dir:

```bash
cd <target> && ln -sfn .agents/skills .claude/skills
```

Keep instances out of git — append to the target `.gitignore`:

```text
/agents/instances/
```

Review with the human, then commit:

```bash
git add agents .agents .claude .gitignore
git commit -m "Add simple dev team from blueprint"
```

## 3. Create the coordinator instance

```bash
cd <target>
mkdir -p agents/instances/coordinator
cd agents/instances/coordinator
ln -sfn ../../souls/coordinator/AGENTS.md AGENTS.md
ln -sfn ../../.. work
ln -sfn AGENTS.md CLAUDE.md   # only if using Claude Code
```

## 4. Connect it

Ask the human to create or choose the team in the dashboard and use its
connect-agent flow; run the generated command from the coordinator's
directory:

```bash
cd <target>/agents/instances/coordinator
AWEB_API_KEY=... AWEB_URL=... aw init ...
```

Verify: `aw workspace status` and `aw whoami` from that directory.

## 5. Publish the shared context

From the connected coordinator directory:

```bash
aw instructions set --body-file ../../instructions.md
aw roles set --bundle-file ../../roles-bundle.json
aw roles show --all-roles
```

(Or one at a time where the CLI supports it: `aw roles add developer
--title "Developer" --playbook-file ../../roles/developer.md`.)

## 6. Hand off

Do not create developer or reviewer instances now — the team spawns them
when work needs them, with `.agents/skills/spawn-instance/`. Report what
was committed, and give the human the launch command:

```bash
cd <target>/agents/instances/coordinator && claude
```

Done when: resources committed, `/agents/instances/` gitignored, the
coordinator connected and verified, instructions/roles published, and the
human has the launch command.
