# Corley Resume

Dave Corley's resume, as LaTeX, in three variants built from one set of sources:

| Variant | For | Output |
|---|---|---|
| `ai-automation` | AI integration, automation, developer tooling | `dist/Dave-Corley-Resume-ai-automation.pdf` |
| `systems-engineering` | Rust, Lua/Luau, runtimes, engine work, cross-platform delivery | `dist/Dave-Corley-Resume-systems-engineering.pdf` |
| `customer-engineering` | Customer-facing engineering, Tier 2 technical support, integrations, troubleshooting | `dist/Dave-Corley-Resume-customer-engineering.pdf` |

## Layout

```
resume.cls               styling: fonts, colours, header, sections, entries
personal.tex             name, location, contact details, links
ai-automation.tex        variant: summary, capabilities, selected work
systems-engineering.tex  variant: summary, capabilities, selected work
customer-engineering.tex   variant: support, customer communication, integrations
content/                 sections every variant shares (experience, education)
cover-letter.tex         cover letter template
scripts/check.sh         checks on the built PDFs
docs/EVIDENCE.md         where each claim was checked, and what is still open
```

Styling, personal details and content never share a file. A new variant is a
new `name.tex` beside the other two, plus its name in `VARIANTS` in the
Makefile; CI picks it up from there.

## Build

With TeX Live and poppler-utils installed:

```
make            # build all three PDFs into dist/ and check them
make review     # build/review/*.pdf with unverified claims highlighted
make cover      # the cover letter template
make links      # request every URL in the sources
```

Without TeX Live, `bash build.sh` runs the same build in the `texlive/texlive`
container with podman or docker.

## Personal details

Defaults live in `personal.tex`. Override them without editing it:

```
make LOCATION="Tulsa, OK" EMAIL=me@example.com PHONE="555 0100"
```

or, for one machine, in an untracked `personal.local.tex`:

```latex
\newcommand{\resumephone}{555 0100}
```

An empty value drops that item from the header. Keep a phone number out of
`personal.tex`: this repository is public.

## Checks

`make check` fails the build when a variant:

- runs past its page budget (one page; `MAX_PAGES=2 make check` to allow more)
- has an overfull or underfull box, a missing character or a substituted font
- has a font that is not embedded or has no Unicode map
- loses its name, a section heading or the email address in extracted text
- extracts with unmapped glyphs, ligature characters or words split by hyphens
- has fewer than five clickable links

It also counts the claims still wrapped in `\verify{...}`. Those print
normally in `dist/`; `make review` highlights them. Confirm each against a
source and unwrap it, or cut it. `docs/EVIDENCE.md` lists what is open.

## Release

Push a tag. CI builds and checks all three variants and attaches the three PDFs to a
GitHub release named for the tag. Pushes to `main` and pull requests run the
same build and keep all three PDFs as workflow artifacts.

Builds are reproducible: the footer date and the PDF timestamps come from the
commit, so one commit always produces the same bytes.

## Options

`\documentclass[logo]{resume}` puts the S3 logo in the header. It is off by
default so both variants stay plain text for applicant tracking systems.
