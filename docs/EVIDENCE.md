# Evidence ledger

Every claim in the resume variants, where it was checked, and what is still
open. Checked on 2026-11-13. A claim with no source here does not go in a
resume; a claim nobody has checked goes in wrapped in `\verify{...}` so
`make review` highlights it.

Status words: **verified** (read in a primary source that day), **owner
records** (read in the owner's private project records, which themselves say
what they were checked against and when), **unverified** (stated by the owner
or inferred; needs checking before the resume is sent).

## OpenMW

| Claim | Status | Source |
|---|---|---|
| Described as "a core developer of OpenMW" | verified | OpenMW blog, "From BSP to ESP", Nov 2024 |
| Object movement in OpenMW-CS, MR !3675 | verified | same post names the MR as his |
| Merged instance drop modes and tooltip, MR !4350 | verified | commits by Dave Corley under the merge "Task #8141: Merge instance drop modes", OpenMW master |
| Water height saved whenever the user adjusted it; esmtool logging fix | verified | commits by Dave Corley, 2024-02-22, OpenMW master |
| Journal records serialized first when saving plugins | verified | commit by Dave Corley, 2024-10-16, OpenMW master |
| Networking layer and headless server on the DreamWeave fork (prototype, not merged) | verified | `apps/openmw/mwnet/` (client, server, network messages, ESM serialization) on branch DREAM-BIRTH-26 of github.com/DreamWeave-MP/DreamWeave, read 2026-11-13; "headless" is the owner's description |

Not used, no evidence found: a date range for the contributions; work on the
Lua API; work on OpenMW's Linux builds or packaging; any OpenMW CI or ccache
change. MR !3938 ("MSVC CCache support") exists upstream but its author was
not confirmed, so it is not claimed.

## Jess, l3i, StroggForge

| Claim | Status | Source |
|---|---|---|
| Jess: one Rust crate, library plus binary; runtime, test runner, type checker, package and workspace tool, type generator, style checker | owner records | checked against the live tree, 2026-10-23 |
| Jess v0.1.0 on 2026-10-21, v0.3.0 on 2026-11-05, on crates.io, MIT or Apache-2.0 | owner records | checked against tags, GitHub releases and crates.io |
| First release carried signed archives for Linux x64, macOS ARM64 and x64, Windows x64, PortMaster ARM64 | owner records | GitHub release of 2026-10-21 |
| Immutable package archive, digest-pinned lockfile, single-file and standalone-executable packing | owner records | live tree, 2026-10-23 |
| Authenticated ranged reads and durable file creation in 0.3.0 | owner records | dependency and type stubs, 2026-11-05 |
| l3i: pinned Luau submodule, hand-declared C API, VM planning, JIT hooks, dialect front end, enforced clang/lld/LTO toolchain; began as a C++ binder for OpenMW | owner records | live tree, 2026-10-23 |
| l3i 1.0.0 on 2026-09-29, 2.7.0 on 2026-11-05 | owner records | tags and crates.io |
| StroggForge: reusable workflows and composite release action (build, portability check, keyless Cosign signing, VirusTotal scan, publish); tag v63 | owner records | live tree, 2026-10-23 |
| CentOS Stream 9 build image for a glibc 2.34 baseline; EL9 sysroot for ARM64 | owner records | same |
| Intel macOS release that would not start off the runner, fixed 2026-10-23 | owner records | same |

Open: the repository links for Jess, l3i and StroggForge were written from the
organization and project names and were not opened. Run `make links`.

## Rook

| Claim | Status | Source |
|---|---|---|
| Releases 0.1.0 to 0.3.2 tagged | verified | tag list of the private repository, supplied by the owner |
| Discord and GitHub integration; grant ledger; hash-bound profile; durable write intents; receipts, budgets, emergency stop; 83 offline test cases | owner records | project records dated 2026-10-29 and 2026-11-05 |
| In use on the DreamWeave-MP Discord | owner stated | the owner confirmed on 2026-11-13 that Rook is live there; replaces "not yet in production use" |
| "Specified and checked AI-assisted implementation against written requirements and acceptance tests" | **unverified** | project records describe AI-assisted work directed by the owner; confirm the precise scope of specification and validation |

