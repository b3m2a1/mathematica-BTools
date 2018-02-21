(* ::Package:: *)

(* ::Subsection:: *)
(*FunctionInfo*)


(* ::Text:: *)
(*Artefact of original development*)


(*Package Declarations*)
PackageAutoFunctionInfo::usage=
	"PackageAutoFunctionInfo[function, ops] generates the front-end integration info
PackageAutoFunctionInfo[{fns...}] generates a combined expression for all fns
PackageAutoFunctionInfo[stringPat] generates for Names[stringPat]";
PackageAutoFunctionInfoExport::usage=
	"PackageAutoFunctionInfoExport[file, e] exports the auto-built integration info to file";


(* ::Subsubsection::Closed:: *)
(*Private Declarations*)


(*Package Declarations*)
PackageFIgetCodeValues::usage="PackageFIgetCodeValues[f, vs]";
PackageFIextractorLocalized::usage="PackageFIextractorLocalized[s]";
PackageFI$usageTypeReplacements::usage="PackageFI$usageTypeReplacements";
PackageFI$usageSymNames::usage="PackageFI$usageSymNames";
PackageFIsymbolUsageReplacementPattern::usage="PackageFIsymbolUsageReplacementPattern[names, conts]";
PackageFIusagePatternReplace::usage="PackageFIusagePatternReplace[vals, reps]";
PackageFIgenerateSymbolUsage::usage="PackageFIgenerateSymbolUsage[f, defaultMessages]";
PackageFIautoCompletionsExtractSeeder::usage="PackageFIautoCompletionsExtractSeeder[_ | (Blank | BlankSequence)[Hue | RGBColor | XYZColor | LABColor], n]
PackageFIautoCompletionsExtractSeeder[_, n]
PackageFIautoCompletionsExtractSeeder[_ | (Blank | BlankSequence)[File] | _File, n]
PackageFIautoCompletionsExtractSeeder[Alternatives[s], n]
PackageFIautoCompletionsExtractSeeder[_, n]
PackageFIautoCompletionsExtractSeeder[a, n]";
PackageFIautoCompletionsExtract::usage="PackageFIautoCompletionsExtract[_[a]]
PackageFIautoCompletionsExtract[f]";
PackageFIgenerateAutocompletions::usage="PackageFIgenerateAutocompletions[f, otherAutos]";
PackageFI$autoCompletionFormats::usage="PackageFI$autoCompletionFormats";
PackageFI$autocompletionAliases::usage="PackageFI$autocompletionAliases";
PackageFI$autocompletionTable::usage="PackageFI$autocompletionTable";
PackageFIautocompletionPreCompile::usage="PackageFIautocompletionPreCompile[v]
PackageFIautocompletionPreCompile[o]
PackageFIautocompletionPreCompile[s, v]
PackageFIautocompletionPreCompile[l, v]";
PackageFIaddAutocompletions::usage="PackageFIaddAutocompletions[pats]
PackageFIaddAutocompletions[pat]";
PackageFIreducePatterns::usage="PackageFIreducePatterns[p]";
PackageFIextractArgStructureHead::usage="PackageFIextractArgStructureHead[f, defs]";
PackageFIgenerateArgPatList::usage="PackageFIgenerateArgPatList[f, defs]";
PackageFIreconstructPatterns::usage="PackageFIreconstructPatterns[p]";
PackageFIargPatPartLens::usage="PackageFIargPatPartLens[patList]";
PackageFImergeArgPats::usage="PackageFImergeArgPats[pats, returnNum]";
PackageFIgenerateSIArgPat::usage="PackageFIgenerateSIArgPat[f]";
PackageFIgenerateSILocVars::usage="PackageFIgenerateSILocVars[f]";
PackageFIgenerateSIColEq::usage="PackageFIgenerateSIColEq[f]";
PackageFIgenerateSIOpNames::usage="PackageFIgenerateSIOpNames[f]";
PackageFIgenerateSyntaxInformation::usage="PackageFIgenerateSyntaxInformation[f, ops]";
PackageFIgenerateArgCount::usage="PackageFIgenerateArgCount[f]";
PackageFIsetArgCount::usage="PackageFIsetArgCount[f, minA, maxA, noo]";
PackageFIgenerateAutoFunctionInfo::usage="PackageFIgenerateAutoFunctionInfo[f, ops]";


