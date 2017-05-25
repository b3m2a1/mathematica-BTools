(* ::Package:: *)

(* ::Subsection:: *)
(*Paths*)


appPath[p__]:=
	FileNameJoin[Flatten@{
		$PackageDirectory,
		p
		}];
appFEFile[p___,f_]:=
	FrontEnd`FileName[
		Evaluate@
		Flatten@{
			$PackageName,
			p
			},
		f
		];
