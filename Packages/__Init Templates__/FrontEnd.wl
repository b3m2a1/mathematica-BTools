(* ::Package:: *)

(* ::Subsection:: *)
(*FrontEnd*)


(* ::Subsubsection::Closed:: *)
(*feInstallStylesheets *)


feInstallStylesheets[]:=
	With[{
		base=
			FileNameJoin@{
				$PackageDirectory,
				"FrontEnd",
				"StyleSheets",
				$PackageName
				},
		target=
			FileNameJoin@{
					$UserBaseDirectory,
					"SystemFiles",
					"FrontEnd",
					"StyleSheets",
					$PackageName}
		},
		If[DirectoryQ@base,
			Do[
				Quiet@
					CreateFile[
						FileNameJoin@{
							target,
							FileNameDrop[f,FileNameDepth[base]]
							},
						CreateIntermediateDirectories->True
						];
				CopyFile[f,
					FileNameJoin@{
						target,
						FileNameDrop[f,FileNameDepth[base]]
						},
					OverwriteTarget->True],
				{f,FileNames["*.nb",base,\[Infinity]]}
				]
			]
		];


(* ::Subsubsection::Closed:: *)
(*feInstallPalettes *)


feInstallPalettes[]:=
	With[{
		base=
			FileNameJoin@{
				$PackageDirectory,
				"FrontEnd",
				"Palettes",
				$PackageName
				},
		target=
			FileNameJoin@{
					$UserBaseDirectory,
					"SystemFiles",
					"FrontEnd",
					"Palettes",
					$PackageName}
		},
		If[DirectoryQ@base,
			Do[
				Quiet@
					CreateFile[
						FileNameJoin@{
							target,
							FileNameDrop[f,FileNameDepth[base]]
							},
						CreateIntermediateDirectories->True
						];
				CopyFile[f,
					FileNameJoin@{
						target,
						FileNameDrop[f,FileNameDepth[base]]
						},
					OverwriteTarget->True],
				{f,FileNames["*.nb",base,\[Infinity]]}
				]
			]
		];


(* ::Subsubsection::Closed:: *)
(*feHiddenBlock*)


feHiddenBlock[expr_]:=
	(
		Internal`SymbolList[False];
		(Internal`SymbolList[True];#)&@expr
		);
feHiddenBlock~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*feUnhideSymbols*)


feUnhideSymbols[syms__Symbol,
	cpath:{__String}|Automatic:Automatic,
	mode:"Update"|"Set":"Update"
	]:=
	With[{stuff=
		Map[
			Function[Null,
				{Context@#,SymbolName@Unevaluated@#},
				HoldAllComplete],
			HoldComplete[syms]
			]//Apply[List]
		},
		KeyValueMap[
			FrontEndExecute@
			If[mode==="Update",
				FrontEnd`UpdateKernelSymbolContexts,
				FrontEnd`SetKernelSymbolContexts
				][
				#,
				Replace[cpath,Automatic->$ContextPath],
				{{#,{},{},#2,{}}}
				]&,
			GroupBy[stuff,First->Last]
			];
		];
feUnhideSymbols[names_String,mode:"Update"|"Set":"Update"]:=
	Replace[
		Thread[ToExpression[Names@names,StandardForm,Hold],Hold],
		Hold[{s__}]:>feUnhideSymbols[s,mode]
		];
feUnhideSymbols~SetAttributes~HoldAllComplete;


(* ::Subsubsection::Closed:: *)
(*feRehideSymbols*)


feRehideSymbols[syms__Symbol,
	cpath:{__String}|Automatic:Automatic,
	mode:"Update"|"Set":"Update"]:=
	With[{stuff=
		Map[
			Function[Null,
				{Context@#,SymbolName@Unevaluated@#},
				HoldAllComplete],
			HoldComplete[syms]
			]//Apply[List]
		},
		KeyValueMap[
			FrontEndExecute@
			If[mode==="Update",
				FrontEnd`UpdateKernelSymbolContexts,
				FrontEnd`SetKernelSymbolContexts
				][
				#,
				Replace[cpath,
					Automatic->$ContextPath
					],
				{{#,{},#2,{},{}}}
				]&,
			GroupBy[stuff,First->Last]
			];
		];
feRehideSymbols[names_String,mode:"Update"|"Set":"Update"]:=
	Replace[
		Thread[ToExpression[Names@names,StandardForm,Hold],Hold],
		Hold[{s__}]:>feRehideSymbols[s,mode]
		];
feRehideSymbols~SetAttributes~HoldAllComplete;


(* ::Subsubsection::Closed:: *)
(*feUnhidePackage*)


feUnhidePackage[package_String?FileExistsQ,a___]:=
	Replace[Thread[Lookup[$DeclaredPackages,package,{}],HoldPattern],
		Verbatim[HoldPattern][{syms__}]:>
			feUnhideSymbols[syms,a]
		];
feUnhidePackage[spec:_String|_List,a___]:=
	feUnhidePackage[appPath@Flatten@{"Packages",spec},a];


(* ::Subsubsection::Closed:: *)
(*feRehidePackage*)


feRehidePackage[package_String?FileExistsQ,a___]:=
	Replace[Thread[Lookup[$DeclaredPackages,package,{}],HoldPattern],
		Verbatim[HoldPattern][{syms__}]:>
			feRehideSymbols[syms,a]
		];
feRehidePackage[spec:_String|_List,a___]:=
	feRehidePackage[appPath@Flatten@{"Packages",spec},a];