Begin["`PackageFI`Private`"];


(* ::Subsubsection::Closed:: *)
(*PackageFIgetCodeValues*)


PackageFIgetCodeValues[f_Symbol,
	vs :
	{Repeated[
			OwnValues | DownValues | SubValues | UpValues]} : {OwnValues, 
		DownValues, SubValues, UpValues}
	] :=
Select[
	If[Intersection[Attributes@f, { ReadProtected, Locked}] === { 
			Locked, ReadProtected},
		{},
		Join @@ Map[#[f] &, vs]
		],
	FreeQ[ArgumentCountQ]
	];
PackageFIgetCodeValues~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageFIusagePatternReplace*)


PackageFIextractorLocalized[s_] :=

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
PackageFI$usageTypeReplacements =
{
	Integer -> PackageFIextractorLocalized["int"],
	Real -> PackageFIextractorLocalized["float"],
	String -> PackageFIextractorLocalized["str"],
	List -> PackageFIextractorLocalized["list"],
	Association -> PackageFIextractorLocalized["assoc"],
	Symbol -> PackageFIextractorLocalized["sym"]
	};
PackageFI$usageSymNames =
{
	Alternatives -> PackageFIextractorLocalized["alt"],
	PatternTest -> PackageFIextractorLocalized["test"],
	Condition -> PackageFIextractorLocalized["cond"],
	s_Symbol :>
	RuleCondition[
		PackageFIextractorLocalized@
		ToLowerCase[StringTake[SymbolName[Unevaluated@s], UpTo[3]]],
		True
		]
	};
PackageFIsymbolUsageReplacementPattern[names_, conts_] :=
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
PackageFIusagePatternReplace[
	vals_,
	reps_: {}
	] :=
