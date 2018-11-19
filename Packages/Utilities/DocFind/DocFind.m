(* ::Package:: *)



GetUsage::usage=
  "Finds the uses of a symbol";
FormattedUsage::usage=
  "Formats a GetUsage call";
FormattedDefs::usage=
  "FormattedUsage with Full";
DocFile::usage="Returns the doc file for a given symbol";
OpenDocs::usage="Opens a documentation notebook for the symbol name";
ContextOrdering::usage="The ordering function for context notebooks";
ContextNotebook::usage="Formats a notebook to give docs for an entire context";
DocsDialog::usage=
  "Creates a documentation search dialog";
$DockDocDialog::usage=
  "A symbol formatted to the docs dialog in the documentation search palette";


Begin["`Private`"];


(* ::Subsubsection::Closed:: *)
(*DocFile*)



DocFile[symbolName_String,mode_:Automatic]:=TemplateApply[
Switch[mode,
"Web"|Hyperlink|URL,
URLBuild@<|"Scheme"->"https",
"Domain"->"reference.wolfram.com",
"Path"->{"language","ref","``.html"}
|>,
Automatic|File,
FileNameJoin@{$InstallationDirectory, "Documentation", "English","System", "ReferencePages","Symbols","``.nb"}
],
symbolName]


(* ::Subsubsection::Closed:: *)
(*PrintDefinitionsNotebook*)



PrintDefinitionsNotebook[nb_,symbolName_]:=
  Block[{GeneralUtilities`PackageScope`$EmbedSymbolBoxStyles=True,
    GeneralUtilities`Debugging`PackagePrivate`$PrintDefinitionsBackground=None,
    CreateDocument =(NotebookWrite[nb,
      #/.GeneralUtilities`PrintDefinitions->GeneralUtilities`PrintDefinitionsLocal,
      None,
      AutoScroll->False]&)
    },
  ToExpression[symbolName,StandardForm,GeneralUtilities`PrintDefinitions]
  ];


(* ::Subsubsection::Closed:: *)
(*OpenDocs*)



