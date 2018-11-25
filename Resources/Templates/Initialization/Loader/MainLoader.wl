(* ::Package:: *)

(* ::Title:: *)
(*$Name`*)


(* ::Text::GrayLevel[0.5]:: *)
(* Autogenerated $Name loader file *)


Temp`PackageScope`$NameLoading`Private`$DependencyLoad=
  TrueQ@Temp`PackageScope`$NameLoading`Private`$DependencyLoad;
If[Temp`PackageScope`$NameLoading`Private`$DependencyLoad,
  Unprotect["`$Name`PackageScope`Private`$TopLevelLoad"];
  Evaluate[Symbol["`$Name`PackageScope`Private`$TopLevelLoad"]]=False,
  Unprotect["$Name`PackageScope`Private`$TopLevelLoad"];
  Evaluate[Symbol["$Name`PackageScope`$NameLoading`$TopLevelLoad"]]=
    MemberQ[$ContextPath, "Global`"]
  ];


If[Temp`PackageScope`$NameLoading`Private`$DependencyLoad,
  Evaluate[Symbol["`$Name`PackageScope`Private`$RootContext"]]=$Context;
  BeginPackage["`$Name`"],
  Evaluate[Symbol["$Name`PackageScope`Private`$RootContext"]]="";
  BeginPackage["$Name`"]
  ]


ClearAll[$Name];
$Name::usage="$Name is a manager head for the $Name package";


(* ::Subsubsection::Closed:: *)
(*ContextPath*)


