#!/usr/bin/env bash
# Validate built resumes: page count, layout warnings, fonts, metadata and
# text extraction. Needs poppler-utils (pdfinfo, pdftotext, pdffonts).
#
#   scripts/check.sh variant:path/to.pdf [variant:path/to.pdf ...]
#   scripts/check.sh --links        check every URL in the sources (network)
#
# MAX_PAGES (default 1) is the page budget per variant.
set -uo pipefail
cd "$(dirname "$0")/.."

fail=0
ok()   { printf '  ok    %s\n' "$*"; }
bad()  { printf '  FAIL  %s\n' "$*"; fail=1; }
note() { printf '  note  %s\n' "$*"; }

if [ "${1:-}" = "--links" ]; then
  urls=$(grep -ohE 'https?://[^}{" \\]+' ./*.tex content/*.tex | sort -u)
  for url in $urls; do
    code=$(curl -sS -o /dev/null -L --max-time 20 -A 'resume-link-check' -w '%{http_code}' "$url" 2>/dev/null)
    case "$code" in
      2*|3*) ok "$code $url" ;;
      # Some hosts refuse scripted requests; a person should open these.
      401|403|429|999) note "$code $url (refuses automated checks; open it by hand)" ;;
      *) bad "$code $url" ;;
    esac
  done
  exit "$fail"
fi

[ "$#" -gt 0 ] || { echo "usage: $0 variant:file.pdf ... | --links" >&2; exit 2; }
for tool in pdfinfo pdftotext pdffonts; do
  command -v "$tool" >/dev/null || { echo "missing $tool: install poppler-utils" >&2; exit 2; }
done

name=$(sed -n 's/^\\providecommand{\\resumename}{\(.*\)}$/\1/p' personal.tex)
max_pages=${MAX_PAGES:-1}

for pair in "$@"; do
  variant=${pair%%:*}
  pdf=${pair#*:}
  log=build/$variant.log
  echo "$variant ($pdf)"
  [ -s "$pdf" ] || { bad "PDF is missing or empty"; continue; }

  pages=$(pdfinfo "$pdf" | awk '/^Pages:/ {print $2}')
  if [ "$pages" -le "$max_pages" ]; then ok "$pages page(s), budget $max_pages"
  else bad "$pages pages, budget $max_pages"; fi

  title=$(pdfinfo "$pdf" | sed -n 's/^Title: *//p')
  [ -n "$title" ] && ok "title metadata: $title" || bad "no title metadata"

  # Layout: nothing may stick out of the text block or leave a ragged gap.
  if [ -f "$log" ]; then
    boxes=$(grep -cE '^(Overfull|Underfull) \\[hv]box' "$log")
    if [ "$boxes" -eq 0 ]; then ok "no overfull or underfull boxes"
    else bad "$boxes layout warning(s):"; grep -E -A1 '^(Overfull|Underfull) \\[hv]box' "$log" | sed 's/^/          /'; fi
    if grep -qE 'LaTeX Warning: (Reference|Citation)|undefined references|Font shape .* undefined|Missing character' "$log"; then
      bad "LaTeX warnings:"; grep -E 'LaTeX Warning: (Reference|Citation)|Font shape .* undefined|Missing character' "$log" | sed 's/^/          /'
    else ok "no reference, font-substitution or missing-character warnings"; fi
  else
    note "no $log: layout warnings not checked"
  fi

  # Fonts: all embedded, all mapped to Unicode, no bitmap fonts.
  fonts=$(pdffonts "$pdf" | tail -n +3)
  if echo "$fonts" | awk '{ if ($(NF-4)!="yes" || $(NF-2)!="yes") f=1 } END { exit f }'; then
    ok "all $(echo "$fonts" | wc -l) fonts embedded with Unicode maps"
  else bad "a font is not embedded or has no Unicode map"; fi
  echo "$fonts" | grep -q 'Type 3' && bad "bitmap (Type 3) font present" || ok "no bitmap fonts"

  # Text extraction, read the way a parser would (reading order, no layout).
  text=$(pdftotext "$pdf" -)
  flat=$(printf '%s' "$text" | tr '\n' ' ')
  [ "$(printf '%s' "$text" | wc -w)" -ge 250 ] && ok "$(printf '%s' "$text" | wc -w) words extracted" || bad "too little text extracted"
  for want in "$name" "SUMMARY" "TECHNICAL CAPABILITIES" "SELECTED ENGINEERING WORK" "PROFESSIONAL EXPERIENCE" "EDUCATION AND TRAINING"; do
    case "$flat" in *"$want"*) ;; *) bad "extracted text lacks \"$want\"" ;; esac
  done
  printf '%s' "$text" | grep -qE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[a-z]{2,}' && ok "name, section headings and email extract as text" || bad "no email address in extracted text"
  if printf '%s' "$text" | LC_ALL=C grep -q $'\xef\xbf\xbd'; then bad "unmapped glyphs (U+FFFD) in extracted text"
  else ok "no unmapped glyphs"; fi
  # Ligatures must come out as plain letters, or "workflow" stops matching.
  if printf '%s' "$text" | grep -qE 'ﬁ|ﬂ|ﬀ|ﬃ|ﬄ'; then bad "ligature characters in extracted text"
  else ok "no ligature characters"; fi
  if printf '%s' "$text" | grep -qE '[a-z]-$'; then bad "words hyphenated across lines:"; printf '%s' "$text" | grep -nE '[a-z]-$' | sed 's/^/          /'
  else ok "no words broken across lines"; fi
  links=$(pdfinfo -url "$pdf" 2>/dev/null | grep -c 'Annotation' || true)
  [ "${links:-0}" -ge 5 ] && ok "$links clickable links" || bad "only ${links:-0} clickable links found"
done

unverified=$(grep -o '\\verify{' ./*.tex content/*.tex | grep -vc '^./resume.cls' || true)
[ "$unverified" -gt 0 ] && note "$unverified claim(s) still wrapped in \\verify{}: run 'make review' and confirm or cut them"

[ "$fail" -eq 0 ] && echo "all checks passed" || echo "CHECKS FAILED"
exit "$fail"
