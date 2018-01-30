(* ::Package:: *)

(* ::Subsection:: *)
(*Usage Messages*)


(* ::Text:: *)
(*This is just an artifact from how this package was originally developed...*)


PackageAutoFunctionInfo::usage="PackageAutoFunctionInfo[f, o]";


(* ::Subsubsection::Closed:: *)
(*Helpers*)


packageFuncInfoGetCodeValues::usage="packageFuncInfoGetCodeValues[f, vs]";
packageFuncInfoExtractorLocalized::usage="packageFuncInfoExtractorLocalized[s]";
$packageFuncInfoUsageTypeReplacements::usage="$packageFuncInfoUsageTypeReplacements";
$packageFuncInfoUsageSymNames::usage="$packageFuncInfoUsageSymNames";
packageFuncInfoSymbolUsageReplacementPattern::usage="packageFuncInfoSymbolUsageReplacementPattern[names, conts]";
packageFuncInfoUsagePatternReplace::usage="packageFuncInfoUsagePatternReplace[vals, reps]";
packageFuncInfoGenerateSymbolUsage::usage="packageFuncInfoGenerateSymbolUsage[f, defaultMessages]";
packageFuncInfoAutoCompletionsExtractSeeder::usage="packageFuncInfoAutoCompletionsExtractSeeder[_ | (Blank | BlankSequence)[Hue | RGBColor | XYZColor | LABColor], n]
packageFuncInfoAutoCompletionsExtractSeeder[_, n]
packageFuncInfoAutoCompletionsExtractSeeder[_ | (Blank | BlankSequence)[File] | _File, n]
packageFuncInfoAutoCompletionsExtractSeeder[Alternatives[s], n]
packageFuncInfoAutoCompletionsExtractSeeder[_, n]
packageFuncInfoAutoCompletionsExtractSeeder[a, n]";
packageFuncInfoAutoCompletionsExtract::usage="packageFuncInfoAutoCompletionsExtract[_[a]]
packageFuncInfoAutoCompletionsExtract[f]";
packageFuncInfoGenerateAutocompletions::usage="packageFuncInfoGenerateAutocompletions[f, otherAutos]";
$packageFuncInfoAutoCompletionFormats::usage="$packageFuncInfoAutoCompletionFormats";
$packageFuncInfoAutocompletionAliases::usage="$packageFuncInfoAutocompletionAliases";
$packageFuncInfoAutocompletionTable::usage="$packageFuncInfoAutocompletionTable";
packageFuncInfoAutocompletionPreCompile::usage="packageFuncInfoAutocompletionPreCompile[v]
packageFuncInfoAutocompletionPreCompile[o]
packageFuncInfoAutocompletionPreCompile[s, v]
packageFuncInfoAutocompletionPreCompile[l, v]";
packageFuncInfoAddAutocompletions::usage="packageFuncInfoAddAutocompletions[pats]
packageFuncInfoAddAutocompletions[pat]";
packageFuncInfoReducePatterns::usage="packageFuncInfoReducePatterns[p]";
packageFuncInfoReconstructPatterns::usage="packageFuncInfoReconstructPatterns[p]";
packageFuncInfoArgPatPartLens::usage="packageFuncInfoArgPatPartLens[patList]";
packageFuncInfoMergeArgPats::usage="packageFuncInfoMergeArgPats[pats, returnNum]";
packageFuncInfoGenerateSIArgPat::usage="packageFuncInfoGenerateSIArgPat[f]";
packageFuncInfoGenerateSILocVars::usage="packageFuncInfoGenerateSILocVars[f]";
packageFuncInfoGenerateSIColEq::usage="packageFuncInfoGenerateSIColEq[f]";
packageFuncInfoGenerateSIOpNames::usage="packageFuncInfoGenerateSIOpNames[f]";
packageFuncInfoGenerateSyntaxInformation::usage="packageFuncInfoGenerateSyntaxInformation[f, ops]";
packageFuncInfoGenerateArgCount::usage="packageFuncInfoGenerateArgCount[f]";
packageFuncInfoSetArgCount::usage="packageFuncInfoSetArgCount[f, minA, maxA, noo]";
packageFuncInfoGeneratePackagePackageAutoFunctionInfo::usage="packageFuncInfoGeneratePackagePackageAutoFunctionInfo[f, ops]";


(* ::Subsection:: *)
(*CodeValues*)


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoGetCodeValues*)


packageFuncInfoGetCodeValues[f_Symbol,
   vs :
    {Repeated[
      OwnValues | DownValues | SubValues | UpValues]} : {OwnValues, 
     DownValues, SubValues, UpValues}
   ] :=
  
  If[Intersection[Attributes@f, { ReadProtected, Locked}] === { 
     Locked, ReadProtected},
   {},
   Join @@ Map[#[f] &, vs]
   ];
packageFuncInfoGetCodeValues~SetAttributes~HoldFirst


(* ::Subsection:: *)
(*Usage*)


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoSymbolUsageReplacementPattern*)


packageFuncInfoExtractorLocalized[s_] :=
  
  Block[{$ContextPath = {"System`"}, $Context = 
     "FEInfoExtractor`Private`"},
   Internal`WithLocalSettings[
    BeginPackage["FEInfoExtractor`Private`"];
    Off[General::shdw];,
    ToExpression[s],
    On[General::shdw];
    EndPackage[]
    ]
   ];
$packageFuncInfoUsageTypeReplacements =
  {
   Integer -> packageFuncInfoExtractorLocalized["int"],
   Real -> packageFuncInfoExtractorLocalized["float"],
   String -> packageFuncInfoExtractorLocalized["str"],
   List -> packageFuncInfoExtractorLocalized["list"],
   Association -> packageFuncInfoExtractorLocalized["assoc"],
   Symbol -> packageFuncInfoExtractorLocalized["sym"]
   };
$packageFuncInfoUsageSymNames =
  {
   Alternatives -> packageFuncInfoExtractorLocalized["alt"],
   PatternTest -> packageFuncInfoExtractorLocalized["test"],
   Condition -> packageFuncInfoExtractorLocalized["cond"],
   s_Symbol :>
    RuleCondition[
     packageFuncInfoExtractorLocalized@
      ToLowerCase[StringTake[SymbolName[Unevaluated@s], UpTo[3]]],
      True
     ]
   };
packageFuncInfoSymbolUsageReplacementPattern[names_, conts_] :=
  s_Symbol?(
     GeneralUtilities`HoldFunction[
      ! MatchQ[Context[#], conts] &&
       ! 
        MemberQ[$ContextPath, Context[#]] &&
       ! 
        KeyMemberQ[names, SymbolName@Unevaluated[#]]
      ]
     ) :>
   RuleCondition[
    ToExpression@
     Evaluate[$Context <>
       
       With[{name = SymbolName@Unevaluated[s]},
        If[StringLength@StringTrim[name, "$"] > 0,
         StringTrim[name, "$"],
         name
         ]
        ]
      ],
    True];
packageFuncInfoSymbolUsageReplacementPattern[
   vals_,
   reps_: {}
   ] :=
  With[{
    names = AssociationMap[Null &, {}(*Names[]*)],
    conts = 
     Alternatives @@ {"System`", "FrontEnd`", "PacletManager`", 
       "Internal`"}
    },
   Replace[
      Replace[
       #,
        {
        Verbatim[HoldPattern][a___] :> a
        },
       {2, 10}
       ],
      Join[$packageFuncInfoUsageTypeReplacements, $packageFuncInfoUsageSymNames],
       Depth[#]
      ] &@
    ReplaceRepeated[
     FixedPoint[
      Replace[
        #,
        {
         Verbatim[Pattern][_, e_] :>
          e,
         Verbatim[HoldPattern][Verbatim[Pattern][_, e_]] :>
          
          HoldPattern[e],
         Verbatim[HoldPattern][Verbatim[HoldPattern][e_]] :>
         
           HoldPattern[e]
         },
        1
        ] &,
      vals
      ],
     Flatten@{
       reps,
       Verbatim[PatternTest][_, ColorQ] :>
        packageFuncInfoExtractorLocalized@"color",
       Verbatim[PatternTest][_, ImageQ] :>
        packageFuncInfoExtractorLocalized@"img",
       Verbatim[Optional][name_, _] :>
        name,
       Verbatim[Pattern][_, _OptionsPattern] :>
        Sequence[],
       Verbatim[Pattern][name_, _] :>
        name,
       Verbatim[PatternTest][p_, _] :>
        p,
       Verbatim[Condition][p_, _] :>
        p,
       Verbatim[Alternatives][a_, ___][___] |
         Verbatim[Alternatives][a_, ___][___][___] |
         Verbatim[Alternatives][a_, ___][___][___][___] |
         Verbatim[Alternatives][a_, ___][___][___][___][___] |
         Verbatim[Alternatives][a_, ___][___][___][___][___][___] :>
        a,
       Verbatim[Alternatives][a_, ___] :>
        RuleCondition[
         Blank[
          Replace[Hold@a,
           {
            Hold[p : Verbatim[HoldPattern][_]] :>
             p,
            Hold[e_[___]] :> e,
            _ :> a
            }
           ]
          ],
         True
         ],
       Verbatim[Verbatim][p_][a___] :>
        p,
       Verbatim[Blank][] :>
        packageFuncInfoExtractorLocalized@"expr",
       Verbatim[Blank][
         t : Alternatives @@ Keys[$packageFuncInfoUsageTypeReplacements]] :>
        
        RuleCondition[
         Replace[t,
          $packageFuncInfoUsageTypeReplacements
          ],
         True
         ],
       Verbatim[Blank][t_] :>
        t,
       Verbatim[BlankSequence][] :>
        
        Sequence @@ packageFuncInfoExtractorLocalized[{"expr1", "expr2"}],
       Verbatim[BlankNullSequence][] :>
        Sequence[],
       packageFuncInfoSymbolUsageReplacementPattern[names, conts],
       h_[a___, Verbatim[Sequence][b___], c___] :> h[a, b, c]
       }
     ]
   ];


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoGenerateSymbolUsage*)


packageFuncInfoGenerateSymbolUsage[f_, 
   defaultMessages : {(_Rule | _RuleDelayed) ...} : {}] :=
  With[
   {
    uml =
     Replace[defaultMessages,
      {
       (h : Rule | RuleDelayed)[Verbatim[HoldPattern][pat___], m_] :>
        h[HoldPattern[Verbatim[HoldPattern][pat]], m],
       (h : Rule | RuleDelayed)[pat___, m_] :>
        h[Verbatim[HoldPattern][pat], m],
       _ -> Nothing
       },
      {1}
      ]
    },
   Replace[
    DeleteDuplicates@packageFuncInfoSymbolUsageReplacementPattern[Keys@packageFuncInfoGetCodeValues[f]],
    {
     Verbatim[HoldPattern][s_[a___]]:>
      With[
       {
        uu =
         StringTrim@
          Replace[HoldPattern[s[a]] /. uml,
           
           Except[_String] :>
            
            Replace[Quiet@s::usage, Except[_String] -> ""]
           ],
        sn = ToString[Unevaluated@s],
        meuu = ToString[Unevaluated[s[a]], InputForm]
        },
       StringReplace["FEInfoExtractor`Private`" -> ""]@
        If[! StringContainsQ[uu, meuu],
         meuu <> " " <>
          Which[
           uu == "",
           
           "has no usage message", ! 
            StringStartsQ[uu, 
             sn | (Except[WordCharacter] .. ~~ "RowBox[{" ~~ 
                Except[WordCharacter] ... ~~ sn)],
           uu,
           True,
           ""
           ],
         StringCases[uu, 
           (StartOfLine | StartOfString) ~~ Except["\n"] ... ~~ meuu ~~
             Except["\n"] ... ~~ EndOfLine,
           1
           ][[1]]
         ]
       ],
     _ -> Nothing
     },
    {1}
    ]
   ];
packageFuncInfoGenerateSymbolUsage~SetAttributes~HoldFirst;


(* ::Subsection:: *)
(*AutoComplete*)


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoAutoCompletionsExtractSeeder*)


Attributes[packageFuncInfoAutoCompletionsExtractSeeder] =
  {
   HoldFirst
   };
packageFuncInfoAutoCompletionsExtractSeeder[
   HoldPattern[Verbatim[PatternTest][_, ColorQ]] |
    (Blank | BlankSequence)[Hue | RGBColor | XYZColor | LABColor],
   n_
   ] := Sow[n -> "Color"];
packageFuncInfoAutoCompletionsExtractSeeder[
   HoldPattern[Verbatim[PatternTest][_, DirectoryQ]],
   n_
   ] := Sow[n -> "Directory"];
packageFuncInfoAutoCompletionsExtractSeeder[
   HoldPattern[Verbatim[PatternTest][_, FileExistsQ]] |
    (Blank | BlankSequence)[File] | _File,
   n_
   ] := Sow[n -> "FileName"];
packageFuncInfoAutoCompletionsExtractSeeder[
   Verbatim[Alternatives][s__String],
   n_
   ] :=
  Sow[n -> {s}];
packageFuncInfoAutoCompletionsExtractSeeder[
   Verbatim[Pattern][_, b_],
   n_
   ] := packageFuncInfoAutoCompletionsExtractSeeder[b, n];
packageFuncInfoAutoCompletionsExtractSeeder[
   Verbatim[Optional][a_, ___],
   n_
   ] := packageFuncInfoAutoCompletionsExtractSeeder[a, n];


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoAutoCompletionsExtract*)


Attributes[packageFuncInfoAutoCompletionsExtract] =
  {
   HoldFirst
   };
packageFuncInfoAutoCompletionsExtract[Verbatim[HoldPattern][_[a___]]] :=
  {ReleaseHold@
    MapIndexed[
     Function[Null, packageFuncInfoAutoCompletionsExtractSeeder[#, #2[[1]]], 
      HoldAllComplete],
     Hold[a]
     ]
   };
packageFuncInfoAutoCompletionsExtract[f_Symbol] :=
 Flatten@
  Reap[
    packageFuncInfoAutoCompletionsExtract /@
     Replace[
      Keys@packageFuncInfoGetCodeValues[f, {DownValues, SubValues, UpValues}],
      {
        Verbatim[HoldPattern][
         HoldPattern[
          f[a___][___]|
          f[a___][___][___]|
          f[a___][___][___][___]|
          f[a___][___][___][___][___]|
          f[a___][___][___][___][___][___]
          ]
         ]:>HoldPattern[f[a]],
        Verbatim[HoldPattern][
         HoldPattern[
          _[___, f[a___], ___]|
          _[___, f[a___][___], ___]|
          _[___, f[a___][___][___], ___]|
          _[___, f[a___][___][___][___], ___]|
          _[___, f[a___][___][___][___][___], ___]|
          _[___, f[a___][___][___][___][___][___],  ___]
          ]
         ]:>HoldPattern[f[a]]
        },
      {1}
      ]
    ][[2]]


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoGenerateAutocompletions*)


packageFuncInfoGenerateAutocompletions[
   f : _Symbol : None, 
   otherAutos : {(_Integer -> _) ...} : {}
   ] :=
  With[
   {
    gg =
     Join[
      GroupBy[
       If[Unevaluated[f] =!= None,
        packageFuncInfoAutoCompletionsExtract[f],
        {}
        ],
       First -> Last,
       Replace[{s_, ___} :> s]
       ],
      GroupBy[
       otherAutos,
       First -> Last
       ]
      ]
    },
   With[{km = Max@Append[Keys@gg, 0]},
    Table[
     Lookup[gg, i, None],
     {i, km}
     ]
    ]
   ];
SetAttributes[packageFuncInfoGenerateAutocompletions, HoldFirst];


(* ::Subsection:: *)
(*Set Autocompletions*)


(* ::Subsubsection::Closed:: *)
(*$packageFuncInfoAutoCompletionFormats*)


$packageFuncInfoAutoCompletionFormats =
  Alternatives @@ Join @@ {
     Range[0, 9],
     {
      _String?(FileExtension[#] === "trie" &),
      {
       _String | (Alternatives @@ Range[0, 9]) | {__String},
       (("URI" | "DependsOnArgument") -> _) ...
       },
      {
       _String | (Alternatives @@ Range[0, 9]) | {__String},
       (("URI" | "DependsOnArgument") -> _) ...,
       (_String | (Alternatives @@ Range[0, 9]) | {__String})
       },
      {
       __String
       }
      },
     {
      "codingNoteFontCom",
      "ConvertersPath",
      "ExternalDataCharacterEncoding",
      "MenuListCellTags",
      "MenuListConvertFormatTypes",
      "MenuListDisplayAsFormatTypes",
      "MenuListFonts",
      "MenuListGlobalEvaluators",
      "MenuListHelpWindows",
      "MenuListNotebookEvaluators",
      "MenuListNotebooksMenu",
      "MenuListPackageWindows",
      "MenuListPalettesMenu",
      "MenuListPaletteWindows",
      "MenuListPlayerWindows",
      "MenuListPrintingStyleEnvironments",
      "MenuListQuitEvaluators",
      "MenuListScreenStyleEnvironments",
      "MenuListStartEvaluators",
      "MenuListStyleDefinitions",
      "MenuListStyles",
      "MenuListStylesheetWindows",
      "MenuListTextWindows",
      "MenuListWindows",
      "PrintingStyleEnvironment",
      "ScreenStyleEnvironment",
      "Style"
      }
     };


(* ::Subsubsection::Closed:: *)
(*$packageFuncInfoAutocompletionAliases*)


$packageFuncInfoAutocompletionAliases =
  {
   "None" | None | Normal -> 0,
   "AbsoluteFileName" | AbsoluteFileName -> 2,
   "FileName" | File | FileName -> 3,
   "Color" | RGBColor | Hue | XYZColor -> 4,
   "Package" | Package -> 7,
   "Directory" | Directory -> 8,
   "Interpreter" | Interpreter -> 9,
   "Notebook" | Notebook -> "MenuListNotebooksMenu",
   "StyleSheet" -> "MenuListStylesheetMenu",
   "Palette" -> "MenuListPalettesMenu",
   "Evaluator" | Evaluator -> "MenuListGlobalEvaluators",
   "FontFamily" | FontFamily -> "MenuListFonts",
   "CellTag" | CellTags -> "MenuListCellTags",
   "FormatType" | FormatType -> "MenuListDisplayAsFormatTypes",
   "ConvertFormatType" -> "MenuListConvertFormatTypes",
   "DisplayAsFormatType" -> "MenuListDisplayAsFormatTypes",
   "GlobalEvaluator" -> "MenuListGlobalEvaluators",
   "HelpWindow" -> "MenuListHelpWindows",
   "NotebookEvaluator" -> "MenuListNotebookEvaluators",
   "PrintingStyleEnvironment" | PrintingStyleEnvironment ->
    
    "PrintingStyleEnvironment",
   "ScreenStyleEnvironment" | ScreenStyleEnvironment ->
    
    ScreenStyleEnvironment,
   "QuitEvaluator" -> "MenuListQuitEvaluators",
   "StartEvaluator" -> "MenuListStartEvaluators",
   "StyleDefinitions" | StyleDefinitions ->
    
    "MenuListStyleDefinitions",
   "CharacterEncoding" | CharacterEncoding |
     ExternalDataCharacterEncoding ->
    
    "ExternalDataCharacterEncoding",
   "Style" | Style -> "Style",
   "Window" -> "MenuListWindows"
   };


(* ::Subsubsection::Closed:: *)
(*$packageFuncInfoAutocompletionTable*)


$packageFuncInfoAutocompletionTable = {
   f : $packageFuncInfoAutoCompletionFormats :> f,
   Sequence @@ $packageFuncInfoAutocompletionAliases,
   s_String :> {s}
   };


(* ::Subsubsection::Closed:: *)
(*autocompletionPreCompile*)


autocompletionPreCompile[v : Except[{__Rule}, _List | _?AtomQ]] :=
  
  Replace[
    Flatten[{v}, 1],
   $packageFuncInfoAutocompletionTable,
   {1}
   ];
autocompletionPreCompile[o : {__Rule}] :=
  Replace[o,
   (s_ -> v_) :>
    (
     Replace[s, _Symbol :> SymbolName[s]] ->
      
      autocompletionPreCompile[v]
     ),
   1
   ];
autocompletionPreCompile[s : Except[_List], v_] :=
  
  autocompletionPreCompile[{s -> v}];
autocompletionPreCompile[l_, v_] :=
  autocompletionPreCompile@
   Flatten@{
     Quiet@
      Check[
       Thread[l -> v],
       Map[l -> # &, v]
       ]
     };


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoAddAutocompletions*)


packageFuncInfoAddAutocompletions[
   pats : {(_String -> {$packageFuncInfoAutoCompletionFormats ..}) ..}] :=
  
  If[$Notebooks &&
    
    Internal`CachedSystemInformation["FrontEnd", "VersionNumber"] > 
     10.0,
   Scan[
    FE`Evaluate[FEPrivate`AddSpecialArgCompletion[#]] &,
    pats
    ];
   pats,
   $Failed
   ];
packageFuncInfoAddAutocompletions[pat : (_String -> {$packageFuncInfoAutoCompletionFormats ..})] :=

    packageFuncInfoAddAutocompletions[{pat}];


packageFuncInfoAddAutocompletions[a__] /; (! TrueQ@$recursionProtect) :=
  
  Block[{$recursionProtect = True},
   Replace[
    packageFuncInfoAddAutocompletions@autocompletionPreCompile[a],
    _packageFuncInfoAddAutocompletions -> $Failed
    ]
   ];


(*packageFuncInfoAddAutocompletions[
packageFuncInfoAddAutocompletions,
{
None,
Replace[Keys[$packageFuncInfoAutocompletionAliases],
Verbatim[Alternatives][s_,___]:>s,
1
]
}
];*)


(* ::Subsection:: *)
(*Pattern Parsing*)


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoReducePatterns*)


packageFuncInfoReducePatterns[p_] :=
  Replace[
    p,
    {
     Except[
       _Pattern | _Optional | _Blank | _BlankSequence | 
        _BlankNullSequence | _PatternSequence | _OptionsPattern |
        _Repeated | _RepeatedNull | _Default | _PatternTest | _Condition
       ] -> _
     },
    {2, Infinity}
    ] //. {
    _Blank -> "Blank",
    _BlankSequence -> "BlankSequence",
    _BlankNullSequence -> "BlankNullSequence",
    _OptionsPattern :> "OptionsPattern",
    Verbatim[HoldPattern][
       Verbatim[Pattern][a_, b_]
       ] | Verbatim[Pattern][a_, b_] :> b,
    (PatternTest | Condition)[a_, b_] :> a,
    Verbatim[Optional][a_, ___] :> "Optional"[a],
    _Default -> "Default",
    Verbatim[Repeated][_] -> "Repeated"[\[Infinity]],
    Verbatim[RepeatedNull][_] -> "RepeatedNull"[\[Infinity]],
    Verbatim[Repeated][_, s_] :> "Repeated"[s],
    Verbatim[RepeatedNull][_, s_] :> "RepeatedNull"[s]
    };


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoReconstructPatterns*)


packageFuncInfoReconstructPatterns[p_] :=
  p //. {
     "Optional"[a_] :> Optional[a],
     "Default" -> _.,
     "OptionsPattern" -> OptionsPattern[],
     "Blank" -> _,
     "BlankSequence" -> __,
     "BlankNullSequence" -> ___,
     "Repeated"[\[Infinity]] -> Repeated[_],
     "RepeatedNull"[\[Infinity]] -> RepeatedNull[_],
     "Repeated"[s_] :> Repeated[_, s],
     "RepeatedNull"[s_] :> RepeatedNull[_, s]
     } // Flatten;


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoArgPatPartLens*)


packageFuncInfoArgPatPartLens[patList_] :=
  Thread[
   patList ->
    Replace[
     patList,
     {
      _Blank -> 1 ;; 1,
      _BlankSequence -> 1 ;; \[Infinity],
      _BlankNullSequence -> 0 ;; \[Infinity],
      Verbatim[Repeated][_] -> 1 ;; \[Infinity],
      Verbatim[RepeatedNull][_] -> 0 ;; \[Infinity],
      Verbatim[Repeated][_, {M_}] :> 1 ;; M,
      Verbatim[RepeatedNull][_, {M_}] :> 0 ;; M,
      (Repeated | RepeatedNull)[_, {M_}] :> ;; M,
      (Repeated | RepeatedNull)[_, {m_, M_}] :> m ;; M,
      _Optional -> 0 ;; 1,
      _Default -> 0 ;; 1,
      _OptionsPattern -> 0 ;; \[Infinity],
      _ -> 1 ;; 1
      },
     {1}
     ]
   ];


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoMergeArgPats*)


packageFuncInfoMergeArgPats[pats_, returnNum : False | True : False] :=
 Module[
  {
   reppedPats = packageFuncInfoArgPatPartLens /@ pats,
   mlen,
   paddies,
   werkit = True,
   patMaxes,
   patMins,
   patChoices,
   patNs,
   patCho
   },
  mlen = Max[Length /@ reppedPats];
  paddies = PadRight[#, mlen, _. -> 0 ;; 1] & /@ reppedPats;
  MapThread[
   Function[
    patMins = MinimalBy[{##}, #[[2, 1]] &];
    patMaxes = MaximalBy[{##}, #[[2, 2]] &];
    patChoices = Intersection[patMins, patMaxes];
    patNs = {patMins[[1, 2, 1]], patMaxes[[1, 2, 2]]};
    patCho =
     If[Length@patChoices > 0,
      SortBy[patChoices,
        Switch[#[[1]],
          _OptionsPattern,
          0,
          _RepeatedNull | _Repeated,
          1,
          _Optional | _Default,
          2,
          _,
          3
          ] &
        ][[1, 1]],
      Replace[ patNs,
       {
        {0, 1} -> _.,
        {1, \[Infinity]} -> __,
        {0, \[Infinity]} -> ___,
        {m_, n_} :> Repeated[_, {m, n}]
        }
       ]
      ];
    If[returnNum, patCho -> patNs, patCho]
    ],
   paddies
   ]
  ]


(* ::Subsection:: *)
(*SyntaxInfo*)


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoGenerateSIArgPat*)


packageFuncInfoGenerateSIArgPat[f_] :=
  With[{dvs = Keys@packageFuncInfoGetCodeValues[f, {DownValues, SubValues, UpValues}]},
   packageFuncInfoMergeArgPats@
    DeleteDuplicates[
     packageFuncInfoReconstructPatterns /@
      ReplaceAll[
       packageFuncInfoReducePatterns /@ 
         Replace[dvs,
           {
           Verbatim[HoldPattern][
             HoldPattern[
              f[a___][___]|
              f[a___][___][___]|
              f[a___][___][___][___]|
              f[a___][___][___][___][___]|
              f[a___][___][___][___][___][___]
              ]
             ]:>HoldPattern[f[a]],
            Verbatim[HoldPattern][
             HoldPattern[
              _[___, f[a___], ___]|
              _[___, f[a___][___], ___]|
              _[___, f[a___][___][___], ___]|
              _[___, f[a___][___][___][___], ___]|
              _[___, f[a___][___][___][___][___], ___]|
              _[___, f[a___][___][___][___][___][___],  ___]
              ]
             ]:>HoldPattern[f[a]]
            },
           1
           ],
       {
        (f | HoldPattern) -> List
        }
       ]
     ]
   ];
packageFuncInfoGenerateSIArgPat~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoGenerateSILocVars*)


packageFuncInfoGenerateSILocVars[f_] :=
  
  With[{att = Attributes[f], 
    dvs = Keys@packageFuncInfoGetCodeValues[f, {DownValues}]},
   Which[
    MemberQ[att, HoldAll],
    {1, Infinity},
    MemberQ[att, HoldRest],
    {2, Infinity},
    MemberQ[att, HoldFirst],
    {1}
    ]
   ];
packageFuncInfoGenerateSILocVars~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoGenerateSIColEq*)


packageFuncInfoGenerateSIColEq[f_] :=
  
  With[{dvs = Keys@packageFuncInfoGetCodeValues[f, {DownValues}]},
   Replace[{a_, ___} :> a]@
    MaximalBy[
     MinMax@Flatten@Position[#, _Equal, 1] & /@ dvs,
     Apply[Subtract]@*Reverse
     ]
   ];
packageFuncInfoGenerateSIColEq~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoGenerateSIOpNames*)


packageFuncInfoGenerateSIOpNames[f_] :=
  ToString[#, InputForm] & /@ Keys@Options[f];
packageFuncInfoGenerateSIOpNames~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoGenerateSyntaxInformation*)


Options[packageFuncInfoGenerateSyntaxInformation] =
  {
   "ArgumentsPattern" -> Automatic,
   "LocalVariables" -> None,
   "ColorEqualSigns" -> None,
   "OptionNames" -> Automatic
   };
Attributes[packageFuncInfoGenerateSyntaxInformation] =
  {
   HoldFirst
   };
packageFuncInfoGenerateSyntaxInformation[
   f_,
   ops : OptionsPattern[]
   ] :=
  {
   "ArgumentsPattern" ->
    Replace[OptionValue["ArgumentsPattern"],
     Automatic :> packageFuncInfoGenerateSIArgPat[f]
     ],
   "LocalVariables" ->
    Replace[OptionValue["LocalVariables"],
     Automatic :> packageFuncInfoGenerateSILocVars[f]
     ],
   "ColorEqualSigns" ->
    Replace[OptionValue["LocalVariables"],
     Automatic :> packageFuncInfoGenerateSIColEq[f]
     ],
   "OptionNames" ->
    Replace[OptionValue["OptionNames"],
     Automatic :> packageFuncInfoGenerateSIOpNames[f]
     ]
   };


(* ::Subsection:: *)
(*ArgCount*)


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoGenerateArgCount*)


packageFuncInfoGenerateArgCount[f_] :=
  Module[
   {
    dvs = Keys@packageFuncInfoGetCodeValues[f, {DownValues, SubValues, UpValues}],
    patsNums,
    patsMax,
    patsMin,
    patsTypes,
    doNonOp = False
    },
   dvs=
     Replace[dvs,
       {
         Verbatim[HoldPattern][
           HoldPattern[
            f[a___][___]|
            f[a___][___][___]|
            f[a___][___][___][___]|
            f[a___][___][___][___][___]|
            f[a___][___][___][___][___][___]
            ]
           ]:>HoldPattern[f[a]],
          Verbatim[HoldPattern][
           HoldPattern[
            _[___, f[a___], ___]|
            _[___, f[a___][___], ___]|
            _[___, f[a___][___][___], ___]|
            _[___, f[a___][___][___][___], ___]|
            _[___, f[a___][___][___][___][___], ___]|
            _[___, f[a___][___][___][___][___][___],  ___]
            ]
           ]:>HoldPattern[f[a]]
          },
       1
       ];
   patsNums =
    packageFuncInfoMergeArgPats[
     DeleteDuplicates[
      packageFuncInfoReconstructPatterns /@
       ReplaceAll[
        packageFuncInfoReducePatterns /@ dvs,
        {
         (f | HoldPattern) -> List
         }
        ]
      ],
     True
     ];
   patsTypes = patsNums[[All, 1]];
   patsMin =
    Block[{noopnoop = False},
     MapThread[
      If[noopnoop,
        0,
        If[MatchQ[#, _OptionsPattern],
         doNonOp = True;
         noopnoop = True;
         0,
         #2
         ]
        ] &,
      {
       patsTypes,
       patsNums[[All, 2, 1]]
       }
      ]
     ];
   patsMax =
    Block[{noopnoop = False},
     MapThread[
      If[noopnoop,
        0,
        If[MatchQ[#, _OptionsPattern],
         doNonOp = True;
         noopnoop = True;
         0,
         #2
         ]
        ] &,
      {
       patsTypes,
       patsNums[[All, 2, 2]]
       }
      ]
     ];
   {"MinArgs" -> Total[patsMin], "MaxArgs" -> Total[patsMax], 
    "OptionsPattern" -> doNonOp}
   ];
packageFuncInfoGenerateArgCount~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoSetArgCount*)


packageFuncInfoSetArgCount[f_Symbol, minA : _Integer, maxA : _Integer|Infinity, 
   noo : True | False] :=
  f[argPatLongToNotDupe___] :=
   (
    1 /; (ArgumentCountQ[f,
        Length@If[noo,
          Replace[Hold[argPatLongToNotDupe], 
            Hold[argPatLongToNotDupe2___, 
              (_Rule | _RuleDelayed | {(_Rule | _RuleDelayed) ..}) ...
              ] :> Hold[argPatLongToNotDupe2]
            ], Hold[argPatLongToNotDupe]], minA, maxA]; False)
    );
packageFuncInfoSetArgCount~SetAttributes~HoldFirst


(* ::Subsection:: *)
(*PackageAutoFunctionInfo*)


(* ::Subsubsection::Closed:: *)
(*packageFuncInfoGenerateAuto*)


Options[packageFuncInfoGenerateAuto] =
  {
   "SyntaxInformation" -> {},
   "Autocompletions" -> {},
   "UsageMessages" -> {},
   "ArgCount" -> Automatic
   };
packageFuncInfoGenerateAuto[
   f_Symbol,
   ops : OptionsPattern[]
   ] :=
  {
   "UsageMessages" ->
    packageFuncInfoGenerateSymbolUsage[f,
     Cases[
      Flatten@List[OptionsPattern["UsageMessages"]],
      _Rule | _RuleDelayed
      ]
     ],
   "SyntaxInformation" ->
    packageFuncInfoGenerateSyntaxInformation[f,
     OptionValue["SyntaxInformation"]
     ],
   "Autocompletions" ->
    packageFuncInfoGenerateAutocompletions[f,
     OptionValue["Autocompletions"]
     ],
   "ArgCount" ->
    Replace[OptionValue@"ArgCount",
     Except[
       KeyValuePattern[
        {"MinArgs" -> _Integer, "MaxArgs" -> _Integer | Infinity, 
         "OptionsPattern" -> (True | False)}
        ]
       ] :> packageFuncInfoGenerateArgCount[f]
     ]
   };
packageFuncInfoGenerateAuto~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageAutoFunctionInfo*)


Options[PackageAutoFunctionInfo] =
  {
   "SyntaxInformation" -> {},
   "Autocompletions" -> {},
   "UsageMessages" -> {},
   "SetInfo" -> False,
   "GatherInfo" -> True
   };
PackageAutoFunctionInfo[f_Symbol, o : OptionsPattern[]] :=
 Module[
  {
   sinfBase =
    If[OptionValue["GatherInfo"] =!= False,
     packageFuncInfoGenerateAuto[f, 
      FilterRules[{o}, Options[packageFuncInfoGenerateAuto]]], 
     Flatten[{o, Options[PackageAutoFunctionInfo]}]
     ],
   sops = FilterRules[{o}, Options[packageFuncInfoGenerateAuto]],
   as = {},
   si,
   um,
   ac,
   argX,
   set = TrueQ@OptionValue["SetInfo"]
   },
  si =
   Replace[
    Replace[Lookup[sinfBase, "SyntaxInformation"],
     Except[{(_String -> _) ..}] :>
      Lookup[as, "SyntaxInformation",
       Lookup[Set[as, packageFuncInfoGenerateAuto[f, sops]], 
        "SyntaxInformation"]
       ]
     ],
    {
     (Except[_String] -> _) -> Nothing,
     (k_ -> None) :> k -> {}
     },
    {1}
    ];
  um =
   Replace[Lookup[sinfBase, "UsageMessages"],
    Except[{__String}] :>
     Lookup[as, "UsageMessages",
      Lookup[Set[as, packageFuncInfoGenerateAuto[f, sops]], 
       "UsageMessages"]
      ]
    ];
  um = StringRiffle[um, "\n"];
  ac =
   Replace[Lookup[sinfBase, "Autocompletions"],
    Except[_List] :>
     Lookup[as, "Autocompletions",
      Lookup[Set[as, packageFuncInfoGenerateAuto[f, sops]], 
       "Autocompletions"]
      ]
    ];
  argX =
   Association@
    Replace[Lookup[sinfBase, "ArgCount"],
     Except[{"MinArgs" -> _Integer, 
        "MaxArgs" -> _Integer | \[Infinity], 
        "OptionsPattern" -> True | False}] :>
      Lookup[as, "ArgCount",
       Lookup[Set[as, packageFuncInfoGenerateAuto[f, sops]], "ArgCount"]
       ]
     ];
  If[set,
   SyntaxInformation[Unevaluated@f] = si;
   If[StringLength@um > 0, f::usage = um];
   If[Length@ac > 0, packageFuncInfoAddAutocompletions[f, ac]];
   packageFuncInfoSetArgCount[f, argX["MinArgs"], argX["MaxArgs"], 
    argX["OptionsPattern"]],
   (* dump to held expression for writing to file *)
   With[
    {
     si2 = si,
     um2 = um,
     acpat = autocompletionPreCompile[ac],
     minA = argX["MinArgs"],
     maxA = argX["MaxArgs"],
     noo = argX["OptionsPattern"]
     },
    Hold[
     SyntaxInformation[Unevaluated[f]] = si2;
     If[StringLength@um2 > 0, Set[f::usage, um2]];
     If[Length@acpat > 0,
      If[$Notebooks &&
        
        Internal`CachedSystemInformation["FrontEnd", 
          "VersionNumber"] > 10.0,
       FE`Evaluate[
        FEPrivate`AddSpecialArgCompletion[
         ToString[Unevaluated[f]] -> acpat]
        ]
       ];
      SetDelayed[
       f[argPatLongToNotDupe___],
       (
        1 /; (ArgumentCountQ[f,
            Length@If[noo,
              Replace[Hold[argPatLongToNotDupe], 
              
              Hold[argPatLongToNotDupe2___, (_Rule | _RuleDelayed | \
{(_Rule | _RuleDelayed) ..}) ...] :> Hold[argPatLongToNotDupe2]
              ], Hold[argPatLongToNotDupe]
             ], minA, maxA]; False)
        )
       ]
      ]
     ]
    ]
   ]
  ]