System`Private`NewContextPath@
  Join[
    $ContextPath,
    $Context<>
      StringReplace[
        FileNameDrop[#,FileNameDepth@DirectoryName@$InputFileName],
        $PathnameSeparator->"`"
        ]&/@
      Select[
        DirectoryQ@#&&
          StringMatchQ[
            StringReplace[
              FileNameDrop[#,FileNameDepth@DirectoryName@$InputFileName],
              $PathnameSeparator->"`"
              ],
            ("$"|WordCharacter)..
            ]
        &]@
      FileNames["*",
        FileNameJoin@{
          DirectoryName@$InputFileName,
          "Packages"
          },
        Infinity
        ]
    ];


(* ::Section:: *)
(* Package Functions *)


Unprotect["`PackageScope`Private`*"];
Begin["`PackageScope`Private`"];
AppendTo[$ContextPath, $Context];


$InitCode


(* ::Subsection:: *)
(*Post-Processing*)


PackagePostProcessPrepSpecs::usage="";
PackagePrepPackageSymbol::usage="";
PackagePostProcessExposePackages::usage="";
PackagePostProcessRehidePackages::usage="";
PackagePostProcessDecontextPackages::usage="";
PackagePostProcessContextPathReassign::usage="";
PackageAttachMainAutocomplete::usage="";
PackagePreemptShadowing::usage="";


Begin["`PostProcess`"];


(* ::Subsubsection::Closed:: *)
(*PrepFileName*)


PackagePostProcessFileNamePrep[fn_]:=
    Replace[
      FileNameSplit@
        FileNameDrop[fn,
          FileNameDepth@
            PackageFilePath["Packages"]
          ],{
      {f_}:>
        f|fn|StringTrim[f,".m"|".wl"],
      {p__,f_}:>
        FileNameJoin@{p,f}|fn|{p,StringTrim[f,".m"|".wl"]}
      }]


(* ::Subsubsection::Closed:: *)
(*PrepSpecs*)


PackagePostProcessPrepSpecs[]:=
  (
    Unprotect[
      $PackagePreloadedPackages,
      $PackageHiddenPackages,
      $PackageHiddenContexts,
      $PackageExposedContexts,
      $PackageDecontextedPackages
      ];
    Replace[
      $PackageLoadSpecs,
      specs:{__Rule}|_Association:>
        CompoundExpression[
          $PackagePreloadedPackages=
            Replace[
              Lookup[specs, "PreLoad"],
              Except[{__String}]->{}
              ],
          $PackageHiddenPackages=
            Replace[
              Lookup[specs,"FEHidden"],
              Except[{__String}]->{}
              ],
          $PackageDecontextedPackages=
            Replace[
              Lookup[specs,"PackageScope"],
              Except[{__String}]->{}
              ],
          $PackageExposedContexts=
            Replace[
              Lookup[specs,"ExposedContexts"],
              Except[{__String}]->{}
              ]
          ]
        ]
    );


(* ::Subsubsection::Closed:: *)
(*ExposePackages*)


PackagePostProcessExposePackages[]/;TrueQ[$AllowPackageRecoloring]:=
  (
    PackageAppGet/@
      $PackagePreloadedPackages;
    With[{
      syms=
        If[
          !MemberQ[$PackageHiddenPackages,
            PackagePostProcessFileNamePrep[#]
            ],
          $DeclaredPackages[#],
          {}
          ]&/@Keys@$DeclaredPackages//Flatten
      },
      Replace[
        Thread[
          If[ListQ@$PackageFEHiddenSymbols,
            DeleteCases[syms,
              Alternatives@@
                (Verbatim[HoldPattern]/@Flatten@$PackageFEHiddenSymbols)
              ],
            syms
            ],
          HoldPattern],
        Verbatim[HoldPattern][{s__}]:>
          PackageFEUnhideSymbols[s]
        ]
      ]
    )




(* ::Subsubsection::Closed:: *)
(*Rehide Packages*)


PackagePostProcessRehidePackages[]/;TrueQ[$AllowPackageRecoloring]:=
  If[
    MemberQ[$PackageHiddenPackages,
      PackagePostProcessFileNamePrep[#]
      ],
    PackageFERehidePackage@#
    ]&/@Keys@$DeclaredPackages


(* ::Subsubsection::Closed:: *)
(*Decontext*)


PackagePostProcessDecontextPackages[]/;TrueQ[$AllowPackageRecoloring]:=
  (
    If[
      MemberQ[$PackageDecontextedPackages,
        PackagePostProcessFileNamePrep[#]
        ],
      PackageFERehidePackage@#;
      PackageDecontext@#
      ]&/@Keys@$DeclaredPackages;
    If[ListQ@$PackageScopedSymbols,
      KeyValueMap[
        With[{newcont=#},
          Replace[Join@@#2,
            HoldComplete[s__]:>
              (
                PackageFERehideSymbols[s];
                Map[
                  Function[Null,
                    Quiet[
                      Check[
                        Set[Context[#],newcont],
                        Remove[#],
                        Context::cxdup
                        ],
                      Context::cxdup
                      ],
                    HoldAllComplete
                    ],
                  HoldComplete[s]
                  ]//ReleaseHold;
                )
            ]
          ]&,
        GroupBy[Flatten@$PackageScopedSymbols,First->Last]
        ];
      ]
    )




(* ::Subsubsection::Closed:: *)
(*ContextPathReassign*)


PackagePostProcessContextPathReassign[]:=
  With[{cp=$ContextPath},
    If[MemberQ[cp],
      "$Name`",
      $ContextPath=
        Join[
          Replace[
            Flatten@{$PackageExposedContexts},
            Except[_String?(StringEndsQ["`"])]->Nothing,
            1
            ],
          $ContextPath
          ];
      If[TrueQ[$AllowPackageRecoloring], 
        FrontEnd`Private`GetUpdatedSymbolContexts[]
        ];
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*AttachMainAutocomplete*)


PackageAttachMainAutocomplete[]:=
  PackageAddAutocompletions[$Name, 
    Table[
      Replace[{}->None]@
        Cases[
          DownValues[$Name],
          Nest[
            Insert[#, _, {1, 1, 1}]&,
            (HoldPattern[Verbatim[HoldPattern]][
              $Name[s_String, ___]
              ]:>_),
            n-1
            ]:>s,
          Infinity
          ],
      {n, 5}
      ]
    ];


(* ::Subsubsection::Closed:: *)
(*PreventShadowing*)


PackagePreemptShadowing[]:=
  Replace[
    Hold[{m___}]:>
      Off[m]
      ]@
    Thread[
      ToExpression[
        Map[#<>"$"&, Names["`PackageScope`Private`*"]
        ],
        StandardForm,
        Function[Null, 
          Hold[MessageName[#, "shdw"]],
          HoldAllComplete
          ]
        ],
      Hold
      ]


(* ::Subsubsection::Closed:: *)
(*PackagePrepPackageSymbol*)


PackagePrepPackageSymbol[]:=
  Switch[$AllowPackageSymbolDefinitions,
    None,
      Remove[$Name],
    False,
      Clear[$Name],
    _,
      PackageAttachMainAutocomplete[]
    ]


End[];


(* ::Subsection:: *)
(*End*)


$ContextPath=DeleteCases[$ContextPath, $Context];
End[];


(* ::Section:: *)
(* Load *)


If[`PackageScope`Private`$AllowPackageRecoloring,
  Internal`SymbolList[False]
  ];


(* ::Subsubsection::Closed:: *)
(*Basic Load*)


`PackageScope`Private`$loadAbort=False;
CheckAbort[
  `PackageScope`Private`PackageAppLoad[];
  `PackageScope`Private`$PackageFEHideExprSymbols=True;
  `PackageScope`Private`$PackageFEHideEvalExpr=True;
  `PackageScope`Private`$PackageScopeBlockEvalExpr=True;
  `PackageScope`Private`$PackageDeclared=True;,
  `PackageScope`Private`$loadAbort=True;
  EndPackage[];
  ];
Protect["`PackageScope`Private`*"];
Unprotect[`PackageScope`Private`$loadAbort];


(* ::Subsubsection::Closed:: *)
(*Post-Process*)


If[!`PackageScope`Private`$loadAbort,
  `PackageScope`Private`PackagePostProcessPrepSpecs[];
  `PackageScope`Private`PackagePrepPackageSymbol[];
  `PackageScope`Private`PackagePostProcessExposePackages[];
  `PackageScope`Private`PackagePostProcessRehidePackages[];
  `PackageScope`Private`PackagePostProcessDecontextPackages[];
  ]


Unprotect[`PackageScope`Private`$PackageFEHiddenSymbols];
Clear[`PackageScope`Private`$PackageFEHiddenSymbols];
Unprotect[`PackageScope`Private`$PackageScopedSymbols];
Clear[`PackageScope`Private`$PackageScopedSymbols];


(* Hide `PackageScope`Private` shadowing *)
`PackageScope`Private`PackagePreemptShadowing[]


(* ::Subsubsection:: *)
(*EndPackage / Reset $ContextPath*)


Temp`PackageScope`$NameLoading`Private`$DependencyLoad=
  `PackageScope`Private`$PackageLoadingMode==="Dependency";


System`Private`RestoreContextPath[]
EndPackage[];


(* ::Subsubsection::Closed:: *)
(*Cleanup*)


If[Temp`PackageScope`$NameLoading`Private`$DependencyLoad,
  If[
    (Clear@`$Name`PackageScope`Private`$loadAbort;!#)&@
      `$Name`PackageScope`Private`$loadAbort,
    Unprotect[`$Name`PackageScope`Private`$LoadCompleted];
    `$Name`PackageScope`Private`$LoadCompleted=True;
    `$Name`PackageScope`Private`PackagePostProcessContextPathReassign[]
    ],
  If[
    (Clear@$Name`PackageScope`Private`$loadAbort;!#)&@
      $Name`PackageScope`Private`$loadAbort,
    Unprotect[$Name`PackageScope`Private`$LoadCompleted];
    $Name`PackageScope`Private`$LoadCompleted=True;
    $Name`PackageScope`Private`PackagePostProcessContextPathReassign[]
    ]
 ]


Remove["Temp`PackageScope`$NameLoading`Private`*"]
