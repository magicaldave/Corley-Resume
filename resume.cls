% resume.cls -- shared document styling for Dave Corley's resume variants.
%
% This file holds presentation only. Who the document is about lives in
% personal.tex; what it says lives in the variant files and content/.
%
% Class options:
%   review   highlight every \verify{...} claim so a human can check it
%   logo     put the S3 logo in the header (off by default: keeps the
%            documents plain text for applicant tracking systems)
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2026/11/13 S3kshun8 Games resume class]

\newif\ifresume@review
\newif\ifresume@logo
\DeclareOption{review}{\resume@reviewtrue}
\DeclareOption{logo}{\resume@logotrue}
\ProcessOptions\relax
\LoadClass[10pt]{article}

% --- Text extraction ------------------------------------------------------
% T1 fonts plus a glyph-to-Unicode map, so copy/paste and resume parsers get
% real characters back out of the PDF, with spaces between the words.
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\input{glyphtounicode}
\pdfgentounicode=1
\pdfinterwordspaceon
\pdfmapline{=dummy-space <dummy-space.pfb}

% --- Reproducible output --------------------------------------------------
% With SOURCE_DATE_EPOCH set (the Makefile does), two builds of one commit
% are byte-identical.
\pdfinfoomitdate=1
\pdftrailerid{}
\pdfsuppressptexinfo=-1

\RequirePackage[sfdefault]{noto}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage[letterpaper,left=0.6in,right=0.6in,top=0.45in,bottom=0.45in]{geometry}
\RequirePackage[tracking=true]{microtype}
\RequirePackage{enumitem}
\RequirePackage{graphicx}
\RequirePackage{hyperref}

% --- Theme ----------------------------------------------------------------
\definecolor{s3base}{HTML}{3D004C}
\colorlet{s3dark}{s3base!70!black}
\colorlet{s3link}{magenta!70!black}
\colorlet{s3muted}{black!68}
\definecolor{s3flag}{HTML}{FFE08A}
\hypersetup{colorlinks=true, urlcolor=s3link, linkcolor=s3link}

% --- Personal details -----------------------------------------------------
% Order of precedence: definitions made before \documentclass (the Makefile's
% LOCATION=... and friends), then the untracked personal.local.tex, then the
% tracked defaults in personal.tex.
\InputIfFileExists{personal.local.tex}{}{}
\input{personal.tex}
\providecommand{\resumeversion}{dev}
\providecommand{\resumedate}{\today}

