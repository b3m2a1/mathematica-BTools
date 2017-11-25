(* ::Package:: *)

(* ::Subsection:: *)
(*Constants*)


(* ::Subsubsection::Closed:: *)
(*Naming*)


$PackageDirectory=
	DirectoryName@$InputFileName;
$PackageName=
	"$Name";


(* ::Subsubsection::Closed:: *)
(*Loading*)


$PackageListing=<||>;
$PackageContexts={
		"$Name`",
		"$Name`Private`Package`",
		"$Name`Private`Hidden`"
		};
$PackageDeclared=
	TrueQ[$PackageDeclared];


(* ::Subsubsection::Closed:: *)
(*Scoping*)


$PackageFEHiddenSymbols={};
$PackageScopedSymbols={};
$PackageLoadSpecs=
	With[{f=FileNameJoin@{$PackageDirectory, "Config", "LoadInfo.m"}},
			Replace[
				Quiet[
					Import@f,
					Import::nffil
					],
				Except[KeyValuePattern[{}]]:>
					{}
				]
		];
$AllowPackageRescoping=
	$TopLevelLoad||Lookup[$PackageLoadSpecs, "AllowRescoping", True];
$AllowPackageRecoloring=
	$TopLevelLoad||Lookup[$PackageLoadSpecs, "AllowRecoloring", True];
