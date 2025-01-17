\RequirePackage{gitinfo2}%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LaTeX document class: doorstop.cls
%%
%% Derived from the Standard LaTeX Book article class.
%%
%% This document class is free to use, copy, distribute,
%% and modify, as long as reference to the original author
%% is given.
%%
%% Original author: Gustav Wulf, gustav@neer.se
%%
%% Last modified by: Gustav Wulf, December 29, 2023.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ******************************************************
% Identification
% ******************************************************
\def\classversion{1.0}
\def\classdate{Dec 29, 2023}

\typeout{Document class version: \classversion}
\typeout{Last modified: \classdate}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{template/doorstop}

% ******************************************************
% Declare Options
% ******************************************************
% Do not know how to handle other options and therefore
% just pass them on to 'article'
\DeclareOption{proofing}{\def\proof{1}}
% Make sure we can do bold typewriter
\DeclareFontShape{OT1}{cmtt}{bx}{n}{<5><6><7><8><9><10><10.95><12><14.4><17.28><20.74><24.88>cmttb10}{}
% Setup the hyperref package options
\PassOptionsToPackage{bookmarks=true,%
  bookmarksopen=true,%
  pdfborder={0 0 0},%
  pdfhighlight={/N},%
  linkbordercolor={.5 .5 .5},%
  colorlinks=true,%
  urlcolor=true,%
  linkcolor=true,%
  raiselinks=true,%
  nesting=false}{hyperref}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

% ******************************************************
% Process Options
% ******************************************************
\ProcessOptions*

% ******************************************************
% Improve error finding capabilities
% ******************************************************
%\errorcontextlines 10000

% ******************************************************
% Load Used Packages and Classes
% ******************************************************
\LoadClass{article}
\RequirePackage{titletoc}
\RequirePackage{palatino}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage{multirow}
\RequirePackage{lastpage}
\RequirePackage{booktabs}
\RequirePackage{color}
\RequirePackage{listings}
\RequirePackage{tikz}
\RequirePackage{csvsimple}
\RequirePackage{xstring}
\RequirePackage[compact]{titlesec}
\RequirePackage{appendix}
\RequirePackage[yyyymmdd]{datetime}
% The following packages are REQUIRED to make the Doorstop publish functions work.
\RequirePackage{amsmath}
\RequirePackage{ulem}
\RequirePackage{longtable}
\RequirePackage{fancyvrb}
\RequirePackage{xr-hyper}
\RequirePackage[unicode,colorlinks]{hyperref}
\RequirePackage{zref-user}
\RequirePackage{zref-xr}
\RequirePackage{parskip}
\RequirePackage{pdflscape}
\RequirePackage{adjustbox}
\RequirePackage{array}
\RequirePackage{rotating}
\RequirePackage[OT1]{fontenc}
\RequirePackage{inputenc}

\edef\masterBranch{\detokenize{master}}
\edef\gitBranch{\gitBranch}

