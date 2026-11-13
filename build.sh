#!/usr/bin/env bash
# Build without a local TeX install: run `make pdf` inside the TeX Live
# container, then check the results on the host.
#
#   bash build.sh                     all resume variants
#   bash build.sh LOCATION="Tulsa, OK"  any make variable passes through
#
# With TeX Live installed locally, plain `make` does the same job.
set -euo pipefail
cd "$(dirname "$0")"

engine=$(command -v podman || command -v docker) || {
  echo "build.sh needs podman or docker; with a local TeX Live, run 'make' instead" >&2
  exit 1
}
flags=()
[ "$(basename "$engine")" = podman ] && flags=(--userns=keep-id)

# The container has no view of git, so hand it the version and commit time.
version=$(git describe --tags --always --dirty 2>/dev/null || echo dev)
epoch=$(git log -1 --format=%ct 2>/dev/null || date +%s)

"$engine" run --rm "${flags[@]}" -v "$PWD":/work:Z -w /work \
  docker.io/texlive/texlive:latest-full \
  make pdf VERSION="$version" SOURCE_DATE_EPOCH="$epoch" "$@"

if command -v pdfinfo >/dev/null; then
  pairs=()
  for pdf in dist/*.pdf; do
    variant=${pdf##*Resume-}
    pairs+=("${variant%.pdf}:$pdf")
  done
  bash scripts/check.sh "${pairs[@]}"
else
  echo "poppler-utils is not installed: built, but not checked" >&2
fi
