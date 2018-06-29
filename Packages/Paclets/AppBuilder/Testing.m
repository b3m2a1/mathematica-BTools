(* ::Package:: *)



(* ::Text:: *)
(*
	Helper utilities for writing tests for a package
*)



AppFindTestingNotebook::usage="Finds the testing notebook for an app";
AppNewTestingNotebook::usage="Makes a new testing notebook for an app";


AppExportTests::usage="Exports the tests in the testing notebook";
AppListTests::usage="Lists the tests in the testing notebook";
AppAddTest::usage="Adds a test to the testing notebook";


Begin["`Private`"];


(* ::Subsubsection::Closed:: *)
(*AppFindTestingNotebook*)



AppFindTestingNotebook[app_, name_:"Testing.nb"]:=
	Replace[
		AppFileNames[app, name, 
			AppPath/@
				{
					{"Resources", "Testing"},
					{"Testing"},
					{"Private", "Testing"},
					{"Private"}
					}
			],
		{
			{f_, ___}:>f,
			_->None
			}
		]


(* ::Subsubsection::Closed:: *)
(*AppNewTestingNotebook*)



AppNewTestingNotebook[app_, name_:"Testing.nb", ops:OptionsPattern[]]:=
	NotebookPut[
		Notebook[
			{},
			StyleDefinitions->
				FrontEnd`FileName[{"MUnit"}, "MUnit.nb",CharacterEncoding->"UTF-8"],
			ops,
			NotebookFileName->
				AppPath[app, "Resources", "Testing", name]
			]
		]


(* ::Subsubsection::Closed:: *)
(*AppListTests*)



AppListTests[app_]:=
	With[{nb=AppFindTestingNotebook[app]},
		
		]


End[];



