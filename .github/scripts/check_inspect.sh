#!/bin/bash

set -e

FOUND=0
OUTPUT=""

# Get list of modified .ex and .exs files compared to main
FILES=$(git diff --name-only origin/main...HEAD -- '*.ex' '*.exs')

if [ -z "$FILES" ]; then
  echo "✅ No modified Elixir files found."
  exit 0
fi

for FILE in $FILES; do
  if [ ! -f "$FILE" ]; then
    continue
  fi

  LINE_NUM=0
  while IFS= read -r LINE; do
    LINE_NUM=$((LINE_NUM + 1))

    if echo "$LINE" | grep -q "IO\.inspect"; then
      # Ignore fully commented lines
      TRIMMED=$(echo "$LINE" | sed 's/^[[:space:]]*//')
      if echo "$TRIMMED" | grep -q "^#"; then
        continue
      fi

      # Ignore lines with approval annotation
      if echo "$LINE" | grep -q "io_inspect_ok"; then
        continue
      fi

      FOUND=1
      OUTPUT="${OUTPUT}\n  📄 ${FILE}, line ${LINE_NUM}:\n     ${LINE}\n"
    fi
  done < "$FILE"
done

if [ $FOUND -eq 1 ]; then
  echo ""
  echo "❌ IO.inspect found without explicit approval:"
  echo ""
  echo -e "$OUTPUT"
  echo "──────────────────────────────────────────────"
  echo "You have two options:"
  echo ""
  echo "  1. Remove IO.inspect if it is no longer needed"
  echo ""
  echo "  2. If intentional, add # io_inspect_ok on the same line:"
  echo '     IO.inspect(user, label: "debug") # io_inspect_ok'
  echo ""
  exit 1
else
  echo "✅ No unapproved IO.inspect found."
  exit 0
fi
