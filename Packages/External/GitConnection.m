(* ::Package:: *)

(* Autogenerated Package *)

(* ::Section:: *)
(*Git Connections*)



Git::usage=
  "A general head for all Git actions";


SVN::usage=
  "A general head for all SVN actions";


GitHub::usage=
  "A connection to the GitHub functinality";


Begin["`Private`"];


(* ::Subsection:: *)
(*Git*)



$gitactions:=
  KeyMap[ToLowerCase]@$GitActions;


PackageAddAutocompletions[
  "Git",
  {
    Keys@$GitActions,
    {"Options", "Function"}
    }
  ]


(* ::Subsubsection::Closed:: *)
(*Git*)



Git//Clear


(* ::Subsubsubsection::Closed:: *)
(*Options*)



Git[
  command_?(KeyMemberQ[$gitactions,ToLowerCase@#]&),
  "Options"
  ]:=
  Options@$gitactions[ToLowerCase[command]];


(* ::Subsubsubsection::Closed:: *)
(*Function*)



Git[
  command_?(KeyMemberQ[$gitactions,ToLowerCase@#]&),
  "Function"
  ]:=
  $gitactions[ToLowerCase[command]];


(* ::Subsubsubsection::Closed:: *)
(*Command*)



Git[
  command_?(KeyMemberQ[$gitactions,ToLowerCase@#]&),
  args:Except[_?OptionQ]...,
  ops:OptionsPattern[],
  "Command"
  ]:=
  Block[{$GitRunFlags=Append[$GitRunFlags, "ReturnCommand"->True]},
    Git[command, args, ops]
    ];


(* ::Subsubsubsection::Closed:: *)
(*Known*)



$GitParamMap["Git"]=
  {
    "GitVersion"->"version",
    "GitHelp"->"help",
    "GitCallFrom"->"C",
    "GitConfig"->"c",
    "GitExecPath"->"exec-path",
    "GitHTMLPath"->"html-path",
    "GitManPath"->"man-path",
    "GitInfoPath"->"info-path",
    "GitPaginate"->"paginate",
    "GitNoPager"->"no-pager",
    "GitDir"->"git-dir",
    "GitWorkTree"->"work-tree",
    "GitNamespace"->"namespace",
    "GitSuperPrefix"->"super-prefix",
    "GitBare"->"bare",
    "GitNoReplaceObjects"->"no-replace-objects",
    "GitLiteralPathSpecs"->"literal-pathspecs",
    "GitGlobalPathSpecs"->"glob-pathspecs",
    "GitNoglobPathSpecs"->"noglob-pathspecs",
    "GitIcasePathSpecs"->"icase-pathspecs"
    };


Options[Git]=
  Thread[Keys@$GitParamMap["Git"]->Automatic];
Git[
  command_?(KeyMemberQ[$gitactions,ToLowerCase@#]&),
  args:Except[_?OptionQ]...,
  ops:OptionsPattern[]
  ]:=
  Block[
    {
      $GitBaseOptionArgs=
        GitPrepParams[
          Git,
          FilterRules[{ops}, Options[Git]],
          $GitParamMap["Git"]
          ],
      opsNew=
        Sequence@@
          DeleteCases[{ops}, 
            Apply[Alternatives, Options[Git]]->_
            ]
      },
    With[{cmd=$gitactions[ToLowerCase[command]]},
      With[{r=cmd[args, opsNew]},
        r/;Head[r]=!=cmd
        ]
      ]
    ];


(* ::Subsubsubsection::Closed:: *)
(*Fallback*)



Git::badcmd=
  "Couldn't execute command `` with parameters ``";
Git[
  cmd_String,
  args___
  ]:=
  Block[
    {
      $GitBaseOptionArgs=
        GitPrepParams[
          Git,
          FilterRules[Select[{args}, OptionQ], Options[Git]],
          $GitParamMap["Git"]
          ],
      argNew=Sequence@@DeleteCases[{args}, Apply[Alternatives, Options[Git]]->_]
      },
    With[{r=GitRun[cmd, argNew]},
      If[Head[r]===GitRun,
        Message[Git::badcmd, cmd, {args}]
        ];
      r/;Head[r]=!=GitRun
      ]
    ];


(* ::Subsection:: *)
(*SVN*)



(* ::Subsubsection::Closed:: *)
(*SVN*)



$svnactions:=
  KeyMap[ToLowerCase]@$SVNActions


PackageAddAutocompletions[
  "SVN",
  {
    Keys[$SVNActions]
    }
  ]


SVN[
  command_?(KeyMemberQ[$svnactions,ToLowerCase@#]&),
  args___
  ]:=
  With[{cmd=$svnactions[ToLowerCase[command]]},
    With[{r=cmd[args]},
      r/;Head[r]=!=cmd
      ]
    ];
SVN[
  cmd_String,
  args___
  ]:=
  SVNRun[cmd,args];


(* ::Subsection:: *)
(*GitHub*)



GitHub//Clear


(* ::Subsubsection::Closed:: *)
(*GitHubPostProcess*)



(* ::Subsubsubsection::Closed:: *)
(*ResultJSON*)



GitHubPostProcess[command_:None, res_, "ResultJSON"]:=
  Module[
    {
      u=URLRead[res],
      status,
      cont,
      mess
      },
    status=u["StatusCode"];
    cont=Quiet@Import[u, "JSON"];
    If[status<400,
      <|
        "StatusCode"->status,
        "Content"->Replace[cont, $Failed->None]
        |>,
      <|
        "StatusCode"->status,
        "Content"->$Failed,
        "Message"->Quiet@Lookup[cont, "message", None]
        |>
      ]
    ]


(* ::Subsubsubsection::Closed:: *)
(*ResultObject*)



GitHubPostProcess[command_, res_, "ResultObject"]:=
  With[{rs=res},
    If[AssociationQ@rs,
      If[rs["StatusCode"]<400,
        Success[
          TemplateApply[
            "GitHub: `` (``)",
            {
              command,
              rs["StatusCode"]
              }
            ], 
          Join[
            <|
              "StatusCode"->rs["StatusCode"],
              "Command"->command
              |>,
            Which[
              AssociationQ@rs["Content"], 
                rs["Content"],
              rs["Content"]=!=Null,
                <|"Result"->rs["Content"]|>,
              True,
                <||>
              ]
            ]
          ],
        Failure[
          TemplateApply[
            "GitHub: `` (``)",
            {
              command,
              rs["StatusCode"]
              }
            ],
          Append[
            KeyDrop[rs, "Content"],
            "Command"->command
            ]
          ]
        ],
      rs
      ]
    ]


(* ::Subsubsubsection::Closed:: *)
(*ResultJSONObject*)



GitHubPostProcess[command_, res_, "ResultJSONObject"]:=
  GitHubPostProcess[
    command,
    GitHubPostProcess[command, res, "ResultJSON"],
    "ResultObject"
    ]


(* ::Subsubsection::Closed:: *)
(*GitHub*)



(* ::Subsubsubsection::Closed:: *)
(*Autocompletions*)



$githubactions:=
  KeyMap[ToLowerCase]@$GitHubActions


PackageAddAutocompletions[
  "GitHub",
  {
    Keys[$GitHubActions],
    {"Options", "Function"}
    }
  ]


(* ::Subsubsubsection::Closed:: *)
(*Function*)



GitHub//Clear


GitHub[
  command_String?(KeyMemberQ[$githubactions,ToLowerCase@#]&),
  "Function"
  ]:=
  $githubactions[ToLowerCase[command]];


(* ::Subsubsubsection::Closed:: *)
(*Options*)



GitHub[
  command_String?(KeyMemberQ[$githubactions,ToLowerCase@#]&),
  "Options"
  ]:=
  Options@Evaluate@$githubactions[ToLowerCase[command]];


(* ::Subsubsubsection::Closed:: *)
(*HTTPRequest*)



GitHub[
  command_String?(KeyMemberQ[$githubactions,ToLowerCase@#]&),
  args:Except[_?OptionQ]...,
  opp___?OptionQ,
  "HTTPRequest"
  ]:=
  GitHub[command, args, opp, "ReturnGitHubQuery"->True];


(* ::Subsubsubsection::Closed:: *)
(*HTTPResponse*)



GitHub[
  command_String?(KeyMemberQ[$githubactions,ToLowerCase@#]&),
  args:Except[_?OptionQ]...,
  opp___?OptionQ,
  "HTTPResponse"
  ]:=
  URLRead@
    GitHub[command, args, opp, 
      "GitHubImport"->False,
      "ReturnGitHubQuery"->True
      ];


(* ::Subsubsubsection::Closed:: *)
(*ResultJSON*)



GitHub[
  command_String?(KeyMemberQ[$githubactions,ToLowerCase@#]&),
  args:Except[_?OptionQ]...,
  opp___?OptionQ,
  "ResultJSON"
  ]:=
  GitHubPostProcess[
    "Command",
    GitHub[command, args, opp, "HTTPRequest"], 
    "ResultJSON"
    ];


(* ::Subsubsubsection::Closed:: *)
(*ImportedResult*)



GitHub[
  command_String?(KeyMemberQ[$githubactions,ToLowerCase@#]&),
  args:Except[_?OptionQ]...,
  opp___?OptionQ,
  "ImportedResult"
  ]:=
  GitHub[command, args, opp, "GitHubImport"->True];


(* ::Subsubsubsection::Closed:: *)
(*ResultObject*)



GitHub[
  command_String?(KeyMemberQ[$githubactions,ToLowerCase@#]&),
  args:Except[_?OptionQ]...,
  opp___?OptionQ,
  "ResultObject"
  ]:=
  GitHubPostProcess[
    command,
    GitHub[command, args, opp, "GitHubImport"->True],
    "ResultObject"
    ]


(* ::Subsubsubsection::Closed:: *)
(*ResultJSONObject*)



GitHub[
  command_String?(KeyMemberQ[$githubactions,ToLowerCase@#]&),
  args:Except[_?OptionQ]...,
  opp___?OptionQ,
  "ResultJSONObject"
  ]:=
  GitHubPostProcess[
    command,
    GitHub[command, args, opp, "GitHubImport"->False],
    "ResultJSONObject"
    ]


(* ::Subsubsubsection::Closed:: *)
(*Main*)



$gitHubOptions=
  "GitHubImport"|"ReturnGitHubQuery";


GitHub[
  command_String?(KeyMemberQ[$githubactions,ToLowerCase@#]&),
  args:Except[_?OptionQ]...,
  opp___?OptionQ
  ]:=
  Block[{$GitHubRepoFormat=True},
    Module[
      {
        cmd=$githubactions[ToLowerCase@command],
        ropp,
        r
        },
      ropp=
        If[Length@#==0, Sequence@@{}, #]&@
          If[Options[cmd]=!={},
            FilterRules[{opp}, Options@cmd],
            FilterRules[
              {opp}, 
              Except[$gitHubOptions]
              ]
            ];
        r=
          PackageExceptionBlock["GitHub"]@
            If[Options[cmd]=!={},
              cmd[args, ropp],
              With[{c=cmd[args, ropp]},
                If[Head@c===cmd, cmd[args], c]
                ]
              ];
          If[TrueQ@Lookup[{opp}, "ReturnGitHubQuery", False],
            r,
            Replace[r,
              h_HTTPRequest:>
                If[Lookup[{opp}, "GitHubImport", $GitHubImport]===False,
                  h, 
                  GitHubImport@URLRead[h]
                  ]
              ]
            ]/;Head[r]=!=cmd
        ]
    ];


(* ::Subsubsubsection::Closed:: *)
(*Raw Request*)



gitHubTrueFallbackMethod=
  (StringStartsQ[LetterCharacter?LowerCaseQ])


GitHub[
  path:{___String}|_String?gitHubTrueFallbackMethod:{},
  query:(_String->_)|{(_String->_)...}:{},
  headers:_Association:<||>,
  opp___?OptionQ
  ]:=
  PackageExceptionBlock["GitHub"]@
  Block[{$GitHubRepoFormat=True},
    If[TrueQ@Lookup[{opp}, "ReturnGitHubQuery", False],
      GitHubQuery[
        path,
        query,
        headers
        ],
      Replace[
        GitHubQuery[
          path,
          query,
          headers
          ],
        {
          h_HTTPRequest:>
            If[Lookup[{opp}, "GitHubImport", $GitHubImport]===False, 
              h, 
              GitHubImport@URLRead[h]
              ]
          }
        ]
      ]
    ];


(* ::Subsubsubsection::Closed:: *)
(*HTTPRequest*)



GitHub[
  path:{___String}|_String?gitHubTrueFallbackMethod:{},
  query:(_String->_)|{(_String->_)...}:{},
  headers:_Association:<||>,
  opp___?OptionQ,
  "HTTPRequest"
  ]:=
  GitHub[path, query, headers, opp, 
    "GitHubImport"->False
    ];


(* ::Subsubsubsection::Closed:: *)
(*HTTPResponse*)



GitHub[
  path:{___String}|_String?gitHubTrueFallbackMethod:{},
  query:(_String->_)|{(_String->_)...}:{},
  headers:_Association:<||>,
  opp___?OptionQ,
  "HTTPResponse"
  ]:=
  URLRead@
    GitHub[path, query, headers, opp, 
      "GitHubImport"->False,
      "ReturnGitHubQuery"->True
      ];


(* ::Subsubsubsection::Closed:: *)
(*ResultJSON*)



GitHub[
  path:{___String}|_String?gitHubTrueFallbackMethod:{},
  query:(_String->_)|{(_String->_)...}:{},
  headers:_Association:<||>,
  opp___?OptionQ,
  "ResultJSON"
  ]:=
  GitHubPostProcess[
    GitHub[path, query, headers, opp, "HTTPRequest"], 
    "ResultJSON"
    ];


(* ::Subsubsubsection::Closed:: *)
(*ImportedResult*)



GitHub[
  path:{___String}|_String?gitHubTrueFallbackMethod:{},
  query:(_String->_)|{(_String->_)...}:{},
  headers:_Association:<||>,
  opp___?OptionQ,
  "ImportedResult"
  ]:=
  GitHub[path, query, headers, opp, "GitHubImport"->True];


(* ::Subsubsubsection::Closed:: *)
(*ResultObject*)



GitHub[
  path:{___String}|_String?gitHubTrueFallbackMethod:{},
  query:(_String->_)|{(_String->_)...}:{},
  headers:_Association:<||>,
  opp___?OptionQ,
  "ResultObject"
  ]:=
  GitHubPostProcess[
    URLBuild@Flatten@{path},
    GitHub[path, query, headers, opp, "GitHubImport"->True],
    "ResultObject"
    ]


(* ::Subsubsubsection::Closed:: *)
(*ResultObject*)



GitHub[
  path:{___String}|_String?gitHubTrueFallbackMethod:{},
  query:(_String->_)|{(_String->_)...}:{},
  headers:_Association:<||>,
  opp___?OptionQ,
  "ResultObject"
  ]:=
  GitHubPostProcess[
    URLBuild@Flatten@{path},
    GitHub[path, query, headers, opp, "GitHubImport"->False],
    "ResultJSONObject"
    ]


End[];