With[{
		names = AssociationMap[Null &, {}(*Names[]*)],
		conts = 
		Alternatives @@ {
			"System`", "FrontEnd`", 
			"PacletManager`", "Internal`"
			},
		repTypes=Alternatives@@Map[Blank, Keys@PackageFI$usageTypeReplacements]
		},
	Replace[
		Replace[
			#,
			{
				Verbatim[HoldPattern][a___] :> a
				},
			{2, 10}
			],
		Join[PackageFI$usageTypeReplacements, PackageFI$usageSymNames],
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
			PackageFIextractorLocalized@"color",
			Verbatim[PatternTest][_, ImageQ] :>
			PackageFIextractorLocalized@"img",
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
			(* for dispatching functions by Alternatives *)
			Verbatim[Alternatives][a_, ___][___] |
			Verbatim[Alternatives][a_, ___][___][___] |
			Verbatim[Alternatives][a_, ___][___][___][___] |
			Verbatim[Alternatives][a_, ___][___][___][___][___] |
			Verbatim[Alternatives][a_, ___][___][___][___][___][___] :>
			a,
			Verbatim[Alternatives][a_, ___] :>
			RuleCondition[
				Blank[
					Replace[
						Hold@a,
						{
							Hold[p : Verbatim[HoldPattern][_]] :>
							p,
							Hold[repTypes]:>Head[a],
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
			PackageFIextractorLocalized@"expr",
			Verbatim[Blank][
				t : Alternatives @@ Keys[PackageFI$usageTypeReplacements]] :>
			
			RuleCondition[
				Replace[t,
					PackageFI$usageTypeReplacements
					],
				True
				],
			Verbatim[Blank][t_] :>
			t,
			Verbatim[BlankSequence][] :>
			
			Sequence @@ PackageFIextractorLocalized[{"expr1", "expr2"}],
			Verbatim[BlankNullSequence][] :>
			Sequence[],
			PackageFIsymbolUsageReplacementPattern[names, conts],
			h_[a___, Verbatim[Sequence][b___], c___] :> h[a, b, c]
			}
		]
	];


(* ::Subsubsection::Closed:: *)
(*PackageFIgenerateSymbolUsage*)


$pkgCont = $Context;


PackageFIgenerateSymbolUsage[f_, 
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
	DeleteDuplicates@Flatten@
	Replace[
		DeleteDuplicates@PackageFIusagePatternReplace[Keys@PackageFIgetCodeValues[f]],
		{
			Verbatim[HoldPattern][s_[a___]]:>
			With[
				{
					(* original usage message *)
					uu =
					StringTrim@
					Replace[HoldPattern[s[a]] /. uml,
						Except[_String] :>
						Replace[Quiet@s::usage, Except[_String] -> ""]
						],
					sn = ToString[Unevaluated@s],
					(* head for the usage message I'm going to add*)
					meuu = StringReplace[ToString[Unevaluated[s[a]], InputForm], $pkgCont -> ""]
					},
				If[!StringContainsQ[uu, meuu],
					Which[
						uu == "",
						meuu <> " has no usage message", 
						! StringStartsQ[uu, sn],
						meuu <> " "<>uu,
						True,
						{uu, meuu <> " has no usage message"}
						],
					StringCases[uu, 
						(StartOfLine | StartOfString) ~~ 
						Except["\n"]... ~~ meuu ~~
						Except["\n"]... ~~ EndOfLine,
						1
						][[1]]
					]
				],
			_ -> Nothing
			},
		{1}
		]
	];
PackageFIgenerateSymbolUsage~SetAttributes~HoldFirst;


(* ::Subsubsection::Closed:: *)
(*PackageFIautoCompletionsExtractSeeder*)


Attributes[PackageFIautoCompletionsExtractSeeder] =
{
	HoldFirst
	};
PackageFIautoCompletionsExtractSeeder[
	HoldPattern[Verbatim[PatternTest][_, ColorQ]] |
	(Blank | BlankSequence)[Hue | RGBColor | XYZColor | LABColor],
	n_
	] := Sow[n -> "Color"];
PackageFIautoCompletionsExtractSeeder[
	HoldPattern[Verbatim[PatternTest][_, DirectoryQ]],
	n_
	] := Sow[n -> "Directory"];
PackageFIautoCompletionsExtractSeeder[
	HoldPattern[Verbatim[PatternTest][_, FileExistsQ]] |
	(Blank | BlankSequence)[File] | _File,
	n_
	] := Sow[n -> "FileName"];
PackageFIautoCompletionsExtractSeeder[
	Verbatim[Alternatives][s__String],
	n_
	] :=
Sow[n -> {s}];
PackageFIautoCompletionsExtractSeeder[
	Verbatim[Pattern][_, b_],
	n_
	] := PackageFIautoCompletionsExtractSeeder[b, n];
PackageFIautoCompletionsExtractSeeder[
	Verbatim[Optional][a_, ___],
	n_
	] := PackageFIautoCompletionsExtractSeeder[a, n];


(* ::Subsubsection::Closed:: *)
(*PackageFIautoCompletionsExtract*)


Attributes[PackageFIautoCompletionsExtract] =
{
	HoldFirst
	};
PackageFIautoCompletionsExtract[Verbatim[HoldPattern][_[a___]]] :=
{ReleaseHold@
	MapIndexed[
		Function[Null, PackageFIautoCompletionsExtractSeeder[#, #2[[1]]], 
			HoldAllComplete],
		Hold[a]
		]
	};
PackageFIautoCompletionsExtract[f_Symbol] :=
 Flatten@
Reap[
	PackageFIautoCompletionsExtract /@
	Replace[
		Keys@PackageFIgetCodeValues[f, {DownValues, SubValues, UpValues}],
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
(*PackageFIgenerateAutocompletions*)


PackageFIgenerateAutocompletions[
	f : _Symbol : None, 
	otherAutos : {(_Integer -> _) ...} : {}
	] :=
With[
	{
		gg =
		Join[
			GroupBy[
				If[Unevaluated[f] =!= None,
					PackageFIautoCompletionsExtract[f],
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
SetAttributes[PackageFIgenerateAutocompletions, HoldFirst];


(* ::Subsubsection::Closed:: *)
(*PackageFI$autoCompletionFormats*)


PackageFI$autoCompletionFormats =
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
(*PackageFI$autocompletionAliases*)


PackageFI$autocompletionAliases =
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
(*PackageFI$autocompletionTable*)


PackageFI$autocompletionTable = {
	f : PackageFI$autoCompletionFormats :> f,
	Sequence @@ PackageFI$autocompletionAliases,
	s_String :> {s}
	};


(* ::Subsubsection::Closed:: *)
(*PackageFIautocompletionPreCompile*)


PackageFIautocompletionPreCompile[v : Except[{__Rule}, _List | _?AtomQ]] :=

Replace[
	Flatten[{v}, 1],
	PackageFI$autocompletionTable,
	{1}
	];
PackageFIautocompletionPreCompile[o : {__Rule}] :=
Replace[o,
	(s_ -> v_) :>
	(
		Replace[s, _Symbol :> SymbolName[s]] ->
		
		PackageFIautocompletionPreCompile[v]
		),
	1
	];
PackageFIautocompletionPreCompile[s : Except[_List], v_] :=

PackageFIautocompletionPreCompile[{s -> v}];
PackageFIautocompletionPreCompile[l_, v_] :=
PackageFIautocompletionPreCompile@
Flatten@{
	Quiet@
	Check[
		Thread[l -> v],
		Map[l -> # &, v]
		]
	};


(* ::Subsubsection::Closed:: *)
(*PackageFIaddAutocompletions*)


PackageFIaddAutocompletions[
	pats : {(_String -> {PackageFI$autoCompletionFormats ..}) ..}] :=

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
PackageFIaddAutocompletions[pat : (_String -> {PackageFI$autoCompletionFormats ..})] :=

PackageFIaddAutocompletions[{pat}];


PackageFIaddAutocompletions[a__] /; (! TrueQ@$recursionProtect) :=

Block[{$recursionProtect = True},
	Replace[
		PackageFIaddAutocompletions@PackageFIautocompletionPreCompile[a],
		_PackageFIaddAutocompletions -> $Failed
		]
	];


(*PackageFIaddAutocompletions[
	PackageFIaddAutocompletions,
	{
		None,
		Replace[Keys[PackageFI$autocompletionAliases],
			Verbatim[Alternatives][s_,___]:>s,
			1
			]
		}
	];*)


(* ::Subsubsection::Closed:: *)
(*PackageFIreducePatterns*)


PackageFIreducePatterns[p_] :=
Replace[
	p,
	{
		Except[
			_Pattern | _Optional | _Blank | _BlankSequence | 
			_BlankNullSequence | _PatternSequence | _OptionsPattern |
			_Repeated | _RepeatedNull | _Default | _PatternTest | _Condition | 
			_List
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
(*PackageFIextractArgStructureHead*)


(* ::Text:: *)
(*Done in multiple arguments for (assumed) dispatch efficiency*)


PackageFIextractArgStructureHead[f_, Verbatim[HoldPattern][f_[a___][___]]]:=
	HoldPattern[f[a]];
PackageFIextractArgStructureHead[f_, Verbatim[HoldPattern][f_[a___][___][___]]]:=
	HoldPattern[f[a]];
PackageFIextractArgStructureHead[f_, Verbatim[HoldPattern][f_[a___][___][___][___]]]:=
	HoldPattern[f[a]];
PackageFIextractArgStructureHead[f_, Verbatim[HoldPattern][f_[a___][___][___][___][___]]]:=
	HoldPattern@f[a];
PackageFIextractArgStructureHead[f_, Verbatim[HoldPattern][f_[a___][___][___][___][___][___]]]:=
	HoldPattern@f[a];
PackageFIextractArgStructureHead[f_, Verbatim[HoldPattern][_[___, f_[a___], ___]]]:=
	HoldPattern@f[a];
PackageFIextractArgStructureHead[f_, Verbatim[HoldPattern][_[___, f_[a___][___], ___]]]:=
	HoldPattern@f[a];
PackageFIextractArgStructureHead[f_, Verbatim[HoldPattern][_[___, f_[a___][___][___], ___]]]:=
	HoldPattern@f[a];
PackageFIextractArgStructureHead[f_, Verbatim[HoldPattern][_[___, f_[a___][___][___][___], ___]]]:=
	HoldPattern@f[a];
PackageFIextractArgStructureHead[f_, Verbatim[HoldPattern][_[___, f_[a___][___][___][___][___], ___]]]:=
	HoldPattern[f[a]];
PackageFIextractArgStructureHead[f_, e:Except[_List]]:=e;


PackageFIextractArgStructureHead~SetAttributes~{Listable, HoldFirst}


(* ::Subsubsection::Closed:: *)
(*PackageFIreconstructPatterns*)


PackageFIreconstructPatterns[p_] :=
Flatten[
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
		},
	1
	];


(* ::Subsubsection::Closed:: *)
(*PackageFIargPatPartLens*)


argPathDispatch=
	Dispatch[
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
		l_List :> iArgPatLens[l],
		_ -> 1 ;; 1
		}
	];
iArgPatLens[patList_]:=
	Replace[
	patList,
	argPathDispatch,
	{1}
	]


PackageFIargPatPartLens[patList_] :=
Thread[ patList -> iArgPatLens[patList] ];


(* ::Subsubsection::Closed:: *)
(*argPatSimplifyDispatch*)


argPatSimplifyDispatch=
Dispatch@
{
	Verbatim[Repeated][_, {1,1}]->_
	}


(* ::Subsubsection::Closed:: *)
(*PackageFImergeArgPats*)


PackageFImergeArgPats[pats_, returnNum : False | True : False] :=
 Module[
	{
		reppedPats = PackageFIargPatPartLens /@ pats,
		mlen,
		paddies,
		werkit = True,
		patMaxes,
		patMins,
		patListPatsNums,
		patChoices,
		patNs,
		patCho,
		patListing
		},
	mlen = Max[Length /@ reppedPats];
	paddies = PadRight[#, mlen, _. -> 0 ;; 1] & /@ reppedPats;
	patListing=
	MapThread[
		Function[
			patMins = MinimalBy[{##},  If[ListQ@#, 1, #[[2, 1]]] &];
			patMaxes = MaximalBy[{##}, If[ListQ@#, 1, #[[2, 2]]] &];
			patChoices = Intersection[patMins, patMaxes];
			patListPatsNums = Length/@Cases[patChoices, {___, _List, ___}];
			patChoices= 
			SortBy[patChoices,
				Replace[
					{
						l_List:>
						Depth[l]*(Max[patListPatsNums] - Length[l]),
						_->0
						}
					]
				];
			patNs = 
			{
				If[ListQ@patMins[[1, 1]], 1, patMins[[1, 2, 1]]], 
				If[ListQ@patMaxes[[1, 1]], 1, patMaxes[[1, 2, 2]]]
				};
			patCho =
			If[Length@patChoices > 0,
				SortBy[patChoices,
					Replace[#[[1]],
						{
							_OptionsPattern->
							0,
							_RepeatedNull | _Repeated->
							1,
							_Optional | _Default->
							2,
							_->
							3
							}
						] &
					][[1, 1]],
				Replace[ 
					patNs,
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
		];
	If[Length@patListing>1,
		ReplaceAll[Most[patListing], _OptionsPattern->___]
		~Append~
		Last[patListing],
		patListing
		]/.argPatSimplifyDispatch
	]


(* ::Subsubsection::Closed:: *)
(*PackageFIgenerateArgPatList*)


PackageFIgenerateArgPatList[f_, dvs_]:=
DeleteDuplicates[
	PackageFIreconstructPatterns /@
	ReplaceAll[
		PackageFIreducePatterns /@ PackageFIextractArgStructureHead[f, dvs],
		{
			(f | HoldPattern) -> List
			}
		]
	];
PackageFIgenerateArgPatList~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageFIgenerateSIArgPat*)


PackageFIgenerateSIArgPat[f_] :=
With[{dvs = Keys@PackageFIgetCodeValues[f, {DownValues, SubValues, UpValues}]},
	PackageFImergeArgPats@PackageFIgenerateArgPatList[f, dvs]
	];
PackageFIgenerateSIArgPat~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageFIgenerateSILocVars*)


PackageFIgenerateSILocVars[f_] :=

With[{att = Attributes[f], 
		dvs = Keys@PackageFIgetCodeValues[f, {DownValues}]},
	Which[
		MemberQ[att, HoldAll],
		{1, Infinity},
		MemberQ[att, HoldRest],
		{2, Infinity},
		MemberQ[att, HoldFirst],
		{1}
		]
	];
PackageFIgenerateSILocVars~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageFIgenerateSIColEq*)


PackageFIgenerateSIColEq[f_] :=

With[{dvs = Keys@PackageFIgetCodeValues[f, {DownValues}]},
	Replace[{a_, ___} :> a]@
	MaximalBy[
		MinMax@Flatten@Position[#, _Equal, 1] & /@ dvs,
		Apply[Subtract]@*Reverse
		]
	];
PackageFIgenerateSIColEq~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageFIgenerateSIOpNames*)


PackageFIgenerateSIOpNames[f_] :=
ToString[#, InputForm] & /@ Keys@Options[f];
PackageFIgenerateSIOpNames~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageFIgenerateSyntaxInformation*)


Options[PackageFIgenerateSyntaxInformation] =
{
	"ArgumentsPattern" -> Automatic,
	"LocalVariables" -> None,
	"ColorEqualSigns" -> None,
	"OptionNames" -> Automatic
	};
Attributes[PackageFIgenerateSyntaxInformation] =
{
	HoldFirst
	};
PackageFIgenerateSyntaxInformation[
	f_,
	ops : OptionsPattern[]
	] :=
{
	"ArgumentsPattern" ->
	Replace[OptionValue["ArgumentsPattern"],
		Automatic :> PackageFIgenerateSIArgPat[f]
		],
	"LocalVariables" ->
	Replace[OptionValue["LocalVariables"],
		Automatic :> PackageFIgenerateSILocVars[f]
		],
	"ColorEqualSigns" ->
	Replace[OptionValue["LocalVariables"],
		Automatic :> PackageFIgenerateSIColEq[f]
		],
	"OptionNames" ->
	Replace[OptionValue["OptionNames"],
		Automatic :> PackageFIgenerateSIOpNames[f]
		]
	};


(* ::Subsubsection::Closed:: *)
(*PackageFIgenerateArgCount*)


PackageFIgenerateArgCount[f_] :=
Module[
	{
		dvs = Keys@PackageFIgetCodeValues[f, {DownValues, SubValues, UpValues}],
		patsNums,
		patsMax,
		patsMin,
		patsTypes,
		doNonOp = False
		},
	dvs=
	PackageFIextractArgStructureHead[f, dvs];
	patsNums =
	PackageFImergeArgPats[PackageFIgenerateArgPatList[f, dvs], True];
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
PackageFIgenerateArgCount~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageFIsetArgCount*)


PackageFIsetArgCount[f_Symbol, minA : _Integer, maxA : _Integer|Infinity, 
	noo : True | False] :=
With[{wasProt=MemberQ[Attributes[f], Protected]},
	If[wasProt, Unprotect[f]];
	Quiet[
		DownValues[f]=
		Cases[DownValues[f], 
			Except[
				Verbatim[HoldPattern][
					HoldPattern[Verbatim[Condition][f[___], (_ArgumentCountQ;False)]]
					]:>_Failure
				]
			];
		f[argPatLongToNotDupe___] /; (
			ArgumentCountQ[f,
				Length@
				If[noo,
					Replace[
						Hold[argPatLongToNotDupe], 
						Hold[argPatLongToNotDupe2___, 
							(_Rule | _RuleDelayed | {(_Rule | _RuleDelayed) ..}) ...
							] :> Hold[argPatLongToNotDupe2]
						], 
					Hold[argPatLongToNotDupe]
					], 
				minA, 
				maxA
				]; 
			False
			) := 
		Failure["Bad Definition",
			"If you're seeing this we have a bug; Raise an issue on GitHub"
			],
		{
			Unset::norep
			}
		];
	If[wasProt, Protect[f]];
	];
PackageFIsetArgCount~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageFIgenerateAutoFunctionInfo*)


Options[PackageFIgenerateAutoFunctionInfo] =
{
	"SyntaxInformation" -> {},
	"Autocompletions" -> {},
	"UsageMessages" -> {},
	"ArgCount" -> Automatic
	};
PackageFIgenerateAutoFunctionInfo[
	f_Symbol,
	ops : OptionsPattern[]
	] :=
{
	"UsageMessages" ->
	PackageFIgenerateSymbolUsage[f,
		Cases[
			Flatten@List[OptionsPattern["UsageMessages"]],
			_Rule | _RuleDelayed
			]
		],
	"SyntaxInformation" ->
	PackageFIgenerateSyntaxInformation[f,
		OptionValue["SyntaxInformation"]
		],
	"Autocompletions" ->
	PackageFIgenerateAutocompletions[f,
		OptionValue["Autocompletions"]
		],
	"ArgCount" ->
	Replace[OptionValue@"ArgCount",
		Except[
			KeyValuePattern[
				{"MinArgs" -> _Integer, "MaxArgs" -> _Integer | Infinity, 
					"OptionsPattern" -> (True | False)}
				]
			] :> PackageFIgenerateArgCount[f]
		]
	};
PackageFIgenerateAutoFunctionInfo~SetAttributes~HoldFirst


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
			PackageFIgenerateAutoFunctionInfo[f, 
				FilterRules[{o}, Options[PackageFIgenerateAutoFunctionInfo]]], 
			Flatten[{o, Options[PackageAutoFunctionInfo]}]
			],
		sops = FilterRules[{o}, Options[PackageFIgenerateAutoFunctionInfo]],
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
				Lookup[Set[as, PackageFIgenerateAutoFunctionInfo[f, sops]], 
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
			Lookup[Set[as, PackageFIgenerateAutoFunctionInfo[f, sops]], 
				"UsageMessages"]
			]
		];
	um = StringRiffle[um, "\n"];
	ac =
	Replace[Lookup[sinfBase, "Autocompletions"],
		Except[_List] :>
		Lookup[as, "Autocompletions",
			Lookup[Set[as, PackageFIgenerateAutoFunctionInfo[f, sops]], 
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
			Lookup[Set[as, PackageFIgenerateAutoFunctionInfo[f, sops]], "ArgCount"]
			]
		];
	If[set,
		SyntaxInformation[Unevaluated@f] = si;
		If[StringLength@um > 0, f::usage = um];
		If[Length@ac > 0, PackageFIaddAutocompletions[f, ac]];
		PackageFIsetArgCount[f, argX["MinArgs"], argX["MaxArgs"], 
			argX["OptionsPattern"]],
		(* dump to held expression for writing to file *)
		With[
			{
				si2 = si,
				um2 = um,
				acpat = PackageFIautocompletionPreCompile[ac],
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
									Length@
									If[noo,
										Replace[Hold[argPatLongToNotDupe], 
											Hold[argPatLongToNotDupe2___, 
												(_Rule | _RuleDelayed | {(_Rule | _RuleDelayed) ..}) ...
												] :> Hold[argPatLongToNotDupe2]
											], 
										Hold[argPatLongToNotDupe]
										], minA, maxA]; False)
								)
							]
						]
					]
				]
			]
		]


PackageAutoFunctionInfo[dymbshyt:{s__Symbol}]:=
Thread[PackageAutoFunctionInfo/@Hold[s], Hold];


PackageAutoFunctionInfo[dymbshyt:{s__Symbol}]:=
Thread[PackageAutoFunctionInfo/@Hold[s],Hold];
PackageAutoFunctionInfo[conto:_?StringPattern`StringPatternQ]:=
Thread[ToExpression[Names[conto], StandardForm, PackageAutoFunctionInfo],Hold];
PackageAutoFunctionInfo[ughwhy:{conto__?StringPattern`StringPatternQ}]:=
ToExpression[Names[conto], StandardForm, PackageAutoFunctionInfo];
PackageAutoFunctionInfo[
	e:Except[{__Symbol}|_String|{__String}|_Symbol|_Pattern]
	]/;!TrueQ@$recursionProtectMe:=
Block[{$recursionProtectMe=True},
	PackageAutoFunctionInfo@Evaluate@e
	];


PackageAutoFunctionInfo~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageAutoFunctionInfoExport*)


PackageAutoFunctionInfoExport[fn:_String|_File, e_]:=
Replace[PackageAutoFunctionInfo[e],
	Put[Unevaluated[e], fn]
	];
PackageAutoFunctionInfoExport~SetAttributes~HoldRest


(* ::Subsubsection:: *)
(*End*)


End[];
