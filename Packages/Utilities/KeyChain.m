(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



KeyChainConnect::usage="Uses the keychain to cloud connect";


KeyChainAdd::usage=
	"Adds auth data to the KeyChain";
KeyChainRemove::usage=
	"Removes auth data from the KeyChain";
KeyChainGet::usage=
	"Gets auth data from the KeyChain";


$KeyChain::usage=
	"An interface object to a password keychain";
$KeyChainSettings::usage=
	"An interface object for the options of the keychain";
$KeyChainPassword::usage=
	"An interface object for the password of the keychain";
$KeyChainDirectory::usage=
	"A settable directory to change where the $KeyChain loads from";


$KeyChainCloudAccounts::usage=
	"A collection of known accounts for KeyChainConnect";


(*KeyChainGenerateWord::usage="Futurized password-management function for building secure passwords"*)


Begin["`Private`"];


(* ::Subsection:: *)
(*KeyChain*)



If[!ValueQ@$KeyChainKey,
	$KeyChainKey:=
		(
			$KeyChainDirectory=Automatic;
			$KeyChainKey="KeyChain"
			)
	];
If[!ValueQ@$KeyChainDirectory,
	$KeyChainDirectory:=
		(
			$KeyChainKey="KeyChain";
			$KeyChainDirectory=Automatic
			)
	];


(* ::Subsubsection::Closed:: *)
(*$KeyChain*)



HoldPattern[$KeyChain[k__]]:=
	EncodedCache[$KeyChainKey][k];
$KeyChain/:
	Set[$KeyChain[k__],v_]:=
		Set[EncodedCache[$KeyChainKey][k],v];
$KeyChain/:
	SetDelayed[$KeyChain[k__],v_]:=
		SetDelayed[EncodedCache[$KeyChainKey][k],v];
$KeyChain/:
	Unset[$KeyChain[k__]]:=
		Unset[EncodedCache[$KeyChainKey][k]];


$KeyChain/:
	File@$KeyChain:=
		EncodedCacheFile[$KeyChainKey];
$KeyChain/:
	DeleteFile[$KeyChain]:=
		DeleteFile@File@$KeyChain;


$KeyChain/:
	Set[$KeyChain,a_Association]:=
		Set[EncodedCache[$KeyChainKey],a];
$KeyChain/:
	Unset[$KeyChain]:=
		Unset[EncodedCache[$KeyChainKey]];


(* ::Subsubsection::Closed:: *)
(*$KeyChainSettings*)



$KeyChainSettings[k__]:=
	EncodedCache[$KeyChainKey,"Options"][k];
$KeyChainSettings/:
	Set[$KeyChainSettings[k__],v_]:=
		Set[EncodedCache[$KeyChainKey,"Options"][k],v];
$KeyChainSettings/:
	Unset[$KeyChainSettings[k__]]:=
		Unset[EncodedCache[$KeyChainKey,"Options"][k]];


$KeyChainSettings/:
	File@$KeyChainSettings:=
		EncodedCacheOptionsFile[$KeyChainKey];
$KeyChainSettings/:
	DeleteFile@$KeyChainSettings:=
		DeleteFile@File@$KeyChainSettings;


(* ::Subsubsection::Closed:: *)
(*$KeyChainPassword*)



$KeyChainPassword[]:=
	EncodedCache[$KeyChainKey,"Password"];
$KeyChainPassword/:
	Set[$KeyChainPassword[],v_]:=
		Set[
			EncodedCache[$KeyChainKey,"Password"],
			v
			];
$KeyChainPassword/:
	Unset[$KeyChainPassword[]]:=
		Unset[EncodedCache[$KeyChainKey,"Password"]];


$KeyChainPassword/:
	File@$KeyChainPassword:=
		EncodedCachePasswordFile[$KeyChainKey];
$KeyChainPassword/:
	DeleteFile@$KeyChainPassword:=
		DeleteFile@File@$KeyChainPassword;


(* ::Subsubsection::Closed:: *)
(*$KeyChainDirectory*)



$KeyChainDirectory/:
	Set[$KeyChainDirectory,dir_]/;(!TrueQ@$inEncodedCacheDirectoryOverload):=
		Block[{$inEncodedCacheDirectoryOverload=True},
			If[dir=!=$KeyChainDirectory,
				Replace[dir,{
					Automatic:>
						(
							$KeyChainKey="KeyChain";
							EncodedCacheOptionsLoad[$KeyChainKey];
							EncodedCacheLoad[$KeyChainKey];
							$KeyChainDirectory=Automatic
							),
					f:FileName[{p___,n_}]:>
						(
							EncodedCacheLoad[FileNameJoin[{p,n}]];
							$KeyChainKey=FileBaseName@n;
							$KeyChainDirectory=f;
							),
					d:(_String|_File)?DirectoryQ:>
						Replace[EncodedCacheLoad[d],
							a_Association:>
								(
									EncodedCacheLoad[d];
									$KeyChainKey=FileBaseName@d;
									$KeyChainDirectory=d;
									)
							]
					}],
				dir
				]
			];


(* ::Subsubsection::Closed:: *)
(*KeyChainAdd*)



$keyChainFailureForms=""|$Failed|$Canceled|_Missing;


KeyChainAdd[site_->{username:Except[None],password:Except[$keyChainFailureForms]}]:=
	$KeyChain[{site,username}]=password;
KeyChainAdd[{site_->{username:Except[None],password:Except[$keyChainFailureForms]}}]:=
	$KeyChain[{site,username}]=password;
KeyChainAdd[sites:{(_->{Except[None],_}),(_->{Except[None],_})..}]:=
	With[{
		saveOps=$KeyChainSettings["SaveOptionsToDisk"],
		saveDisk=$KeyChainSettings["SaveToDisk"],
		storeLocal=$KeyChainSettings["StoreInMemory"]
		},
		$KeyChainSettings["SaveOptionsToDisk"]=False;
		If[storeLocal,
			$KeyChainSettings["SaveToDisk"]=False
			];
		With[{s=KeyChainAdd/@Most@sites},
			If[storeLocal,
				$KeyChainSettings["SaveToDisk"]=saveDisk
				];
			$KeyChainSettings["SaveOptionsToDisk"]=saveOps;
			Append[s,
				KeyChainAdd@Last@sites
				]
			]
		];
KeyChainAdd[
	sites:(
		_String|(_String->_String)|
			{(_String|(_String->_String))..}
		)
	]:=
	(Clear@$keyChainAuth;Replace[#,_KeyChainAdd->$Failed])&@
		KeyChainAdd@
			Normal@
				AuthDialog[
					Dynamic@$keyChainAuth,
					"",
					None,
					Sequence@@
						Replace[Flatten@{sites},
							(s_->u_):>
								{{s,Automatic},u},
							1
							]
					];
KeyChainAdd[
	site_->{None,s_String}
	]:=
	(Clear@$keyChainAuth;Replace[#,_KeyChainAdd->$Failed])&@
		KeyChainAdd[
			site->
				{
					s,
					PasswordDialog[
						Dynamic@$keyChainAuth,
						s,
						s,
						"PromptString"->
							"Enter ``:",
						WindowTitle->s,
						FieldMasked->False
						]
					}
			];


(* ::Subsubsection::Closed:: *)
(*KeyChainRemove*)



KeyChainRemove[site_->username:Except[None]]:=
	$KeyChain[{site,username}]=.;


(* ::Subsubsection::Closed:: *)
(*KeyChainGet*)



$KeyChainGetAccountKeys=
	{"AccountData", "WolframCloud"};


KeyChainGet[site_String,lookup:True|False:False]:=
	If[lookup,
		FirstCase[#,_String?(StringLength@#>0&),
			KeyChainAdd[site]
			],
		FirstCase[#,_String?(StringLength@#>0&)]
		]&@
		$KeyChain[{site,Key@{site,""}}];
iKeyChainGet[
	{
		site_String, 
		username_String,
		subparts___String
		},
	lookup:True|False:False
	]:=
	If[lookup,
		FirstCase[#,Except[$keyChainFailureForms],
			KeyChainAdd[site->StringJoin[username, subparts]]
			],
		FirstCase[#,Except[$keyChainFailureForms]]
		]&@$KeyChain[{Key@{site,StringJoin[username, subparts]}}];
KeyChainGet[
	{
		site:Except[Alternatives@@Append[$KeyChainGetAccountKeys, ""], _String], 
		username_String,
		subparts___String
		},
	lookup:True|False:False
	]:=
	iKeyChainGet[{site, username, subparts}, lookup];
KeyChainGet[
	site_->{None, username_String, subparts___String},
	lookup:True|False:False
	]:=
	With[{key=StringJoin[username, subparts]},
		Replace[
			iKeyChainGet[{site,key}],
			e:$keyChainFailureForms:>
				If[lookup, KeyChainAdd[site->{None,key}], e]
			]
		];
KeyChainGet[
	{
		site:Alternatives@@$KeyChainGetAccountKeys, 
		username_String,
		subparts___String
		},
	lookup:True|False:False
	]:=
	KeyChainGet[
		site->{None, username, subparts}
		]


PackageAddAutocompletions[
	"KeyChainGet",
	{
		Map[
			ToString[{"\""<>#<>"\"", "accountName"}]&,
			$KeyChainGetAccountKeys
			]
		}
	]


(* ::Subsubsection::Closed:: *)
(*KeyChainConnect*)



$KeyChainCloudAccounts=
	"TestingAccount"|"DeploymentsAccount"|
		"PacletsAccount"|"DatasetsAccount"|
		"ServiceConnectionsAccount"|"DocumentationAccount"|
		"PaidAccount"|"FreeAccount";


PackageAddAutocompletions[
	"KeyChainConnect",
	{List@@$KeyChainCloudAccounts}
	]


Options[KeyChainConnect]=
	Options[CloudConnect];
KeyChainConnect[
	acc:$KeyChainCloudAccounts,
	ops:OptionsPattern[]
	]:=
	KeyChainConnect[Key[acc],ops];
KeyChainConnect[
	acct:_String|Key[_String]:Key["TestingAccount"],
	ops:OptionsPattern[]
	]:=
	With[
		{
			user=
				Replace[acct,Key[a_]:>KeyChainGet[{"WolframCloud", a},True]],
			base=
				Replace[OptionValue[CloudBase],Automatic:>$CloudBase]
			},
		If[$WolframID=!=user||$CloudBase=!=base,
			CloudConnect[user,
				KeyChainGet[{base,user},True],
				ops
				],
			$WolframID	
			]
		];
KeyChainConnect[
	acct:_String|Key[_String],
	pass_String,
	ops:OptionsPattern[]
	]:=
	With[{
		user=
			Replace[acct,Key[a_]:>KeyChainGet[{"WolframCloud", a}, True]],
		base=Replace[OptionValue[CloudBase],Automatic:>$CloudBase]
		},
		If[$WolframID=!=user||$CloudBase=!=base,
			CloudConnect[user,
				pass,
				ops
				]
			]
		];


End[];


