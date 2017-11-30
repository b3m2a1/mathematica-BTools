(* ::Package:: *)

Merge[
	{
		"PreLoad"-> None,
		"FEHidden" ->
				{
					"FormattingTools",
					"FETools",
					"ScrapeTools",
					"TRTools",
					"AuthDialogs"
					},
		"PackageScope"->{
			"GoogleDrive"
			},
		If[TrueQ@FileExistsQ@
			FileNameJoin@{$PackageDirectory, "Private", "Config", "LoadInfo.m"},
			Import[FileNameJoin@{$PackageDirectory, "Private", "Config", "LoadInfo.m"}],
			{}
			]
		},
	Last
	]