Rook's source is private. The resume describes what it does and how it is
governed, and names nothing about its repositories, host or model.

## Tools

| Claim | Status | Source |
|---|---|---|
| vfstool: library and CLI over OpenMW's VFS; drift check with an exit code; Linux, Windows, macOS; crates.io and AUR | verified | vfstool README on docs.rs |
| S3LightFixes: lighting patch from a whole load order; Cosign signatures tied to its GitHub Actions workflow | verified | S3LightFixes README; modding-openmw.com listing |
| Morrobroom: TrenchBroom maps to Morrowind plugins and meshes; featured on the OpenMW blog | verified | OpenMW blog, Nov 2024 |

## Employment and training

Carried over unchanged in substance from the previous resume: Conduent
(Mar 2017 to Jan 2019), United States Cellular (2019), Holberton Tulsa
(2022 to 2023), Tulsa Tech Riverside (2015 to 2016). None was independently
checked. On 2026-11-13 the owner confirmed the Conduent dates, and confirmed
that the A+ entry was the course only: no certification was earned, so the
entry stays worded as a course. Neither training entry is a degree. "A+ certification course" names
a course; if the certification itself was earned, say so, and if not, leave it.

## Customer-facing engineering variant

The `customer-engineering` resume reuses `content/experience.tex` and
`content/education.tex` without changing dates, employers or credentials. Its
customer-facing positioning rests on the existing Conduent Tier 2 technical
support and U.S. Cellular frontline customer service entries. Both employment
entries remain **unverified** externally; confirm dates, title and mentoring
before sending. Do not present the A+ *course* as an earned certification.

| Claim in new variant | Status | Source |
|---|---|---|
| Conduent: Tier 2, multi-platform hardware/software troubleshooting, complex cases, mentoring | unverified (carried over) | `content/experience.tex`; employment and training section above |
| U.S. Cellular: frontline customer service, billing/technical triage and escalation | unverified (carried over) | `content/experience.tex`; employment and training section above |
| Rook: Discord/GitHub engineering assistant; permissions, ambiguous-write safeguards, budgets, receipts, 83 offline tests | owner records | Rook section above; private project records checked on 2026-11-05 |
| OpenMW: object movement, instance drop modes and tooltip; plugin save fixes | verified | OpenMW section above |
| Jess: one-binary runtime/toolchain and signed multi-platform release archives | owner records | Jess section above |
| vfstool: VFS CLI and CI drift check; StroggForge: reusable signed release workflows | owner records / verified | Tools and StroggForge sections above |

The summary's claim to communicate technical problems in practical terms is a
professional positioning statement, not an independently documented business
outcome. No customer-facing role, production deployment or measured impact was
invented for the independent projects.

## Asked for, not included

- **ccache optimization.** No evidence of authorship was found.
- **Linux build support for OpenMW.** Only the StroggForge work above could be
  sourced.
- **Measured outcomes** such as build-time or cache-hit numbers. None were
  found for any project; add them with their source when they exist.

## Backend and games variants

Added 2026-11-13. `backend.tex` and `games.tex` reuse only claims already in
this ledger, reworded for the role; they add no new facts. The games variant
carries the DreamWeave networking prototype and the backend variant carries
Rook's deployment status, both since confirmed above.

## Header location

Changed 2026-11-13 from "Oklahoma, USA" to "Remote (US), relocating to Miami,
FL" for every variant: the owner is targeting remote US roles and roles in the
Miami area.

## Python, SQL and TypeScript

Added 2026-11-13 to the languages line of the `ai-automation`, `backend` and
`customer-engineering` variants. **Owner stated** that day: substantial Python
and SQL in college coursework, and TypeScript in one project. No public
repository was checked. Listed after the primary languages, with no project
or level claimed; be ready to show or discuss a sample in an interview.
