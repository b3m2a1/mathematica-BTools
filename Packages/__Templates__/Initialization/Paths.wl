(* ::Package:: *)

(* ::Subsection:: *)
(*Paths*)


(* ::Subsubsection::Closed:: *)
(*PackageFilePath*)


PackageFilePath[p__]:=
	FileNameJoin[Flatten@{
		$PackageDirectory,
		p
		}];


(* ::Subsubsection::Closed:: *)
(*PackageFEFile*)


PackageFEFile[p___,f_]:=
	FrontEnd`FileName[
		Evaluate@
		Flatten@{
			$PackageName,
			p
			},
		f
		];
