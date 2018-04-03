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
	CompoundExpression[
		Block[{$ContextPath={"System`"}},
			BeginPackage["$Name`"];
			$ContextPath=
				DeleteDuplicates[
					Join[$ContextPath,$PackageContexts]
					];
			CheckAbort[
				With[{res=expr},
					EndPackage[];
					res
					],
				EndPackage[]
				]
			]
		];
PackageExecute~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackagePullDeclarations*)


PackagePullDeclarationsAction//Clear
PackagePullDeclarationsAction[
	Hold[
		_Begin|_BeginPackage|
			CompoundExpression[_Begin|_BeginPackage,___]
		]
	]:=
	Throw[Begin];
PackagePullDeclarationsAction[
	p:
		Hold[
			_PackageFEHiddenBlock|_PackageScopeBlock|
			CompoundExpression[
				_PackageFEHiddenBlock|_PackageScopeBlock,
				___]
			]
	]/;TrueQ[$AllowPackageRecoloring]:=
	(
		ReleaseHold[p];
		Sow[p];
		);
PackagePullDeclarationsAction[e:Except[Hold[Expression]]]:=
	Sow@e;


PackagePullDeclarations[pkgFile_]:=
	pkgFile->
		Cases[
				Reap[
					With[{f=OpenRead[pkgFile]},
						Catch@
							Do[
								If[
									Length[
										ReadList[
											f,
											PackagePullDeclarationsAction@Hold[Expression],
											1
											]
										]===0,
										Throw[EndOfFile]
									],
								Infinity
								];
						Close[f]
						]
				][[2,1]],
			s_Symbol?(
				Function[Null,
					Quiet[Context[#]===$Context],
					HoldAllComplete
					]
					):>
					HoldPattern[s],
			Infinity
			]


(* ::Subsubsection::Closed:: *)
(*PackageLoadPackage*)


PackageLoadPackage[heldSym_,context_,pkgFile_->syms_]:=
	Block[{
		$loadingChain=
			If[ListQ@$loadingChain,$loadingChain,{}],
		$inLoad=TrueQ[$inLoad],
		$ContextPath=$ContextPath
		},
		If[!MemberQ[$loadingChain,pkgFile],
			With[{$$inLoad=$inLoad},
				$inLoad=True;
				If[$AllowPackageRecoloring,
					Internal`SymbolList[False]
					];
				Replace[Thread[syms,HoldPattern],
					Verbatim[HoldPattern][{s__}]:>Clear[s]
					];
				If[Not@MemberQ[$ContextPath,context],
					$ContextPath=Prepend[$ContextPath,context];
					];
				Block[{PackageFEHiddenBlock=Null},
					PackageAppGet[context,pkgFile];
					];
				Unprotect[$LoadedPackages];
				AppendTo[$LoadedPackages,pkgFile];
				Protect[$LoadedPackages];
				If[!$$inLoad&&$AllowPackageRecoloring,
					Internal`SymbolList[True]
					];
				ReleaseHold[heldSym]
				]
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
				#:=PackageLoadPackage[#,c,pkgFile->syms]
				]&,
			syms
			]
		];


(* ::Subsubsection::Closed:: *)
(*PackageLoadDeclare*)


PackageLoadDeclare[pkgFile_String]:=
	If[!MemberQ[$LoadedPackages,pkgFile],
		If[!KeyMemberQ[$DeclaredPackages,pkgFile],
			PackageDeclarePackage@
				PackagePullDeclarations[pkgFile]
			],
		PackageAppGet[pkgFile]
		];


(* ::Subsubsection::Closed:: *)
(*PackageAppLoad*)


packageAppLoad[dir_, listing_]:=
	With[
		{
			fileNames=
				Select[
					FileNames["*", dir],
					DirectoryQ@#||MatchQ[FileExtension[#], "m"|"wl"]&
					]
			},
		Replace[
			Select[fileNames, 
				StringMatchQ[
					ToLowerCase@FileNameTake[#],
					"__pre__."~~("m"|"wl")
					]&
				],
			{f_}:>Get[f]
			];
		PackageAppLoad[
			$PackageListing[listing]=
				Select[fileNames, StringFreeQ["__"]@*FileBaseName]
			];
		Replace[
			Select[fileNames, 
				StringMatchQ[
					ToLowerCase@FileNameTake[#], 
					"__Post__."~~("m"|"wl")
					]&
				],
			{f_}:>Get[f]
			];
		];


PackageAppLoad[dir_String?DirectoryQ]:=
	If[StringMatchQ[FileBaseName@dir,(WordCharacter|"$")..],
		Begin["`"<>FileBaseName[dir]<>"`"];
		AppendTo[$PackageContexts, $Context];
		packageAppLoad[dir, FileNameDrop[dir,FileNameDepth[$PackageDirectory]+1]];
		End[];
		];
PackageAppLoad[file_String?FileExistsQ]:=
	PackageLoadDeclare[file];
PackageAppLoad[]:=
	PackageExecute@
		packageAppLoad[FileNameJoin@{$PackageDirectory,"Packages"}, $PackageName];
PackageAppLoad~SetAttributes~Listable;


(* ::Subsubsection::Closed:: *)
(*PackageAppGet*)


PackageAppGet[f_]:=
	PackageExecute@
		With[{fBase = 
			If[FileExistsQ@f,
				f,
				PackageFilePath["Packages",f<>".m"]
				]
			},
			With[{cont = 
				Most@
					FileNameSplit[
						FileNameDrop[fBase, FileNameDepth[PackageFilePath["Packages"]]]
						]},
				If[Length[cont]>0,
					Begin[StringRiffle[Append[""]@Prepend[""]@cont, "`"]];
					(End[];#)&@Get[fBase],
					Get[fBase]
				]
			]
		];
PackageAppGet[c_,f_]:=
	PackageExecute[
		Begin[c];
		(End[];#)&@
			If[FileExistsQ@f,
				Get@f;,
				Get@PackageFilePath["Packages",f<>".m"]
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


$PackageScopeBlockEvalExpr=TrueQ[$PackageScopeBlockEvalExpr];
PackageScopeBlock[
	e_,
	scope:_String?(StringFreeQ["`"]):"Package",
	context:_String?(StringEndsQ["`"]):"`PackageScope`"
	]/;TrueQ[$AllowPackageRescoping]:=
	With[{
		newcont=
			If[StringStartsQ[context, "`"],
				"$Name"<>context<>scope<>"`",
				context<>scope<>"`"
				],
		res=If[$PackageScopeBlockEvalExpr,e]
		},
		If[!MemberQ[$PackageContexts, newcont],
			Unprotect[$PackageContexts];
			AppendTo[$PackageContexts,newcont];
			];
		Replace[
			Thread[
				Cases[
					HoldComplete[e],
					sym_Symbol?(
						Function[Null,
							MemberQ[$PackageContexts,Quiet[Context[#]]],
							HoldAllComplete
							]
						):>
						HoldComplete[sym],
					\[Infinity]
					],
				HoldComplete
				],
			HoldComplete[{s__}]:>
				If[!$PackageDeclared&&ListQ@$PackageScopedSymbols,
					$PackageScopedSymbols=
						{
							$PackageScopedSymbols,
							newcont->
								HoldComplete[s]
							},
					Block[{$AllowPackageRecoloring=True},
						PackageFERehideSymbols[s]
						];
					Map[
						Function[Null,
							Quiet[
								Check[
									Set[Context[#], newcont],
									Remove[#],
									Context::cxdup
									],
								Context::cxdup
								],
							HoldAllComplete
							],
						HoldComplete[s]
						]//ReleaseHold;
					]
			];
		res
		];
PackageScopeBlock[e_, scope_String:"Package"]/;Not@TrueQ[$AllowPackageRescoping]:=
	If[$PackageScopeBlockEvalExpr,e];
PackageScopeBlock~SetAttributes~HoldFirst;


(* ::Subsubsection::Closed:: *)
(*PackageDecontext*)


PackageDecontext[
	pkgFile_String?(KeyMemberQ[$DeclaredPackages,#]&),
	scope:_String?(StringFreeQ["`"]):"Package",
	context:_String?(StringEndsQ["`"]):"`PackageScope`"
	]/;TrueQ[$AllowPackageRescoping]:=
	With[{
		names=$DeclaredPackages[pkgFile],
		ctx=
		 If[StringStartsQ[context, "`"],
			"$Name"<>context<>scope<>"`",
			context<>scope<>"`"
			]
		},
		Replace[names,
			Verbatim[HoldPattern][s_]:>
				Set[Context[s], ctx],
			1
			]
		];


(* ::Subsubsection::Closed:: *)
(*PackageRecontext*)


PackageRecontext[
	pkgFile_String?(KeyMemberQ[$DeclaredPackages,#]&)
	]/;TrueQ[$AllowPackageRescoping]:=
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