\newcommand{\resumetitle}[1]{\def\resume@title{#1}}
\newcommand{\resumekeywords}[1]{\def\resume@keywords{#1}}
\resumetitle{}
\resumekeywords{}

% --- Page -----------------------------------------------------------------
\pagestyle{empty}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\raggedright
% Never break a word across lines: parsers read "inno-" and "vative" as two
% words.
\hyphenpenalty=10000
\exhyphenpenalty=10000
\emergencystretch=1.5em

\AtBeginDocument{%
  \hypersetup{
    pdftitle={\resumename\ -- \resume@title},
    pdfauthor={\resumename},
    pdfsubject={Resume},
    pdfkeywords={\resume@keywords},
    pdflang={en-US},
    pdfdisplaydoctitle=true,
  }%
}

% --- Header ---------------------------------------------------------------
\newcommand{\resume@sep}{\hspace{0.4em}{\color{s3base}\textperiodcentered}\hspace{0.4em}}
\newif\ifresume@first
\newcommand{\resume@item}[1]{%
  \ifresume@first\resume@firstfalse\else\resume@sep\fi\mbox{#1}}
\newcommand{\resume@empty}{}
\newcommand{\resume@ifset}[2]{%
  \expandafter\ifx\csname #1\endcsname\resume@empty\else #2\fi}
\newcommand{\resume@weblink}[2]{\href{https://#1}{#2}}

\newcommand{\makeheader}{%
  \begingroup
  \ifresume@logo
    \begin{minipage}[c]{0.11\linewidth}%
      \includegraphics[width=\linewidth]{profilepicture}%
    \end{minipage}\hfill
    \begin{minipage}[c]{0.86\linewidth}\raggedright
  \fi
  \leavevmode{\fontsize{21}{24}\selectfont\bfseries\color{s3dark}\resumename}%
  \hfill{\large\color{s3base}\resume@title}\par
  \vspace{3pt}
  {\footnotesize
    \resume@firsttrue
    \resume@ifset{resumelocation}{\resume@item{\resumelocation}}%
    \resume@ifset{resumephone}{\resume@item{\resumephone}}%
    \resume@ifset{resumeemail}{\resume@item{\href{mailto:\resumeemail}{\resumeemail}}}%
    \resume@ifset{resumesite}{\resume@item{\resume@weblink{\resumesite}{\resumesite}}}%
    \par\resume@firsttrue
    \resume@ifset{resumegithub}{\resume@item{\resume@weblink{github.com/\resumegithub}{github.com/\resumegithub}}}%
    \resume@ifset{resumegitlab}{\resume@item{\resume@weblink{gitlab.com/\resumegitlab}{gitlab.com/\resumegitlab}}}%
    \resume@ifset{resumelinkedin}{\resume@item{\resume@weblink{www.linkedin.com/in/\resumelinkedin}{linkedin.com/in/\resumelinkedin}}}%
  \par}
  \ifresume@logo\end{minipage}\fi
  \endgroup
  \vspace{2pt}
}

% --- Sections -------------------------------------------------------------
% Bold, tracked capitals with a rule to the margin. Each one is also a PDF
% bookmark, so a screen reader or a viewer's outline can jump between them.
\renewcommand{\section}[1]{%
  \par\addvspace{6.5pt}%
  \pdfbookmark[1]{#1}{sec.#1}%
  {\color{s3base}\bfseries\small\textls[70]{\MakeUppercase{#1}}%
   \hspace{0.6em}\leaders\hrule height 3.3pt depth -2.9pt\hfill\kern0pt}%
  \par\nobreak\vspace{2.5pt}}

% --- Entries --------------------------------------------------------------
% \entry{Name}{what it is}{status or dates}
\newcommand{\entry}[3]{%
  \par\addvspace{3.6pt}%
  \begingroup
  \setbox0=\hbox{{\footnotesize\itshape\color{s3muted}#3}}%
  \parbox[t]{\dimexpr\linewidth-\wd0-1em\relax}{\raggedright\leavevmode
    {\bfseries\color{s3dark}#1}%
    \if\relax\detokenize{#2}\relax\else\hspace{0.5em}{\small #2}\fi}%
  \hfill\box0
  \par\endgroup\nobreak\vspace{1pt}}

% One muted line under an entry heading: links, stack, role.
\newcommand{\entrymeta}[1]{{\footnotesize\color{s3muted}#1\par}\nobreak\vspace{0.5pt}}

\newlist{bullets}{itemize}{1}
\setlist[bullets]{
  label={\color{s3base}\textbullet},
  leftmargin=1.05em, labelsep=0.45em,
  topsep=1.5pt, itemsep=1.2pt, parsep=0pt, partopsep=0pt,
  before=\small,
}

% \skill{Area}{items}
\newcommand{\skill}[2]{{\small\textbf{#1:}\hspace{0.4em}#2\par}\vspace{1.6pt}}

\newcommand{\summary}[1]{{\small #1\par}}

% --- Claims awaiting verification ------------------------------------------
% Wrap any statement nobody has checked against a source in \verify{...}.
% Normal builds print it as written; `make review` paints it so it cannot be
% missed. scripts/check.sh counts them.
\ifresume@review
  \newcommand{\verify}[1]{\begingroup\fboxsep=0.8pt\colorbox{s3flag}{\strut#1}\endgroup}
\else
  \newcommand{\verify}[1]{#1}
\fi

% --- Footer ---------------------------------------------------------------
\newcommand{\makefooter}{%
  % Normal resumes have no generated build metadata or source-control footer.
  % A review build still makes unverified claims visible.
  \ifresume@review
    \vfill
    {\fontsize{7}{9}\selectfont\color{s3muted}%
     REVIEW BUILD: highlighted claims need checking\par}%
  \fi}

% --- Cover letter ---------------------------------------------------------
% \begin{coverletter}{Company}{Position}{Contact person} ... \end{coverletter}
\newenvironment{coverletter}[3]{%
  \section{Cover letter}
  {\small\textbf{Company:}\hspace{0.4em}#1\par\textbf{Position:}\hspace{0.4em}#2\par}
  \vspace{8pt}
  \setlength{\parskip}{6pt}\small
  Dear #3,\par}{\par}
