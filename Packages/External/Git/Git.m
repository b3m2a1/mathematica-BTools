(* ::Package:: *)



(* ::Subsection:: *)
(*Git*)



GitRun::usage="processRunDupe wrapper for git";
$GitRunFlags::usage="A collection of flags for GitRun";
$GitParamMap::usage="Parameter map for Git";
GitRegisterFunction::usage="Registers a Git function";
$GitLogCommands::usage="";
$GitCommandLog::usage="";


(* ::Subsubsection::Closed:: *)
(*Create*)



GitCreate::usage="Creates a new repository";
GitInit::usage="Initializes a git repository";
GitClone::usage="Clones a repository";


(* ::Subsubsection::Closed:: *)
(*Edit*)



GitIgnore::usage="Adds to the .gitignore file for a directory";
GitAdd::usage="Adds a file to the staging area of a  git repository";
GitCommit::usage="Runs the commit command, using -a by default";


(* ::Subsubsection::Closed:: *)
(*Config/Status*)



GitStatus::usage="Gets the status of a repository";
GitListTree::usage="Lists files on the tree";
GitListTreeRecursive::usage="Lists files on the tree recursively";
GitLog::usage="Gets the log of the git repo";
GitConfig::usage="Sugar on the GitConfig tool";
GitHelp::usage="Gets help from the git man pages";


(* ::Subsubsection::Closed:: *)
(*Remotes and branching*)



GitListRemotes::usage=
  "git remote -v show command";
GitAddRemote::usage=
  "git remote add origin command";
GitRemoveRemote::usage=
  "Removes remote";
GitFetch::usage="git fetch";
GitPush::usage="git push";
GitPushOrigin::usage="git push origin master";
GitPull::usage="git pull";
GitPullOrigin::usage="git pull origin master";
GitBranch::usage="git branch";
GitShowBranch::usage="git show branch";


(* ::Subsubsection::Closed:: *)
(*Repo finding*)



GitRepositories::usage="Finds all the directories that support a git repo";
$GitRepo::usage="The current git repo";
GitRepo::usage=
  "Returns: 
the arg if it is a repo, 
a github URL if the arg is github:<repo>, 
else None";
GitRepoQ::usage=
  "Returns true if the thing is a directory with a .git file";


(* ::Subsubsection::Closed:: *)
(*Git*)



$GitActions::usage=
  "The known actions for Git";


Begin["`Private`"];


(* ::Subsection:: *)
(*Constants*)



(* ::Subsubsection::Closed:: *)
(*GitRepo*)



If[Not@MatchQ[$GitRepo,_String?DirectoryQ],
  $GitRepo=None
  ];


(* ::Subsection:: *)
(*Git*)



(* ::Subsubsection::Closed:: *)
(*processRunCopy*)



(* ::Text:: *)
(*An exact duplicate of ProcessRun to make this stand-alone*)



processRunDupe::pnfd="Program `` not found. 
$PATH = ``
$PWD = ``";
processRunDupe::fail="Process failed to run: ``"; 
processRunDupe::err="\nError in command \"``\":\n``";
processRunDupe~SetAttributes~HoldRest;


Options[processRunDupe]=
  Join[Options[RunProcess],{
    "ErrorHandler"->Automatic,
    "ParseFunction"->Identity
    }];
