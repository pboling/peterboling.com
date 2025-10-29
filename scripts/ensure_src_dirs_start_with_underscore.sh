#!/usr/bin/env bash
# Ensure direct child directories of the src/ directory begin with an underscore (_)
# Default: dry-run. Use --apply to perform renames.

set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") [--apply] [--src DIR]

Options:
  --apply        Actually perform renames. Without this flag the script runs in dry-run mode.
  --src DIR      Source directory to operate on (default: src)
  -h, --help     Show this help and exit

Behavior:
  - Scans only direct child entries of the given src directory.
  - Only renames directories (not files or symlinks).
  - Skips names that already start with an underscore or a dot (hidden dirs).
  - If destination (with leading underscore) already exists the entry is skipped.
EOF
}

DRY_RUN=1
SRC_DIR="src"

# parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply)
      DRY_RUN=0
      shift
      ;;
    --src)
      if [[ $# -lt 2 ]]; then
        echo "--src requires a directory argument" >&2
        exit 2
      fi
      SRC_DIR="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Error: source directory '$SRC_DIR' does not exist or is not a directory." >&2
  exit 1
fi

echo "Mode: $( [[ $DRY_RUN -eq 1 ]] && echo 'DRY-RUN (no changes will be made)')$( [[ $DRY_RUN -eq 0 ]] && echo 'APPLY (renames will be performed)') )"
echo "Scanning direct children of: $SRC_DIR"

shopt -s nullglob
for entry in "$SRC_DIR"/*; do
  # skip non-direct children (shouldn't happen) and non-directories
  [[ -d "$entry" ]] || continue

  base=$(basename "$entry")

  # skip hidden directories
  if [[ "$base" == .* ]]; then
    echo "SKIP hidden: $base"
    continue
  fi

  # already starts with underscore
  if [[ "$base" == _* ]]; then
    echo "OK    already underscored: $base"
    continue
  fi

  dest="$SRC_DIR/_$base"
  if [[ -e "$dest" ]]; then
    echo "ERROR dest exists, skipping: $base -> $(basename "$dest")"
    continue
  fi

  if [[ $DRY_RUN -eq 1 ]]; then
    echo "[DRY-RUN] would rename: $entry -> $dest"
  else
    echo "Renaming: $entry -> $dest"
    mv -- "$entry" "$dest"
  fi

done

echo "Done."

