(* ::Package:: *)



(* ::Subsubsection::Closed:: *)
(*Package Scope*)



PackageScopeBlock[
	(*  Options *)
	$EncodedCacheDefaultOptions::usage="";
	EncodedCacheOption::usage="";
	EncodedCacheOptionsFile::usage="";
	EncodedCacheOptionsLoad::usage="";
	EncodedCacheOptionsExport::usage="";
	(*  Passwords *)
	EncodedCachePassword::usage="";
	EncodedCachePasswordDialog::usage="";
	EncodedCachePasswordFile::usage="";
	EncodedCachePasswordLoad::usage="";
	EncodedCachePasswordExport::usage="";
	$EncodedCachePasswords::usage="";
	(* Functions *)
	EncodedCacheLoaded::usage="";
	EncodedCacheFile::usage="";
	EncodedCacheExport::usage="";
	(* Symbols *)
	MakeEncodedCacheSymbol::usage="",
	"Package",
	$Context
	]


(* ::Subsubsection::Closed:: *)
(*EncodedCache*)



EncodedCache::usage=
	"An object representing an encoded Association";
EncodedCacheLoad::usage=
	"Loads an EncodedCache from a directory";


(* ::Subsubsection::Closed:: *)
(*$EncodedCache*)



$EncodedCache::usage=
	"An interface object for the default cache";
$EncodedCacheSettings::usage=
	"An interface object for the options of the default cache";
$EncodedCachePassword::usage=
	"An interface object for the password of the default cache";
$EncodedCacheDirectory::usage=
	"A settable directory to change where the $EncodedCache loads from";


Begin["`Private`"];


(* ::Subsection:: *)
(*Options*)



(* ::Subsubsection::Closed:: *)
(*Base*)



$EncodedCacheDefaultOptions=
	<|
		"SaveOptionsToDisk"->
			True,
		"UsePassword"->
			True,
		"StorePasswordInMemory"->
			True,
		"SavePasswordToDisk"->
			False,
		"StoreInMemory"->
			True,
		"SaveToDisk"->
			True,
		"Persistent"->
			True,
		"SyncBase"->
			FileName[{
				$HomeDirectory,
				"Dropbox"
				}],
		"PersistenceBase"->
			FileName[{
				$UserBaseDirectory,
				"ApplicationData",
				"EncodedCache"
				}],
		"TemporaryBase"->
			FileName[{
				$TemporaryDirectory,
				"EncodedCache"
				}],
		"CacheName"->
			"Cache"
		|>;


If[!AssociationQ@$EncodedCacheOptions,
	$EncodedCacheOptions=<||>
	];


(* ::Subsubsection::Closed:: *)
(*Lookup*)



EncodedCacheOption[spec_?StringQ,option_]:=
	Lookup[
		Lookup[$EncodedCacheOptions,
			spec,
			Lookup[$EncodedCacheOptions,
				"Default",
				$EncodedCacheOptions["Default"]=$EncodedCacheDefaultOptions
				]
			],
		option,
		Lookup[$EncodedCacheOptions["Default"],option]
		];


(* ::Subsubsection::Closed:: *)
(*Set / Unset*)



EncodedCacheOption/:
	Set[EncodedCacheOption[spec_?StringQ],value_]:=
		(
			$EncodedCacheOptions[spec]=value;
			If[EncodedCacheOption[spec,"SaveOptionsToDisk"],
				EncodedCacheOptionsExport[spec]
				];
			value
			);
EncodedCacheOption/:
	SetDelayed[EncodedCacheOption[spec_?StringQ],value_]:=
		(
			$EncodedCacheOptions[spec]:=value;
			If[EncodedCacheOption[spec,"SaveOptionsToDisk"],
				EncodedCacheOptionsExport[spec]
				];
			value
			);
EncodedCacheOption/:
	Unset[EncodedCacheOption[spec_?StringQ]]:=(
		$EncodedCacheOptions[spec]=.;
		If[EncodedCacheOption[spec,"SaveOptionsToDisk"],
			EncodedCacheOptionsExport[spec]
			];
		);
