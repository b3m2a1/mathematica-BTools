(* ::Package:: *)

$packageHeader

BeginPackage["$CuratedData`"];


$CuratedData::usage=
	"An wrapper to the other DataPaclets";


Begin["DataPaclets`$CuratedDataDump`"];


$DataFunctions=
	$CuratedDataFunctions;


If[!AssociationQ@$DataFunctionsLoaded,
	$DataFunctionsLoaded=<||>
	];


$CuratedData["DataFunctions"]=
	$DataFunctions;


$CuratedData[data_?(KeyMemberQ[$DataFunctions,#]&),"DataFunction"]:=
	(
		If[!TrueQ@Lookup[$DataFunctionsLoaded,$DataFunctions[data],False],
			With[{functionName=SymbolName[$DataFunctions[data]]},
				If[Length@PacletManager`PacletFind[functionName]===0,
					PacletManager`PacletInstall[functionName];
					];
				If[Length@DownValues@Evaluate@$DataFunctions[data]===0,
					Get[functionName<>"`"]
					];
				$DataFunctionsLoaded[$DataFunctions[data]]=True
				]
			];
		$DataFunctions[data]
		);
$CuratedData[data_?(KeyMemberQ[$DataFunctions,#]&),args___]:=
	$CuratedData[data,"DataFunction"][args];
$CuratedData[]:=
	Values@$DataFunctions;


End[];


EndPackage[];



