(* ::Package:: *)

(* ::Subsection:: *)
(*Constants*)


$PackageDirectory::usage="";
$PackageName::usage="";
$PackageListing::usage="";
$PackageContexts::usage="";
$PackageDeclared::usage="";
$PackageFEHiddenSymbols::usage="";
$PackageScopedSymbols::usage="";
$PackageLoadSpecs::usage="";
$AllowPackageSymbolDefinitions::usage="";
$AllowPackageRescoping::usage="";
$AllowPackageRecoloring::usage="";
$AllowPackageAutocompletions::usage="";


(* ::Subsubsection::Closed:: *)
(*Begin*)


Begin["`Constants`"];


(* ::Subsubsection::Closed:: *)
(*Naming*)


$Name["Directory"]:=
	$PackageDirectory;
$PackageDirectory=
	DirectoryName@$InputFileName;


$Name["Name"]:=
	$PackageName;
$PackageName=
	"$Name";


(* ::Subsubsection::Closed:: *)
(*Loading*)


$Name["PackageListing"]:=$PackageListing;
$PackageListing=<||>;
$Name["Contexts"]:=$PackageContexts;
$PackageContexts=
	{
		"$Name`",
		"$Name`PackageScope`Private`",
		"$Name`PackageScope`Package`"
		};
$PackageDeclared=
	TrueQ[$PackageDeclared];


(* ::Subsubsection::Closed:: *)
(*Scoping*)


$Name["FEScopedSymbols"]:=$PackageFEHiddenSymbols;
$PackageFEHiddenSymbols={};
$Name["PackageScopedSymbols"]:=$PackageScopedSymbols;
$PackageScopedSymbols={};
$Name["LoadingParameters"]:=$PackageLoadSpecs
$PackageLoadSpecs=
	Merge[
		{
			With[
				{
					f=
						Append[
							FileNames[
								"LoadInfo."~~"m"|"wl",
								FileNameJoin@{$PackageDirectory, "Config"}
								],
							None
							][[1]]
					},
				Replace[
						Quiet[
							Import@f,
							{
								Import::nffil,
								Import::chtype
								}
							],
					Except[KeyValuePattern[{}]]:>
						{}
					]
				],
			With[
				{
					f=
						Append[
							FileNames[
								"LoadInfo."~~"m"|"wl",
								FileNameJoin@{$PackageDirectory, "Private", "Config"}
								],
							None
							][[1]]},
				Replace[
					Quiet[
						Import@f,
						{
							Import::nffil,
							Import::chtype
							}
						],
					Except[KeyValuePattern[{}]]:>
						{}
					]
				]
			},
		Last
		];


(* ::Subsubsection::Closed:: *)
(*Allow flags*)


$AllowPackageSymbolDefinitions=
	Replace[
		Lookup[$PackageLoadSpecs, "PackageSymbolDefinitions"],
		Except[True|False|None]->True
		];
$Name["AllowRescoping"]:=$AllowPackageRescoping;
$AllowPackageRescoping=
	Replace[
		Lookup[$PackageLoadSpecs, "AllowRescoping"],
		Except[True|False]->$TopLevelLoad
		];
$Name["AllowRecoloring"]:=$AllowPackageRecoloring;
$AllowPackageRecoloring=
	Replace[
		Lookup[$PackageLoadSpecs, "AllowRecoloring"],
		Except[True|False]->$TopLevelLoad
		];
$Name["AllowAutocompletions"]:=$AllowPackageAutocompletions;
$AllowPackageAutocompletions=
	Replace[
		Lookup[$PackageLoadSpecs, "AllowAutocompletions"],
		Except[True|False]->$TopLevelLoad
		];


(* ::Subsubsection::Closed:: *)
(*End*)


End[]
