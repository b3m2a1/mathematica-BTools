(* ::Package:: *)

(* ::Subsection:: *)
(*SyntaxInformation*)


(* ::Subsubsection::Closed:: *)
(*$PackageSyntaxInformationSet*)


If[!AssociationQ@$PackageSyntaxInformationSet,
	$PackageSyntaxInformationSet=<|
		
		|>
	];


(* ::Subsubsection::Closed:: *)
(*PackageGetSyntaxInformation*)


PackageGetSyntaxInformation[Except[HoldPattern][pats___]]:=
	ReplaceRepeated[HoldPattern[#],{
		Verbatim[Pattern][_,b_]:>b,
		_Optional:>(_.),
		Verbatim[PatternTest][p_,_]:>p,
		Verbatim[Blank][s_]:>_,
		Verbatim[BlankSequence][s_]:>__,
		Verbatim[BlankNullSequence][s_]:>___,
		Verbatim[OptionsPattern][s__]:>OptionsPattern[]
		}]&/@Hold[pats]//Thread[List@@#,HoldPattern]&//ReleaseHold;
PackageGetSyntaxInformation[Verbatim[HoldPattern][pat_]]:=
	PackageGetSyntaxInformation[pat];
PackageGetSyntaxInformation[Verbatim[HoldPattern][pats___]]:=
	PackageGetSyntaxInformation[Hold[pats]];
PackageGetSyntaxInformation[pat_Symbol]:=
	Replace[DownValues[pat],
		(Verbatim[HoldPattern][p_]:>_):>
			PackageGetSyntaxInformation[p],
		1
		];
PackageGetSyntaxInformation~SetAttributes~HoldFirst;


(* ::Subsubsection::Closed:: *)
(*PackageSetSyntaxInformation*)


PackageSetSyntaxInformation[Verbatim[HoldPattern][f_Symbol[pats___]],o___]:=
	PackageSetSyntaxInformation[f[pats],o];
PackageSetSyntaxInformation[f_Symbol[pats___],o___]:=
	If[!Lookup[$PackageSyntaxInformationSet,f,False],
		$PackageSyntaxInformationSet[f]=True;
		SyntaxInformation[f]={
			"ArgumentsPattern"->PackageGetSyntaxInformation[f[pats]],
			o
			};
		];
PackageSetSyntaxInformation~SetAttributes~HoldFirst;


PackageSetSyntaxInformation[f_Symbol,o___]:=
	If[!Lookup[$PackageSyntaxInformationSet,f,False],
		With[{d=
			First@
				MaximalBy[
					Length@Extract[#,1,Unevaluated]&
					]@
				MaximalBy[First/@DownValues[f],
					Length@Cases[#,_Optional|_Default|_OptionsPattern,\[Infinity]]&
					]},
			PackageSetSyntaxInformation[d,o]
			]
		];


(* ::Subsubsection::Closed:: *)
(*PackageClearSyntaxInformation*)


PackageClearSyntaxInformation[f_Symbol]:=
	(SyntaxInformation[f]=.;$PackageSyntaxInformationSet[f]=False;);
PackageClearSyntaxInformation[f_Symbol[pats___]]:=
	(SyntaxInformation[f]=.;$PackageSyntaxInformationSet[f]=False;);
