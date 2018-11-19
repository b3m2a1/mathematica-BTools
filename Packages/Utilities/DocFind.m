(* ::Package:: *)



DocFind::usage="Finds all the docs for a given pattern";
CtxFind::usage="Finds all the contexts for a given pattern";
OpsFind::usage=
  "Finds all the options for a given object and pattern";
MsgFind::usage="Finds all the messages for a given object and MessageName pattern";


Begin["`Private`"];


(* ::Subsubsection::Closed:: *)
(*DocFind*)



Options@DocFind=
  Join[
    {
      Format->True,
      Context->None,
      Autocomplete->True,
      SortBy->None,
      Sort->None,
      Hyperlink->Automatic,
      ButtonFunction->Automatic,
      Select->Identity
      },
    Options[Names],
    Options@PaneColumn
    ];


With[{
  callablePattern=(
  Except[
    None|_List|_String|_Rule|
    _Alternatives|_StringExpression|Automatic|
    _?(NumericQ)|_?(BooleanQ)|_?StringPattern`StringPatternQ|
    _?AtomQ
    ]
    )
  },
DocFind[
  name:_?StringPattern`StringPatternQ:"*",
  cont:(_?StringPattern`StringPatternQ|Automatic):Automatic,
  sortBySorting:None|callablePattern:None,
  ops:OptionsPattern[]
  ]:=
  Module[{searchName,names,selectBy},
    searchName=
      StringExpression@@{
        #context,
        If[#autocomp,"*",""],
        #name,
        If[#autocomp,"*",""]
        }&@<|
            "context"->
              Replace[Except[_?StringPattern`StringPatternQ]->""]@
                Replace[cont, 
                  {
                    s_String?(Not@*StringEndsQ["`"]):>s<>"`",
                    Automatic:>Alternatives@@$Packages
                    }
                  ],
            "name"->Replace[name,Verbatim[Verbatim][s_]:>s],
            "autocomp"->
              Replace[name,{_Verbatim->False,_:>TrueQ[OptionValue@Autocomplete]}]
            |>;
    names=Names[searchName,FilterRules[{ops},Options[Names]]];
    
    names=
      Replace[
        OptionValue[Select],{
        Identity:>
          names,
        match:
          _String?(
            Not@MatchQ[#,"Inert"]&&
            Not@KeyMemberQ[$SymbolNameTypes,#]
            &)|
          Verbatim[Alternatives][__?(Not@KeyMemberQ[$SymbolNameTypes,#]&)]|
          _StringExpression:>
          Select[names,StringMatchQ[match]],
        
        s:(_StringMatchQ|_StringContainsQ|_StringStartsQ|_StringEndsQ):>
          Select[names,s],
        s:(Not@*(_StringMatchQ|_StringContainsQ|_StringStartsQ|_StringEndsQ)):>
          Select[names,s],
        s_:>
          With[{f=
            Replace[s,{
              "Inert"|_?(KeyMemberQ[$SymbolNameTypes,#]&):>
                Function[Null,
                  SymbolDetermineType[#,s],
                  HoldFirst],
              ((Alternatives|Or|And)[__?(KeyMemberQ[$SymbolNameTypes,#]&)]):>
                Function[Null,
                  SymbolDetermineType[#,s],
                  HoldFirst],
              Query[f1_,o___]:>
                Function[Null,
                  Fold[#2@#&,
                    f1[Unevaluated[#]],
                    {o}],
                  HoldFirst
                  ]
                }
              ]
            },
            Pick[names,
              Replace[
                ToExpression[
                  names,
                  StandardForm,
                  Hold],
                Hold[sym_]:>
                  f[Unevaluated[sym]], 
                1
                ]
              ]
            ]
        }];
    names=
      Replace[sortBySorting,{
        sort1:callablePattern:>
          SortBy[names,
            Replace[sort1[#],
              b:True|False:>
                Boole@(*Not@*)b
              ]&
            ],
        _:>Replace[OptionValue@SortBy,{
            f:callablePattern:>
              SortBy[names,
                Replace[f[#],
                  b:True|False:>
                    Boole@Not@b
                  ]&
                ],
            _:>Replace[OptionValue@Sort,{
                g:callablePattern:>
                  Sort[names,g],
                _:>
                  SortBy[names,StringLength]
                }]
            }]
        }];
      If[OptionValue[Format]=!=False,
        If[Length@names>0,
          With[{buttonFunction=
            Replace[OptionValue@ButtonFunction,
              Automatic->(
                If[URLParse[#2]["Scheme"]===None,
                  OpenDocs@#1,
                  SystemOpen@#2
                  ]&)
                ]},
            Switch[Format,
              Links,
                Table[
                  With[{n=n,h=DocFile[n,OptionValue@Hyperlink]},
                    Interpretation[
                      Button[
                        Mouseover[
                          Style[n,"Hyperlink"],
                          Style[n,"HyperlinkActive"]],
                        buttonFunction[n,h],
                        Appearance->"Frameless",
                        Method->"Queued"
                        ],
                      ToExpression@n
                      ]
                    ],
                  {n,names}
                  ],
            _,
              Interpretation[
                PaneColumn[
                  Table[
                    With[{n=n,h=DocFile[n,OptionValue@Hyperlink]},
                      Interpretation[
                        Button[
                          Mouseover[
                            Style[n,"Hyperlink"],
                            Style[n,"HyperlinkActive"]],
                          buttonFunction[n,h],
                          Appearance->"Frameless",
                          Method->"Queued"
                          ],
                        ToExpression@n
                        ]
                      ],
                    {n,names}
                    ],
                  FilterRules[{ops,Options@DocFind},Options@PaneColumn]
                  ],
                ToExpression[names, StandardForm, Defer]
                ]
              ]
            ],
          None],
        names
        ]
      ]
    ];


$DocFindInterestingContexts=
  {
      "System`",
      "System`Private`",
      "System`Convert`",
      "System`*`",
      "Internal`",
      "FrontEnd`",
      "FEPrivate`",
      "PacletManager`",
      "MathLink`",
      "GeneralUtilities`",
      "TypeSystem`",
      "Dataset`",
      "Documentation`"
      };


PackageAddAutocompletions[
  "DocFind",
  {
    None,
    $DocFindInterestingContexts
    }
  ]


(* ::Subsubsection::Closed:: *)
(*CtxFind*)



Options[CtxFind]=
  Join[
    Options[Names],
    Options[PaneColumn],
    {
      "IncludePrivate"->False
      }
    ];
CtxFind[pat_?StringPattern`StringPatternQ, ops:OptionsPattern[]]:=
  With[
    {
      patReal=
        Replace[pat, 
          {
            Verbatim[p_]:>p,
            e_:>___~~e~~___
            }
          ]
        },
    Interpretation[
      PaneColumn[#, FilterRules[{ops}, Options@PaneColumn]],
      #
      ]&@
      Select[
        Sort@DeleteDuplicates@
          Map[StringRiffle[Append[Most[#], ""], "`"]&]@
            StringSplit[
              Names[patReal~~"`"~~__, FilterRules[{ops}, Options[Names]]],
              "`"
              ],
        If[TrueQ@OptionValue["IncludePrivate"],
          StringContainsQ[patReal], 
          StringContainsQ[#, patReal]&&!StringEndsQ[#, "Private`"]&
          ]
        ]
    ]


(* ::Subsubsection::Closed:: *)
(*OpsFind*)



Options@OpsFind:=
  Append[Options@DocFind,Function:>Options];
OpsFind[sym:Except@_List,stuff:(Except[_Rule|_RuleDelayed]...),ops:OptionsPattern[]]:=
  With[{opList=
    Replace[
      Replace[sym,{
        _CellObject:>Replace[
          OptionValue[Function],
          Options->AbsoluteOptions]@sym,
        _:>OptionValue[Function]@sym
        }],{
      o:Except[_List]:>{}
      }]
      },
    OpsFind[opList,stuff,ops]
  ];
OpsFind[options_List,
    pattern:_String|_StringExpression|_Alternatives:"*",
    sortBySorting:_Function|_Symbol?(#=!=None&):None,
    ops:OptionsPattern[]]:=
  With[{buttonFunction=Replace[
    OptionValue@ButtonFunction,{
      NotebookWrite->(
        SelectionMove[EvaluationCell[],After,Cell];
        NotebookWrite[InputNotebook[],Cell[BoxData@ToBoxes@#,"Output"]]
        &),
      Automatic|Hyperlink->(If[
        MatchQ[First@#,_Symbol],
        Evaluate@ToString@First@#//OpenDocs,
        Print[First@#<>" is not a symbol"]
        ]&)
      }]},
      With[{c=Cases[
        {#,ToString[First@#]}&/@options,
        {op_,name_?(
          StringMatchQ[#,
            If[
              MatchQ[pattern,_String],
              "*"<>pattern<>"*",
              ___~~pattern~~___
              ]]&)}:>{name,
                  Button[
                    Tooltip[
                      Mouseover[
                        Style[First@op,"Hyperlink"],
                        Style[First@op,"HyperlinkActive"]
                        ],op],
                    buttonFunction[op],
                    Appearance->"Frameless",
                    Method->"Queued"]
                    }]
                },
          If[Length@c>0,
            With[{sortedC=
      Replace[
              Replace[sortBySorting,
        Except[_Function|_Symbol?(#=!=None&)]:>OptionValue@SortBy
        ],{
                    f:_Function|_Symbol?(#=!=None&):>
                      With[{firsts=SortBy[First/@c,f]},
                        SortBy[c,Position[firsts,First@#]&]
                      ],
                    _:>Replace[OptionValue@Sort,{
                        f:_Function|_Symbol?(#=!=None&):>
                          With[{firsts=Sort[First/@c]},
                            SortBy[c,Position[firsts,First@#]&]
                            ],
                        _:>With[{firsts=SortBy[First/@c,StringLength]},
                            SortBy[c,Position[firsts,First@#]&]
                            ]
                          }]
                      }]},
            PaneColumn[
              Last/@sortedC,
              FilterRules[{ops,Options@OpsFind},Options@PaneColumn]
              ]
            ],
      None]
          ]
      ]


(* ::Subsubsection::Closed:: *)
(*MsgFind*)



MsgFind//Clear


Options@MsgFind=
  Join[
    Options@PaneColumn,
    Options@StringContainsQ,
    Options@Names,
    {
      "SearchBody"->False
      }
    ];
MsgFind[{syms___Symbol},mpat_?(StringPattern`StringPatternQ),ops:OptionsPattern[]]:=
  With[
    {
      sco=Sequence@@FilterRules[{ops}, Options@StringContainsQ],
      sb=TrueQ@OptionValue@"SearchBody"
      },
    If[Length@#>0,
          PaneColumn[#,
            FilterRules[
              {ops,Options@MsgFind},
              Options@PaneColumn
              ]
            ],
          None
          ]&@
    Quiet@
    Flatten@
      List@
      ReleaseHold@
      Map[
        Function[
          sym,
          With[{m=First/@Messages@sym},
            Cases[m,
              If[sb,
                Verbatim[HoldPattern][
                  mn_MessageName?(StringContainsQ[___~~mpat~~___, sco])
                  ],
                HoldPattern[
                  Verbatim[HoldPattern][
                    mn:MessageName[sym,
                        mname_?(StringContainsQ[___~~mpat~~___, sco])
                        ]
                      ]
                  ]
                ]:>
                Button[
                  Tooltip[
                    Mouseover[
                      Style[HoldForm[mn],"Hyperlink"],
                      Style[HoldForm[mn],"HyperlinkActive"]
                      ],
                    mn
                    ],
                  Print@
                  Interpretation[
                    MessageObject@
                      <|
                        "MessageSymbol":>sym,
                        "MessageTag"->mname,
                        "MessageTemplate"->mn
                        |>,
                    MessageObject@
                      <|
                        "MessageSymbol":>sym,
                        "MessageTag"->mname,
                        "MessageTemplate"->mn
                        |>
                    ],
                  Method->"Queued",
                  Appearance->"Frameless"
                  ]
                ]
            ],
        HoldFirst
        ],
      Hold[syms]
      ]
    ];
MsgFind[sym_Symbol,mpat_?(StringPattern`StringPatternQ),ops:OptionsPattern[]]:=
  MsgFind[{sym}, mpat, ops];
MsgFind[
  names:_?(StringPattern`StringPatternQ):"*",
  mpat_?(StringPattern`StringPatternQ),
  ops:OptionsPattern[]
  ]:=
Replace[
  Thread[
    ToExpression[
      Names[names, FilterRules[{ops}, Options@Names]], 
      StandardForm, 
      Hold
      ],
    Hold
    ],
  Hold[s_]:>MsgFind[s, mpat, ops]
  ];
MsgFind[
  e_,
  mpat_?(StringPattern`StringPatternQ),
  ops:OptionsPattern[]
  ]/;!TrueQ[$inMsgFind]:=
  Block[
    {
      $inMsgFind=True,
      res
      },
    res=MsgFind[Evaluate@e, mpat, ops];
    res/;Head[res]=!=MsgFind
    ];
MsgFind~SetAttributes~HoldFirst


End[];