OpenDocs[
  symbolName:_String,
  fileSource:_String|Automatic:Automatic,
  docNB:_NotebookObject|CreateNotebook|Automatic:Automatic,
  ops:OptionsPattern[Notebook]]:=
  Module[{
    file=Replace[fileSource,Automatic:>DocFile@symbolName],
    winTit="Documentation Notebook: "<>symbolName,
    nb=Replace[docNB,{
        Automatic|_NotebookObject?(NotebookInformation@#===$Failed&):>$DocPage,
        CreateNotebook:>
          Quiet[
            CreateNotebook[ops,
              WindowTitle->"Documentation Notebook: "<>symbolName,
              System`ClosingSaveDialog->False,
              CellMargins->{{100,Automatic},{100,Automatic}},
              StyleDefinitions->
                FrontEnd`FileName[{"Wolfram"},"Reference.nb",CharacterEncoding->"UTF-8"]
              ],
            ClosingSaveDialog::shdw]
          }]},
    If[MatchQ[nb,
      Except[_NotebookObject]|_NotebookObject?(NotebookInformation@#===$Failed&)],
      nb=If[
        FreeQ[
          CurrentValue[EvaluationNotebook[],StyleDefinitions],
          _String?(StringContainsQ["Palette"|"Dialog"|"PrivateStylesheetFormatting"])
          ],
        Documentation`HelpLookup[symbolName,EvaluationNotebook[]],
        Documentation`HelpLookup[symbolName,None]
        ];
      If[docNB===Automatic,$DocPage=nb];,
      If[FileExistsQ@file//TrueQ,
        With[{nbops=
          FilterRules[
            Join[{ops},Replace[AbsoluteOptions@nb,$Failed->{}]],
            Except[WindowTitle]]},
          NotebookPut[Get@file,nb,Sequence@@Prepend[nbops,WindowTitle->winTit]]
          ],
        Do[
          If[Not@(Deletable/.Options[c,Deletable]),SetOptions[c,Deletable->True]];,
          {c,Cells@nb}];
        NotebookDelete[Cells@nb];
        SetOptions[nb,WindowTitle->winTit]
        ]
      ];
  SetSelectedNotebook@nb;
  SelectionMove[nb,After,Notebook,AutoScroll->False];
  NotebookWrite[nb,
    Cell["Definitions Block","Section",CellFrame->{{0,0},{1,1}}],
    None,
    AutoScroll->False];
  Replace[
    Replace[
      ToExpression[symbolName,StandardForm,HoldComplete],
      HoldComplete[s_]:>MessageName[s,"usage"]
      ],
    e:Except[_MessageName]:>
      NotebookWrite[nb,Cell[BoxData[e],"Output"],None,AutoScroll->False]
    ];
  PrintDefinitionsNotebook[nb,symbolName];
  NotebookWrite[nb,
    Cell["","Section",
        CellFrame->{{0,0},{1,1}}],None,AutoScroll->False];
    SelectionMove[nb,Before,Notebook];
    nb
  ];


OpenDocs[s_ToString,o___]:=OpenDocs[Evaluate@s,o]
OpenDocs[sym_Symbol,o___]:=OpenDocs[ToString@Unevaluated@sym,o];
OpenDocs~SetAttributes~HoldFirst;


(* ::Subsubsection::Closed:: *)
(*GetUsage*)



definitionPatternsSimplify[valueSpec_List]:=
  Replace[valueSpec,
    Verbatim[HoldPattern][p___]:>
      (HoldForm[p]/.{
        Verbatim[Pattern][name_,pat_]:>pat,
        Verbatim[Optional][Verbatim[Pattern][name_,pat_],v_]:>Optional[pat,v]
        }),
    1];


defintionsValueFunctions=
  OwnValues|DownValues|UpValues|SubValues|Attributes|Messages|Options;
GetUsage[
  sym_Symbol|Verbatim[HoldPattern][sym_Symbol],
  getTypes:
    (defintionsValueFunctions|
    {defintionsValueFunctions..}|All|Short):Short,
  fullUsage:Full|True|False|Short:False]:=
  With[{
    get=
      Replace[getTypes,
        {
          All->{
            OwnValues,DownValues,UpValues,SubValues,
            Attributes,Messages,Options},
          Short->{OwnValues,DownValues,UpValues,SubValues},
          a:Except[_List]:>{a}
          }],
    full=Replace[fullUsage,{Full->True,Short->False}]
    },
    With[{vals=Join@@Table[With[{a=a},a[sym]],{a,get}]},
      If[full,
        vals,
        First/@vals//definitionPatternsSimplify
        ]
      ]
    ];
GetUsage~SetAttributes~HoldFirst;


formattedUsageOnClick=
  Block[{
    GeneralUtilities`Debugging`PackagePrivate`$DefinitionSymbolTemplateBoxOptions=
      {
        Editable -> False,
        DisplayFunction -> 
          Function[
            TagBox[
              TagBox[
                TooltipBox[#2,
                  StyleBox[#,
                    FontColor -> RGBColor[0, 0, 0],
                    FontFamily -> "Courier", 
                    FontWeight -> Bold
                    ],
                  TooltipDelay -> 0.4
                  ],
                EventHandlerTag[{
                  "MouseClicked" :>(
                    Replace[ToExpression[#,StandardForm,FormattedDefs],
                      c:Column[{__}]:>(
                        SelectionMove[EvaluationNotebook[],After,Cell];
                        NotebookWrite[EvaluationNotebook[],
                          Cell[BoxData@ToBoxes@c,
                            Sequence@@Rest@NotebookRead[EvaluationCell[]]
                            ],
                          None,
                          AutoScroll->False
                          ]
                      )]
                    )
                  }]
              ],
              MouseAppearanceTag @ "LinkHand"
            ]
          ],
          InterpretationFunction -> (#&)
        }
      },
      RawBoxes@ToBoxes@GeneralUtilities`CodeForm[#]
      ]&;


Options[FormattedUsage]=
  Join[
    {
      Format->formattedUsageOnClick
      },
    Options@Column,
    Options@Style
    ];
FormattedUsage[
  sym_Symbol|Verbatim[HoldPattern][sym_Symbol],
  fullUsage:Full|True|False|Short:False,
  ops:OptionsPattern[]]:=
  With[{
    format=
      Replace[OptionValue[Format],{
        None->Identity,
        Automatic|Box->(GeneralUtilities`PrettyForm@#&)
        }]
        },
    format/@(sym~GetUsage~fullUsage)
      //Column[#,FilterRules[{ops},Options@Column]]&
      //Style[#,"Input",FilterRules[{ops},Options@Style]]&
    ];
FormattedUsage~SetAttributes~HoldFirst;


FormattedDefs[
  sym_Symbol|Verbatim[HoldPattern][sym_Symbol],
  ops:OptionsPattern[]
  ]:=
  FormattedUsage[sym,Full,ops];
FormattedDefs~SetAttributes~HoldFirst;


(* ::Subsubsection::Closed:: *)
(*ToolbarAdd*)



ToolBarEdit[toolbar_,
editFunction_:(Delete[#1,First/@#2]&),
editObjects_:(_Grid|_Row|_Column)
]:=
With[{toolbarCell=FirstCase[FrontEndResource["FEExpressions",toolbar],
_Cell]},
With[{toolbarExpression=ToExpression@First@toolbarCell},
With[{resourceList=
    Replace[
Position[toolbarExpression,editObjects],
pos_List:>Table[p->Part[toolbarExpression,Sequence@@p],{p,pos}]
]
},
ReplacePart[toolbarCell,
1->Replace[editFunction[
toolbarExpression,
resourceList
],
b:Except[_BoxData]:>BoxData@ToBoxes@b
]
]
]
]
]


(* ::Subsubsection::Closed:: *)
(*ContextNotebook*)



usageMSG[s_]:=MessageName[s,"usage"];
usageMSG~SetAttributes~HoldFirst;


ContextOrdering[name_]:=(StringLength[name]+Which[
    MemberQ[ToExpression[name,StandardForm,Attributes],Temporary],
    1000,
    (Length@ToExpression[name,StandardForm,OwnValues]==0&&
      Length@ToExpression[name,StandardForm,DownValues]==0&&
      Length@ToExpression[name,StandardForm,UpValues]==0&&
      Length@ToExpression[name,StandardForm,SubValues]==0),
    500,
    MatchQ[
      ToExpression[name,StandardForm,usageMSG],
      _MessageName
      ],100,
    True,
    LetterNumber@StringTake[name,{1}]
    ])


ContextFind[pkg_,pat_:"*",ops:(_Rule|_RuleDelayed)...]:=
  DocFind[pat,
    ContextOrdering,
    Context->pkg,
    ops]


ContextNotebook[pkg_]:=With[{nb=OpenDocs[
    "",
    CreateNotebook,
    Visible->False]},
  With[{cells=Prepend[Cell[BoxData@#,"SearchResultCell",
    CellEventActions->{},
    Deletable->True]&/@Cases[DocFind["*",
      ContextOrdering,
      Context->pkg,
      ButtonFunction->((
        NotebookDelete@Cells[nb];
        OpenDocs[#,nb])&)
      ],Button[
      Mouseover[Style[text_,___],___],
      cmd___]:>{Cell[
        BoxData@ToBoxes@Button[Mouseover[
          Style[text,RGBColor[.75,0,0]],
          Style[text,RGBColor[.95,.2,0]]
          ],
        cmd],
      "SearchResultTitle"],
    Cell[Replace[
      ToExpression["Unevaluated["<>pkg<>"`"<>text<>"]",
        StandardForm,MessageName[#,"usage"]&],{
        _MessageName:>pkg<>"`"<>text,
        b_:>BoxData@b
        }],
    "SearchResultSummary"]
    },
  \[Infinity]],
  Cell[pkg,"SearchPageHeading",CellFrame->{{0,0},{1,0}}]
  ]},
  SetOptions[nb,
    DockedCells->
    Replace[
      ToolBarEdit["HelpViewerToolbar",
        BoxData@{ToBoxes@#1,
          ToBoxes@Button[
            Row@{Spacer[25],Style["\[ReturnIndicator]",Gray]},
            SetOptions[#,Deletable->True]&/@Cells@nb;
            NotebookPut[Notebook[cells,AbsoluteOptions@nb],nb];
            SelectionMove[nb,Before,Notebook];
            SetOptions[nb,WindowTitle->"Context: "<>pkg<>"`"],
            Method->"Queued",
            Appearance->"Frameless"
            ]}&
        ],
      Cell[e_,t_,c__]:>Cell[e,t,
        Background->GrayLevel[.95],
        CellFrame->{{0,0},{5,0}},c]
      ]
    ];
  NotebookDelete@Cells@nb;
  NotebookWrite[nb,cells,None,AutoScroll->False]];
  SetOptions[nb,WindowTitle->"Context: "<>pkg<>"`",Visible->True];
  nb
  ]


(* ::Subsubsection::Closed:: *)
(*Documentation Dialog*)



DocsDialog[dialog:Except[_Rule]:False,ops:OptionsPattern[CreateDialog]]:=
DynamicModule[{
  symbolName="",context="",option="",
  optionUpdate,symbolUpdate,viewing=False,
  autocomplete=True},
  Dynamic[viewing;context;
    {
      Column@{
        TextCell["Context","Text",
          FontSize->If[dialog===DockedCells,12,Automatic]],
        TextCell[
          InputField[
            Dynamic[context,
            (If[
                MemberQ[StringLength/@{#,context},0]
                  ||
                Not@(StringMatchQ[#,context<>"*"]||StringMatchQ[context,#<>"*"]),
                symbolName="";
                option=""];
                context=#
              )&
            ],String],"Input"]},
      Grid[{
        {
          TextCell["Symbol","Text",FontSize->If[dialog===DockedCells,12,Automatic]],
          TextCell["Option","Text",FontSize->If[dialog===DockedCells,12,Automatic]]
        },
        {
          TextCell[
            InputField[
              Dynamic[symbolName,
                (symbolName=#;symbolUpdate=RandomReal[];&)],
              String,
              FieldSize->Automatic
              ],
            "Input"],
          TextCell[
            InputField[
              Dynamic[option,
                  (If[symbolName=!="",option=#;optionUpdate=RandomReal[];]&)],
              String,
              FieldSize->Automatic],
            "Input"]
          },
          With[{conf=
            {
              FrameStyle->GrayLevel[.8],
              Framed->True,
              Background->White,
              ImageSize->{290,If[dialog===DockedCells,60,250]}}
            },
              {
                Dynamic[symbolName;
                  If[StringLength[symbolName]>1,
                    If[DownValues@DocFind=={},Needs@"BTools`"];
                    DocFind[symbolName,
                        Context->If[context=="","*",context],
                        Sequence@@conf
                      ],
                    ""
                    ],
                  TrackedSymbols:>{symbolName}
                  ],
                Dynamic[option;
                      If[option=!="",
                          OpsFind[
                            ToExpression[
                                If[context=="",symbolName,context<>"`"<>symbolName],
                                  StandardForm,Unevaluated],
                              option,
                              ButtonFunction->Hyperlink,
                              Sequence@@conf
                            ],
                          ""
                        ],
                  TrackedSymbols:>{option}
                  ]
                }
              ]
            },
            Dividers->{{1->Gray,2->Gray,3->Gray},{1->Gray,-1->Gray}},
            Alignment->{Left,Top}
          ]
        }//
          If[dialog===DockedCells,
            Column@{
              Button[
                RawBoxes@
                  FrontEndResource["FEBitmaps",
                    If[viewing,"SquareMinusIconSmall","SquarePlusIconSmall"]
                    ],
                viewing=Not@viewing,
                Appearance->"Frameless"
                      ],
              Row@{
                  Spacer[25],
                  If[viewing,
                    Column@#,
                    Button[Style["Search Documentation",Italic,Gray],
                      viewing=True,
                      Appearance->"Frameless"]
                    ]
                  }
                }&,
              Column],
      TrackedSymbols:>{viewing,context}
    ]]//
      If[dialog===DockedCells,
        (#/.(Dividers->_)->(Dividers->None))&,
        TextCell[
          Framed[#,
            RoundingRadius->5,
            Background->GrayLevel[.95]],
          FontFamily->"ArialBlack"]&]//
      Deploy//
        Switch[
          If[
            MatchQ[dialog,
              _NotebookObject?(NotebookInformation[#]===$Failed&)|
              Except[_NotebookObject|True]
              ],
            (Length@{ops}>0),
            dialog
          ],
          True,CreateDialog[#,ops,WindowTitle->"Documentation Helper"]&,
          _NotebookObject,CreateDialog[#,dialog,Sequence@@Join[{ops},Options@dialog]]&,
          _,Identity];


(* ::Subsubsection::Closed:: *)
(*$DockDocDialog*)



$DockDocDialog:=
  Append[
    First@FEResourceFind["Help*Toolbar"]//Last,
    Cell[
      BoxData@ToBoxes@(
        DocsDialog[DockedCells]/.
          (
            (ImageSize->{290,_})->(ImageSize->{290,{60,250}})
          )
        )]
    ]


End[];