EncodedCacheOption/:
	Set[EncodedCacheOption[spec_?StringQ, option_],value_]:=
		(
			If[!KeyMemberQ[$EncodedCacheOptions,spec],
				$EncodedCacheOptions[spec]=<||>
				];
			If[value===Inherited,
				$EncodedCacheOptions[spec,option]=.,
				$EncodedCacheOptions[spec,option]=value
				];
			If[EncodedCacheOption[spec,"SaveOptionsToDisk"],
				EncodedCacheOptionsExport[spec]
				];
			value
			);
EncodedCacheOption/:
	SetDelayed[EncodedCacheOption[spec_?StringQ,option_],value_]:=
		(
			If[!KeyMemberQ[$EncodedCacheOptions,spec],
				$EncodedCacheOptions[spec]=<||>
				];
			If[value===Inherited,
				$EncodedCacheOptions[spec,option]=.,
				$EncodedCacheOptions[spec,option]:=value
				];
			If[EncodedCacheOption[spec,"SaveOptionsToDisk"],
				EncodedCacheOptionsExport[spec]
				];
			value
			);


(* ::Subsubsection::Closed:: *)
(*Load / Export*)



EncodedCacheOptionsFile[spec_?StringQ]:=
	FileNameJoin@Flatten@
		Replace[
			{
				If[EncodedCacheOption[spec,"Persistent"],
					EncodedCacheOption[spec,"PersistenceBase"],
					EncodedCacheOption[spec,"TemporaryBase"]
					],
				spec,
				spec<>".m"
				},
			FileName[f_]:>f,
			1
			];
EncodedCacheOptionsLoad[file_?FileExistsQ]:=
	Replace[
		Quiet@
			Import@
				If[DirectoryQ@file,
					FileNameJoin@{file,FileBaseName[file]<>".m"},
					file
					],
		a_Association:>
			(
				$EncodedCacheOptions[FileBaseName@file]=a
				)
		];
EncodedCacheOptionsLoad[spec_?StringQ]:=
	Replace[
		Import@EncodedCacheOptionsFile[spec],
		a_Association:>
			(
				$EncodedCacheOptions[spec]=
					Join[
						Lookup[$EncodedCacheOptions,spec,<||>],
						a
						]
				)
		];


EncodedCacheOptionsExport[spec_?StringQ]:=
	(
		Quiet@
			CreateDirectory[
				DirectoryName@
					EncodedCacheOptionsFile[spec],
				CreateIntermediateDirectories->True
				];
		Export[
			EncodedCacheOptionsFile[spec],
			$EncodedCacheOptions[spec]
			]
		)


(* ::Subsection:: *)
(*Password*)



(* ::Subsubsection::Closed:: *)
(*Base*)



If[!AssociationQ@$EncodedCachePasswords,
	$EncodedCachePasswords=
		<|
			|>
	];


(* ::Subsubsection::Closed:: *)
(*Lookup*)



