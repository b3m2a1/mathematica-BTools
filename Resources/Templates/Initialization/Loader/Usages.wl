(* ::Package:: *)

(* ::Subsection:: *)
(*Usages*)


PackageAddUsage::usage="";


(* ::Subsubsection::Closed:: *)
(*Begin*)


Begin["`Paths`"]


(* ::Subsubsection::Closed:: *)
(*PackageAddUsage*)


PackageAddUsage[call:(s_Symbol[___]|s_Symbol), description_]:=
  Block[
    {
      Internal`$ContextMarks=False,
      name=SymbolName[Unevaluated[s]],
      baseString,
      initialUsage,
      usage
      },
    initialUsage=s::usage;
    Which[
      StringQ@initialUsage&&StringLength[initialUsage]>0&&
        !StringStartsQ[initialUsage, name],
      s::basicusage=initialUsage;
      initialUsage="",
      !StringQ@initialUsage,
      initialUsage=""
      ];
    initialUsage=StringTrim[initialUsage];
    baseString=ToString[Unevaluated[call], InputForm];
    baseString=StringReplace[baseString, "OptionsPattern[]"->"ops..."];
    usage=baseString<>" "<>description;
    If[StringLength@initialUsage>0,
      If[StringFreeQ[initialUsage, baseString],
        usage=initialUsage<>"\n"<>usage,
        usage=
          StringReplace[initialUsage, 
            Shortest[baseString~~__~~(StartOfLine~~name)]:>usage
            ]
        ]
      ];
    s::usage=usage
    ];
PackageAddUsage~SetAttributes~HoldFirst;


(* ::Subsubsection::Closed:: *)
(*End*)


End[]
