(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*FrontEnd*)


(* ::Subsubsection::Closed:: *)
(* feInstallStylesheets *)


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
(* feInstallPalettes *)


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
