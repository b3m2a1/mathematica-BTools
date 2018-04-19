(* ::Package:: *)

(* ::Subsection:: *)
(*Exceptions*)


(* ::Subsubsection::Closed:: *)
(*PackageThrow*)


PackageThrow[value_, tag:_String:"Failure"]:=
	Throw[value, $PackageName<>tag];


(* ::Subsubsection::Closed:: *)
(*PackageCatch*)


$PackageCatchCallback=(#&);


PackageCatch[expr_, tag:_String:"Failure", callback_:Automatic]:=
	Catch[expr, $PackageName<>tag, 
		Replace[callback, Automatic:>$PackageCatchCallback]
		];
PackageCatch~SetAttributes~HoldFirst


(* ::Subsubsection:: *)
(*PackageMessage*)


$PackageErrorMessage=
	"$Name encountered exception ``";


Options[PackageMessage]=
	{
		"MessageParameters":>{}
		};
PackageMessage[
	msg_MessageName, 
	body_String,
	ops:OptionsPattern[]
	]:=
	(
		Set[msg, body];
		Message[msg, Sequence@@OptionValue["MessageParameters"]]
		);
PackageMessage[
	tag_?StringQ,
	body_String,
	ops:OptionsPattern[]
	]:=
	PackageMessage[
		MessageName[$Name, tag],
		body,
		ops
		];
PackageMessage[
	tag_?StringQ
	]:=
	PackageMessage[
		MessageName[$Name, tag],
		$PackageErrorMessage,
		"MessageParameters"->{tag}
		];
PackageMessage~SetAttributes~HoldAll


(* ::Subsubsection:: *)
(*PackageCheck*)


$PackageCheckMessage=
	"Check caught exceptions ``";


$PackageCheckCallback=
	Function[
		PackageRaiseException[
			"Check",
			$PackageCheckMessage,
			"MessageParameters"->Thread[HoldForm[$MessageList]]
			]
		];


PackageCheck[
	expr_,
	failexpr_:Automatic,
	msg:{___String}:{}
	]:=
	Replace[
		Thread[Map[Hold[MessageName[$Name, #]]&, msg], Hold],
		{
			{}:>
				Check[expr, 
					Replace[failexpr, {Automatic:>$PackageCheckCallback[]}]
					],
			Hold[msgs_]:>
				Check[expr, 
					Replace[failexpr, {Automatic:>$PackageCheckCallback[]}], 
					msgs
					],
			_:>
				Replace[failexpr, {Automatic:>$PackageCheckCallback[]}]
			}
		];
PackageCheck~SetAttributes~HoldAll;


(* ::Subsubsection:: *)
(*PackageFailure*)


Options[PackageFailure]=
	Join[
		Options[PackageMessage],
		{
			"FailureTag"->Automatic
			}
		];
PackageFailure[
	msg_MessageName,
	body_?StringQ,
	ops:OptionsPattern[]
	]:=
	Replace[
		OptionValue[Automatic, Automatic, "MessageParameters", Hold],
		Hold[params_]:>
			Failure[
				$PackageName<>
					Replace[OptionValue["FailureTag"], 
						Automatic:>Hold[msg][[1, 2]]
						],
				<|
					"MessageTemplate":>
						msg,
					"MessageParameters":>
						params
					|>
				]
		];
PackageFailure[
	tag:_?StringQ:"Exception",
	body_?StringQ,
	ops:OptionsPattern[]
	]:=
	(
		Set[MessageName[$Name, tag], body];
		PackageFailure[
			MessageName[$Name, tag],
			body,
			ops
			]
		);
PackageFailure~SetAttributes~HoldFirst


(* ::Subsubsection:: *)
(*PackageRaiseException*)


Options[PackageRaiseException]=
	Options[PackageFailure]
PackageRaiseException[
	msg_MessageName,
	body_?StringQ,
	ops:OptionsPattern[]
	]:=
	(
		PackageMessage[msg, body, 
			FilterRules[{ops}, Options[PackageMessage]]
			];
		PackageThrow[
			PackageFailure[msg, body, ops]
			]
		);
PackageRaiseException[
	tag_?StringQ,
	body_String,
	ops:OptionsPattern[]
	]:=
	PackageRaiseException[
		MessageName[$Name, tag],
		body,
		ops
		];
PackageRaiseException[tag_?StringQ]:=
	PackageRaiseException[
		tag,
		$PackageErrorMessage,
		"MessageParameters"->{tag}
		];
PackageRaiseException~SetAttributes~HoldFirst
