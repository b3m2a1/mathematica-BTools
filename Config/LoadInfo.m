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
					}
				],
		"PackageScope"->{
			"GoogleDrive"
			},
		If[TrueQ@FileExistsQ@PackageFilePath["Private", "Config", "LoadInfo.m"],
			Import[PackageFilePath["Private", "Config", "LoadInfo.m"]]
			{}
			]
		},
	Last
	]