processRunDupe[cmds:{__},
  errorMessage:Except[_?OptionQ|_FilterRules]:processRunDupe::err,
  ops:OptionsPattern[]
  ]:=
  Block[{capturedMessages={}},
    With[{r=
      GeneralUtilities`WithMessageHandler[
        RunProcess[cmds,
          FilterRules[{ops},Options@RunProcess]
          ],
        AppendTo[capturedMessages,#]&
        ],
      parseFunction=
        OptionValue["ParseFunction"],
      errorHander=
        Replace[OptionValue["ErrorHandler"],
          Automatic->
            Function[Null,
              Message[#,
                StringJoin@Riffle[cmds," "],
                #2
                ],
              HoldFirst
              ]
          ]
      },
      If[r=!=$Failed,
        parseFunction@Replace[
          StringTrim[r["StandardOutput"]<>"\n"<>r["StandardError"]],
          ""->Null
          ],
        Message[processRunDupe::fail,
          StringJoin@Riffle[
            Replace[cmds,
              (k_->v_):>
                (ToString@k<>"=="<>ToString@v),
              1],
            " "]
          ];
        Replace[capturedMessages,
          Failure[RunProcess,<|
            "MessageTemplate":>
              RunProcess::pnfd,
            "MessageParameters" -> pars_
            |>]:>(
              Message[processRunDupe::pnfd,
                Sequence@@Join[pars,
                  StringTrim@
                    RunProcess[{$SystemShell,"-c","echo $PATH"},"StandardOutput"],
                  StringTrim@
                    RunProcess[{$SystemShell,"-c","echo $PWD"},"StandardOutput"]
                  ]
                ];
              ),
          1];
        $Failed
        ]
      ]
    ];
processRunDupe[s_String,
  errorMessage:_MessageName:processRunDupe::err,
  ops:OptionsPattern[]]:=
  processRunDupe[{s},errorMessage,ops];


(* ::Subsubsection::Closed:: *)
(*GitRun*)



If[!AssociationQ@$GitRunFlags,
  $GitRunFlags=
    <|
      "LogCommands"->False,
      "ReturnCommand"->False
      |>
  ];


If[!ListQ@$GitCommandLog, $GitCommandLog={}];


gitDoInDir[dir_String?DirectoryQ,cmd_]:=
  With[{d=ExpandFileName@dir},
      SetDirectory@d;
      With[{r=cmd},
        ResetDirectory[];
        r
        ]
      ];
gitDoInDir~SetAttributes~HoldRest;


processRunDupe;
Git::err=processRunDupe::err;


GitRun//Clear


GitRun[
  dir:_String?DirectoryQ|None|Automatic:None,
  cmd1_String?(Not@*DirectoryQ),
  cmd2___String
  ]:=
  With[{d=Replace[dir,Automatic:>$GitRepo]},
    Replace[
      Git::err,
      _MessageName:>
        (Git::err=processRunDupe::err)
      ];
    If[MatchQ[d,_String],
      With[{
        cmd=
          {
            "git",
            Sequence@@Replace[$GitBaseOptionArgs, Except[_?OptionQ]->{}],
            cmd1, 
            cmd2
            }//
            Map[If[FileExistsQ@#, ExpandFileName@#, #]&]
        },
        If[TrueQ@$GitRunFlags["ReturnCommand"],
          cmd,
          If[$GitRunFlags["LogCommands"], AppendTo[$GitCommandLog, cmd]];
          processRunDupe[
            cmd,
            Git::err, 
            ProcessDirectory->ExpandFileName@d
            ]
          ]
        ],
      With[{cmd={"git", cmd1, cmd2}},
        If[TrueQ@$GitRunFlags["ReturnCommand"],
          cmd,
          If[$GitRunFlags["LogCommands"], AppendTo[$GitCommandLog, cmd]];
          processRunDupe[
            cmd, 
            Git::err
            ]
          ]
        ]
      ]
    ];
GitRun[
  dir:_String?DirectoryQ|None|Automatic:None,
  cmd1:_String?(Not@*DirectoryQ)|{__String},
  cmd2:_String|{__String}...
  ]:=
  With[{
    d=Replace[dir,Automatic:>$GitRepo],
    cmdBits=
      Flatten[
        Riffle[
          Join[
            {"git", Sequence@@Replace[$GitBaseOptionArgs, Except[_?OptionQ]->{}]},
            Flatten@{#}
            ]&/@{cmd1, cmd2},"\n\n"],
        1
        ]//
        Map[If[FileExistsQ@#, ExpandFileName@#, #]&]
    },
    Replace[
      Git::err,
      _MessageName:>
        (Git::err=processRunDupe::err)
      ];
    If[TrueQ@$GitRunFlags["ReturnCommands"],
      cmdBits,
      If[$GitRunFlags["LogCommands"], AppendTo[$GitCommandLog, cmdBits]];
      If[MatchQ[d,_String],
        processRunDupe[
          cmdBits,
          Git::err,
          ProcessDirectory->ExpandFileName@d
          ],
        processRunDupe[
          cmdBits,
          Git::err
          ]
        ]
      ]
    ];
Git::nodir="`` is not a valid directory";
Git::nrepo="`` not a git repository";


(* ::Subsubsection::Closed:: *)
(*GitPrepParams*)



$GitParamMap=<||>;


GitPrepType//Clear
GitPrepType[n_?NumericQ]:=
  ToString[n];
GitPrepType[n_?DateObjectQ]:=
  ToString@UnixTime[n];
GitPrepType[q_Quantity]:=
  ToString@
    QuantityMagnitude@
      If[CompatibleUnitQ[q, "Seconds"], 
        UnitConvert[q, "Seconds"],
        q
        ];
GitPrepType[l_List]:=
  StringRiffle[GitPrepType/@l, ","];
GitPrepType[e_]:=e;


GitPrepParamVals[ops_]:=
  Replace[
    ops,
    {
      (h:Rule|RuleDelayed)[s_String, o_]:>
        s->GitPrepType[o]
      },
    1
    ];
GitPrepParams[ops_, map_]:=
  Replace[
    GitPrepParamVals@Flatten@Normal@{ops},
    {
      (Rule|RuleDelayed)[s_String, True]:>
        Replace[
          Lookup[map, s, None],
          {
            p_String?(StringLength[#]==1&):>
              "-"<>p,
            p_String:>
              "--"<>p,
            {p_String, join_String}:>
              "--"<>p<>join<>"true",
            _->Nothing
            }
          ],
      (Rule|RuleDelayed)[s_String, v_String]:>
        Replace[
          Lookup[map, s, None],
          {
            p_String?(StringLength[#]==1&):>
              Sequence@@{"-"<>p, v},
            p_String:>
              "--"<>p<>"="<>v,
            {p_String, join_String}:>
              "--"<>p<>join<>v,
            _->Nothing
            }
          ],
      _->Nothing
      },
    1
    ];
GitPrepParams[fn_, ops_, map_]:=
  With[{baseOps=Flatten@{ops}},
    GitPrepParams[
      DeleteDuplicatesBy[First]@
        Flatten[{baseOps, Options@fn}], 
      map
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*GitRegisterFunction*)



GitRegisterFunction//Clear
GitRegisterFunction[
  sym_Symbol, 
  cmd:{__String},
  map_?OptionQ,
  joinOps:_List?OptionQ:{},
  fn:_Symbol:GitRun
  ]:=
  With[
    {
      main=ToLowerCase[First@cmd],
      rest=Sequence@@Map[ToLowerCase, Rest@cmd],
      big=ToUpperCase[StringTake[#, 1]]<>StringDrop[#, 1]&/@Map[ToLowerCase, cmd]
      },
    $GitParamMap[big]=map;
    Options[sym]=
      DeleteDuplicatesBy[
        Join[
          joinOps,
          Thread[Keys@$GitParamMap[big]->Automatic]
          ],
        First
        ];
    sym[
      dir:_String?DirectoryQ|Automatic:Automatic,
      args___String,
      ops:OptionsPattern[]
      ]:=
      fn[
        dir,
        main,
        rest,
        Sequence@@
          GitPrepParams[
            sym,
            {ops}, 
            $GitParamMap[big]
            ],
        args
        ]
    ];
GitRegisterFunction[
  sym_Symbol, 
  cmd_String,
  map_?OptionQ,
  joinOps:_List?OptionQ:{},
  fn:_Symbol:GitRun
  ]:=
  GitRegisterFunction[sym, {cmd}, map, joinOps]
GitRegisterFunction[
  sym_Symbol, 
  map_?OptionQ,
  joinOps:_List?OptionQ:{},
  fn:_Symbol:GitRun
  ]:=
  GitRegisterFunction[
    sym,
    ToLowerCase@StringTrim[SymbolName[sym], "Git"],
    map,
    joinOps
    ]


(* ::Subsubsection::Closed:: *)
(*GitRepoQ*)



GitRepoQ[d:(_String|_File)?DirectoryQ]:=
  DirectoryQ@FileNameJoin@{d,".git"};
GitRepoQ[_]:=False


(* ::Subsubsection::Closed:: *)
(*GitAddGitIgnore*)



GitAddGitIgnore[
  dirB:_String?DirectoryQ|Automatic:Automatic,
  patterns:_String|{__String}:
    {
      ".DS_Store"
      }
  ]:=
  With[
    {dir=Replace[dirB, Automatic:>Directory[]]},
    If[GitRepoQ@dir,
      With[{f=OpenWrite[FileNameJoin@{dir,".gitignore"}]},
        WriteLine[f,
          StringJoin@Riffle[Flatten@{patterns},"\n"]
          ];
        Close@f
        ],
      $Failed
      ]
    ];


(* ::Subsubsection::Closed:: *)
(*GitAddGitExclude*)



GitAddGitExclude[
  dirB:_String?DirectoryQ|Automatic:Automatic,
  patterns:_String|{__String}:{"*.DS_Store"}
  ]:=
  With[
    {dir=Replace[dirB, Automatic:>Directory[]]},
    If[GitRepoQ@dir,
      If[Not@DirectoryQ@FileNameJoin@{dir,".git","info"},
        CreateDirectory[FileNameJoin@{dir,".git","info"}]
        ];
      With[{f=OpenWrite[FileNameJoin@{dir,".git","info","exclude"}]},
        WriteLine[f,
          StringJoin@Riffle[Flatten@{patterns},"\n"]
          ];
        Close@f
        ],
      $Failed
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*GitInit*)



GitCreate[dir_String?(DirectoryQ@*DirectoryName)]:=
  With[{d=ExpandFileName@dir},
    Quiet@CreateDirectory@d;
    GitInit[d]
    ];


$GitParamMap["Init"]=
  {
    "Quiet"->"quiet",
    "Bare"->"bare",
    "Template"->"template",
    "SeparateGitDir"->"separate-git-dir",
    "Shared"->"shared"
    };
Options[GitInit]=
  Thread[Keys@$GitParamMap["Init"]->Automatic];
GitInit[
  dir:_String?DirectoryQ|Automatic:Automatic,
  ignorePats:{___String}|None:None,
  excludePats:{___String}|None:None,
  ops:OptionsPattern[]
  ]:=
  With[
  {
    r=
      GitRun[dir, 
        Sequence@@
            GitPrepParams[
              GitInit,
              {ops}, 
              $GitParamMap["Init"]
              ],
        "init"
        ]
    },
    If[ignorePats=!=None, 
      GitAddGitIgnore[dir, ignorePats]
      ];
    If[excludePats=!=None,
      GitAddGitExclude[dir, excludePats];
      ];
    r
    ]


(* ::Subsubsection::Closed:: *)
(*GitClone*)



GitClone//Clear


$GitParamMap["Clone"]=
  {
    "Local"->"local",
    "NoHardlinks"->"no-hardlinks",
    "Shared"->"shared",
    "Reference"->"reference",
    "Dissociate"->"dissociate",
    "Quiet"->"quiet",
    "Verbose"->"verbose",
    "Progress"->"progress",
    "NoCheckout"->"no-checkout",
    "Bare"->"bare",
    "Mirror"->"mirror",
    "Origin"->"origin",
    "Branch"->"branch",
    "UploadPack"->"upload-pack",
    "Template"->"template",
    "Config"->"config",
    "Depth"->"depth",
    "ShallowSince"->"shallow-since",
    "ShallowExclude"->"shallow-exclude",
    "SingleBranch"->"single-branch",
    "NoSingleBranch"->"no-single-branch",
    "NoTags"->"no-tags",
    "RecurseSubmodules"->"recurse-submodules",
    "ShallowSubmodules"->"shallow-submodules",
    "NoShallowSubmodules"->"no-shallow-submodules",
    "SeparateGitDir"->"separate-git-dir",
    "Jobs"->"jobs"
    };


Options[GitClone]=
  Join[
    Thread[Keys[$GitParamMap["Clone"]]->Automatic],
    {
      OverwriteTarget->False
      }
    ];
GitClone[
  repo:_String|_File|_URL,
  dir:_String|_File|Automatic:Automatic,
  overwriteTarget:True|False|Automatic:Automatic,
  o___?OptionQ
  ]:=
  With[{
    r=
      Replace[repo,
        {
          File[d_]:>
            If[GitRepoQ@d,
              d,
              GitRepo
              ],
          URL[d_]:>
            d
          }
        ],
    d=
      Replace[dir,
        Automatic:>
          FileNameJoin@
            {
              $TemporaryDirectory,
              Switch[repo,
                _String|_File,
                  FileBaseName@repo,
                _URL,
                  URLParse[repo,"Path"][[-1]]
                ]
              }
        ]
      },
    If[TrueQ@$GitRunFlags["ReturnCommand"],
      GitRun[dir, "clone", r, d,
        Sequence@@
          GitPrepParams[
            GitClone,
            {o}, 
            $GitParamMap["Clone"]
            ]
        ],
      If[TrueQ[overwriteTarget]||
        (overwriteTarget===Automatic&&TrueQ@Lookup[Flatten@{o}, OverwriteTarget]),
        Quiet@DeleteDirectory[d,DeleteContents->True]
        ];
      If[!DirectoryQ@d,
        CreateDirectory[d, CreateIntermediateDirectories->True];
        GitRun[dir, "clone", r, d,
          Sequence@@
            GitPrepParams[
              GitClone,
              {o}, 
              $GitParamMap["Clone"]
              ]
          ];
        d,
        $Failed
        ]
      ]
    ];


(* ::Subsubsection::Closed:: *)
(*GitIgnore*)



GitIgnore[dir:_String?DirectoryQ|Automatic:Automatic,filePatterns:{___}]:=
  With[{d=Replace[dir,Automatic:>$GitRepo]},
    If[MatchQ[d,_String?DirectoryQ],
      With[{file=OpenAppend@FileNameJoin@{d,".gitignore"}},
        Do[
          WriteLine[file,f],
          {f,filePatterns}
          ];
        Close@file;
        GitRun[d,"add",".gitignore"]
        ],
      Message[GitRun::nodir,d];$Failed
      ]
    ];


(* ::Subsubsection::Closed:: *)
(*GitAdd*)



GitRegisterFunction[GitAdd, "add",
  {
    "All"->"A",
    "NoAll"->"no-all",
    "DryRun"->"dry-run",
    "Verbose"->"verbose",
    "Force"->"force",
    "Interactive"->"interactive",
    "Patch"->"patch",
    "Edit"->"edit",
    "Update"->"update",
    "IgnoreRemoval"->"ignore-removal",
    "IntentToAdd"->"intent-to-add",
    "Refresh"->"refresh",
    "IgnoreErrors"->"ignore-errors",
    "IgnoreMissing"->"ignore-missing",
    "NoWarnEmbeddedRepo"->"no-warn-embedded-repo",
    "ChangeMode"->"chmod"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitMove*)



GitRegisterFunction[GitMove, 
  "mv",
  {
    "Force"->"force",
    "IgnoreErrors"->"k",
    "DryRun"->"dry-run",
    "Verbose"->"verbose"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitRemove*)



GitRegisterFunction[GitRemove,
 "rm",
  {
    "Force"->"force",
    "DryRun"->"dry-run",
    "Recursive"->"r",
    "Cached"->"cached",
    "IgnoreUnmatch"->"ignore-unmatch",
    "Quiet"->"quiet"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitRemoveRecursive*)



Options[GitRemoveRecursive]=
  Options[GitRemove]
GitRemoveRecursive[
  dir:_String?DirectoryQ|Automatic:Automatic,
  args___String,
  ops:OptionsPattern[]
  ]:=
  GitRemove[dir, args, "Recursive"->True, ops]


(* ::Subsubsection::Closed:: *)
(*GitRemoveCached*)



Options[GitRemoveCached]=
  Options[GitRemove]
GitRemoveCached[
  dir:_String?DirectoryQ|Automatic:Automatic,
  args___String,
  ops:OptionsPattern[]
  ]:=
  GitRemove[dir, args, "Cached"->True, ops]


(* ::Subsubsection::Closed:: *)
(*GitRemoveCachedRecursive*)



Options[GitRemoveCachedRecursive]=
  Options[GitRemove]
GitRemoveCachedRecursive[
  dir:_String?DirectoryQ|Automatic:Automatic,
  args___String,
  ops:OptionsPattern[]
  ]:=
  GitRemove[dir, args, "Recursive"->True, "Cached"->True, ops]


(* ::Subsubsection::Closed:: *)
(*GitCommit*)



GitRegisterFunction[
  GitCommit,
  "commit",
  {
    "All"->"all",
    "Patch"->"patch",
    "ReuseMessage"->"reuse-message",
    "ReeditMessage"->"reedit-message",
    "FixUp"->"fixup",
    "Squash"->"squash",
    "ResetAuthor"->"reset-author",
    "Short"->"short",
    "Branch"->"branch",
    "Porcelain"->"porcelain",
    "Long"->"long",
    "Null"->"null",
    "File"->"file",
    "Author"->"author",
    "Date"->"date",
    "Message"->"message",
    "Template"->"template",
    "Signoff"->"signoff",
    "NoVerify"->"no-verify",
    "AllowEmpty"->"allow-empty",
    "AllowEmptyMessage"->"allow-empty-message",
    "Cleanup"->"cleanup",
    "Edit"->"edit",
    "NoEdit"->"no-edit",
    "Amend"->"amend",
    "NoPostRewrite"->"no-post-rewrite",
    "Include"->"include",
    "Only"->"only",
    "UntrackedFiles"->"untracked-files",
    "Verbose"->"verbose",
    "Quiet"->"quiet",
    "DryRun"->"dry-run",
    "Status"->"status",
    "NoStatus"->"no-status",
    "GpgSign"->"gpg-sign",
    "NoGpgSign"->"no-gpg-sign"
    },
  {
    "Message"->"Commited via Mathematica"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitLog*)



GitLog//Clear


GitRegisterFunction[
  GitLog,
  "log",
  SortBy[First]@
  {
    "Follow"->"follow",
    "Decorate"->"decorate",
    "Source"->"source",
    "UseMailmap"->"use-mailmap",
    "FullDiff"->"full-diff",
    "LogSize"->"log-size",
    "TraceLines"->"L",
    "MaxCount"->"max-count",
    "Skip"->"skip",
    "Since"->"since",
    "Before"->"before",
    "Committer"->"committer",
    "GrepReflog"->"grep-reflog",
    "Grep"->"grep",
    "AllMatch"->"all-match",
    "InvertGrep"->"invert-grep",
    "RegexpIgnoreCase"->"regexp-ignore-case",
    "BasicRegexp"->"basic-regexp",
    "ExtendedRegexp"->"extended-regexp",
    "FixedStrings"->"fixed-strings",
    "PerlRegexp"->"perl-regexp",
    "RemoveEmpty"->"remove-empty",
    "Merges"->"merges",
    "NoMerges"->"no-merges",
    "MinParents"->"min-parents",
    "MaxParents"->"max-parents",
    "NoMinParents"->"no-max-parents",
    "NoMaxParents"->"no-max-parents",
    "FirstParent"->"first-parent",
    "Bisect"->"bisect",
    "Not"->"not",
    "All"->"all",
    "Branches"->"branches",
    "Tags"->"tags",
    "Remotes"->"remotes",
    "Glob"->"glob",
    "Exclude"->"exclude",
    "Reflog"->"reflog",
    "IgnoreMissing"->"ignore-missing",
    "Stdin"->"stdin",
    "CherryMark"->"cherry-mark",
    "CherryPick"->"cherry-pick",
    "RightOnly"->"right-only",
    "Cherry"->"cherry",
    "WalkReflogs"->"walk-reflogs",
    "Merge"->"merge",
    "Boundary"->"boundary",
    "SimplifyByDecoration"->"simplify-by-decoration",
    "FullHistory"->"full-history",
    "Dense"->"dense",
    "Sparse"->"sparse",
    "SimplifyMerges"->"simplify-merges",
    "AncestryPath"->"ancestry-path",
    "DateOrder"->"date-order",
    "AuthorDateOrder"->"author-date-order",
    "TopoOrder"->"topo-order",
    "Reverse"->"reverse",
    "NoWalk"->"no-walk",
    "DoWalk"->"do-walk",
    "Pretty"->"pretty",
    "AbbrevCommit"->"abbrev-commit",
    "NoAbbrevCommit"->"no-abbrev-commit",
    "Oneline"->"oneline",
    "Encoding"->"encoding",
    "ExpandTabs"->"expand-tabs",
    "Notes"->"notes",
    "NoNotes"->"no-notes",
    "ShowNotes"->"show-notes",
    "ShowSignature"->"show-signature",
    "RelativeDate"->"relative-date",
    "Date"->"date",
    "Parents"->"parents",
    "Children"->"children",
    "LeftRight"->"left-right",
    "Graph"->"graph",
    "ShowLinearBreak"->"show-linear-break",
    "Compress"->"c",
    "CompressComplete"->"cc",
    "ShowMergeDiffs"->"m",
    "Recursive"->"r",
    "ShowTree"->"t",
    "Stat"->"stat"
    }
  ]


(* ::Subsubsection::Closed:: *)
(*GitLogDataset*)



(* ::Text:: *)
(*Assumes commit has already been stripped*)



GitLogPostProcess[ass_]:=
  With[
    {
      date=
        With[{dateBits=StringSplit[StringTrim@ass["Date"]]},
          DateObject[
            StringRiffle[Most[dateBits]],
            TimeZone->
              (ToExpression[Last@dateBits]/100)
            ]
          ]
      },
    ReplacePart[ass,
      "Date"->date
      ]
    ]


GitLogParsePiece[str_String]:=
  Module[
    {
      commit,
      body,
      head,
      headParams,
      message,
      messageBits,
      files=None
      },
    {commit, body}=
      StringSplit[str, "\n", 2];
    {head, message}=
      StringSplit[body, "\n\n", 2];
    If[StringContainsQ[message, StartOfLine~~" "~~WordCharacter],
      messageBits=StringSplit[message, "\n\n"];
      files=
        StringCases[
          Last@messageBits, 
          StartOfLine~~" "~~fil:Except[WhitespaceCharacter]..~~Whitespace~~"|":>
            fil
          ];
      message=StringRiffle[Most@messageBits, "\n\n"]
      ];
    headParams=
      StringCases[
          head,
          StartOfLine~~tag:WordCharacter..~~":"~~val:Except["\n"]..:>
            (tag->val)
          ];
    GitLogPostProcess@Association@
      {
        "Commit"->commit,
        "Message"->StringTrim@message,
        headParams,
        "Files"->
          If[files===None, 
            Missing["NotAvailable"],
            files
            ]
        }
    ];


Options[GitLogDataset]=
  Options[GitLog];
GitLogDataset[args___]:=
  With[{str=Replace[GitLog[args], Null->""]},
    Dataset[
      GitLogParsePiece/@
        StringSplit[str, StartOfLine~~"commit "]
      ]/;StringQ@str
    ]


(* ::Subsubsection::Closed:: *)
(*GitFileHistory*)



GitFileHistory//Clear


Options[GitFileHistory]=
  Options[GitLogDataset]
GitFileHistory[
  args__,
  fpat:_?StringPattern`StringPatternQ:"*",
  ops:OptionsPattern[]
  ]:=
  With[
    {
      ds=
        Normal@
          GitLogDataset[
            args,
            If[!StringQ@fpat, 
              First@StringPattern`PatternConvert[fpat], 
              fpat
              ],
            ops,
            "Stat"->True
            ]
      },
    Dataset@GroupBy[
      Flatten@
        Map[
          With[{files=Replace[#Files, _Missing:>{}], rest=KeyDrop[#, "Files"]}, 
            Map[#->rest&, files]
            ]&,
          ds
          ],
      First->Last,
      GroupBy[#Commit&]
      ]/;ListQ@ds
    ]


(* ::Subsubsection::Closed:: *)
(*GitStatus*)



GitRegisterFunction[
  GitStatus,
  "status",
  {
    "Short"->"short",
    "Branch"->"branch",
    "ShowStash"->"show-stash",
    "Porcelain"->"porcelain",
    "Long"->"long",
    "Verbose"->"verbose",
    "UntrackedFiles"->"untracked-files",
    "IgnoreSubmodules"->"ignore-submodules",
    "Ignored"->"ignored",
    "NULTerminated"->"z",
    "Column"->"column"
    }
  ]


(* ::Subsubsection::Closed:: *)
(*GitConfig*)



GitRegisterFunction[
  GitConfig,
  "config",
  {
    "ReplaceAll"->"replace-all",
    "Add"->"add",
    "Get"->"get",
    "GetAll"->"get-all",
    "GetRegexp"->"get-regexp",
    "GetUrlmatch"->"get-urlmatch",
    "Global"->"global",
    "System"->"system",
    "Local"->"local",
    "File"->"file",
    "Blob"->"blob",
    "RemoveSection"->"remove-section",
    "RenameSection"->"rename-section",
    "Unset"->"unset",
    "UnsetAll"->"unset-all",
    "List"->"list",
    "Bool"->"bool",
    "Int"->"int",
    "BoolOrInt"->"bool-or-int",
    "Path"->"path",
    "Null"->"null",
    "NameOnly"->"name-only",
    "ShowOrigin"->"show-origin",
    "GetColorbool"->"get-colorbool",
    "GetColor"->"get-color",
    "Edit"->"edit",
    "Includes"->"includes",
    "NoIncludes"->"no-includes"
    },
  {
    "Global"->True
    }
  ]


GitConfig[setting:_String:"--global",opts___String]:=
  GitRun["config",setting,opts];
GitConfig[setting:_String:"--global","Username"->name_]:=
  GitConfig[setting,"user.name",name];
GitConfig[setting:_String:"--global","UserEmail"->email_]:=
  GitConfig[setting,"user.email",email];
GitConfig[setting:_String:"--global","TextEditor"->editor_]:=
  GitConfig[setting,"core.editor",editor]
GitConfig[setting:_String:"--global",opts__Rule]:=
  StringJoin@
    Riffle[
      Cases[
        Table[
          GitConfig[setting,opt],
          {opt,{opts}}
          ],
        _String
        ],
      "\n"
      ];


(* ::Subsubsection::Closed:: *)
(*GitDiff*)



GitRegisterFunction[GitDiff, 
  "diff",
  {
    "Patch"->"patch",
    "NoPatch"->"no-patch",
    "Unified"->"unified",
    "Raw"->"raw",
    "PatchWithRaw"->"patch-with-raw",
    "NoIndentHeuristic"->"no-indent-heuristic",
    "Minimal"->"minimal",
    "Patience"->"patience",
    "Histogram"->"histogram",
    "DiffAlgorithm"->"diff-algorithm",
    "Stat"->"stat",
    "Numstat"->"numstat",
    "Shortstat"->"shortstat",
    "Dirstat"->"dirstat",
    "Summary"->"summary",
    "PatchWithStat"->"patch-with-stat",
    "NULTerminated"->"z",
    "NameOnly"->"name-only",
    "NameStatus"->"name-status",
    "Submodule"->"submodule",
    "Color"->"color",
    "NoColor"->"no-color",
    "WordDiff"->"word-diff",
    "WordDiffRegex"->"word-diff-regex",
    "ColorWords"->"color-words",
    "NoRenames"->"no-renames",
    "Check"->"check",
    "WsErrorHighlight"->"ws-error-highlight",
    "FullIndex"->"full-index",
    "Binary"->"binary",
    "Abbrev"->"abbrev",
    "BreakRewrites"->"break-rewrites",
    "FindRenames"->"find-renames",
    "FindCopies"->"find-copies",
    "FindCopiesHarder"->"find-copies-harder",
    "IrreversibleDelete"->"irreversible-delete",
    "DiffFilter"->"diff-filter",
    "PickaxeAll"->"pickaxe-all",
    "PickaxeRegex"->"pickaxe-regex",
    "Recursive"->"R",
    "Relative"->"relative",
    "Text"->"text",
    "IgnoreSpaceAtEol"->"ignore-space-at-eol",
    "IgnoreSpaceChange"->"ignore-space-change",
    "IgnoreAllSpace"->"ignore-all-space",
    "IgnoreBlankLines"->"ignore-blank-lines",
    "InterHunkContext"->"inter-hunk-context",
    "FunctionContext"->"function-context",
    "ExitCode"->"exit-code",
    "Quiet"->"quiet",
    "ExtDiff"->"ext-diff",
    "NoExtDiff"->"no-ext-diff",
    "NoTextconv"->"no-textconv",
    "IgnoreSubmodules"->"ignore-submodules",
    "SrcPrefix"->"src-prefix",
    "DstPrefix"->"dst-prefix",
    "NoPrefix"->"no-prefix",
    "LinePrefix"->"line-prefix",
    "ItaInvisibleInIndex"->"ita-invisible-in-index"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitMerge*)



GitRegisterFunction[
  GitMerge, 
  "merge",
  {
    "NoCommit"->"no-commit",
    "NoEdit"->"no-edit",
    "FastForward"->"ff",
    "NoFastForward"->"no-ff",
    "FastForwardOnly"->"ff-only",
    "Log"->"log",
    "NoStat"->"no-stat",
    "NoSquash"->"no-squash",
    "Strategy"->"strategy",
    "StrategyOption"->"strategy-option",
    "NoVerifySignatures"->"no-verify-signatures",
    "NoSummary"->"no-summary",
    "Quiet"->"quiet",
    "Verbose"->"verbose",
    "NoProgress"->"no-progress",
    "AllowUnrelatedHistories"->"allow-unrelated-histories",
    "GpgSign"->"gpg-sign",
    "Message"->"m",
    "RerereAutoupdate"->"rerere-autoupdate",
    "NoRerereAutoupdate"->"no-rerere-autoupdate",
    "Abort"->"abort",
    "Continue"->"continue"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitMergeTool*)



GitRegisterFunction[
  GitMergeTool, 
  "mergetool",
  {
    "Tool"->"tool",
    "ToolHelp"->"tool-help",
    "NoPrompt"->"no-prompt",
    "Prompt"->"prompt"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitTag*)



GitRegisterFunction[
  GitTag, 
  "tag",
  {
    "Annotate"->"annotate",
    "Sign"->"sign",
    "LocalUser"->"local-user",
    "Force"->"force",
    "Delete"->"delete",
    "Verify"->"verify",
    "List"->"list",
    "Sort"->"sort",
    "IgnoreCase"->"ignore-case",
    "Column"->"column",
    "Contains"->"contains",
    "NoContains"->"no-contains",
    "Merged"->"merged",
    "NoMerged"->"no-merged",
    "PointsAt"->"points-at",
    "Message"->"message",
    "File"->"file",
    "Cleanup"->"cleanup",
    "CreateReflog"->"create-reflog"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitWorkTree*)



GitRegisterFunction[
  GitWorkTree, 
  "worktree",
  {
    "Force"->"force",
    "Branch"->"b",
    "Detach"->"detach",
    "Checkout"->"checkout",
    "NoCheckout"->"no-checkout",
    "Lock"->"lock",
    "DryRun"->"dry-run",
    "Porcelain"->"porcelain",
    "Verbose"->"verbose",
    "Expire"->"expire",
    "Reason"->"reason"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitSubmodule*)



GitRegisterFunction[
  GitSubmodule, 
  "submodule",
  {
    "Quiet"->"quiet",
    "All"->"all",
    "Branch"->"branch",
    "Force"->"force",
    "Cached"->"cached",
    "Files"->"files",
    "SummaryLimit"->"summary-limit",
    "Remote"->"remote",
    "NoFetch"->"no-fetch",
    "Checkout"->"checkout",
    "Merge"->"merge",
    "Rebase"->"rebase",
    "Init"->"init",
    "Name"->"name",
    "Reference"->"reference",
    "Recursive"->"recursive",
    "Depth"->"depth",
    "RecommendShallow"->"recommend-shallow",
    "NoRecommendShallow"->"no-recommend-shallow",
    "Jobs"->"jobs"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitShow*)



GitRegisterFunction[
  GitShow, 
  "show",
  {
    "Pretty"->"pretty",
    "AbbrevCommit"->"abbrev-commit",
    "NoAbbrevCommit"->"no-abbrev-commit",
    "Oneline"->"oneline",
    "Encoding"->"encoding",
    "ExpandTabs"->"expand-tabs",
    "Notes"->"notes",
    "NoNotes"->"no-notes",
    "ShowNotes"->"show-notes",
    "ShowSignature"->"show-signature"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitShortLog*)



GitRegisterFunction[
  GitShortLog, 
  "shortlog",
  {
    "Numbered"->"numbered",
    "Summary"->"summary",
    "Email"->"email",
    "Format"->"format",
    "Committer"->"committer",
    "Width"->"w"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitDescribe*)



GitRegisterFunction[
  GitDescribe, 
  "Describe",
  {
    "Broken"->"broken",
    "All"->"all",
    "Tags"->"tags",
    "Contains"->"contains",
    "Abbrev"->"abbrev",
    "Candidates"->"candidates",
    "ExactMatch"->"exact-match",
    "Debug"->"debug",
    "Long"->"long",
    "Match"->"match",
    "Exclude"->"exclude",
    "Always"->"always",
    "FirstParent"->"first-parent"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitApply*)



GitRegisterFunction[
  GitApply,
  {
    "Stat"->"stat",
    "Numstat"->"numstat",
    "Summary"->"summary",
    "Check"->"check",
    "Index"->"index",
    "Cached"->"cached",
    "BuildFakeAncestor"->"build-fake-ancestor",
    "Reverse"->"reverse",
    "Reject"->"reject",
    "Z"->"z",
    "UnidiffZero"->"unidiff-zero",
    "Apply"->"apply",
    "NoAdd"->"no-add",
    "AllowBinaryReplacement"->"allow-binary-replacement",
    "Exclude"->"exclude",
    "Include"->"include",
    "IgnoreSpaceChange"->"ignore-space-change",
    "Whitespace"->"whitespace",
    "InaccurateEof"->"inaccurate-eof",
    "Verbose"->"verbose",
    "Recount"->"recount",
    "Directory"->"directory",
    "UnsafePaths"->"unsafe-paths"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitRebase*)



GitRegisterFunction[
  GitRebase,
  {
    "Onto"->"onto",
    "Continue"->"continue",
    "Abort"->"abort",
    "Quit"->"quit",
    "KeepEmpty"->"keep-empty",
    "Skip"->"skip",
    "EditTodo"->"edit-todo",
    "Merge"->"merge",
    "Strategy"->"strategy",
    "StrategyOption"->"strategy-option",
    "GpgSign"->"gpg-sign",
    "Quiet"->"quiet",
    "Verbose"->"verbose",
    "Stat"->"stat",
    "NoStat"->"no-stat",
    "NoVerify"->"no-verify",
    "Verify"->"verify",
    "ForceRebase"->"force-rebase",
    "NoForkPoint"->"no-fork-point",
    "Whitespace"->"whitespace",
    "CommitterDateIsAuthorDate"->"committer-date-is-author-date",
    "Interactive"->"interactive",
    "Signoff"->"signoff",
    "PreserveMerges"->"preserve-merges",
    "Exec"->"exec",
    "Root"->"root",
    "NoAutosquash"->"no-autosquash",
    "NoAutostash"->"no-autostash",
    "NoFf"->"no-ff"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitRevert*)



GitRegisterFunction[
  GitRevert,
  {
    "Edit"->"edit",
    "Mainline"->"mainline",
    "NoEdit"->"no-edit",
    "NoCommit"->"no-commit",
    "GpgSign"->"gpg-sign",
    "Signoff"->"signoff",
    "Strategy"->"strategy",
    "StrategyOption"->"strategy-option"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitBisect*)



GitRegisterFunction[
  GitBisect,
  {
    "NoCheckout"->"no-checkout"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitBlame*)



GitRegisterFunction[
  GitBlame,
  {
    "ShowBlank"->"b",
    "Root"->"root",
    "ShowStats"->"show-stats",
    "Lines"->"L",
    "Log"->"l",
    "ShowTimestamps"->"t",
    "RevisionsFile"->"S",
    "Reverse"->"reverse",
    "Porcelain"->"porcelain",
    "LinePorcelain"->"line-porcelain",
    "Incremental"->"incremental",
    "Encoding"->"encoding",
    "Contents"->"contents",
    "Date"->"date",
    "Progress"->"progress",
    "NoProgress"->"no-progress",
    "DetectMoves"->"M",
    "DetectExternalMoves"->"C",
    "Help"->"h",
    "AnnotateOutput"->"c",
    "ScoreDebug"->"score-debug",
    "ShowName"->"show-name",
    "ShowNumber"->"show-number",
    "SuppressTimestamp"->"s",
    "ShowEmail"->"show-email",
    "IgnoreWhitespace"->"w",
    "Abbrev"->"abbrev",
    "NoIndentHeuristic"->"no-indent-heuristic"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitGrep*)



GitRegisterFunction[
  GitGrep,
  {
    "Cached"->"cached",
    "NoIndex"->"no-index",
    "Untracked"->"untracked",
    "NoExcludeStandard"->"no-exclude-standard",
    "ExcludeStandard"->"exclude-standard",
    "RecurseSubmodules"->"recurse-submodules",
    "ParentBasename"->"parent-basename",
    "Text"->"text",
    "Textconv"->"textconv",
    "NoTextconv"->"no-textconv",
    "IgnoreCase"->"ignore-case",
    "IgnoreBinary"->"I",
    "MaxDepth"->"max-depth",
    "WordRegexp"->"word-regexp",
    "InvertMatch"->"invert-match",
    "HideFilename"->"h",
    "FullName"->"full-name",
    "BasicRegexp"->"basic-regexp",
    "ExtendedRegexp"->"extended-regexp",
    "PerlRegexp"->"perl-regexp",
    "FixedStrings"->"fixed-strings",
    "LineNumber"->"line-number",
    "FilesWithoutMatch"->"files-without-match",
    "OpenFilesInPager"->"open-files-in-pager",
    "Null"->"null",
    "Count"->"count",
    "Color"->"color",
    "NoColor"->"no-color",
    "Break"->"break",
    "Heading"->"heading",
    "ShowFunction"->"show-function",
    "Context"->"context",
    "AfterContext"->"after-context",
    "BeforeContext"->"before-context",
    "FunctionContext"->"function-context",
    "Threads"->"threads",
    "File"->"f",
    "Pattern"->"e",
    "And"->"and",
    "AllMatch"->"all-match",
    "Quiet"->"quiet"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitInstaWeb*)



GitRegisterFunction[
  GitInstaWeb,
  {
    "Local"->"local",
    "HTTPDaemon"->"httpd",
    "ModulePath"->"module-path",
    "Port"->"port",
    "Browser"->"browser"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitArchive*)



GitRegisterFunction[
  GitArchive,
  {
    "Format"->"format",
    "List"->"list",
    "Verbose"->"verbose",
    "Prefix"->"prefix",
    "Output"->"output",
    "WorktreeAttributes"->"worktree-attributes",
    "Remote"->"remote",
    "Exec"->"exec"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitSVN*)



GitRegisterFunction[
  GitSVN,
  {
    "Shared"->"shared",
    "Template"->"template",
    "Revision"->"revision",
    "StandardIn"->"stdin",
    "Pretty"->"pretty",
    "RemoveDirector"->"rmdir",
    "Edit"->"edit",
    "FindCopiesHarder"->"find-copies-harder",
    "AuthorsFile"->"authors-file",
    "AuthorsProg"->"authors-prog",
    "Quiet"->"quiet",
    "Strategy"->"strategy",
    "DryRun"->"dry-run",
    "UseLogAuthor"->"use-log-author",
    "AddAuthorFrom"->"add-author-from"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitBundle*)



GitRegisterFunction[
  GitBundle,
  {
    }
  ];


(* ::Subsubsection::Closed:: *)
(*GitDaemon*)



GitRegisterFunction[
  GitDaemon,
  {
    "StrictPaths"->"strict-paths",
    "BasePath"->"base-path",
    "BasePathRelaxed"->"base-path-relaxed",
    "InterpolatedPath"->"interpolated-path",
    "ExportAll"->"export-all",
    "Inetd"->"inetd",
    "Listen"->"listen",
    "Port"->"port",
    "InitTimeout"->"init-timeout",
    "Timeout"->"timeout",
    "MaxConnections"->"max-connections",
    "Syslog"->"syslog",
    "UserPath"->"user-path",
    "Verbose"->"verbose",
    "Reuseaddr"->"reuseaddr",
    "Detach"->"detach",
    "PidFile"->"pid-file",
    "Group"->"group",
    "Disable"->"disable",
    "ForbidOverride"->"forbid-override",
    "InformativeErrors"->"informative-errors",
    "NoInformativeErrors"->"no-informative-errors",
    "AccessHook"->"access-hook"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*Repository finding and stuff*)



GitRepositories[
  dirs:{(_String?DirectoryQ)..}|_String?DirectoryQ,
  depth:_Integer|\[Infinity]:2
  ]:=
  ParentDirectory/@FileNames[".git",dirs,depth];


(* ::Subsubsection::Closed:: *)
(*GitRepo*)



(*Options declared later*)
GitRepo[repo_String?(StringMatchQ["github:*"]),ops:OptionsPattern[]]:=
  GitHubRepo[StringTrim[repo,"github:"],{"Username"->"",ops}];
GitRepo[repo:(_String|_File)?DirectoryQ]:=
  Replace[
    GitRepositories[repo,1],{
    {d_,___}:>d,
    _:>None
    }];
GitRepo[r:_String|_URL]:=
  With[{u=URLParse@r},
    If[u["Scheme"]===None,
      If[u["Domain"]===None,
        If[Length@u["Path"]<2||!StringMatchQ[u["Path"]//First,"*.*"],
          None,
          URLBuild@Append[u,"Scheme"->"https"]
          ],
        URLBuild@Append[u,"Scheme"->"https"]
        ],
      URLBuild@u
      ]
    ];
GitRepo[r_]:=None;
GitRepoQ[r:(_String|_File)?DirectoryQ]:=
  (GitRepo@r=!=None);


(* ::Subsubsection::Closed:: *)
(*GitListRemotes*)



GitRegisterFunction[
  iGitRemoteShow,
  {"remote", "-v", "show"},
  {
    "UseCached"->"n"
    }
  ];


GitListRemotes//Clear


Options[GitListRemotes]=
  Options[iGitRemoteShow];
GitListRemotes[
  dir:_String?DirectoryQ|Automatic:Automatic,
  remoteName:_String?((StringLength[#]==0||Not@DirectoryQ[#]&)):"origin",
  args___String,
  ops:OptionsPattern[]
  ]:=
  iGitRemoteShow[dir, remoteName, args, ops]


(* ::Subsubsection::Closed:: *)
(*AddRemote*)



GitAddRemote//Clear


GitRegisterFunction[
  iGitRemoteAdd,
  {"remote", "add"},
  {
    "AutoFetch"->"f",
    "ImportTags"->"tags",
    "NoImportTags"->"no-tags",
    "TrackBranch"->{"t", " "},
    "Mirror"->"m"
    }
  ];


Options[GitAddRemote]=
  Options[iGitRemoteAdd];
GitAddRemote[
  dir:_String?DirectoryQ|Automatic:Automatic,
  remoteName:_String?((StringLength[#]==0||Not@DirectoryQ[#]&)):"origin",
  remote:_String|_URL,
  ops:OptionsPattern[]
  ]:=
  iGitRemoteAdd[dir,
    remoteName,
    URLBuild@remote,
    ops
    ];


(* ::Subsubsection::Closed:: *)
(*RemoveRemote*)



GitRegisterFunction[
  iGitRemoteRemove,
  {"remote", "remove"},
  {
    }
  ];


GitRemoveRemote[
  dir:_String?DirectoryQ|Automatic:Automatic,
  remoteName:_String?((StringLength[#]==0||Not@DirectoryQ[#]&)):"origin"
  ]:=
  iGitRemoteRemove[dir, remoteName]


(* ::Subsubsection::Closed:: *)
(*GetRemoteURL*)



GitRegisterFunction[
  iGitRemoteGetURL,
  {"remote", "get-url"},
  {
    "PushURL"->"push",
    "AllURLs"->"all",
    "All"->"all",
    "Push"->"push"
    }
  ];
Options[GitGetRemoteURL]=
  Options[iGitRemoteGetURL];
GitGetRemoteURL[
  dir:_String?DirectoryQ|Automatic:Automatic,
  remoteName:_String?((StringLength[#]==0||Not@DirectoryQ[#]&)):"origin",
  args___String,
  ops:OptionsPattern[]
  ]:=
  iGitRemoteGetURL[dir, remoteName, args, ops]


(* ::Subsubsection::Closed:: *)
(*SetRemoteURL*)



GitRegisterFunction[
  iGitRemoteSetURL,
  {"remote", "set-url"},
  {
    "PushURL"->"push",
    "AllURLs"->"all",
    "AddURL"->"add",
    "DeleteURL"->"delete"
    }
  ];
Options[GitSetRemoteURL]=
  Options[iGitRemoteSetURL];
GitSetRemoteURL[
  dir:_String?DirectoryQ|Automatic:Automatic,
  remoteName:_String?((StringLength[#]==0||Not@DirectoryQ[#]&)):"origin",
  args___String,
  ops:OptionsPattern[]
  ]:=
  iGitRemoteSetURL[dir, remoteName, args, ops]


(* ::Subsubsection::Closed:: *)
(*GitSetRemote*)



GitSetRemote[
  dir:_String?DirectoryQ|Automatic:Automatic,
  remoteName:_String?((StringLength[#]==0||Not@DirectoryQ[#]&)):"origin",
  origin:(_String|_GitHubPath)?GitHubRepoQ
  ]:=
  Quiet@
    Check[
      GitAddRemote[dir, remoteName, origin],
      GitRemoveRemote[dir, remoteName];
      GitAddRemote[dir, remoteName, origin]
      ];


(* ::Subsubsection::Closed:: *)
(*GitRealignRemotes*)



GitRealignRemotes[
  dir:_String?DirectoryQ|Automatic:Automatic,
  remoteName:_String?(Not@*DirectoryQ):"origin",
  branchName:_String?(Not@*DirectoryQ):"master"
  ]:=
  (
    Git["Fetch", dir];
    Git["Reset", dir, URLBuild@{remoteName, branchName}];
    Git["Checkout", dir, URLBuild@{remoteName, branchName}];
    )


(* ::Subsubsection::Closed:: *)
(*ReattachHead*)



GitReattachHead[
  dir:_String?DirectoryQ|Automatic:Automatic
  ]:=
  With[{uuid=CreateUUID[]},
    Git["Branch", dir, uuid];
    Git["Checkout", dir, uuid];
    Git["Branch", dir, "-f", "master", uuid];
    Git["Checkout", dir, "master"];
    Git["Branch", dir, "-d", uuid];
    ]


(* ::Subsubsection::Closed:: *)
(*Push*)



GitRegisterFunction[
  iGitPush,
  "push",
  {
    "All"->"all",
    "Prune"->"prune",
    "Mirror"->"mirror",
    "DryRun"->"dry-run",
    "Porcelain"->"porcelain",
    "Delete"->"delete",
    "Tags"->"tags",
    "FollowTags"->"follow-tags",
    "Sign"->"sign",
    "Atomic"->"atomic",
    "NoAtomic"->"no-atomic",
    "PushOption"->"push-option",
    "ReceivePack"->"receive-pack",
    "ForceWithLease"->"force-with-lease",
    "Force"->"force",
    "Repo"->"repo",
    "SetUpstream"->"set-upstream",
    "Thin"->"thin",
    "NoThin"->"no-thin",
    "Quiet"->"quiet",
    "Verbose"->"verbose",
    "Progress"->"progress",
    "RecurseSubmodules"->"recurse-submodules",
    "Verify"->"verify",
    "NoVerify"->"no-verify"
    }
  ]


GitPush//Clear


Options[GitPush]=
  Join[
    {
      "Username"->
        None,
      "Password"->
        None
      },
    Options[iGitPush]
    ];
GitPush[
  dir:_String?DirectoryQ,
  locs__String,
  ops:OptionsPattern[]
  ]:=
  iGitPush[
    dir,
    ops,
    locs
    ];


(* ::Subsubsection::Closed:: *)
(*Fetch*)



GitRegisterFunction[
  GitFetch,
  "fetch",
  {
    "All"->"all",
    "Append"->"append",
    "Depth"->"depth",
    "Deepen"->"deepen",
    "ShallowSince"->"shallow-since",
    "ShallowExclude"->"shallow-exclude",
    "Unshallow"->"unshallow",
    "UpdateShallow"->"update-shallow",
    "DryRun"->"dry-run",
    "Force"->"force",
    "Keep"->"keep",
    "Multiple"->"multiple",
    "Prune"->"prune",
    "NoTags"->"no-tags",
    "Refmap"->"refmap",
    "Tags"->"tags",
    "RecurseSubmodules"->"recurse-submodules",
    "Jobs"->"jobs",
    "NoRecurseSubmodules"->"no-recurse-submodules",
    "SubmodulePrefix"->"submodule-prefix",
    "RecurseSubmodulesDefault"->"recurse-submodules-default",
    "UpdateHeadOk"->"update-head-ok",
    "UploadPack"->"upload-pack",
    "Quiet"->"quiet",
    "Verbose"->"verbose",
    "Progress"->"progress"
    }
  ]


(* ::Subsubsection::Closed:: *)
(*Reset*)



GitRegisterFunction[
  GitReset,
  "fetch",
  {
    "Patch"->"patch",
    "Soft"->"soft",
    "Mixed"->"mixed",
    "Hard"->"hard",
    "Merge"->"merge",
    "Keep"->"keep",
    "Verbose"->"verbose"
    }
  ]


(* ::Subsubsection::Closed:: *)
(*Checkout*)



GitRegisterFunction[
  GitCheckout,
  "checkout",
  {
    "Quiet"->"q",
    "MakeBranch"->"b",
    "Track"->"t",
    "Progress"->"progress",
    "Force"->"f",
    "Ours"->"ours",
    "Theirs"->"theirs",
    "NoTrack"->"notrack",
    "Log"->"l",
    "Detach"->"Detach",
    "Orphan"->"orphan",
    "IgnoreSkipWorktreeBits"->
      "ignore-skip-worktree-bits",
    "Conflict"->"conflict",
    "Patch"->"p",
    "IgnoreOtherWorktrees"->"ignore-other-worktrees",
    "RecurseSubmodules"->"recurse-submodules"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*Pull*)



GitRegisterFunction[
  GitPull,
  "pull",
  {
    "Quiet"->"quiet",
    "Verbose"->"verbose",
    "RecurseSubmodules"->"recurse-submodules",
    "NoRecurseSubmodules"->"no-recurse-submodules",
    "NoCommit"->"no-commit",
    "NoEdit"->"no-edit",
    "FastForward"->"ff",
    "NoFastForward"->"no-ff",
    "FastForwardOnly"->"ff-only",
    "Log"->"log",
    "NoStat"->"no-stat",
    "NoSquash"->"no-squash",
    "Strategy"->"strategy",
    "StrategyOption"->"strategy-option",
    "NoVerifySignatures"->"no-verify-signatures",
    "NoSummary"->"no-summary",
    "AllowUnrelatedHistories"->"allow-unrelated-histories",
    "Rebase"->"rebase",
    "NoRebase"->"no-rebase",
    "NoAutostash"->"no-autostash",
    "All"->"all",
    "Append"->"append",
    "Depth"->"depth",
    "Deepen"->"deepen",
    "ShallowSince"->"shallow-since",
    "ShallowExclude"->"shallow-exclude",
    "Unshallow"->"unshallow",
    "UpdateShallow"->"update-shallow",
    "Force"->"force",
    "Keep"->"keep",
    "NoTags"->"no-tags",
    "UpdateHeadOk"->"update-head-ok",
    "UploadPack"->"upload-pack",
    "Progress"->"progress"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*PullOrigin*)



Options[GitPullOrigin]=
  Options[GitPull];
GitPullOrigin[
  dir:_String?DirectoryQ|Automatic:Automatic,
  args___String,
  ops:OptionsPattern[]
  ]:=
  GitPull[dir, "origin", "master", args, ops]


(* ::Subsubsection::Closed:: *)
(*PushOrigin*)



Options[GitPushOrigin]=
  Options[GitPush];
GitPushOrigin[
  dir:_String?DirectoryQ|Automatic:Automatic,
  args___String,
  ops:OptionsPattern[]
  ]:=
  GitPush[dir,
    "origin",
    "master",
    args,
    ops
    ];


(* ::Subsubsection::Closed:: *)
(*GetPushURL*)



GitGetPushURL[
  dir:_String?DirectoryQ|Automatic:Automatic,
  rem:_String?(Not@*DirectoryQ):"origin"
  ]:=
  With[
    {
      rems=
        #[[1]]->#[[2]]&/@
          Cases[
            Partition[
              Append[""]@
              StringSplit[
                Replace[
                  Git["ListRemotes", dir],
                  Except[_String]->""
                  ]
                ],
              3
              ],
            {_, _, _?(StringContainsQ["push"])}
            ]//Association
      },
    If[Length@rems>0,
      rem->rems[rem],
      URL@GitHubPath[FileBaseName@Replace[dir, Automatic:>rem]]
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*GetFetchURL*)



GetFetchURL//Clear


GitGetFetchURL[
  dir:_String?DirectoryQ|Automatic:Automatic,
  rem:_String?(Not@*DirectoryQ):"origin"
  ]:=
  With[
    {
      rems=
        #[[1]]->#[[2]]&/@
          Cases[
            Partition[
              Append[""]@
              StringSplit[
                Replace[Git["ListRemotes", dir],
                  Except[_String]->""
                  ]
                ],
              3
              ],
            {_, _, _?(StringContainsQ["fetch"])}
            ]//Association
      },
    If[Length@rems>0,
      rem->rems[rem],
      URL@GitHubPath[FileBaseName@Replace[dir, Automatic:>rem]]
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*ListTree*)



GitRegisterFunction[
  GitListTree,
  "ls-tree",
  {
    "NoChildren"->"d",
    "Recursive"->"r",
    "ShowRecursiveTrees"->"t",
    "Long"->"long",
    "NULTerminated"->"z",
    "NameStatus"->"name-status",
    "Abbrev"->"abbrev",
    "FullName"->"full-name",
    "FullTree"->"full-tree"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*ListTreeRecursive*)



Options[GitListTreeRecursive]=
  Options@GitListTree;
GitListTreeRecursive[
  dir:_String?DirectoryQ|Automatic:Automatic,
  args___String,
  ops:OptionsPattern[]
  ]:=
  GitListTree[dir, args, "Recursive"->True, ops]


(* ::Subsubsection::Closed:: *)
(*RefLog*)



GitRegisterFunction[
  GitReflog,
  "reflog",
  {
    "All"->"all",
    "Expire"->"expire",
    "ExpireUnreachable"->"expire-unreachable",
    "Updateref"->"updateref",
    "Rewrite"->"rewrite",
    "StaleFix"->"stale-fix",
    "DryRun"->"dry-run",
    "Verbose"->"verbose"
    }
  ]


(* ::Subsubsection::Closed:: *)
(*RefLogShow*)



GitRegisterFunction[
  RefLogShow,
  {"reflog", "show"},
  {
    "Follow"->"follow",
    "Decorate"->"decorate",
    "Source"->"source",
    "UseMailmap"->"use-mailmap",
    "FullDiff"->"full-diff",
    "LogSize"->"log-size",
    "TraceLines"->"L",
    "MaxCount"->"max-count",
    "Skip"->"skip",
    "Since"->"since",
    "Before"->"before",
    "Committer"->"committer",
    "GrepReflog"->"grep-reflog",
    "Grep"->"grep",
    "AllMatch"->"all-match",
    "InvertGrep"->"invert-grep",
    "RegexpIgnoreCase"->"regexp-ignore-case",
    "BasicRegexp"->"basic-regexp",
    "ExtendedRegexp"->"extended-regexp",
    "FixedStrings"->"fixed-strings",
    "PerlRegexp"->"perl-regexp",
    "RemoveEmpty"->"remove-empty",
    "Merges"->"merges",
    "NoMerges"->"no-merges",
    "MinParents"->"min-parents",
    "NoMaxParents"->"no-max-parents",
    "FirstParent"->"first-parent",
    "Bisect"->"bisect",
    "Not"->"not",
    "All"->"all",
    "Branches"->"branches",
    "Tags"->"tags",
    "Remotes"->"remotes",
    "Glob"->"glob",
    "Exclude"->"exclude",
    "Reflog"->"reflog",
    "IgnoreMissing"->"ignore-missing",
    "Stdin"->"stdin",
    "CherryMark"->"cherry-mark",
    "CherryPick"->"cherry-pick",
    "RightOnly"->"right-only",
    "Cherry"->"cherry",
    "WalkReflogs"->"walk-reflogs",
    "Merge"->"merge",
    "Boundary"->"boundary",
    "SimplifyByDecoration"->"simplify-by-decoration",
    "FullHistory"->"full-history",
    "Dense"->"dense",
    "Sparse"->"sparse",
    "SimplifyMerges"->"simplify-merges",
    "AncestryPath"->"ancestry-path",
    "DateOrder"->"date-order",
    "AuthorDateOrder"->"author-date-order",
    "TopoOrder"->"topo-order",
    "Reverse"->"reverse",
    "NoWalk"->"no-walk",
    "DoWalk"->"do-walk",
    "Pretty"->"pretty",
    "AbbrevCommit"->"abbrev-commit",
    "NoAbbrevCommit"->"no-abbrev-commit",
    "Oneline"->"oneline",
    "Encoding"->"encoding",
    "ExpandTabs"->"expand-tabs",
    "Notes"->"notes",
    "NoNotes"->"no-notes",
    "ShowNotes"->"show-notes",
    "ShowSignature"->"show-signature",
    "RelativeDate"->"relative-date",
    "Date"->"date",
    "Parents"->"parents",
    "Children"->"children",
    "LeftRight"->"left-right",
    "Graph"->"graph",
    "ShowLinearBreak"->"show-linear-break",
    "Compress"->"c",
    "CompressComplete"->"cc",
    "ShowMergeDiffs"->"m",
    "Recursive"->"r",
    "ShowTree"->"t"
    }
  ]


(* ::Subsubsection::Closed:: *)
(*RefLogExpire*)



GitRegisterFunction[
  RefLogExpire,
  {"reflog", "expire"},
  {
    "All"->"all",
    "Expire"->"expire",
    "ExpireUnreachable"->"expire-unreachable",
    "Updateref"->"updateref",
    "Rewrite"->"rewrite",
    "StaleFix"->"stale-fix",
    "DryRun"->"dry-run",
    "Verbose"->"verbose"
    }
  ]


(* ::Subsubsection::Closed:: *)
(*Clean*)



Options[GitClean]=
  {
    "reflogExpire"->Automatic,
    "reflogExpireUnreachable"->Automatic,
    "rerereresolved"->Automatic,
    "rerereunresolved"->Automatic,
    "pruneExpire"->Automatic
    }
GitClean[
  dir:_String?DirectoryQ|Automatic:Automatic,
  args___String,
  ops:OptionsPattern[]
  ]:=
  With[
    {
      conf=
        Map[
          StringJoin@
            Prepend[Insert[List@@ToString/@#," ",2],"--gc."]&, 
          Flatten@{ops}
          ]
        },
      GitRun[dir,"gc",args,Sequence@@conf]
    ]


(* ::Subsubsection::Closed:: *)
(*GitCleanEverything*)



(*(* Taken from here: https://stackoverflow.com/a/14729486 *)
GitCleanEverything[
	dir:_String?DirectoryQ|Automatic:Automatic,
	args___
	]:=
	GitClean[dir,"\"$@\"",args,
		{
			"reflogExpire"\[Rule]0,
			"reflogExpireUnreachable"\[Rule]0,
			"rerereresolved"\[Rule]0,
			"rerereunresolved"\[Rule]0,
			"pruneExpire"\[Rule]"now"
			}
		]*)


(* ::Subsubsection::Closed:: *)
(*GitFilterBranch*)



GitFilterBranch//Clear


GitFilterBranch[
  dir:_String?DirectoryQ|Automatic:Automatic,
  filterType_String?(StringStartsQ["--"]),
  filterCMD_String,
  args___
  ]:=
  GitRun[dir,"filter-branch",
    If[StringQ@branch,branch,Sequence@@{}],
    filterType, 
    "''``''"~TemplateApply~filterCMD,
    args
    ];


(* ::Subsubsection::Closed:: *)
(*GitFilterTree*)



GitFilterTree//Clear


GitFilterTree[
  dir:_String?DirectoryQ|Automatic:Automatic,
  filterCMD_String,
  args___
  ]:=
  GitFilterBranch[dir, "--tree-filter",filterCMD, args];


(* ::Subsubsection::Closed:: *)
(*Prune*)



GitRegisterFunction[
  GitPrune,
  "Prune",
  {
    "DryRun"->"dry-run",
    "Verbose"->"verbose",
    "Expire"->"expire"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*Branch*)



GitRegisterFunction[
  GitBranch,
  "Branch",
  {
      "Delete"->"delete",
      "ForceDelete"->"D",
      "CreateReflog"->"create-reflog",
      "Force"->"force",
      "Move"->"move",
      "ForceMove"->"M",
      "Color"->"color",
      "NoColor"->"no-color",
      "IgnoreCase"->"ignore-case",
      "NoColumn"->"no-column",
      "Remotes"->"remotes",
      "All"->"all",
      "List"->"list",
      "Verbose"->"verbose",
      "Quiet"->"quiet",
      "Abbrev"->"abbrev",
      "NoAbbrev"->"no-abbrev",
      "Track"->"track",
      "NoTrack"->"no-track",
      "SetUpstream"->"set-upstream",
      "SetUpstreamTo"->"set-upstream-to",
      "UnsetUpstream"->"unset-upstream",
      "EditDescription"->"edit-description",
      "Contains"->"contains",
      "NoContains"->"no-contains",
      "Merged"->"merged",
      "NoMerged"->"no-merged",
      "Sort"->"sort",
      "PointsAt"->"points-at",
      "Format"->"format"
      }
    ]


(* ::Subsubsection::Closed:: *)
(*ShowBranch*)



GitRegisterFunction[
  GitShowBranch,
  "show-branch",
  {
    "Remotes"->"remotes",
    "All"->"all",
    "Current"->"current",
    "TopoOrder"->"topo-order",
    "DateOrder"->"date-order",
    "Sparse"->"sparse",
    "More"->"more",
    "List"->"list",
    "MergeBase"->"merge-base",
    "Independent"->"independent",
    "NoName"->"no-name",
    "Sha1Name"->"sha1-name",
    "Topics"->"topics",
    "Reflog"->"reflog",
    "Color"->"color",
    "NoColor"->"no-color"
    }
  ];


(* ::Subsubsection::Closed:: *)
(*ListBranches*)



splitGitBranches//Clear


splitGitBranches[bstring_String]:=
  StringCases[
    bstring,
    (" "|StartOfString)~~name:WordCharacter..:>name
    ];
splitGitBranches[bstring_]:=
  {}


Options[GitListBranches]=
  Options[GitBranch];
GitListBranches[
  dir:_String?DirectoryQ|Automatic:Automatic,
  o___?OptionQ
  ]:=
  splitGitBranches@GitBranch[dir]


(* ::Subsubsection::Closed:: *)
(*CurrentBranch*)



getGitCurrentBranch[bstring_]:=
  First@StringCases[
    bstring,
    "* "~~name:Except[WhitespaceCharacter]..:>name
    ]


Options[GitCurrentBranch]=
  Options[GitBranch];
GitCurrentBranch[
  dir:_String?DirectoryQ|Automatic:Automatic,
  o___?OptionQ
  ]:=
  getGitCurrentBranch@
    GitBranch[dir]


(* ::Subsubsection::Closed:: *)
(*ListWithCurrentBranch*)



Options[GitListWithCurrentBranch]=
  Options[GitBranch];
GitListWithCurrentBranch[
  dir:_String?DirectoryQ|Automatic:Automatic,
  o___?OptionQ
  ]:=
  With[{brs=GitBranch[dir]},
    With[
      {curr=
        getGitCurrentBranch@brs
        },
      Prepend[curr]@
        DeleteCases[
          splitGitBranches@brs,
          curr
          ]
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*SwitchBranch*)



Options[GitSwitchBranch]=
  Options[GitCheckout];
GitSwitchBranch[
  dir:_String?DirectoryQ|Automatic:Automatic,
  newBranch_String,
  o___?OptionQ
  ]:=
  With[{bb=GitListWithCurrentBranch[dir]},
    Which[
      newBranch===First@bb,
        bb,
      MemberQ[bb, newBranch],
        GitCheckout[dir, newBranch];
        newBranch,
      True,
        GitCheckout[dir, "MakeBranch"->newBranch];
        newBranch
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*WipeTheSlate*)



GitWipeTheSlate//Clear


(* Take from here: https://stackoverflow.com/a/26000395 *)
GitWipeTheSlate[
  dir:_String?DirectoryQ|Automatic:Automatic
  ]:=
  (
    GitCheckout[dir, "--orphan", "latest_branch"];
    GitAdd[dir, "-A"];
    GitCommit[dir, "-a",
      Message->"Wiped the slate clean"
      ];
    GitBranch[dir, "-D", "master"];
    GitBranch[dir, "-m", "master"];
    )


(* ::Subsubsection::Closed:: *)
(*Help*)



GitHelp[cmd_String]:=
  With[{s=GitRun["help", cmd]},
    StringReplace[s, 
      {
        (* There are sneaky \\.08 chars in here! Beware! *)
        l:(a:WordCharacter~~"\.08"~~a_):>
          a,
        l:(Repeated["_\.08"~~Except[WhitespaceCharacter]]):>
          StringJoin@StringTake[l, List/@Range[3, StringLength[l], 3]]
        }
      ]
    ]


GitHelpPart[cmd_, delim1_, delim2_]:=
  With[{h=GitHelp[cmd]},
    Replace[
      StringCases[h, 
        Shortest[delim1~~t__~~delim2]:>
        With[{ws=
            MinimalBy[
              StringCases[t, (StartOfString|StartOfLine)~~Except["\n", Whitespace]], 
              StringLength
              ]},
          StringDelete[t,
            (StartOfString|StartOfLine)~~Apply[Alternatives, ws]
            ]
          ]
        ],
      {
        l:{s_, ___}:>
          StringTrim@s,
        _->None
        }
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*Synopsis*)



GitHelpSynopsis[cmd_String]:=
  GitHelpPart[cmd, "SYNOPSIS", "DESCRIPTION"]


(* ::Subsubsection::Closed:: *)
(*Description*)



GitHelpDescription[cmd_String]:=
  GitHelpPart[cmd, "DESCRIPTION", "OPTIONS"]


(* ::Subsubsection::Closed:: *)
(*Options*)



GitHelpOptions[cmd_String]:=
  GitHelpPart[cmd, "OPTIONS", 
    ("\n"~~Except[WhitespaceCharacter])|EndOfString
    ]


(* ::Subsubsection::Closed:: *)
(*Flags*)



GitHelpFlags[cmd_String]:=
  StringTrim@
    StringCases[
      GitHelpOptions[cmd],
      Shortest[StartOfLine~~(Whitespace|"")~~"-"~~__~~EndOfLine]
      ]


(* ::Subsubsection::Closed:: *)
(*FlagMap*)



GitHelpFlagMap[cmd_]:=
  StringTrim[
    StringSplit[
      Map[
        If[StringContainsQ[#, "--["],
          Sequence@@{
            StringReplace[#, Shortest["--["~~__~~"]"]:>"--"],
            StringReplace[#, Shortest["--["~~t__~~"]"]:>"--"<>t]
            },
          #
          ]&,
        Flatten@
        Map[
          Take[
            MaximalBy[
              Select[
                StringTrim@#, 
                StringStartsQ[
                  Repeated["-", {1, 2}]~~
                    Except["-"]
                  ]
                ], 
              StringLength
              ],
            UpTo[1]
            ]&,
          StringSplit[GitHelpFlags[cmd], ","]
          ]
        ],
      "["|" "|"="
      ]//Map[First],
    "-"..|Whitespace
    ]//DeleteDuplicates//
      Select[
        StringStartsQ[#, LetterCharacter]&&
        StringEndsQ[#, LetterCharacter]&
        ]//Map[
          StringReplace[ToUpperCase[StringTake[#, 1]]<>StringDrop[#, 1],
            "-"~~s_:>ToUpperCase[s]
            ]->#&
          ]


(* ::Subsubsection::Closed:: *)
(*Git*)



$GitActions=
  KeySort@
  <|
    "Repo"->
      GitRepo,
    "RepoQ"->
      GitRepoQ,
    "Create"->
      GitCreate,
    "Init"->
      GitInit,
    "Clone"->
      GitClone,
    "AddGitIgnore"->
      GitAddGitIgnore,
    "AddGitExclude"->
      GitAddGitExclude,
    "Add"->
      GitAdd,
    "Move"->
      GitMove,
    "Remove"->
      GitRemove,
    "RemoveCached"->
      GitRemoveCached,
    "RemoveRecursive"->
      GitRemoveRecursive,
    "RemoveCachedRecursive"->
      GitRemoveCachedRecursive,
    "Commit"->
      GitCommit,
    "Branch"->
      GitBranch,
    "ShowBranch"->
      GitShowBranch,
    "ListBranches"->
      GitListBranches,
    "CurrentBranch"->
      GitCurrentBranch,
    "SwitchBranch"->
      GitSwitchBranch,
    "ListRemotes"->
      GitListRemotes,
    "AddRemote"->
      GitAddRemote,
    "RemoveRemote"->
      GitRemoveRemote,
    "GetRemoteURL"->
      GitGetRemoteURL,
    "SetRemoteURL"->
      GitSetRemoteURL,
    "RealignRemotes"->
      GitRealignRemotes,
    "ReattachHead"->
      GitReattachHead,
    "Fetch"->
      GitFetch,
    "Reset"->
      GitReset,
    "Checkout"->
      GitCheckout,
    "Prune"->
      GitPrune,
    "Pull"->
      GitPull,
    "PullOrigin"->
      GitPullOrigin,
    "Push"->
      GitPush,
    "PushOrigin"->
      GitPushOrigin,(*
		"GetPushURL"->
			GitGetPushURL,
		"GetFetchURL"->
			GitGetFetchURL,*)
    "Repositories"->
      GitRepositories,
    "Log"->
      GitLog,
    "LogDataset"->
      GitLogDataset,
    "FileHistory"->
      GitFileHistory,
    "Status"->
      GitStatus,
    "ListTree"->
      GitListTree,
    "ListTreeRecursive"->
      GitListTreeRecursive,
    "RefLog"->
      GitRefLog,
    "RefLogExpire"->
      GitRefLogExpire,
    "Clean"->
      GitClean,
    "WipeTheSlate"->
      GitWipeTheSlate,
    "FilterBranch"->
      GitFilterBranch,
    "FilterTree"->
      GitFilterTree,
    "Config"->
      GitConfig,
    "Diff"->
      GitDiff,
    "Merge"->
      GitMerge,
    "MergeTool"->
      GitMergeTool,
    "Tag"->
      GitTag,
    "WorkTree"->
      GitWorkTree,
    "Submodule"->
      GitSubmodule,
    "Show"->
      GitShow,
    "ShortLog"->
      GitShortLog,
    "Describe"->
      GitDescribe,
    "Apply"->
      GitApply,
    "Rebse"->
      GitRebase,
    "Revert"->
      GitRevert,
    "Bisect"->
      GitBisect,
    "Blame"->
      GitBlame,
    "Grep"->
      GitGrep,
    "InstaWeb"->
      GitInstaWeb,
    "Archive"->
      GitArchive,
    "SVN"->
      GitSVN,
    "Bundle"->
      GitBundle,
    "Daemon"->
      GitDaemon,
    "Help"->
      GitHelp,
    "HelpSynopsis"->
      GitHelpSynopsis,
    "HelpDescription"->
      GitHelpDescription,
    "HelpOptions"->
      GitHelpOptions,
    "HelpFlags"->
      GitHelpFlags,
    "HelpFlagMap"->
      GitHelpFlagMap
    |>;


End[];



