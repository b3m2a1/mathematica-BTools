(* ::Package:: *)

(* ::Subsection:: *)
(*Loading*)


(* ::Subsubsection::Closed:: *)
(*Constants*)


If[Not@AssociationQ@$PackageFileContexts,
	$PackageFileContexts=
		<||>
	];


If[Not@AssociationQ@$DeclaredPackages,
	$DeclaredPackages=
		<||>
	];


If[Not@ListQ@$LoadedPackages,
	$LoadedPackages={}
	];


(* ::Subsubsection::Closed:: *)
(*PackageFileContext*)


PackageFileContextPath[f_String?DirectoryQ]:=
	FileNameSplit[FileNameDrop[f,FileNameDepth[$PackageDirectory]+1]];
PackageFileContextPath[f_String?FileExistsQ]:=
	PackageFileContextPath[DirectoryName@f];


PackageFileContext[f_String?DirectoryQ]:=
	With[{s=PackageFileContextPath[f]},
		StringRiffle[Append[""]@Prepend[s,$Name],"`"]
		];
PackageFileContext[f_String?FileExistsQ]:=
	PackageFileContext[DirectoryName[f]];


(* ::Subsubsection::Closed:: *)
(*PackageExecute*)


PackageExecute[expr_]:=
	(
		BeginPackage["$Name`"];
		$ContextPath=
			DeleteDuplicates[Join[$ContextPath,$PackageContexts]];
		(EndPackage[];#)&@CheckAbort[expr,EndPackage[]]
		);
PackageExecute~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackagePullDeclarations*)


PackagePullDeclarations[pkgFile_]:=
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
							{p:Hold[_PackageFEHiddenBlock|_PackageScopeBlock]}:>
								(ReleaseHold[p];Sow[p]),
							{e_}:>Sow[e]
							}],
						Infinity
						];
					Close@f;
					][[2,1]],
				s_Symbol?(
					Function[sym,
						Quiet[StringContainsQ[Context[sym],StartOfString~~"$Name`"]],
						HoldFirst]):>
					HoldPattern[s],
				Infinity
				]
	];


(* ::Subsubsection::Closed:: *)
(*PackageLoadPackage*)


PackageLoadPackage[heldSym_,context_,pkgFile_->syms_]:=
	Block[{$loadingChain=
		If[ListQ@$loadingChain,$loadingChain,{}]
		},
		If[!MemberQ[$loadingChain,pkgFile],
			Replace[Thread[syms,HoldPattern],
				Verbatim[HoldPattern][{s__}]:>Clear[s]
				];
			If[Not@MemberQ[$ContextPath,context],
				$ContextPath=Prepend[$ContextPath,context];
				FrontEnd`Private`GetUpdatedSymbolContexts[]
				];
			PackageAppGet[context,pkgFile];
			Unprotect[$LoadedPackages];
			AppendTo[$LoadedPackages,pkgFile];
			Protect[$LoadedPackages];
			ReleaseHold[heldSym]
			]	
		];


(* ::Subsubsection::Closed:: *)
(*PackageDeclarePackage*)


PackageDeclarePackage[pkgFile_->syms_]:=
	With[{c=$Context},
		$DeclaredPackages[pkgFile]=syms;
		$PackageFileContexts[pkgFile]=c;
		Map[
			If[True,
				#:=PackageFEHiddenBlock[PackageLoadPackage[#,c,pkgFile->syms]]
				]&,
			syms
			]
		];


(* ::Subsubsection::Closed:: *)
(*PackageLoadDeclare*)


PackageLoadDeclare[pkgFile_String]:=
	If[!MemberQ[$LoadedPackages,pkgFile],
		PackageFEHiddenBlock[
			If[!KeyMemberQ[$DeclaredPackages,pkgFile],
				PackageDeclarePackage@PackagePullDeclarations[pkgFile]
				]
			],
		PackageAppGet[pkgFile]
		];


(* ::Subsubsection::Closed:: *)
(*PackageAppLoad*)


