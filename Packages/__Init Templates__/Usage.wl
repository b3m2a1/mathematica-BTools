(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*Usage*)


addUsage[sym_Symbol,usage_String]:=
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
addUsage[pat:Except[_Missing],usage_String]:=
	addUsage[
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
addUsage[pat:Except[_Missing],usage_]:=
	addUsage[pat,ToString[usage]];
addUsage~SetAttributes~HoldFirst;
