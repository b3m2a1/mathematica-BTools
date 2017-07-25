(* ::Package:: *)

(* ::Subsection:: *)
(*Autocompletion*)


(* ::Subsubsection::Closed:: *)
(* $PackageAutoCompletionFormats *)


$PackageAutoCompletionFormats=
	Alternatives@@Join@@{
		Range[9],
		{{__String}},
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
(* PackageAddAutocompletions Basic*)


PackageAddAutocompletions[pats:{(_String->{$PackageAutoCompletionFormats..})..}]:=
	If[$Notebooks&&
		Internal`CachedSystemInformation["FrontEnd","VersionNumber"]>10.0,
		Scan[
			FE`Evaluate[FEPrivate`AddSpecialArgCompletion[#]]&,
			pats
			];
		pats,
		$Failed
		];
PackageAddAutocompletions[pat:(_String->{$PackageAutoCompletionFormats..})]:=
	PackageAddAutocompletions[{pat}];


(* ::Subsubsection::Closed:: *)
(* $autocompletionTable *)


$PackageAutocompletionTable={
	f:$PackageAutoCompletionFormats:>f,
	None|Normal|"Standard"->0,
	AbsoluteFileName|"AbsoluteFileName"->2,
	FileName->3,
	"Color"->4,
	Package|"Package"->7,
	Directory|"Directory"->8,
	Interpreter|"InterpreterType"->9,
	s_String:>{s}
	};


(* ::Subsubsection::Closed:: *)
(* PackageAddAutocompletions Formatted *)


PackageAddAutocompletions[o:{__Rule}]/;(!TrueQ@$PackageRecursionProtect):=
	Block[{$recursionProtect=True},
		Replace[
			PackageAddAutocompletions@
				Replace[o,
					(s_->v_):>
						(Replace[s,_Symbol:>SymbolName[s]]->
							Replace[
								Flatten[{v},1],
								$PackageAutocompletionTable,
								1
								]),
					1
					],
			_PackageAddAutocompletions->$Failed
			]
		];
PackageAddAutocompletions[s:Except[_List],v_]:=
	PackageAddAutocompletions[{s->v}];
PackageAddAutocompletions[l_,v_]:=
	PackageAddAutocompletions@
		Flatten@{
			Quiet@
				Check[
					Thread[l->v],
					Map[l->#&,v]
					]
			};


(* ::Subsubsection::Closed:: *)
(* PackageSetAutocompletionData *)


PackageSetAutocompletionData[]:=
	If[DirectoryQ@
			FileNameJoin@{
					$PackageDirectory,
					"Resources",
					"FunctionalFrequency"
					},
		CurrentValue[
		$FrontEndSession,
			{PrivatePaths,"AutoCompletionData"}
			]=
			DeleteDuplicates@
				Append[
					CurrentValue[
						$FrontEndSession,
						{PrivatePaths,"AutoCompletionData"}
						],
					FileNameJoin@{
						$PackageDirectory,
						"Resources",
						"FunctionalFrequency"
						}
					]
		];