EncodedCachePasswordDialog[spec_]:=
	(Clear@$encodedCacheTemporary;#)&@
		PasswordDialog[
			Dynamic[$encodedCacheTemporary],
			"Encoded Cache",
			spec
			];


EncodedCachePassword[spec_?StringQ]:=
	If[EncodedCacheOption[spec,"StorePasswordInMemory"]//TrueQ,
		Replace[$EncodedCachePasswords[spec],{
			e:Except[_String?(StringLength@#>0&)]:>
				If[EncodedCacheOption[spec,"UsePassword"],
					Replace[
						If[FileExistsQ@EncodedCachePasswordFile[spec],
							EncodedCachePasswordLoad[spec],
							None
							],
						Except[_String?(StringLength@#>0&)]:>
							Replace[EncodedCachePasswordDialog[spec],
								{
									s_String?(StringLength@#>0&):>
										(EncodedCachePassword[spec]=s),
									_->None
									}]
						],
					None
					]
			}],
		$EncodedCachePasswords[spec]=.;
		Replace[
			If[FileExistsQ@EncodedCachePasswordFile[spec],
				EncodedCachePasswordLoad[spec],
				None
				],
			Except[_String?(StringLength@#>0&)]:>
				Replace[EncodedCachePasswordDialog[spec],{
					s_String?(StringLength@#>0&):>
						s,
					_->None
					}]
			]
		];


(* ::Subsubsection::Closed:: *)
(*Set / Unset*)



EncodedCachePassword/:
	Set[EncodedCachePassword[spec_?StringQ],pwd_]:=(
		$EncodedCachePasswords[spec]=pwd;
		If[EncodedCacheOption[spec,"SavePasswordToDisk"],
			EncodedCachePasswordExport[spec]
			];
		If[!EncodedCacheOption[spec,"StorePasswordInMemory"],
			EncodedCachePassword[spec]=.
			];
		pwd
		);


EncodedCachePassword/:
	SetDelayed[EncodedCachePassword[spec_?StringQ],pwd_]:=(
		$EncodedCachePasswords[spec]:=pwd;
		If[EncodedCacheOption[spec,"SavePasswordToDisk"],
			EncodedCachePasswordExport[spec]
			];
		If[!EncodedCacheOption[spec,"StorePasswordInMemory"],
			EncodedCachePassword[spec]=.
			];
		pwd
		);


EncodedCachePassword/:
	Unset[EncodedCachePassword[spec_?StringQ]]:=(
		If[
			EncodedCacheOption[spec,"StorePasswordInMemory"]&&
				EncodedCacheOption[spec,"SavePasswordToDisk"],
			DeleteFile@EncodedCachePasswordFile[spec];
			];
		$EncodedCachePasswords[spec]=.;
		);


(* ::Subsubsection::Closed:: *)
(*Load / Export*)



EncodedCachePasswordFile[spec_?StringQ]:=
	FileNameJoin@Flatten@
		Replace[
			{
				If[EncodedCacheOption[spec,"Persistent"],
					EncodedCacheOption[spec,"PersistenceBase"],
					EncodedCacheOption[spec,"TemporaryBase"]
					],
				spec,
				"Password"<>".mx"
				},
			FileName[d_]:>d,
			1];
EncodedCachePasswordLoad[spec_?StringQ]:=
	If[FileExistsQ@EncodedCachePasswordFile[spec],
		With[{pwd=
			Replace[Get@EncodedCachePasswordFile[spec],
				Except[_String]->None
				]
			},
			If[StringQ@pwd&&StringLength@pwd>0,
				If[EncodedCacheOption[spec,"StorePasswordInMemory"],
					$EncodedCachePasswords[spec]=pwd
					];
				pwd,
				None
				]
			],
		None
		];
EncodedCachePasswordExport[spec_?StringQ]:=
	With[{
		file=EncodedCachePasswordFile[spec],
		temp=FileNameJoin@{$TemporaryDirectory,RandomSample[Alphabet[],10]<>".m"}
		},
		Export[
			temp,
			EncodedCachePassword[spec]
			];
		Quiet@
			CreateDirectory[
				DirectoryName@file,
				CreateIntermediateDirectories->True
				];
		Encode[temp,file];
		DeleteFile@temp;
		file
		]


(* ::Subsection:: *)
(*Cache*)



(* ::Subsubsection::Closed:: *)
(*Bases*)



If[!AssociationQ@$EncodedCaches,
	$EncodedCaches=
		<|
			|>
	];


(* ::Subsubsection::Closed:: *)
(*Export / Load*)



EncodedCacheLoaded[spec_?StringQ]:=
	KeyMemberQ[$EncodedCaches,spec];
EncodedCacheLoaded[EncodedCache[spec_?StringQ]]:=
	KeyMemberQ[$EncodedCaches,spec];


EncodedCacheFile[spec_?StringQ]:=
	FileNameJoin@Flatten@
		Replace[
			{
				If[EncodedCacheOption[spec,"Persistent"],
					EncodedCacheOption[spec,"PersistenceBase"],
					EncodedCacheOption[spec,"TemporaryBase"]
					],
				spec,
				EncodedCacheOption[spec,"CacheName"]<>".mx"
				},
			FileName[d_]:>d,
			1];
EncodedCacheFiles[pat_:"*"]:=
	FileNames[
		pat,
		{
			EncodedCacheOption["Default", "PersistenceBase"],
			EncodedCacheOption["Default", "TemporaryBase"],
			EncodedCacheOption["Default", "SyncBase"]
			}
		]


EncodedCacheExport[
 (spec_?StringQ)?(KeyMemberQ[$EncodedCaches,#]&),
 val:_?AssociationQ|Automatic:Automatic
 ]:=
	With[{
		file=EncodedCacheFile[spec],
		temp=FileNameJoin@{$TemporaryDirectory,RandomSample[Alphabet[],10]<>".m"}
		},
		Export[
			temp,
			Replace[val, Automatic:>$EncodedCaches[spec]]
			];
		Quiet@
			CreateDirectory[
				DirectoryName@file,
				CreateIntermediateDirectories->True
				];
		If[TrueQ@EncodedCacheOption[spec,"UsePassword"],
			Encode[temp,
				file,
				EncodedCachePassword[spec]
				],
			Encode[temp, file]
			];
		DeleteFile@temp;
		file
		];


EncodedCacheLoad[(spec_?StringQ)?(KeyMemberQ[$EncodedCacheOptions,#]&)]:=
	With[{a=
		With[{file=EncodedCacheFile[spec]},
			If[FileExistsQ@file,
				If[EncodedCacheOption[spec, "UsePassword"]//TrueQ,
					Replace[
						Nest[
							If[!AssociationQ@#,
								Quiet[
									Check[
										Get[file, EncodedCachePassword[spec]],
										EncodedCachePassword[spec]=.,
										Get::enkey
										],
									Get::enkey
									],
								#
								]&,
							None,
							3
							],
						$Failed:>
							<||>
						],
					Get[file]
					],
				<||>
				]
			]
		},
		If[AssociationQ@a,
			If[TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
				$EncodedCaches[spec]=a,
				a
				],
			a
			]
		];
EncodedCacheLoad[d_String?(Not@*DirectoryQ)]:=
	With[{f=
		FileNameJoin@Flatten@
			Replace[
				{
					If[EncodedCacheOption[d,"Persistent"],
						EncodedCacheOption[d,"PersistenceBase"],
						EncodedCacheOption[d,"TemporaryBase"]
						],
					d
					},
				FileName[s_]:>s,
				1]
		},
		If[FileExistsQ@f,
			EncodedCacheLoad[f],
			<||>
			]
		];
EncodedCacheLoad[d_String?DirectoryQ]:=
	(
		If[FileExistsQ@FileNameJoin@{d,FileBaseName@d<>".m"},
			EncodedCacheOptionsLoad[FileNameJoin@{d,FileBaseName@d<>".m"}],
			$EncodedCacheOptions[FileBaseName@d]=
				<|
					"Persistent"->True,
					"PersistenceBase"->DirectoryName@d
					|>
			];
		Replace[EncodedCacheLoad[FileBaseName@d],
			e:Except[_Association]:>
				($EncodedCacheOptions[FileBaseName@d]=.;e)
			]
		);


(* ::Subsubsection::Closed:: *)
(*Destructuring Interface*)



EncodedCache/:
	Key[EncodedCache[spec_?StringQ]]:=
		spec;


(* ::Subsubsection::Closed:: *)
(*Lookup Interface*)



EncodedCache[spec_?StringQ][keys__]:=
	If[TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
		(
			If[!EncodedCacheLoaded[spec],
				EncodedCacheLoad[spec];
				];
		Lookup[
			Lookup[
				$EncodedCaches,
				spec,
				<||>],
			keys
			]
		),
		EncodedCacheLoad[spec][keys]
		];
EncodedCache[spec_?StringQ,"Options"][op_]:=
	(	
		If[!EncodedCacheLoaded[spec],
			EncodedCacheLoad[spec]
			];
		EncodedCacheOption[spec,op]
		);
EncodedCache[spec_?StringQ,"Password"]:=
	(
		If[!EncodedCacheLoaded[spec],
			EncodedCacheLoad[spec]
			];
		EncodedCachePassword[spec]
		);


(* ::Subsubsection::Closed:: *)
(*Set / Unset Interface*)



EncodedCache/:
	Set[EncodedCache[spec_?StringQ,"Options"][op_],value_]:=
		EncodedCacheOption[spec,op]=value;
EncodedCache/:
	Unset[EncodedCache[spec_?StringQ,"Options"][op_]]:=
		EncodedCacheOption[spec,op]=.;


EncodedCache/:
	Set[EncodedCache[spec_?StringQ,"Password"],value_]:=
		EncodedCachePassword[spec]=value;
EncodedCache/:
	Unset[EncodedCache[spec_?StringQ,"Password"]]:=
		EncodedCachePassword[spec]=.;


EncodedCache/:
	Set[EncodedCache[spec_?StringQ],a_Association]:=
	(
		If[TrueQ@EncodedCacheOption[spec,"SaveToDisk"],
			$EncodedCaches[spec]=a;
			EncodedCacheExport[spec];
			If[!TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
				$EncodedCaches[spec]=.
				],
			If[TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
				$EncodedCaches[spec]=a
				]
			];
		a
		);
EncodedCache/:
	Unset[EncodedCache[spec_?StringQ]]:=
	(
		If[TrueQ@EncodedCacheOption[spec,"SaveToDisk"],
			$EncodedCaches[spec]=.;
			$EncodedCacheOptions[spec]=.;
			$EncodedCachePasswords[spec]=.;
			Quiet@
				DeleteDirectory[DirectoryName@EncodedCacheFile[spec],
					DeleteContents->True
					];,
			$EncodedCaches[spec]=.;
			$EncodedCacheOptions[spec]=.;
			$EncodedCachePasswords[spec]=.;
			];
		);


EncodedCache/:
	Set[EncodedCache[spec_?StringQ][keys__],value_]:=
	(
		If[TrueQ@EncodedCacheOption[spec,"SaveToDisk"],
			If[!TrueQ@EncodedCacheOption[spec,"StoreInMemory"]||
					!KeyMemberQ[$EncodedCaches,spec],
				Replace[EncodedCacheLoad[spec],
					a_Association:>
						($EncodedCaches[spec]=a)
					]
				];
			$EncodedCaches[spec,keys]=value;
			EncodedCacheExport[spec];
			If[!TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
				$EncodedCaches[spec]=.
				],
			If[TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
				$EncodedCaches[spec,keys]=value
				]
			];
		value
		);


EncodedCache/:
	SetDelayed[EncodedCache[spec_?StringQ][keys__],value_]:=
	If[TrueQ@EncodedCacheOption[spec,"SaveToDisk"],
		If[!TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
				Replace[EncodedCacheLoad[spec],
					a_Association:>
						($EncodedCaches[spec]=a)
					]
			];
		$EncodedCaches[spec][keys]:=value;
		EncodedCacheExport[spec];
		If[!TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
			$EncodedCaches[spec]=.
			];,
		If[TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
			$EncodedCaches[spec][keys]:=value
			];
		];


EncodedCache/:
	Unset[EncodedCache[spec_?StringQ][keys__]]:=
	If[TrueQ@EncodedCacheOption[spec,"SaveToDisk"],
		If[!TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
				Replace[EncodedCacheLoad[spec],
					a_Association:>
						($EncodedCaches[spec]=a)
					]
			];
		$EncodedCaches[spec][keys]=.;
		EncodedCacheExport[spec];
		If[!TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
			$EncodedCaches[spec]=.
			];,
		If[TrueQ@EncodedCacheOption[spec,"StoreInMemory"],
			$EncodedCaches[spec][keys]=.
			];
		];


(* ::Subsubsection::Closed:: *)
(*Mutation Handler*)



validEncodedCacheQ[EncodedCache[spec_?StringQ]]:=
	True;
validEncodedCacheQ[s_Symbol]:=
	MatchQ[OwnValues[s], 
		{_:>_EncodedCache?validEncodedCacheQ}
		];
validEncodedCacheQ[_]:=
	False;


ClearAll[EncodedCacheMutationHandler];
EncodedCacheMutationHandler~SetAttributes~HoldAllComplete


(* ::Subsubsubsection::Closed:: *)
(*Basic*)



EncodedCacheMutationHandler[
	Set[
		(symbol_Symbol?validEncodedCacheQ)[attr_],
		val_
		]
	]:=
	Set[Evaluate@symbol[attr], val];
EncodedCacheMutationHandler[
	SetDelayed[
		(symbol_Symbol?validEncodedCacheQ)[attr_],
		val_
		]
	]:=
	SetDelayed[Evaluate@symbol[attr], val];
EncodedCacheMutationHandler[
	Unset[
		(symbol_Symbol?validEncodedCacheQ)[attr_]
		]
	]:=
	Unset[Evaluate@symbol[attr]];


(* ::Subsubsubsection::Closed:: *)
(*Password*)



EncodedCacheMutationHandler[
	Set[
		(symbol_Symbol?validEncodedCacheQ)[attr_, "Password"],
		val_
		]
	]:=
	Set[Evaluate@symbol[attr, "Password"], val];
EncodedCacheMutationHandler[
	SetDelayed[
		(symbol_Symbol?validEncodedCacheQ)[attr_, "Password"],
		val_
		]
	]:=
	SetDelayed[Evaluate@symbol[attr, "Password"], val];
EncodedCacheMutationHandler[
	Unset[
		(symbol_Symbol?validEncodedCacheQ)[attr_, "Password"]
		]
	]:=
	Unset[Evaluate@symbol[attr, "Password"]];


(* ::Subsubsubsection::Closed:: *)
(*Options*)



EncodedCacheMutationHandler[
	Set[
		(symbol_Symbol?validEncodedCacheQ)[attr_, "Options"],
		val_
		]
	]:=
	Set[Evaluate@symbol[attr, "Options"], val];
EncodedCacheMutationHandler[
	SetDelayed[
		(symbol_Symbol?validEncodedCacheQ)[attr_, "Options"],
		val_
		]
	]:=
	SetDelayed[Evaluate@symbol[attr, "Options"], val];
EncodedCacheMutationHandler[
	Unset[
		(symbol_Symbol?validEncodedCacheQ)[attr_, "Options"]
		]
	]:=
	Unset[Evaluate@symbol[attr, "Options"]];


EncodedCacheMutationHandler[
	Set[
		Options[
			symbol:(_Symbol|_EncodedCache)?validEncodedCacheQ
			],
		val_
		]
	]:=
	With[{k=Key@symbol},
		Set[EncodedCacheOption[k], val]
		];
EncodedCacheMutationHandler[
	SetDelayed[
		Options[
			symbol:(_Symbol|_EncodedCache)?validEncodedCacheQ
			],
		val_
		]
	]:=
	With[{k=Key@symbol},
		SetDelayed[EncodedCacheOption[k], val]
		];
EncodedCacheMutationHandler[
	Unset[
		Options[
			symbol:(_Symbol|_EncodedCache)?validEncodedCacheQ
			]
		]
	]:=
	With[{k=Key@symbol},
		Unset[EncodedCacheOption[k]]
		];


EncodedCacheMutationHandler[
	Set[
		Options[
			symbol:(_Symbol|_EncodedCache)?validEncodedCacheQ,
			opt_
			],
		val_
		]
	]:=
	With[{k=Key@symbol},
		Set[EncodedCacheOption[k, opt], val]
		];
EncodedCacheMutationHandler[
	SetDelayed[
		Options[
			symbol:(_Symbol|_EncodedCache)?validEncodedCacheQ,
			opt_
			],
		val_
		]
	]:=
	With[{k=Key@symbol},
		SetDelayed[EncodedCacheOption[k, opt], val]
		];
EncodedCacheMutationHandler[
	Unset[
		Options[
			symbol:(_Symbol|_EncodedCache)?validEncodedCacheQ,
			opt_
			]
		]
	]:=
	With[{k=Key@symbol},
		Unset[EncodedCacheOption[k, opt]]
		];


(* ::Subsubsubsection::Closed:: *)
(*SetMutationHandler*)



EncodedCacheMutationHandler[___]:=
	Language`MutationFallthrough


Language`SetMutationHandler[EncodedCache, EncodedCacheMutationHandler]


(* ::Subsubsection::Closed:: *)
(*File / Delete Interface*)



EncodedCache/:
	File[EncodedCache[spec_?StringQ]]:=
		EncodedCacheFile[spec];
EncodedCache/:
	DeleteFile[EncodedCache[spec_?StringQ]]:=
		DeleteFile@EncodedCacheFile[spec];
EncodedCache/:
	Export[c:EncodedCache[spec_?StringQ], val:_?AssociationQ|Automatic:Automatic]:=
		EncodedCacheExport[c, val]


(* ::Subsection:: *)
(*Symbol*)



(* ::Subsubsection::Closed:: *)
(*MakeEncodedCacheSymbol*)



Options[MakeEncodedCacheSymbol]=
	{
		"Key"->Automatic,
		"Directory"->Automatic,
		"Settings"->{}
		};


iMakeEncodedCacheSymbol[
	symName_String, 
	key:_String|Automatic,
	dir:_String?DirectoryQ|Automatic,
	settings_?OptionQ
	]:=
	Catch@
		With[
			{
				sym=Check[Symbol[symName], Throw[$Failed]],
				keySym=
					Symbol@Evaluate@
						If[StringContainsQ[symName, "`"],
							symName<>"`Key",
							"`"<>symName<>"`Key"
							],
				dirSym=
					Symbol@Evaluate@
						If[StringContainsQ[symName, "`"],
							symName<>"`Directory",
							"`"<>symName<>"`Directory"
							],
				settingsSym=
					Symbol@Evaluate@
						If[StringContainsQ[symName, "`"],
							symName<>"`Options",
							"`"<>symName<>"`Options"
							]
				},
			If[key===Automatic,
				If[!ValueQ[keySym], keySym=symName],
				keySym=key
				];
			dirSym=dir;
			HoldPattern[sym[k__]]:=
				EncodedCache[keySym][k];
			sym/:
				Set[sym[k__],v_]:=
					Set[EncodedCache[keySym][k],v];
			sym/:
				SetDelayed[sym[k__],v_]:=
					SetDelayed[EncodedCache[keySym][k],v];
			sym/:
				Unset[sym[k__]]:=
					Unset[EncodedCache[keySym][k]];
			sym/:
				File@sym:=
					EncodedCacheFile[keySym];
			sym/:
				DeleteFile[sym]:=
					DeleteFile@File@sym;
			sym/:
				Set[sym,a_Association]:=
					Set[EncodedCache[keySym],a];
			sym/:
				Unset[sym,a_Association]:=
					Unset[EncodedCache[keySym]];
			(*
			Make settings symbol
			*)
			settingsSym[k__]:=
				EncodedCache[keySym, "Options"][k];
			settingsSym/:
				Set[settingsSym[k__],v_]:=
					Set[EncodedCache[keySym, "Options"][k],v];
			settingsSym/:
				Unset[settingsSym[k__]]:=
					Unset[EncodedCache[keySym, "Options"][k]];
			settingsSym/:
				File@settingsSym:=
					EncodedCacheOptionsFile[keySym];
			settingsSym/:
				DeleteFile@settingsSym:=
					DeleteFile@File@settingsSym;
			]


(* ::Subsection:: *)
(*Default*)



If[!ValueQ@$EncodedCacheDefaultKey,
	$EncodedCacheDefaultKey:=
		(
			$EncodedCacheDirectory=Automatic;
			$EncodedCacheDefaultKey="Default"
			)
	];
If[!ValueQ@$EncodedCacheDirectory,
	$EncodedCacheDirectory:=
		(
			$EncodedCacheDefaultKey="Default";
			$EncodedCacheDirectory=Automatic
			)
	];


(* ::Subsubsection::Closed:: *)
(*$EncodedCache*)



HoldPattern[$EncodedCache[k__]]:=
	EncodedCache[$EncodedCacheDefaultKey][k];
$EncodedCache/:
	Set[$EncodedCache[k__],v_]:=
		Set[EncodedCache[$EncodedCacheDefaultKey][k],v];
$EncodedCache/:
	SetDelayed[$EncodedCache[k__],v_]:=
		SetDelayed[EncodedCache[$EncodedCacheDefaultKey][k],v];
$EncodedCache/:
	Unset[$EncodedCache[k__]]:=
		Unset[EncodedCache[$EncodedCacheDefaultKey][k]];


$EncodedCache/:
	File@$EncodedCache:=
		EncodedCacheFile[$EncodedCacheDefaultKey];
$EncodedCache/:
	DeleteFile[$EncodedCache]:=
		DeleteFile@File@$EncodedCache;


$EncodedCache/:
	Set[$EncodedCache,a_Association]:=
		Set[EncodedCache[$EncodedCacheDefaultKey],a];
$EncodedCache/:
	Unset[$EncodedCache,a_Association]:=
		Unset[EncodedCache[$EncodedCacheDefaultKey]];


(* ::Subsubsection::Closed:: *)
(*$EncodedCacheSettings*)



$EncodedCacheSettings[k__]:=
	EncodedCache[$EncodedCacheDefaultKey,"Options"][k];
$EncodedCacheSettings/:
	Set[$EncodedCacheSettings[k__],v_]:=
		Set[EncodedCache[$EncodedCacheDefaultKey,"Options"][k],v];
$EncodedCacheSettings/:
	Unset[$EncodedCacheSettings[k__]]:=
		Unset[EncodedCache[$EncodedCacheDefaultKey,"Options"][k]];


$EncodedCacheSettings/:
	File@$EncodedCacheSettings:=
		EncodedCacheOptionsFile[$EncodedCacheDefaultKey];
$EncodedCacheSettings/:
	DeleteFile@$EncodedCacheSettings:=
		DeleteFile@File@$EncodedCacheSettings;


(* ::Subsubsection::Closed:: *)
(*$EncodedCachePassword*)



$EncodedCachePassword[]:=
	EncodedCache[$EncodedCacheDefaultKey,"Password"];
$EncodedCachePassword/:
	Set[$EncodedCachePassword[],v_]:=
		Set[
			EncodedCache[$EncodedCacheDefaultKey,"Password"],
			v
			];
$EncodedCachePassword/:
	Unset[$EncodedCachePassword[]]:=
		Unset[EncodedCache[$EncodedCacheDefaultKey,"Password"]];


$EncodedCachePassword/:
	File@$EncodedCachePassword:=
		EncodedCachePasswordFile[$EncodedCacheDefaultKey];
$EncodedCachePassword/:
	DeleteFile@$EncodedCachePassword:=
		DeleteFile@File@$EncodedCachePassword;


(* ::Subsubsection::Closed:: *)
(*$EncodedCacheDirectory*)



$EncodedCacheDirectory/:
	Set[$EncodedCacheDirectory,dir_]/;(!TrueQ@$inEncodedCacheDirectoryOverload):=
		Block[{$inEncodedCacheDirectoryOverload=True},
			If[dir=!=$EncodedCacheDirectory,
				Replace[dir,{
					Automatic:>
						(
							$EncodedCacheDefaultKey="Default";
							EncodedCacheOptionsLoad[$EncodedCacheDefaultKey];
							EncodedCacheLoad[$EncodedCacheDefaultKey];
							$EncodedCacheDirectory=Automatic
							),
					f:FileName[{p___,n_}]:>
						(
							EncodedCacheLoad[FileNameJoin[{p,n}]];
							$EncodedCacheDefaultKey=FileBaseName@n;
							$EncodedCacheDirectory=f;
							),
					d:(_String|_File)?DirectoryQ:>
						Replace[EncodedCacheLoad[d],
							a_Association:>
								(
									EncodedCacheLoad[d];
									$EncodedCacheDefaultKey=FileBaseName@d;
									$EncodedCacheDirectory=d;
									)
							]
					}],
				dir
				]
			];


End[];



