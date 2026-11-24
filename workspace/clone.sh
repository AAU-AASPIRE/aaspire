#!/usr/bin/env bash
# Clone every AASPIRE repository side by side, into the folder above this repository (AAU-AASPIRE):
#   workspace/clone.sh             # clone what is missing
#   workspace/clone.sh --install   # ... and pip install -e every Python part
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$here/../.." && pwd)"
grep -v '^\s*#' "$here/repositories.txt" | awk 'NF {print $1}' | while read -r name; do
    if [ -d "$root/$name/.git" ]; then echo "$name: there"; else git clone "https://github.com/AAU-AASPIRE/$name.git" "$root/$name"; fi
done
if [ "${1:-}" = "--install" ]; then
    for name in iec61499-mgmt-py iec61499-skill-lib modlink modsync modplan modreg module-py AAS-MAS; do
        python -m pip install --no-deps -e "$root/$name"
    done
fi
