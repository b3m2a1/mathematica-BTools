(* ::Package:: *)

(* ::Subsection:: *)
(*Usage*)


(* ::Subsubsection::Closed:: *)
(*PackageAddUsage*)


PackageAddUsage[sym_Symbol,usage_String]:=
	(sym::usages=
		StringTrim@StringRiffle[{
			StringReplace[
				Replace[sym::usages,
					Except[_String]->""
					],
				usage->""
				],
			usage},
			"\n"]);
PackageAddUsage[pat:Except[_Missing],usage_String]:=
	PackageAddUsage[
		Evaluate@FirstCase[Hold[pat],
			s_Symbol?(
				Function[Null,
				Context[#]==("$Name`"),
				HoldFirst]):>s,
			Missing["NotFound"],
			Infinity,
			Heads->True
			],
		ToString[Unevaluated[pat]]<>" "<>usage
		];
PackageAddUsage[pat:Except[_Missing],usage_]:=
	PackageAddUsage[pat,ToString[usage]];
PackageAddUsage~SetAttributes~HoldFirst;
