#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/project" >&2
  exit 2
fi

src="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="$1"

if [ ! -d "$dest" ]; then
  echo "target project does not exist: $dest" >&2
  exit 1
fi

copy_dir() {
  local from="$1" to="$2"
  if [ -e "$to" ]; then
    echo "refusing to overwrite existing path: $to" >&2
    exit 1
  fi
  cp -R "$from" "$to"
}

copy_file() {
  local from="$1" to="$2"
  if [ -e "$to" ]; then
    echo "refusing to overwrite existing path: $to" >&2
    exit 1
  fi
  cp "$from" "$to"
}

mkdir -p "$dest/agents/souls" "$dest/agents/roles" "$dest/agents/docs" \
  "$dest/.agents/skills"

for soul in coordinator developer reviewer; do
  copy_dir "$src/resources/souls/$soul" "$dest/agents/souls/$soul"
done

for skill in spawn-instance retire-instance self-maintenance; do
  copy_dir "$src/skills/$skill" "$dest/.agents/skills/$skill"
done

for role_file in "$src"/resources/roles/*.md; do
  copy_file "$role_file" "$dest/agents/roles/$(basename "$role_file")"
done

copy_file "$src/resources/instructions.md" "$dest/agents/instructions.md"
copy_file "$src/resources/docs/team-architecture.md" "$dest/agents/docs/team-architecture.md"
"$src/scripts/build-roles-bundle.py" > "$dest/agents/roles-bundle.json"

cat <<EOF
Installed the simple-dev-team resources into $dest

Next steps:
  1. cd $dest
  2. Keep instances out of git:
       printf '/agents/instances/\n' >> .gitignore
  3. For Claude Code, link the skills dir:
       ln -sfn .agents/skills .claude/skills
  4. Review and commit:
       git add agents .agents .claude .gitignore
       git commit -m "Add simple dev team from blueprint"
  5. Create and connect the coordinator (see skills/create-team in the blueprint).
  6. From the connected coordinator home, publish shared context:
       aw instructions set --body-file ../../instructions.md
       aw roles set --bundle-file ../../roles-bundle.json
EOF
