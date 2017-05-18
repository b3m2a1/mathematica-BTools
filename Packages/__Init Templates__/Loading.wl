(* ::Package:: *)

(* ::Subsection:: *)
(*Loading*)


If[Not@ListQ@$DeclaredPackages,
	$DeclaredPackages=
		<||>
	];


If[Not@ListQ@$LoadedPackages,
	$LoadedPackages={}
	];


(* ::Subsubsection::Closed:: *)
(*fileContext*)


fileContextPath[f_String?DirectoryQ]:=
	FileNameSplit[FileNameDrop[f],FileNameDepth[$PackageDirectory]+1];
fileContextPath[f_String?FileExistsQ]:=
	fileContextPath[DirectoryName@f];


fileContext[f_String?DirectoryQ]:=
	With[{s=fileContextPath[f]},
		StringRiffle[Append[""]@Prepend[s,$Name],"`"]
		];


(* ::Subsubsection::Closed:: *)
(*packageExecute*)


packageExecute[expr_]:=
	(
		BeginPackage["$Name`"];
		$ContextPath=
			DeleteDuplicates[Join[$ContextPath,$Contexts]];
		(EndPackage[];#)&@CheckAbort[expr,EndPackage[]]
		);
packageExecute~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*pullDeclarations*)


pullDeclarations[pkgFile_]:=
	With[{f=OpenRead[pkgFile]},
		pkgFile->
		Cases[
			Reap[
				Do[
					Replace[ReadList[f,Hold[Expression],1],{
						{}->Return[EndOfFile],
						{Hold[_Begin|_BeginPackage|
							CompoundExpression[_Begin|_BeginPackage,___]]}:>
							Return[Begin],
						{e_}:>Sow[e]
						}],
					Infinity];
				Close@f;
				][[2,1]],
			s_Symbol?(
				Function[sym,
					Quiet[MemberQ[$Contexts,Context[sym]]],
					HoldFirst]):>
				HoldPattern[s],
			Infinity
			]
	];


(* ::Subsubsection::Closed:: *)
(*loadPackage*)


loadPackage[heldSym_,context_,pkgFile_->syms_]:=
	Block[{$loadingChain=
		If[ListQ@$loadingChain,$loadingChain,{}]
		},
		If[!MemberQ[$loadingChain,pkgFile],
			Replace[Thread[syms,HoldPattern],
				Verbatim[HoldPattern][{s__}]:>Clear[s]
				];
			appGet[context,pkgFile];
			AppendTo[$LoadedPackages,pkgFile];
			ReleaseHold[heldSym]
			]	
		];


(* ::Subsubsection::Closed:: *)
(*declarePackage*)


declarePackage[pkgFile_->syms_]:=
	With[{c=$Context},
		$DeclaredPackages[pkgFile]=syms;
		Map[
			If[True(*Not@MatchQ[Apply[OwnValues][#],{_:>_loadPackage}]*),
				#:=loadPackage[#,c,pkgFile->syms];
				Replace[#,
					Verbatim[HoldPattern][s_]:>(
						s/:HoldPattern[
							m:Except[
								Clear|ClearAll|OwnValues|
								HoldPattern|Hold|HoldComplete|
								Set|SetDelayed|
								RuleCondition|CompoundExpression
								][s,__]]:=
							RuleCondition[
								loadPackage[#,c,pkgFile->syms];
								m,
								True]	
						)]]&,
			syms
			]
		];


(* ::Subsubsection::Closed:: *)
(*loadDeclare*)


loadDeclare[pkgFile_String]:=
	If[!MemberQ[$LoadedPackages,pkgFile],
		If[!KeyMemberQ[$DeclaredPackages,pkgFile],
			declarePackage@pullDeclarations[pkgFile],
			ReleaseHold@First@$DeclaredPackages[pkgFile]
			],
		appGet[pkgFile]
		];


(* ::Subsubsection::Closed:: *)
(*appLoad*)


appLoad[dir_String?DirectoryQ]:=
	If[StringMatchQ[FileBaseName@dir,(WordCharacter|"$")..],
		Begin["`"<>FileBaseName[dir]<>"`"];
		AppendTo[$Contexts,$Context];
		appLoad[
			`$Packages[FileNameDrop[dir,FileNameDepth[$PackageDirectory]+1]]=
				Select[
					FileNames["*",dir],
					DirectoryQ@#||MatchQ[FileExtension[#],"m"|"wl"]&
					]
			];
		End[];
		];
appLoad[file_String?FileExistsQ]:=
	loadDeclare[file];
appLoad[]:=
	appLoad[
		`$Packages[$PackageName]=
			Select[
				FileNames["*",FileNameJoin@{$PackageDirectory,"Packages"}],
				DirectoryQ@#||MatchQ[FileExtension[#],"m"|"wl"]&
				]
			];
appLoad~SetAttributes~Listable;


(* ::Subsubsection::Closed:: *)
(*appGet*)


appGet[f_]:=
	packageExecute[
		feHiddenBlock[
			If[FileExistsQ@f,
				Get@f,
				Get@appPath[f<>".m"]
				]
			]
		];
appGet[c_,f_]:=
	packageExecute[
		Begin[c];
		(End[];#)&@
			feHiddenBlock[
				If[FileExistsQ@f,
					Get@f,
					Get@appPath[f<>".m"]
					]
				]
		];


(* ::Subsubsection::Closed:: *)
(*appNeeds*)


appNeeds[pkgFile_String?FileExistsQ]:=
	If[!MemberQ[$LoadedPackages,pkgFile],
		If[KeyMemberQ[$DeclaredPackages,pkgFile],
			loadDeclare[pkgFile],
			Do[loadDeclare[pkgFile],2]
			];
		];


appNeeds[pkg_String]:=
	If[FileExistsQ@appPath["Packages",pkg<>".m"],
		appNeeds[appPath["Packages",pkg<>".m"]],
		$Failed
		];
