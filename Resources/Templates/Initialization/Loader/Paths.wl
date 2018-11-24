(* ::Package:: *)

(* ::Subsection:: *)
(*Paths*)


PackageFilePath::usage="";
PackageFEFile::usage="";


(* ::Subsubsection::Closed:: *)
(*Begin*)


Begin["`Paths`"]


(* ::Subsubsection::Closed:: *)
(*PackageFilePath*)


PackageFilePath[p__]:=
  FileNameJoin[Flatten@{
    $PackageDirectory,
    p
    }];


(* ::Subsubsection::Closed:: *)
(*PackageFEFile*)


PackageFEFile[p___,f_]:=
  FrontEnd`FileName[
    Evaluate@
    Flatten@{
      $PackageName,
      p
      },
    f
    ];


(* ::Subsubsection::Closed:: *)
(*PackagePathSymbol*)


PackagePathSymbol[parts___String,sym_String]:=
  ToExpression[StringRiffle[{$PackageName,parts,sym},"`"],StandardForm,HoldPattern];
PackagePathSymbol[parts___String,sym_Symbol]:=
  PackagePathSymbol[parts,Evaluate@SymbolName@Unevaluated[sym]];
PackagePathSymbol~SetAttributes~HoldRest;


(* ::Subsubsection::Closed:: *)
(*End*)


End[]
