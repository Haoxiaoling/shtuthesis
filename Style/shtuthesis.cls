%---------------------------------------------------------------------------%
%-                                                                         -%
%-                           Document Class                                -%
%-                                                                         -%
%---------------------------------------------------------------------------%
%- Copyright (C) Huangrui Mo <huangrui.mo@gmail.com> 
%- This is free software: you can redistribute it and/or modify it
%- under the terms of the GNU General Public License as published by
%- the Free Software Foundation, either version 3 of the License, or
%- (at your option) any later version.
%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\ProvidesClass{shtuthesis}[2014/10/01 v1.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\DeclareOption{oneside}{%
    \PassOptionsToClass{oneside}{ctexbook}%
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{twoside}{ctexbook}%
}
\newif\ifshtu@print \shtu@printfalse
\DeclareOption{print}{%
    \PassOptionsToClass{twoside}{ctexbook}%
    \shtu@printtrue%
}
%-
%-> Language
%-
\newif\ifshtu@plain \shtu@plainfalse
\DeclareOption{scheme=plain}{% enable plain writing style
    \PassOptionsToClass{scheme=plain}{ctexbook}%
    \shtu@plaintrue%
}
%-
%-> Draft version info
%-
\newif\ifshtu@versioninfo \shtu@versioninfofalse
\DeclareOption{draftversion}{%
    \shtu@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexbook}
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{etoolbox}% a toolbox of programming facilities
\newcommand{\shtuifstreq}{\expandafter\ifstrequal\expandafter}% expansion control
\newcommand{\shtuifstrbk}{\expandafter\ifblank\expandafter}% expansion control
\RequirePackage{expl3}% LaTeX3 programming environment
\ExplSyntaxOn
\newcommand{\shtulntotab}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextend{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\ExplSyntaxOff
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/shtuthesis.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- use \topmargin insead of \voffset to shift the complete text vertically
%- use \<odd|even>sidemargin insead of \hoffset to shift text horizontally
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- binding side width + textwidth + nonbinding side width = paperwidth
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{146.6mm}% set required text width first
\setlength{\hoffset}{0mm}% set horizontal offset
\ifshtu@print% if print layout enabled
    \setlength{\oddsidemargin}{12.6mm}% binding side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{6.3mm}% left side margin
    \setlength{\evensidemargin}{6.3mm}% ensure uniform left side width for EThesis
\fi
\setlength{\marginparwidth}{35pt}% width of margin notes
\setlength{\marginparsep}{10pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{246.2mm}% set required text height first
\setlength{\voffset}{0mm}% set vertical offset
\setlength{\topmargin}{-10.4mm}% vertical margin above header
\setlength{\headheight}{12pt}% header height
\setlength{\headsep}{17.5pt}% vertical margin between header and body text
\setlength{\footskip}{10.4mm}% vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.6}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}
%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex%
    %\RequirePackage{ulem}% loaded by xeCJKfntef
\else%
    \RequirePackage{ulem}%
\fi
\newcommand{\ulunify}[1]{\uline{#1}}% unified name
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \setlength{\ULdepth}{0.3em}% set depth
    \expandafter\ulunify\expandafter{#2}% linebreak fix
}
\newcommand{\ulhshift}{-4em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> Chinese item commands
%-
\def\shtu@value@ch@confidential{}
\newcommand{\confidential}[1]{\def\shtu@value@ch@confidential{#1}}
\def\shtu@value@ch@orderid{}
\newcommand{\orderid}[1]{\def\shtu@value@ch@orderid{#1}}
\def\shtu@value@ch@classid{}
\newcommand{\classid}[1]{\def\shtu@value@ch@classid{#1}}
\def\shtu@value@ch@udc{}
\newcommand{\udc}[1]{\def\shtu@value@ch@udc{#1}}
\def\shtu@value@ch@schoollogo{}
\newcommand{\schoollogo}[2][]{\def\shtu@value@ch@schoollogo{\shtuifstrbk{#1}{\zihao{-2}\bfseries\sffamily #2}{\includegraphics[#1]{#2}}}}
\def\shtu@value@ch@title{}
\def\shtu@value@ch@titlemark{}
\renewcommand{\title}[2][\shtu@value@ch@title]{%
    \def\shtu@value@ch@title{#2}
    %\def\shtu@value@ch@titlemark{\MakeUppercase{#1}}}
    \def\shtu@value@ch@titlemark{#1}}
\def\shtu@value@ch@author{}
\renewcommand{\author}[1]{\def\shtu@value@ch@author{#1}}
\def\shtu@value@ch@advisor{}
\newcommand{\advisor}[1]{\long\def\shtu@value@ch@advisor{#1}}
\def\shtu@value@ch@advisors{}
\newcommand{\advisors}[1]{\long\def\shtu@value@ch@advisors{#1}}
\def\shtu@value@ch@degree{}
\newcommand{\degree}[1]{\def\shtu@value@ch@degree{#1}}
\def\shtu@value@ch@degreetype{}
\newcommand{\degreetype}[1]{\def\shtu@value@ch@degreetype{#1}}
\def\shtu@value@ch@subject{}
\newcommand{\subject}[1]{\def\shtu@value@ch@subject{#1}}
\def\shtu@value@ch@major{}
\newcommand{\major}[1]{\def\shtu@value@ch@major{#1}}
\def\shtu@value@ch@institute{}
\newcommand{\institute}[1]{\long\def\shtu@value@ch@institute{#1}}
\def\shtu@value@ch@school{}
\newcommand{\school}[1]{\def\shtu@value@ch@school{#1}}
\def\shtu@value@ch@orginization{}
\newcommand{\orginization}[1]{\def\shtu@value@ch@orginization{#1}}
\def\shtu@value@ch@completedate{}
\newcommand{\completedate}[1]{\def\shtu@value@ch@completedate{#1}}
\def\shtu@value@ch@submitdate{}
\newcommand{\submitdate}[1]{\def\shtu@value@ch@submitdate{#1}}
\def\shtu@value@ch@studydatefrom{}
\newcommand{\studydatefrom}[1]{\def\shtu@value@ch@studydatefrom{#1}}
\def\shtu@value@ch@studydateto{}
\newcommand{\studydateto}[1]{\def\shtu@value@ch@studydateto{#1}}
\def\shtu@value@ch@date{}
\renewcommand{\date}[1]{\def\shtu@value@ch@date{#1}}
%-
%-> English item commands
%-
\def\shtu@value@en@title{}
\def\shtu@value@en@titlemark{}
\newcommand{\TITLE}[2][\shtu@value@en@title]{%
    \def\shtu@value@en@title{#2}
    %\def\shtu@value@en@titlemark{\MakeUppercase{#1}}}
    \def\shtu@value@en@titlemark{#1}}
\def\shtu@value@en@author{}
\newcommand{\AUTHOR}[1]{\def\shtu@value@en@author{#1}}
\def\shtu@value@en@advisor{}
\newcommand{\ADVISOR}[1]{\def\shtu@value@en@advisor{#1}}
\def\shtu@value@en@degree{}
\newcommand{\DEGREE}[1]{\edef\shtu@value@en@degree{\zap@space#1 \@empty}}% expand and remove space
\def\shtu@value@en@degreetype{}
\newcommand{\DEGREETYPE}[1]{\def\shtu@value@en@degreetype{#1}}
\def\shtu@value@en@thesistype{}
\newcommand{\THESISTYPE}[1]{\def\shtu@value@en@thesistype{#1}}
\def\shtu@value@en@major{}
\newcommand{\MAJOR}[1]{\def\shtu@value@en@major{#1}}
\def\shtu@value@en@institute{}
\newcommand{\INSTITUTE}[1]{\def\shtu@value@en@institute{#1}}
\def\shtu@value@en@school{}
\newcommand{\SCHOOL}[1]{\def\shtu@value@en@school{#1}}
\def\shtu@value@en@date{}
\newcommand{\DATE}[1]{\def\shtu@value@en@date{#1}}
%-
%-> Detect and adjust items
%-
\AtEndPreamble{%
    \shtuifstreq{\shtu@value@en@degree}{Bachelor}{%
        \def\shtu@label@ch@thesis{\shtu@label@ch@thesis@bac}%
        \def\shtu@label@ch@author{\shtu@label@ch@author@bac}%
        \def\shtu@label@ch@major{\shtu@label@ch@major@bac}%
        \def\shtu@label@ch@institute{\shtu@label@ch@institute@bac}%
        \def\shtu@value@en@thesistype{\shtu@value@en@thesistype@bac}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \shtuifstreq{\shtu@value@en@degree}{Master}{%
        \def\shtu@label@ch@thesis{\shtu@label@ch@thesis@mas}%
        \def\shtu@label@ch@author{\shtu@label@ch@author@mas}%
        \def\shtu@label@ch@major{\shtu@label@ch@major@mas}%
        \def\shtu@label@ch@institute{\shtu@label@ch@institute@mas}%
        \def\shtu@value@en@thesistype{\shtu@value@en@thesistype@mas}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \shtuifstreq{\shtu@value@en@degree}{Doctor}{%
        \def\shtu@label@ch@thesis{\shtu@label@ch@thesis@doc}%
        \def\shtu@label@ch@author{\shtu@label@ch@author@doc}%
        \def\shtu@label@ch@major{\shtu@label@ch@major@doc}%
        \def\shtu@label@ch@institute{\shtu@label@ch@institute@doc}%
        \def\shtu@value@en@thesistype{\shtu@value@en@thesistype@doc}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \shtuifstreq{\shtu@value@en@degree}{Postdoctor}{%
        \def\shtu@label@ch@thesis{\shtu@label@ch@thesis@pdc}%
        \def\shtu@label@ch@author{\shtu@label@ch@author@pdc}%
        \def\shtu@label@ch@major{\shtu@label@ch@major@pdc}%
        \def\shtu@label@ch@institute{\shtu@label@ch@institute@pdc}%
        \def\shtu@value@en@thesistype{\shtu@value@en@thesistype@pdc}%
        \def\maketitle{\maketitle@pdc}
        \def\MAKETITLE{\MAKETITLE@pdc}
    }{%
        \ClassWarning{shtuthesis}{Invalid value of '\string\DEGREE', please check the spelling}%
    }}}}%
}
%-
%-> Define Chinese style
%-
\newcommand{\maketitle@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.6}
        \zihao{4}\bfseries

        \hfill{} \shtuifstrbk{\shtu@value@ch@confidential}{}{\shtu@label@ch@confidential \ulenhance{\ulextend[50pt]{\hspace*{-\ulhshift}\zihao{5}\shtu@value@ch@confidential}}}

        \vspace*{\stretch{4}}

        {\shtu@value@ch@schoollogo}

        \vspace*{\stretch{2}}

        {\zihao{1}\bfseries\sffamily {\shtu@label@ch@thesis}}

        \vspace*{\stretch{3}}

        {\zihao{-3}\bfseries\sffamily \ulenhance[1.5pt]{\shtu@value@ch@title}}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{lc}
            \shtu@label@ch@author & \ulenhance[1.2pt]{\ulextend{\shtu@value@ch@author}}\\
            \shtu@label@ch@advisor & \shtulntotab[1.2pt]{\shtu@value@ch@advisor}\\
            \shtu@label@ch@degree & \ulenhance[1.2pt]{\ulextend{\shtu@value@ch@degreetype\shtu@value@ch@degree}}\\
            \shtu@label@ch@major & \ulenhance[1.2pt]{\ulextend{\shtu@value@ch@major}}\\
            \shtu@label@ch@institute & \shtulntotab[1.2pt]{\shtu@value@ch@institute}\\
        \end{tabular}

        \vspace*{\stretch{4}}

        {\shtu@value@ch@date}

        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifshtu@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifshtu@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
    \ifshtu@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
\newcommand{\maketitle@pdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}

        \vspace*{30pt}

        \linespread{2.0}
        \zihao{4}\bfseries

        \makebox[3.0em][s]{\shtu@label@ch@classid} \ulenhance{\ulextend[6em]{\zihao{5}\shtu@value@ch@classid}} \hfill{} \shtu@label@ch@confidential \ulenhance{\ulextend[6em]{\zihao{5}\shtu@value@ch@confidential}}

        \makebox[3.0em][s]{\shtu@label@ch@udc} \ulenhance{\ulextend[6em]{\zihao{5}\shtu@value@ch@udc}} \hfill{} \shtu@label@ch@orderid \ulenhance{\ulextend[6em]{\zihao{5}\shtu@value@ch@orderid}}

        \vspace*{\stretch{6}}

        {\ziju{1.5}\shtu@value@ch@schoollogo}

        \vspace*{\stretch{1}}

        {\zihao{-2}\bfseries\sffamily{\ziju{0.5} \shtu@label@ch@thesis}}

        \vspace*{\stretch{3}}

        {\zihao{-3}\bfseries\sffamily \ulenhance[1.5pt]{\shtu@value@ch@title}}

        \vspace*{\stretch{2.5}}

        \shtu@value@ch@author

        \vspace*{\stretch{2.5}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{l@{\quad}c}
            \shtu@label@ch@completedate & \ulenhance{\ulextend[200pt]{\shtu@value@ch@completedate}}\\
            \shtu@label@ch@submitdate & \ulenhance{\ulextend[200pt]{\shtu@value@ch@submitdate}}\\
        \end{tabular}

        \vspace*{\stretch{2}}

        \shtu@value@ch@institute

        \shtu@value@ch@date

        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
    \ifshtu@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
%-
%-> Define English style
%-
\newcommand{\MAKETITLE@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.6}
        \zihao{4}\bfseries

        \vspace*{50pt}

        {\zihao{-3}\bfseries \ulenhance[1.5pt]{\shtu@value@en@title}}

        \vspace*{\stretch{3}}

        {\shtu@label@en@statement}

        {By}

        {\shtu@value@en@author}

        {\shtu@value@en@advisor}

        \vspace*{\stretch{3}}

        {\shtu@value@en@institute}

        \vspace*{\stretch{1}}

        {\shtu@value@en@date}

        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
\newcommand{\MAKETITLE@pdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{2.0}
        \zihao{4}\bfseries

        \vspace*{50pt}

        {\zihao{3}\bfseries \shtu@value@ch@title}

        \vspace*{\stretch{3}}

        {\zihao{-3}\bfseries \shtu@value@en@title}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{l@{\quad}l}
            \makebox[11em][s]{\shtu@label@ch@author} & \shtu@value@ch@author\\
            \makebox[11em][s]{\shtu@label@ch@subject} & \shtu@value@ch@subject\\
            \makebox[11em][s]{\shtu@label@ch@major} & \shtu@value@ch@major\\
        \end{tabular}

        \vspace*{\stretch{3}}

        \shtu@label@ch@studydatefrom \quad \shtu@value@ch@studydatefrom

        \shtu@label@ch@studydateto \quad \shtu@value@ch@studydateto

        \vspace*{\stretch{3}}

        \shtu@value@ch@orginization

        \shtu@value@ch@date

        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> Author's declaration
%---------------------------------------------------------------------------%
\newcommand{\makedeclaration}{%
    \cleardoublepage
    \thispagestyle{empty}
    {
        \linespread{1.6}
        \zihao{-4}

        \vspace*{2ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \shtu@label@ch@declare@creativity}
        \end{center}

        {\shtu@value@ch@declare@creativity}

        \vspace*{3ex}

        {\hfill{} {\shtu@label@ch@declare@author \hspace*{14em}}}

        {\hfill{} {\shtu@label@ch@declare@date \hspace*{14em}}}

        \vspace*{6ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \shtu@label@ch@declare@rights}
        \end{center}

        {\shtu@value@ch@declare@rights}

        {\shtu@value@ch@declare@rule}

        \vspace*{3ex}

        {\hfill{} {\shtu@label@ch@declare@author \hspace*{10em} \shtu@label@ch@declare@advisor \hspace*{9em}}}

        {\hfill{} {\shtu@label@ch@declare@date \hspace*{10em} \shtu@label@ch@declare@date \hspace*{9em}}}

        \vspace*{3ex}
    }
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> New environments
%---------------------------------------------------------------------------%
%- define chinese keywords
\newcommand{\keywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \shtu@label@ch@keywords} #1}
%- define engish keywords
\newcommand{\KEYWORDS}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \shtu@label@en@keywords} #1}
%---------------------------------------------------------------------------%
%->> Structure elements
%---------------------------------------------------------------------------%
\ifshtu@plain%
    \def\contentsname{\shtu@label@en@tocname}
    \def\listfigurename{\shtu@label@en@lsfigname}
    \def\listtablename{\shtu@label@en@lstabname}
    \def\bibname{\shtu@label@en@bibname}
    \def\refname{\shtu@label@en@bibname}
    \def\algname{\shtu@label@en@algname}
    \def\bibetal{\shtu@label@en@bibetal}
    \def\biband{\shtu@label@en@biband}
    \def\axiomname{\shtu@label@en@axiomname}
    \def\theoremname{\shtu@label@en@theoremname}
    \def\lemmaname{\shtu@label@en@lemmaname}
    \def\corollaryname{\shtu@label@en@corollaryname}
    \def\assertionname{\shtu@label@en@assertionname}
    \def\propositionname{\shtu@label@en@propositionname}
    \def\conjecturename{\shtu@label@en@conjecturename}
    \def\definitionname{\shtu@label@en@definitionname}
    \def\examplename{\shtu@label@en@examplename}
    \def\remarkname{\shtu@label@en@remarkname}
    \def\proofname{\shtu@label@en@proofname}
    \def\@title{\shtu@value@en@titlemark}
    \def\@author{\shtu@value@en@author}
\else
    \def\contentsname{\shtu@label@ch@tocname}
    \def\listfigurename{\shtu@label@ch@lsfigname}
    \def\listtablename{\shtu@label@ch@lstabname}
    \def\algname{\shtu@label@ch@algname}
    \def\bibname{\shtu@label@ch@bibname}
    \def\refname{\shtu@label@ch@bibname}
    \def\bibetal{\shtu@label@ch@bibetal}
    \def\biband{\shtu@label@ch@biband}
    \def\axiomname{\shtu@label@ch@axiomname}
    \def\theoremname{\shtu@label@ch@theoremname}
    \def\lemmaname{\shtu@label@ch@lemmaname}
    \def\corollaryname{\shtu@label@ch@corollaryname}
    \def\assertionname{\shtu@label@ch@assertionname}
    \def\propositionname{\shtu@label@ch@propositionname}
    \def\conjecturename{\shtu@label@ch@conjecturename}
    \def\definitionname{\shtu@label@ch@definitionname}
    \def\examplename{\shtu@label@ch@examplename}
    \def\remarkname{\shtu@label@ch@remarkname}
    \def\proofname{\shtu@label@ch@proofname}
    \def\@title{\shtu@value@ch@titlemark}
    \def\@author{\shtu@value@ch@author}
\fi
%---------------------------------------------------------------------------%
%->> Structure layout
%---------------------------------------------------------------------------%
%- chapter
\ctexset {
    chapter = {
        format = \linespread{1.0}\zihao{4}\bfseries\sffamily\centering,
        nameformat = {},
        titleformat = {},
        number = \arabic{chapter},
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {7pt},
        afterskip = {18pt},
        pagestyle = plain,
    }
}
%- section
\ctexset {
    section = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {24pt},
        afterskip = {6pt},
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- appendix
\ctexset {
    appendix = {
        %numbering = true|false,
        %number = \rmfamily\Alph{chapter},
    }
}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- the table of contents is specified by defining \l@chapter, \l@section, ...
%- most commands are then defined with the \@dottedtocline:
%- \@dottedtocline{⟨level⟩}{⟨indent⟩}{⟨numwidth⟩}{⟨title⟩}{⟨page⟩}
%- ⟨level⟩    an entry is produced only if ⟨level⟩ <= value of the tocdepth counter
%-            note, \chapter is level 0, \section is level 1, etc
%- ⟨indent⟩   indentation from the outer left margin of the start of the contents line
%- ⟨numwidth⟩ width of a box in which the section number is to go
%- <title>    title
%- <page>     page number

%- parameters for spacing and length in toc
\def\@dotsep{1.5mu}% separation between dots in mu units
\def\@pnumwidth{2em}% width of a box in which the page number is put
\def\@tocrmarg{2em}% right margin for multiple line entries, \@tocrmarg ≥ \@pnumwidth
\def\@chaptervspace{1ex}% vertical space between chapter titles

%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from book.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty{-\@highpenalty}%
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{4}\sffamily #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \global\@nobreaktrue
            \everypar{\global\@nobreakfalse\everypar{}}%
        \endgroup
    \fi
}
%- redefine l@chapter from book.cls to add dotted toc line
\renewcommand*{\l@chapter}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{4}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}
%- redefine indentation for others
\renewcommand*\l@section{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2em}{2.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{3em}{3.8em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{4em}{4.8em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{5em}{5.8em}}
\renewcommand*\l@figure{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@table{\@dottedtocline{1}{1em}{1.8em}}
%---------------------------------------------------------------------------%
\endinput

