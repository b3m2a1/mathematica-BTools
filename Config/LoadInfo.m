(* ::Package:: *)

Merge[
	{
		"PreLoad"-> None,
		"FEHidden" ->
				{
					},
		"PackageScope"->{
			"AppBuilder",
			"GoogleDrive",
			"FormattingTools",
			"FETools",
			"ScrapeTools",
			"TRTools",
			"AuthDialogs"
			},
		If[TrueQ@FileExistsQ@
			FileNameJoin@{$PackageDirectory, "Private", "Config", "LoadInfo.m"},
			Import[FileNameJoin@{$PackageDirectory, "Private", "Config", "LoadInfo.m"}],
			{}
			]
		},
	Last
	]
