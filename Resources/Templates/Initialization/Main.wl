(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*Temp Loading Flag Code*)


Temp`PackageScope`$NameLoading`Private`$PackageLoadData=
  If[#===None, <||>, Replace[Quiet@Get@#, Except[_?OptionQ]-><||>]]&@
    Append[
      FileNames[
        "LoadInfo."~~"m"|"wl",
        FileNameJoin@{DirectoryName@$InputFileName, "Config"}
        ],
      None
      ][[1]];
Temp`PackageScope`$NameLoading`Private`$PackageLoadMode=
  Lookup[Temp`PackageScope`$NameLoading`Private`$PackageLoadData, "Mode", "Primary"];
Temp`PackageScope`$NameLoading`Private`$DependencyLoad=
  TrueQ[Temp`PackageScope`$NameLoading`Private`$PackageLoadMode==="Dependency"];


(* ::Subsection:: *)
(*Main*)


If[Temp`PackageScope`$NameLoading`Private`$DependencyLoad,
  If[!TrueQ[Evaluate[Symbol["`$Name`PackageScope`Private`$LoadCompleted"]]],
    Get@FileNameJoin@{DirectoryName@$InputFileName, "$NameLoader.wl"}
    ],
  If[!TrueQ[Evaluate[Symbol["$Name`PackageScope`Private`$LoadCompleted"]]],
    <<$Name`$NameLoader`
    ]
  ]
