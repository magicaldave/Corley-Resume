#!/usr/bin/env bash
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
podman run --rm --userns=keep-id -v "$SRC":/work:Z -w /work docker.io/texlive/texlive:latest-full pdflatex -interaction=nonstopmode dcresume.tex
