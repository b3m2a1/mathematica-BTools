(* ::Package:: *)

(* ::Subsection:: *)
(*Exceptions*)


$PackageExceptionTag::usage="";
PackageExceptionBlock::usage="";


PackageThrowException::usage="";
PackageCatchException::usage="";
PackageCatchExceptionCallback::usage="";


PackageThrowMessage::usage="";
PackageCatchMessage::usage="";


PackageFailureException::usage="";
PackageRaiseException::usage="";


(* ::Subsubsection::Closed:: *)
(*Begin*)


Begin["`Exceptions`Private`"]


(* ::Subsubsection::Closed:: *)
(*PackageThrowException*)


PackageThrowException[value:Except[_Failure], tag:_String:"Failure"]:=
  Throw[value, $PackageName<>tag];
PackageThrowException[f_Failure]:=
  Throw[f, f[[1]]];


(* ::Subsubsection::Closed:: *)
(*PackageCatchException*)


$PackageCatchCallback=(#&);


PackageCatchExceptionHandler[tag_]:=
  $PackageCatchCallback;


PackageCatchException[
  expr:Except[_String], 
  tag:_String:"Failure", 
  callback_:Automatic
  ]:=
  Catch[expr, 
    $PackageName<>tag, 
    Replace[callback, Automatic:>PackageCatchExceptionHandler[tag]]
    ];
PackageCatchException[tag_String, callback_:Automatic]:=
  Function[Null,
    PackageCatchException[#, tag, callback],
    HoldFirst
    ];
PackageCatchException~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageThrowMessage*)


$PackageErrorMessage=
  "$Name encountered exception ``";


Options[PackageThrowMessage]=
  {
    "MessageParameters":>{}
    };
PackageThrowMessage[
  msg_MessageName, 
  body:_?StringQ,
  ops:OptionsPattern[]
  ]:=
  (
    Set[msg, body];
    Message[msg, Sequence@@OptionValue["MessageParameters"]]
    );
PackageThrowMessage[
  tag_?StringQ,
  body_?StringQ,
  ops:OptionsPattern[]
  ]:=
  PackageThrowMessage[
    MessageName[$Name, tag],
    body,
    ops
    ];
PackageThrowMessage[
  tag_?StringQ
  ]:=
  PackageThrowMessage[
    MessageName[$Name, tag],
    $PackageErrorMessage,
    "MessageParameters"->{tag}
    ];
PackageThrowMessage~SetAttributes~HoldAll


(* ::Subsubsection::Closed:: *)
(*PackageCatchMessage*)


$PackageCatchMessageMessage=
  "Check caught exceptions ``";


$PackageCatchMessageCallback=
  Function[
    PackageRaiseException[
      "Check",
      $PackageCatchMessageMessage,
      "MessageParameters"->Thread[HoldForm[$MessageList]]
      ]
    ];


PackageCatchMessage[
  expr_,
  failexpr_:Automatic,
  msg:{___String}:{}
  ]:=
  Replace[
    Thread[Map[Hold[MessageName[$Name, #]]&, msg], Hold],
    {
      {}:>
        Check[expr, 
          Replace[failexpr, {Automatic:>$PackageCatchMessageCallback[]}]
          ],
      Hold[msgs_]:>
        Check[expr, 
          Replace[failexpr, {Automatic:>$PackageCatchMessageCallback[]}], 
          msgs
          ],
      _:>
        Replace[failexpr, {Automatic:>$PackageCatchMessageCallback[]}]
      }
    ];
PackageCatchMessage~SetAttributes~HoldAll;


(* ::Subsubsection::Closed:: *)
(*PackageFailureException*)


Options[PackageFailureException]=
  Options[PackageThrowMessage];
PackageFailureException[
  msg_MessageName,
  body_?StringQ,
  ops:OptionsPattern[]
  ]:=
  Replace[
    OptionValue[Automatic, Automatic, "MessageParameters", Hold],
    Hold[params_]:>
      Failure[
        $PackageName<>Hold[msg][[1, 2]],
        <|
          "MessageTemplate":>
            msg,
          "MessageParameters":>
            params
          |>
        ]
    ];
PackageFailureException[
  tag:_?StringQ:"Exception",
  body_?StringQ,
  ops:OptionsPattern[]
  ]:=
  (
    Set[MessageName[$Name, tag], body];
    PackageFailureException[
      MessageName[$Name, tag],
      body,
      ops
      ]
    );
PackageFailureException~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageRaiseException*)


PackageRaiseException//Clear;
Options[PackageRaiseException]=
  Options[PackageFailureException]
PackageRaiseException[
  msg_MessageName,
  body_?StringQ,
  ops:OptionsPattern[]
  ]:=
  (
    PackageThrowMessage[msg, body, 
      Evaluate@FilterRules[{ops}, Options[PackageThrowMessage]]
      ];
    PackageThrowException[
      PackageFailureException[msg, body, ops]
      ]
    );
PackageRaiseException[
  tag_?StringQ,
  body_?StringQ,
  ops:OptionsPattern[]
  ]:=
  PackageRaiseException[
    MessageName[$Name, tag],
    body,
    ops
    ];
PackageRaiseException[
  tag:_?(StringQ[#]&&StringMatchQ[#, WordCharacter..]&),
  ops:OptionsPattern[]
  ]:=
  PackageRaiseException[
    tag,
    $PackageErrorMessage,
    {
      ops,
      "MessageParameters"->{tag}
      }
    ];
PackageRaiseException[
  Optional[Automatic, Automatic],
  body:_?StringQ,
  ops:OptionsPattern[]
  ]:=
  PackageRaiseException[
    Evaluate@$PackageExceptionTag,
    body,
    ops
    ];
PackageRaiseException[
  tag:Automatic|_String,
  body_String,
  args:__?(Not@*OptionQ)
  ]:=
  PackageRaiseException[tag, body, "MessageParameters"->{args}];
PackageRaiseException~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageExceptionBlock*)


$PackageExceptionStack={};
Protect[$PackageExceptionStack];


$PackageExceptionTag="Failure";


PackageExceptionBlock//Clear
(*PackageExceptionBlock/:
  HoldPattern[
    SetDelayed[lhs_, 
      peb:PackageExceptionBlock[_, _String]
      ]
    ]:=
  SetDelayed[lhs,
    Block[{$PackageExceptionBlockResult},
      $PackageExceptionBlockResult=peb;
      peb/;!FailureQ@peb
      ]
    ];*)
PackageExceptionBlock[
  expr_,
  tag:_String
  ]:=
  Block[
    {
      $PackageExceptionTag=tag,
      $PackageExceptionStack=
        Append[$PackageExceptionStack, tag],
      result
      },
    result=PackageCatchException[expr, tag, #&];
    If[MatchQ[result, Failure[_String?(StringEndsQ[tag]), _]]&&
      MemberQ[Most@$PackageExceptionStack, tag],
      PackageThrowException[result]
      ];
    result(*/;!FailureQ@result*)
    ];
PackageExceptionBlock[tag_String]:=
  Function[Null, PackageExceptionBlock[#, tag], HoldFirst];
PackageExceptionBlock[Optional[Automatic, Automatic]]:=
  Function[Null, PackageExceptionBlock[#, $PackageExceptionTag], HoldFirst];
PackageExceptionBlock~SetAttributes~HoldFirst;


(* ::Subsubsection::Closed:: *)
(*End*)


End[]
