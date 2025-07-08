% Derivative of https://github.com/muratcankaracabey/latex_cv
\author{Dave Corley}
\RequirePackage[dvipsnames]{xcolor}
\LoadClass[11pt]{article}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{s8g_base}[S3kshun8 Games Document Base]
\RequirePackage[sfdefault]{noto}
\RequirePackage{etoolbox}
\RequirePackage{pgffor}
\RequirePackage{titlesec}
\RequirePackage{tikz}
\RequirePackage{fontspec}
\RequirePackage[left=0.75in,top=0.3in,right=0.75in,bottom=0.6in]{geometry} % Document margins
\RequirePackage{hyperref}
\usepackage{fontawesome5}
\RequirePackage{mfirstuc}
\RequirePackage{ifthen}
\RequirePackage{lipsum}
\RequirePackage{array}
\pagestyle{empty}

% Defined in order of appearance
\def\@firstname{Dave}
\def\@lastname{Corley}
\def\@address{Phoenix, AZ}
\def\@mail{S3kshun8.Games@proton.me}
\def\@position{UI/UX Designer}
\def\@themecolor{magenta}
\def\@githubaccount{https://github.com/magicaldave}
\def\@linkedinaccount{https://www.linkedin.com/in/s3kshun8}
\def\@gitlabaccount{https://gitlab.com/magicaldave1}

\definecolor{s3base}{HTML}{3d004c}
\colorlet{s3light}{s3base!70!white}
\colorlet{s3dark}{s3base!70!black}
\colorlet{s3link}{magenta!70!black}

%Setup for coverletter

\newcommand*{\setcompanyname}[1]{\def\@companyname{#1}}
\newcommand*{\setcontactperson}[1]{\def\@contactperson{#1}}
\newcommand*{\setclaimedposition}[1]{\def\@claimedposition{#1}}

\hypersetup{
    colorlinks=true,
    urlcolor=s3link,
}

% View commands
% Header
\newcommand\headerview{
    % Left column: Profile picture, aligned to the left
    \begin{minipage}{0.25\linewidth}
        \raggedright
        \profpic{0.5}{profilepicture}
    \end{minipage}%
    \hspace*{\fill}
    % Right column: Name and contact details, aligned to the right
    \begin{minipage}{0.7\linewidth}
        \raggedleft
        \textbf{\huge \name} \\[0.1cm]
        \contact
    \end{minipage}
}



%profilpicture

\newsavebox{\picbox}
\newcommand{\profpic}[2]{%
    \savebox{\picbox}{%
    \includegraphics[scale=#1]{#2}}% 
    \tikz\node [draw, circle,%
    line width=0.25pt, color=s3base,%
    minimum width=\wd\picbox,minimum height=\ht\picbox,%
    path picture={ \node at (path picture bounding box.center)% 
    {\usebox{\picbox}};}]% 
    {};}
    
%contactsubviews 
    
    
\newcommand{\githubview}{\href{\@linkedinaccount}{\faLinkedinIn\ \footnotesize LinkedIn}}
\newcommand{\linkedinview}{\href{\@githubaccount}{\faGithubSquare\ \footnotesize GitHub}}
\newcommand{\gitlabview}{\href{\@gitlabaccount}{\faGitlab\ \footnotesize GitLab}}

\newcommand{\name}{%
    {\large \@firstname \ \textsc{\@lastname}}
}

\newcommand{\contact}{%
        {\small \@address  \\ \@mail%
        \\%
        \linkedinview \cps \githubview \cps \gitlabview \\
        } % 
}

% Covverletterview

\newcommand\coverletter[1]{ 
\\  \coverlettersubview 
\section{} \vspace{1ex} 
\textbf{ Dear \@contactperson, \\[0.1cm]}
  #1
}

\newcommand\coverlettersubview{
\begin{tabular}{>{\scshape \bfseries \color{\@themecolor}}l  >{\small }l}
Company: & \@companyname \\
Position: & \@claimedposition \\
\end{tabular}
}


% Helper commands

\newcommand\ruleafter[1]{#1~{\color{black!60!\@themecolor}\hrulefill}} % a trick to put the line with <before> parameter in \titleformat

%colorfulpipeseperator

\newcommand{\cps}{{\color{\@themecolor} \quad\textbar\quad}}
\newcommand{\cpshalf}{{\color{\@themecolor} \hspace{0.2em}\textbar\hspace{0.2em}}}

\newcommand{\coloredbullet}{{\color{\@themecolor} \textbullet}}

% Edit section styles

\titleformat{\section}      % Customise the \section command 
  {\large\bfseries\scshape\raggedright\color{\@themecolor}} % Make the \section headers large (\Large),
                               % small capitals (\scshape) and left aligned (\raggedright)
  {}{0em}                      % Can be used to give a prefix to all sections, like 'Section ...'
  {\ruleafter}                           % Can be used to insert code before the heading

\titlespacing*{\section}{-1pt}{0pt}{0pt}

% Textview commands

\newcommand{\experience}[2]{%
  \mbox { \hspace{1em} \scshape \textbf{#1} }%
}

\newcommand{\datetext}[1]{%
{\itshape  \footnotesize \mdseries  \color{black!60!\@themecolor} #1 } 
}

\newcommand{\datedexperience}[2]{%
  \begin{small} \mbox { \hspace{1em} \scshape \textbf{#1} } \end{small} \hfill \datetext{#2}\\[0.01cm] %
}

\newcommand{\explanation}[1]{%
    \mbox { \scshape \hspace{1.2em} \footnotesize #1}\\[0.05cm]
}

\newcommand{\explanationdetail}[1]{%
    \indent \begin{minipage}{0.96\linewidth} \footnotesize #1 \end{minipage} \\[0.1cm]
}

\newcommand{\itemwithtext}[1]{%
    \begin{minipage}{\linewidth} \footnotesize \item #1 \end{minipage}
}

\newcommand{\addblocktext}[2]{%
  \section{#1} 
  \indent \explanationdetail{\hspace{4ex} #2}
}

\newcommand\createskill[2]{%
    \textsc{\textbf{#1}} & #2
}

\newcommand\createtablecontent[1]{%
    \foreach \x [count=\xi] in {#1} {\ifthenelse{\xi=1}{\x}{\\ \x}}
}

\newcommand\createskillsanothertry[1]{%not used
  \begin{tabular}{r|l}
      \createtablecontent{#1}
        \end{tabular}
}

\newcommand\createskills[1]{%
\explanationdetail{
  \begin{tabular}{rl}
    \makeatletter
    \@for\thisitem:=#1\do{\thisitem\\[0.1cm]}
    \makeatother
    \end{tabular}
}
}

\newcommand\createbullets[1]{%
    \renewcommand{\labelitemi}{\coloredbullet}
  \begin{itemize}
    \makeatletter
    \@for\thisitem:=#1\do{\itemwithtext{\thisitem}}
    \makeatother
  \end{itemize}
}

\newcommand\createfootnote{%
  \renewcommand{\footnotesize}{\fontsize{7pt}{11pt}\selectfont}
    \renewcommand\footnoterule{\rule{0.3\linewidth}{0.5pt}}
    \let\thefootnote\relax\footnote{\today\ / \href{https://github.com/magicaldave/Corley-Resume}{source code}}}