% ******************************************************
% Functions for PlantUML support.
% ******************************************************
% Define an verbatim environment for PlantUML:
\newenvironment{plantuml}[1]{\VerbatimOut{#1.txt}}{\endVerbatimOut}

% Process a PlantUML code:
\newcommand{\process}[4]{%
    % Call PlantUML to produce a svg vector graphcis:
    \immediate\write18{plantuml -tsvg #1.txt}
    % Call Inkscape to convert the svg to a pdf (pdflatex cannot use svg):
    \immediate\write18{inkscape #1.svg --export-pdf=#1.pdf}
    % Include the pdf:
	\begin{figure}[!h]
		\includegraphics[width=#2]{#1.pdf}
        \caption{#3}
		\label{fig:plant#4}\zlabel{fig:plant#4}
    \end{figure}
    % Remove all intermediate files:
    \immediate\write18{rm #1.txt #1.svg #1.pdf}
}

% ******************************************************
% Markdown Test Setup
% ******************************************************

\makeatletter
\newcount\markdownLaTeXRowCounter
\newcount\markdownLaTeXRowTotal
\newcount\markdownLaTeXColumnCounter
\newcount\markdownLaTeXColumnTotal
\newtoks\markdownLaTeXTable
\newtoks\markdownLaTeXTableAlignment
\newtoks\markdownLaTeXTableEnd

\markdownSetup{
  renderers = {
    table = {%
      \markdownLaTeXTable={}%
      \markdownLaTeXTableAlignment={}%
      \markdownLaTeXTableEnd={%
        \end{tabularx}%
      }%
      \ifx\empty#1\empty\else
        \addto@hook\markdownLaTeXTable{%
          \begin{table}
          \caption{#1}
          \centering
        }%
        \addto@hook\markdownLaTeXTableEnd{%
          \end{table}%
        }%
      \fi
      \addto@hook\markdownLaTeXTable{
        \begin{tabularx}{\linewidth}%
      }%
      \markdownLaTeXRowCounter=0%
      \markdownLaTeXRowTotal=#2%
      \markdownLaTeXColumnTotal=#3%
      \markdownLaTeXRenderTableRow
    }
  }
}

\def\markdownLaTeXRenderTableRow#1{%
  \markdownLaTeXColumnCounter=0%
  \ifnum\markdownLaTeXRowCounter=0\relax
    \markdownLaTeXReadAlignments#1%
    \markdownLaTeXTable=\expandafter\expandafter\expandafter{%
      \expandafter\the\expandafter\markdownLaTeXTable\expandafter{%
        \the\markdownLaTeXTableAlignment
      }%
    }%
    \addto@hook\markdownLaTeXTable{\hline}%
  \else
    \markdownLaTeXRenderTableCell#1%
    \addto@hook\markdownLaTeXTable{\hline}%
  \fi
  \advance\markdownLaTeXRowCounter by 1\relax
  \ifnum\markdownLaTeXRowCounter>\markdownLaTeXRowTotal\relax
    \expandafter\the\expandafter\markdownLaTeXTable
    \the\markdownLaTeXTableEnd
    \expandafter\@gobble
  \fi\markdownLaTeXRenderTableRow
}

\def\markdownLaTeXReadAlignments#1{%
  \advance\markdownLaTeXColumnCounter by 1\relax
  \if#1d%
    \addto@hook\markdownLaTeXTableAlignment{|X<{\RaggedRight}}%
  \else
    \addto@hook\markdownLaTeXTableAlignment{|#1<{\RaggedRight}}%
  \fi
  \ifnum\markdownLaTeXColumnCounter<\markdownLaTeXColumnTotal
    \relax
  \else
    \addto@hook\markdownLaTeXTableAlignment{|}%
    \expandafter\@gobble
  \fi\markdownLaTeXReadAlignments
}

\def\markdownLaTeXRenderTableCell#1{%
  \advance\markdownLaTeXColumnCounter by 1\relax
  \ifnum\markdownLaTeXColumnCounter<\markdownLaTeXColumnTotal\relax
    \addto@hook\markdownLaTeXTable{#1&}%
  \else
    \addto@hook\markdownLaTeXTable{#1\\}%
    \expandafter\@gobble
  \fi\markdownLaTeXRenderTableCell
}
\makeatother

% ******************************************************
% Start defining and redefining old article style stuff
% ******************************************************
% Setup the page margins
\setlength{\topmargin}{-2cm}
\setlength{\textwidth}{16cm}
\setlength{\textheight}{23cm}
\setlength{\evensidemargin}{-4.5mm}
\setlength{\oddsidemargin}{5.5mm}
\setlength{\intextsep}{24pt}
\setlength{\headheight}{3cm}
\setlength{\headwidth}{16cm}

% Define logotype and trim.
\newcommand{\definetrim}[2]{%
  \define@key{Gin}{#1}[]{\setkeys{Gin}{trim=#2,clip}}%
}
\def\logo{template/logo-black-white.png}
\definetrim{logotrim}{20pt 100pt 20pt 100pt}
\def\titlelogo{template/title-logo.png}

% Define the repositories href format
\def\gitlabrepo{\href{\repourl}{GitLab Repo}}
\def\githubrepo{\href{\githuburl}{GitHub Repo}}

% Sets the counting depths for TOC
\setcounter{tocdepth}{3}
\setcounter{topnumber}{4}
\setcounter{totalnumber}{5}

% Change paragraph to act as a subsubsubsection
\setcounter{secnumdepth}{4}
\titleformat{\paragraph}[hang]{\normalfont\normalsize\bfseries}{\theparagraph}{0em}{}
\titlespacing*{\paragraph}{0pt}{3.25ex plus 1ex minus .2ex}{1em}

% Setup colors
\definecolor{grey}{rgb}{0.75,0.75,0.75}
\definecolor{orchid}{rgb}{0.8516,0.4375,0.8359}

% Set internal link color
\hypersetup{%
	colorlinks=true,
	linkcolor=blue,
	urlcolor=blue,
	filecolor=blue,
	linktoc=all,
	citecolor=blue,
}

% Setup how the TOC looks
% Change TOC index to start with 0 instead of 1
\setcounter{section}{-1}
% Section
\titlecontents*{section}[0em]
	{\bfseries}
	{\thecontentslabel\hspace*{1pc}}
	{}
	{\normalfont\titlerule*[1pc]{-}\contentspage\\[1mm]}
% Subsection
\titlecontents*{subsection}[2em]
	{\normalfont\bfseries}
	{\thecontentslabel\hspace*{1pc}}
	{}
	{\titlerule*[1pc]{-}\contentspage\\[1mm]}
% Subsubsection
\titlecontents*{subsubsection}[4em]
	{\normalfont}
	{\thecontentslabel\hspace*{1pc}}
	{}
	{\titlerule*[1pc]{.}\contentspage\\}
% Paragraph (subsubsubsection)
\titlecontents*{paragraph}[6em]
	{\normalfont}
	{\thecontentslabel\hspace*{1pc}\itshape}
	{}
	{\normalfont\titlerule*[1pc]{.}\contentspage\\}

% Setup the listings package
\lstset{breaklines=true,basicstyle=\ttfamily,moredelim=[is][\bfseries]{€}{€}}

% Setup how the headings look
% Section
\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                  {\Large\bfseries}}
% Subsection
\renewcommand\subsection{\@startsection {subsection}{2}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                  {\large\bfseries}}
% Subsubsection
\renewcommand\subsubsection{\@startsection {subsubsection}{3}{\z@}%
                                   {-1ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                  {\large\bfseries}}
%% Subsubsubsection / paragraph
%\renewcommand\paragraph{\@startsection {paragraph}{4}{\z@}%
%                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
%                                   {2.3ex \@plus.2ex}%
%                                  {\large\bfseries}}


% Setup how floats are placed on the pages
\renewcommand{\topfraction}{.95}
\renewcommand{\textfraction}{.05}
\renewcommand{\floatpagefraction}{.75}


% Setup the headers and footers
% Fancy style
\pagestyle{fancy}
\fancyhf{}% Clear all settings
\fancyhead[RE,RO]{\raisebox{0.5cm}{\textsf{\begin{tabular}{p{5cm}p{2.5cm}p{3.5cm}}
\textbf{\large\doctitle} & {\footnotesize\textbf{Repository:}} &{\footnotesize\textbf{Workflow:}}\tabularnewline
\multirow{3}{5cm}[1ex]{\textit{\docdef}}&\textrm{\small\gitlabrepo} & \textrm{\small\gitBranch} \tabularnewline
&{\footnotesize\textbf{Date:}} & {\footnotesize\textbf{Commit:}}\tabularnewline
&\textrm{\small\today} & \textrm{\small\gitDescribe} \tabularnewline
\end{tabular}}}}
\fancyhead[LE,LO]{\hspace*{0cm}\includegraphics[logotrim, width=3.5cm]{\logo}}
\fancyfoot[RO]{%
	\thepage(\pageref{LastPage})
	\begin{tikzpicture}[overlay,remember picture]
		\node [rotate=-90, font=\tiny, yshift=-0.6cm, text width=9cm] at (current page.east)
		 {\claimer
		};
	\end{tikzpicture}
	}
\fancyfoot[LE]{%
	\thepage(\pageref{LastPage})
	\begin{tikzpicture}[overlay,remember picture]
		\node [rotate=90, font=\tiny, yshift=-0.6cm, text width=9cm] at (current page.west)
		 {\claimer
		};
	\end{tikzpicture}
	}
% Blankpage style
\fancypagestyle{blankpage}{ %
\fancyhf{}% Clear all settings
\renewcommand{\headrulewidth}{0pt} % remove lines as well
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[RO]{%
	\thepage(\pageref{LastPage})
	\begin{tikzpicture}[overlay,remember picture]
		\node [rotate=-90, font=\tiny, yshift=-0.6cm, text width=9cm] at (current page.east)
		 {\claimer
		};
	\end{tikzpicture}
	}
\fancyfoot[LE]{%
	\thepage(\pageref{LastPage})
	\begin{tikzpicture}[overlay,remember picture]
		\node [rotate=90, font=\tiny, yshift=-0.6cm, text width=9cm] at (current page.west)
		 {\claimer
		};
	\end{tikzpicture}
	}
\vspace*{10cm}
\Huge{\color{grey}This page was intentionally left blank.}
\vspace*{\fill}
}

% ******************************************************
% Make it easy to use appendices
% ******************************************************
\newcommand{\app}{%
\appendix%
\clearpage{\thispagestyle{blankpage}\cleardoublepage}%
}

% ******************************************************
% Generate cover page/toc etc.
% ******************************************************

\renewcommand{\maketitle}{
	\pagestyle{empty}
	\thispagestyle{empty}
	%--- Make title page
	\setcounter{page}{1}
	\begin{center}
		\includegraphics[height=3in]{\logo}\\[1mm]
		\vspace{0.5cm} \mbox{}\hrulefill \mbox{}\\[1cm]
     		{\Huge \textbf{\doctitle\\[0.5cm]}}
			{\LARGE \textit{\subtitle}}\\[0.5cm]
     		{\large \textit{\docdef}}\\[0.2cm]
            {\large \textbf{Date: }\today} \vfill
            {\large \textbf{\gitlabrepo} \textit{- Full Requirements Generation Repository}}\\[0.2cm]
            {\large \textbf{\githubrepo} \textit{- Levels 0-3 Requirements Repository}}\\[0.2cm]
			{\large \textbf{Workflow: } \gitBranch}
			{\large \textbf{ Commit:} \gitDescribe} \vfill
			{\small \textbf{Authors: } \authors} \\[0.2cm]
            {\small \textbf{Contributors: } \contributors} \vfill
     		{\large \access} \vfill
     		{\large \mbox{}\hrulefill\mbox{}\\[35mm]}
  	\end{center}
	\clearpage{\thispagestyle{blankpage}\cleardoublepage}
	\pagestyle{fancy}
}
%--- Make TOC
\newcommand{\maketoc}{
	\pagestyle{fancy}
	\thispagestyle{fancy}
  \tableofcontents
  	\clearpage{\mbox{}\thispagestyle{blankpage}\clearpage}
  	\pagestyle{fancy}
}


% ******************************************************
% Define a ToDo-command.
% ******************************************************
\newcommand{\todo}[1]{%
\noindent\textcolor{red}{\textbf{TODO:} #1}
}