PackageAppLoad[dir_String?DirectoryQ]:=
	If[StringMatchQ[FileBaseName@dir,(WordCharacter|"$")..],
		Begin["`"<>FileBaseName[dir]<>"`"];
		AppendTo[$PackageContexts,$Context];
		PackageAppLoad[
			$PackageListing[FileNameDrop[dir,FileNameDepth[$PackageDirectory]+1]]=
				Select[
					FileNames["*",dir],
					DirectoryQ@#||MatchQ[FileExtension[#],"m"|"wl"]&
					]
			];
		End[];
		];
PackageAppLoad[file_String?FileExistsQ]:=
	PackageLoadDeclare[file];
PackageAppLoad[]:=
	PackageExecute@
	PackageAppLoad[
		$PackageListing[$PackageName]=
			Select[
				FileNames["*",FileNameJoin@{$PackageDirectory,"Packages"}],
				DirectoryQ@#||MatchQ[FileExtension[#],"m"|"wl"]&
				]
			];
PackageAppLoad~SetAttributes~Listable;


(* ::Subsubsection::Closed:: *)
(*PackageAppGet*)


PackageAppGet[f_]:=
	PackageExecute[
		PackageFEHiddenBlock[
			If[FileExistsQ@f,
				Get@f,
				Get@PackageFilePath["Packages",f<>".m"]
				]
			]
		];
PackageAppGet[c_,f_]:=
	PackageExecute[
		Begin[c];
		(End[];#)&@
			PackageFEHiddenBlock[
				If[FileExistsQ@f,
					Get@f,
					Get@PackageFilePath["Packages",f<>".m"]
					]
				]
		];


(* ::Subsubsection::Closed:: *)
(*PackageAppNeeds*)


PackageAppNeeds[pkgFile_String?FileExistsQ]:=
	If[!MemberQ[$LoadedPackages,pkgFile],
		If[KeyMemberQ[$DeclaredPackages,pkgFile],
			PackageLoadDeclare[pkgFile],
			Do[PackageLoadDeclare[pkgFile],2]
			];
		];


PackageAppNeeds[pkg_String]:=
	If[FileExistsQ@PackageFilePath["Packages",pkg<>".m"],
		PackageAppNeeds[PackageFilePath["Packages",pkg<>".m"]],
		$Failed
		];


(* ::Subsubsection:: *)
(*PackageScopeBlock*)


PackageScopeBlock[e_,scope_String:"Hidden"]:=
	With[{s="$Name`Private`"<>StringTrim[scope,"`"]<>"`"},
		If[!MemberQ[$PackageContexts,s],AppendTo[$PackageContexts,s]];
		Cases[
			HoldComplete[e],
			sym_Symbol?(
				Function[Null,
					MemberQ[$PackageContexts,Quiet[Context[#]]],
					HoldAllComplete
					]
				):>
				RuleCondition[Set[Context[sym],s],True],
			\[Infinity],
			Heads->True
			];
		e
		];
PackageScopeBlock~SetAttributes~HoldAllComplete;


(* ::Subsubsection::Closed:: *)
(*PackageDecontext*)


PackageDecontext[
	pkgFile_String?(KeyMemberQ[$DeclaredPackages,#]&),
	scope_String:"Hidden"
	]:=
	With[{
		names=$DeclaredPackages[pkgFile],
		ctx="$Name`Private`"<>StringTrim[scope,"`"]<>"`"
		},
		Replace[names,
			Verbatim[HoldPattern][s_]:>
				Set[Context[s],ctx],
			1
			]
		];


(* ::Subsubsection::Closed:: *)
(*PackageRecontext*)


PackageRecontext[pkgFile_String?(KeyMemberQ[$DeclaredPackages,#]&)]:=
	With[{
		names=$DeclaredPackages[pkgFile],
		ctx=PackageFileContext[pkgFile]
		},
		Replace[names,
			Verbatim[HoldPattern][s_]:>
				Set[Context[s],ctx],
			1
			]
		];
