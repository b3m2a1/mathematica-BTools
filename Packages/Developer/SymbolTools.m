(* ::Package:: *)

(* Autogenerated Package *)

SymbolNameMatchQ::usage=
  "StringMatchQ on just the SymbolName (also works for strings)";
SymbolDetermineType::usage=
  "Determines symbol type";
$SymbolTypeNames=
  "Mapping of type to string";


Begin["`Private`"];


(* ::Subsubsection::Closed:: *)
(*SymbolNameMatchQ*)



SymbolNameMatchQ[s_Symbol,pat_]:=
  StringMatchQ[SymbolName@Unevaluated[s],pat];
SymbolNameMatchQ[s_String,pat_]:=
  StringMatchQ[Last@StringSplit[s,"`"],pat];
SymbolNameMatchQ[e:Except[_Symbol],pat_]:=
  SymbolNameMatchQ[e,pat];
SymbolNameMatchQ[pat_][e_]:=
  SymbolNameMatchQ[e,pat];
SetAttributes[SymbolNameMatchQ,HoldFirst];


(* ::Subsubsection::Closed:: *)
(*SymbolDetermineType*)



docFindValues[s_,type_]:=
  Quiet[
    Replace[type[s],
      Except[_List]->{}]
    ];
docFindValues~SetAttributes~HoldFirst;


$SymbolTypeNames=
  <|
    OwnValues->"Constant",
    DownValues->"Function",
    UpValues->"Object",
    SubValues->"Operator",
    FormatValues->"Wrapper"
    |>;
$SymbolNameTypes=
  AssociationThread[
    Values@$SymbolTypeNames,
    Keys@$SymbolTypeNames
    ];
SymbolDetermineType//Clear;
SymbolDetermineType[s_Symbol,all:True|False:False]:=
  Catch[
    Replace[
      Map[
        If[SymbolDetermineType[s,$SymbolTypeNames[#]],
          If[all,
            $SymbolTypeNames[#],
            Throw[$SymbolTypeNames[#]]
            ],
          Nothing
          ]&,
        Keys@$SymbolTypeNames
        ],
      {}->"Inert"
      ]
    ];
SymbolDetermineType[s_Symbol,$SymbolTypeNames[OwnValues]]:=
  (10.4<=$VersionNumber&&System`Private`HasOwnCodeQ@s)||
    Length@docFindValues[s,OwnValues]>0;
SymbolDetermineType[s_Symbol,$SymbolTypeNames[DownValues]]:=
  (10.4<=$VersionNumber&&System`Private`HasDownCodeQ@s)||
    Length@docFindValues[s,DownValues]>0;
SymbolDetermineType[s_Symbol,$SymbolTypeNames[SubValues]]:=
  (10.4<=$VersionNumber<=11.1&&System`Private`HasSubCodeQ@s)||
    Length@docFindValues[s,SubValues]>0;
SymbolDetermineType[s_Symbol,$SymbolTypeNames[UpValues]]:=
  (10.4<=$VersionNumber&&System`Private`HasUpCodeQ@s)||
    Length@docFindValues[s,UpValues]>0;
SymbolDetermineType[s_Symbol,$SymbolTypeNames[FormatValues]]:=
  (10.4<=$VersionNumber&&System`Private`HasPrintCodeQ@s)||
    Length@docFindValues[s,FormatValues]>0;
SymbolDetermineType[s_Symbol,"Inert"]:=
  SymbolDetermineType[s]==="Inert";
SymbolDetermineType[s_Symbol,
  Verbatim[Alternatives][t__?(KeyMemberQ[$SymbolNameTypes,#]&)]]:=
  Or@@Map[SymbolDetermineType[s,#]&,{t}];
SymbolDetermineType[s_Symbol,Or[t__?(KeyMemberQ[$SymbolNameTypes,#]&)]]:=
  Or@@Map[SymbolDetermineType[s,#]&,{t}];
SymbolDetermineType[s_Symbol,And[t__?(KeyMemberQ[$SymbolNameTypes,#]&)]]:=
  And@@Map[SymbolDetermineType[s,#]&,{t}];
SymbolDetermineType[s_String,e___]:=
  ToExpression[s,StandardForm,Function[Null,SymbolDetermineType[#,e],HoldFirst]];
SymbolDetermineType[s:{__String},e___]:=
  AssociationThread[
    s,
    ToExpression[s,StandardForm,Function[Null,SymbolDetermineType[#,e],HoldFirst]]
    ];
SymbolDetermineType[{},___]:=
  <||>;
SymbolDetermineType~SetAttributes~HoldFirst;


End[];



