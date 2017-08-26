(* ::Package:: *)

(* Mathematica Package *)
  
BeginPackage["$ServiceConnectionLoad`"]
(* Exported symbols added here with SymbolName::usage *)  

Begin["`Private`"] (* Begin Private Context *) 

If[!ListQ[System`$Services],Get["OAuth`"]]

Block[{dir=DirectoryName[System`Private`$InputFileName]},
	Switch[$ServiceConnectionClientName,
		"OAuthClient"|"oauthclient"|"OauthClient",
			OAuthClient`addOAuthservice,
		"KeyClient"|"keyclient",
			KeyClient`addKeyservice,
		"OtherClient"|"otherclient",
			OtherClient`addOtherservice
		]["$ServiceConnection",dir]
	]


End[] (* End Private Context *)
EndPackage[]
