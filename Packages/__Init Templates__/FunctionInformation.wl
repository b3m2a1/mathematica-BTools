(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*FunctionInformation*)


If[!AssociationQ@$FunctionInformationSet,
	$FunctionInformationSet=<|
		
		|>
	];


(* ::Subsubsection::Closed:: *)
(*getFunctionInformation*)


getFunctionInformation[_[pats___]]:=
	ReplaceRepeated[HoldPattern[#],{
		Verbatim[Pattern][_,b_]:>b,
		_Optional:>(_.),
		Verbatim[PatternTest][p_,_]:>p,
		Verbatim[Blank][s_]:>_,
		Verbatim[BlankSequence][s_]:>__,
		Verbatim[BlankNullSequence][s_]:>___,
		Verbatim[OptionsPattern][s__]:>OptionsPattern[]
		}]&/@Hold[pats];
getFunctionInformation~SetAttributes~HoldFirst;


(* ::Subsubsection::Closed:: *)
(*setFunctionInformation*)


setFunctionInformation[f_Symbol[pats___]]:=
	If[!Lookup[$FunctionInformationSet,f,False],
		$FunctionInformationSet[f]=True;
		SyntaxInformation[f]=getFunctionInformation[f[pats]]
		];
setFunctionInformation[Verbatim[HoldPattern][f_Symbol[pats___]]]:=
	setFunctionInformation[f[pats]];
setFunctionInformation~SetAttributes~HoldFirst;


setFunctionInformation[f_Symbol]:=
	If[!Lookup[$FunctionInformationSet,f,False],
		With[{d=
			MaximalBy[DownValues[f],
				Length@Extract[#,1,Unevaluated]&
				]},
			setFunctionInformation[d]
			]
		];


(* ::Subsubsection::Closed:: *)
(*clearFunctionInformation*)


clearFunctionInformation[f_Symbol]:=
	($FunctionInformationSet[f]=False);
clearFunctionInformation[f_Symbol[pats___]]:=
	($FunctionInformationSet[f]=False);
