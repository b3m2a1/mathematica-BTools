(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*SyntaxInformation*)


If[!AssociationQ@$SyntaxInformationSet,
	$SyntaxInformationSet=<|
		
		|>
	];


(* ::Subsubsection::Closed:: *)
(*getSyntaxInformation*)


getSyntaxInformation[Except[HoldPattern][pats___]]:=
	ReplaceRepeated[HoldPattern[#],{
		Verbatim[Pattern][_,b_]:>b,
		_Optional:>(_.),
		Verbatim[PatternTest][p_,_]:>p,
		Verbatim[Blank][s_]:>_,
		Verbatim[BlankSequence][s_]:>__,
		Verbatim[BlankNullSequence][s_]:>___,
		Verbatim[OptionsPattern][s__]:>OptionsPattern[]
		}]&/@Hold[pats]//Thread[List@@#,HoldPattern]&//ReleaseHold;
getSyntaxInformation[Verbatim[HoldPattern][pat_]]:=
	getSyntaxInformation[pat];
getSyntaxInformation[Verbatim[HoldPattern][pats___]]:=
	getSyntaxInformation[Hold[pats]];
getSyntaxInformation[pat_Symbol]:=
	Replace[DownValues[pat],
		(Verbatim[HoldPattern][p_]:>_):>
			getSyntaxInformation[p],
		1
		];
getSyntaxInformation~SetAttributes~HoldFirst;


(* ::Subsubsection::Closed:: *)
(*setSyntaxInformation*)


setSyntaxInformation[Verbatim[HoldPattern][f_Symbol[pats___]],o___]:=
	setSyntaxInformation[f[pats],o];
setSyntaxInformation[f_Symbol[pats___],o___]:=
	If[!Lookup[$SyntaxInformationSet,f,False],
		$SyntaxInformationSet[f]=True;
		SyntaxInformation[f]={
			"ArgumentsPattern"->getSyntaxInformation[f[pats]],
			o
			};
		];
setSyntaxInformation~SetAttributes~HoldFirst;


setSyntaxInformation[f_Symbol,o___]:=
	If[!Lookup[$SyntaxInformationSet,f,False],
		With[{d=
			First@
				MaximalBy[
					Length@Extract[#,1,Unevaluated]&
					]@
				MaximalBy[First/@DownValues[f],
					Length@Cases[#,_Optional|_Default|_OptionsPattern,\[Infinity]]&
					]},
			setSyntaxInformation[d,o]
			]
		];


(* ::Subsubsection::Closed:: *)
(*clearSyntaxInformation*)


clearSyntaxInformation[f_Symbol]:=
	(SyntaxInformation[f]=.;$SyntaxInformationSet[f]=False;);
clearSyntaxInformation[f_Symbol[pats___]]:=
	(SyntaxInformation[f]=.;$SyntaxInformationSet[f]=False;);
