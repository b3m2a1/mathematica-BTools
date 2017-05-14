(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*Paths*)


appPath[p__]:=
	FileNameJoin[{
		$PackageDirectory,
		p
		}];
appFEFile[p___,f_]:=
	FileNameJoin[{
		$PackageName,
		p
		},
		f
		];
