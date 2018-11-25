(* ::Subsection::Closed:: *)
(*Temp Loading Flag Code*)


Temp`PackageScope`BToolsLoading`Private`$PackageLoadData=
  If[#===None, <||>, Replace[Quiet@Get@#, Except[_?OptionQ]-><||>]]&@
    Append[
      FileNames[
        "LoadInfo."~~"m"|"wl",
        FileNameJoin@{DirectoryName@$InputFileName, "Config"}
        ],
      None
      ][[1]];
Temp`PackageScope`BToolsLoading`Private`$PackageLoadMode=
  Lookup[Temp`PackageScope`BToolsLoading`Private`$PackageLoadData, "Mode", "Primary"];
Temp`PackageScope`BToolsLoading`Private`$DependencyLoad=
  TrueQ[Temp`PackageScope`BToolsLoading`Private`$PackageLoadMode==="Dependency"];


(* ::Subsection:: *)
(*Main*)


If[Temp`PackageScope`BToolsLoading`Private`$DependencyLoad,
  If[!TrueQ[Evaluate[Symbol["`BTools`PackageScope`Private`$LoadCompleted"]]],
    Get@FileNameJoin@{DirectoryName@$InputFileName, "BToolsLoader.wl"}
    ],
  If[!TrueQ[Evaluate[Symbol["BTools`PackageScope`Private`$LoadCompleted"]]],
    <<BTools`BToolsLoader`
    ]
  ]