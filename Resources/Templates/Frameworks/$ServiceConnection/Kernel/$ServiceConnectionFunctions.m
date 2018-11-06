(* ::Package:: *)

(* ::Section:: *)
(*$ServiceConnection Service Connection Aids*)


(* ::Text:: *)
(*This is a the package of helper functions for the $ServiceConnection service connection.*)


(* ::Subsection:: *)
(*Exposed*)


BeginPackage["$ServiceConnectionFunction`"];


$ServiceConnectionHelperNames


(* ::Subsubsection::Closed:: *)
(*OAuth loopback*)


$serviceconnectionprivateoauthpagelink::usage=
	"A local redirect URI that tells the user what the access code to copy is";
$serviceconnectionprivateoauthcloudlink::usage=
	"A cloud exported redirect URI that tells the user what the access code to copy is";


$serviceconnectionprivateoauthtokenfile::usage=
	"A fake OAuth token for when a real OAuth token isn't needed by the OAuth client is desired";


$$serviceconnectionoauthcodecloudlink::usage=
	"A static cloud object URL for getting code copied"
$$serviceconnectionoauthaccesstokencloudlink::usage=
	"A static cloud object URL for getting an access_token copied"
	$$serviceconnectionoauthaccesscodecloudlink::usage=
		"A static cloud object URL for getting an access_code copied"


(* ::Subsubsection::Closed:: *)
(*Token Echo*)


$serviceconnectionprivateoauthpagelink::usage;
$serviceconnectiontokenechocloudlink::usage;


(* ::Subsubsection::Closed:: *)
(*Credentials*)


$$serviceconnectionclientdatacaching::usage=
	"Caching flag";


$serviceconnectiongetclientdata::usage=
	"Credential getting function. Useful for things like client secrets.";


$serviceconnectionstoreclientdata::usage=
	"Credential storing function. Uses a raw Encode if BTools isn't installed";


$serviceconnectionclearclientdata::usage=
	"Clears stored credentials";


(* ::Subsubsection::Closed:: *)
(*Request Formatting*)


$serviceconnectionreformatbodydata::usage=
	"Reformats the BodyData parameter of a request. Used by default for KeyClient";


$serviceconnectionreformatmultipartbodydata::usage=
	"Reformats BodyData into a MultipartData made of metadata and content fragment";


$serviceconnectionpatchedurlfetchblock::usage=
	"A block that patches $$serviceconnectionurlfetchpatch into URLFetch";


$serviceconnectionpatchmultipartparams::usage=
	"A block that sets the patching for multipart data";


$$serviceconnectionlastrequest::usage=
	"A symbol that temporariliy gets the request association when using URLFetch override";


(* ::Subsection:: *)
(*Private*)


Begin["`Private`"];


$ServiceConnectionHelperFunctions


(* ::Subsubsection::Closed:: *)
(*Fake Auth File*)


$$serviceconnectionprivateoauthtokenfile=
	FileNameJoin@{
		$TemporaryDirectory,
		"oauth2token"
		};


$serviceconnectionprivateoauthtokenfile[tokenName_:"access_token"]:=
	StringReplace[
		URLBuild[<|
			"Scheme"->"file",
			"Domain"->"",
			"Path"->FileNameSplit@#
			|>]&@
				Export[
					$$serviceconnectionprivateoauthtokenfile,
					ExportString[{
						tokenName->CreateUUID["token-"]
						},
						"JSON"
						],
					"Text"
					],
		"file:"->"file://"
		];


(* ::Subsubsection::Closed:: *)
(*Cloud Loopback*)


$serviceconnectionprivateoauthpagetemplate[keys_]:=
"<html>
	<head>
		<title> OAuth Callback </title>
		<style>
			* {
				margin: 0;
				padding: 0;
				border: 0;
				outline: 0;
				font-size: 100%;
				vertical-align: baseline;
				background: transparent;
    }
			body { background: #fcfcfc; padding: 0; width: 100%;}
			.top-bar {
				width: 100%; background: #cc0000; height: 100px;
				border-bottom: solid 1px gray;
      margin: 0px 0px 25px 0px;
				}
			.key-field {
				background: white;
      padding: 15px 50px 15px 50px;
				margin: 5px 0px 5px 0px;
				width: 100%;
				border-top: solid 1px gray;
      border-bottom: solid 1px gray;
				}
			.footer-bar {
				position: absolute;
				bottom: 0;
				background: #555;
				width: 100%; height: 50px;
				border-top: solid 1px gray;
				}
      h3 {
       color: #777;
      }
      .key-field p {
       color: black;
       font-weight: normal;
      }
				.muted p {
       color: grey;
       font-weight: normal;
      }
		</style>
		<script>
			function pullAuthCode () {
				// Copped from stack overflow.
				// Pulls the query parameters then returns the appropriate one
				var query_string = {};
				var query = window.location.hash;
				if (!query || !query.includes(\"=\")) {
					query = window.location.search.substring(1)
					} else {
						query = query.slice(1)
					};
				// console.log(query)
				var vars = query.split(\"&\");
				for (var i=0;i<vars.length;i++) {
				 	var pair = vars[i].split(\"=\");
				 		// If first entry with this name
				 		if (typeof query_string[pair[0]] === \"undefined\") {
				 			query_string[pair[0]] = decodeURIComponent(pair[1]);
				 			// If second entry with this name
				 			} else if (typeof query_string[pair[0]] === \"string\") {
				 				var arr = [ query_string[pair[0]],decodeURIComponent(pair[1]) ];
				 				query_string[pair[0]] = arr;
				 			// If third or later entry with this name
				 			} else {
				 				query_string[pair[0]].push(decodeURIComponent(pair[1]));
				 				}
				 			};
	 		return { `keys` }
			};
			function authCodeInsert () {
				// Inserts the pulled parameters into the page
				var query_strings = pullAuthCode();
				for ( key in query_strings ){
					// console.log(key);
					document.getElementById(key).innerHTML=query_strings[key]
					}
				};

		</script>
	</head>
	<body>
	<div class=\"top-bar\">
	</div>
	`fields`
	<script> authCodeInsert()</script>
	<div class=\"footer-bar\">
	</div>
	</body>
</html>"~TemplateApply~
		<|
			"keys"->StringRiffle["\""<>#<>"\" : "<>"query_string."<>#&/@Flatten@{keys},","],
			"fields"->
				StringRiffle[
					"
		<div class=\"key-field\">
			<h3>Your `` is:</h3>
			<p id=\"``\"></p>
		</div>
		"~TemplateApply~{
						StringRiffle[
							Replace[
								Capitalize/@StringSplit[#,"_"],
								Capitalize[s_]:>
								(ToUpperCase@StringTake[s,1]<>StringDrop[s,1]),
								1
								]
							],#}&/@Flatten@{keys},
					"\n"
					]
		|>


$serviceconnectionprivateoauthcloudlink[keys_]:=
	First@
		CloudExport[
			$serviceconnectionprivateoauthpagetemplate[keys],
			"HTML",
			"o/oauthflow/oauth2callback"<>"-"<>StringRiffle[Flatten@{keys},"-"],
			Permissions->"Public"
			];


$$serviceconnectionoauthcodecloudlink=
	"https://www.wolframcloud.com/objects/b3m2a1/o/oauthflow/oauth2callback-code";


$$serviceconnectionoauthaccesstokencloudlink=
	"https://www.wolframcloud.com/objects/b3m2a1/o/oauthflow/oauth2callback-access_token";

$$serviceconnectionoauthaccesscodecloudlink=
	"https://www.wolframcloud.com/objects/b3m2a1/o/oauthflow/oauth2callback-access_code";


$serviceconnectionprivateoauthfile=
	FileNameJoin@{
		$TemporaryDirectory,
		"oauth2callback"
		};


$serviceconnectionport=1965;
$serviceconnectionprivateoauthpagelink[key_]:=
		With[{text=$serviceconnectionprivateoauthpagetemplate[key]},
			Catch[
				Check[
					HTTPHandling`StartWebServer;
					If[!TrueQ[Length@DownValues@HTTPHandling`StartWebServer>0],
						Throw[$Failed,"fail"]];
					Quiet@KillProcess@HTTPHandling`WebServer[$serviceconnectionport];
					HTTPHandling`StartWebServer[
						URLDispatcher[{
							___~~"outh2callback"~~___:>
								APIFunction[{"code"->"String"},
									ExportForm[
										StringReplace[text,
											"query_string."<>ToString@key->"\""<>#code<>"\""
											],
										"HTML"
										]&]
							}],
						$serviceconnectionport
						];
					URLBuild[<|
						"Scheme"->"http",
						"Domain"->"localhost:"<>ToString@$serviceconnectionport,
						"Path"->"outh2callback"
						|>],
					Throw[$Failed,"fail"]
					],
				"fail",
				URLBuild[<|
					"Scheme"->"http",
					"Domain"->"localhost:8080",
					"Path"->FileNameSplit@#
					|>]&@
						Export[
							$serviceconnectionprivateoauthfile,
							text,
							"Text"
							]&
					]
				];


(* ::Subsubsection::Closed:: *)
(*Code to Access Token*)


$serviceconnectiontokenechopage[token_]:=
	ExportString[
		{"access_token"->token},
		"JSON"
		]


$serviceconnectiontokenechocloudlink[token_]:=
	First@
		CloudExport[
			$serviceconnectiontokenechopagetemplate[token],
			"Text",
			"o/oauthflow/oauth2accesstoken",
			Permissions->"Public"
			];


$serviceconnectiontokenechofile=
	FileNameJoin@{
		$TemporaryDirectory,
		"oauth2accesstoken"
		};


$serviceconnectiontokenechopagelink[key_]:=
		With[{text=$serviceconnectiontokenechopage[key]},
			Catch[
				Check[
					HTTPHandling`StartWebServer;
					If[!TrueQ[Length@DownValues@HTTPHandling`StartWebServer>0],
						Throw[$Failed,"fail"]];
					Quiet@KillProcess@HTTPHandling`WebServer[$serviceconnectionport];
					HTTPHandling`StartWebServer[
						ExportForm[text,"Text"],
						$serviceconnectionport
						];
					URLBuild[<|
						"Scheme"->"http",
						"Domain"->"localhost:"<>ToString@$serviceconnectionport,
						"Path"->"oauth2accesstoken"
						|>],
					Throw[$Failed,"fail"]
					],
				"fail",
				URLBuild[<|
					"Scheme"->"http",
					"Domain"->"localhost:8080",
					"Path"->FileNameSplit@#
					|>]&@
						Export[
							$serviceconnectiontokenechofile,
							text,
							"Text"
							]&
					]
				];


(* ::Subsubsection::Closed:: *)
(*BannerDialog*)


bannerCredDialog[key_]:=
	DialogInput[
		{
				ExpressionCell[#,
					CellFrameMargins->None,
					CellMargins->8]&@
						Pane[
							Column@{
								Row@{"Input ",key,":"},
								InputField[Dynamic@$credCache[key],
									String,
									FieldMasked->True
									]
								},
							ImageSize->
								{400,290},
							BaseStyle->"Output",
							Scrollbars->Automatic
							],
				ExpressionCell[#,
					"Output",
					Background->GrayLevel[.98],
					CellFrameColor->GrayLevel[.8],
					CellFrame->{{0,0},{0,1}},
					CellMargins->0,
					CellTags->{"FooterCell"}
					]&@
					Pane[
						Row@
							{
								Button[
									Style["Submit",White],
									DialogReturn[$credCache[key]],
									ImageSize->{100,30},
									Appearance->
										{"Default"->Image[CompressedData["
1:eJxTTMoPSmNiYGAo5gASQYnljkVFiZXBAkBOaF5xZnpeaopnXklqemqRRRIz
UFAGiHmBmIUBBfwngFGAa5rtf2Ixsp6MmTEE8TDW859EPf+Hgp7MWTEEMbqe
rDmxBDG6nuy5cQQxup6c+fEEMbqe3IUJBDG6nrxFiQQxup6CJUkEMbqewmXJ
BDG6nqLlKQQxhp4VqQQxhXoYSNTDMBT0kFgmEipzMcpgALzlzcw=
"], "Byte", ColorSpace -> "RGB", Interleaving -> True],"Hover"->Image[CompressedData["
1:eJxTTMoPSmNiYGAo5gASQYnljkVFiZXBAkBOaF5xZnpeaopnXklqemqRRRIz
UFAGiHmBmIUBBfwngFFAZEnwf2Ixsp62tTUE8TDW859EPf+Hgp72dbUEMbqe
jvV1BDG6ns6NdQQxhp5N9QQxup6uLQ0EMbqe7q2NBDG6np5tTQQxup7eHc0E
Mbqevp3NBDG6nv5dLQQxhXoYSNTDMBT0kFgmEipzMcpgAEESIOE=
"], "Byte", ColorSpace -> "RGB", Interleaving -> True],"Pressed"->Image[CompressedData["
1:eJxTTMoPSmNiYGAo5gASQYnljkVFiZXBAkBOaF5xZnpeaopnXklqemqRRRIz
UFAGiHmBmIUBBfwngFGAXYz5f2Ixsp7QWm+CeBjr+U+inv9DQU94gy9BjK4n
stmPIEbXE90aQBCj64npCCKI0fXEdQcTxOh6EnpDCWJ0PUkTwglidD0pkyMI
YnQ9adOiCGJ0PenTowliCvUwkKiHYSjoIbFMJFTmYpTBADDZm5A=
"], "Byte", ColorSpace -> "RGB", Interleaving -> True]}
									],
								Spacer[{10,0}],
								CancelButton[
									"Cancel",
									DialogReturn[$Canceled],
									ImageSize->{100,30},
									Appearance->
										{"Default"->Image[CompressedData["
1:eJzV1EEKgkAYhuGhWrQJOkCbbtG2ZduiAyhZtDGwIDqKRxNFUVFEEVF0bUMU
5NfiS1r1wzvMDDzbf66e1vuBEOI8lsdauS4NQ7ltpvKx1c/Hg67tVvpFO2jG
Qh3Kz5lsIhuJzrSkzpim2X7bu7Esi4bGtm0aGsdxaGhc16Wh8TyP9mYed9/3
aU/TvkwQBDQ0YRjS0ERRREMTxzENTZIkNDRpmtLQZFlGQ5PnOQ1NURQ0NGVZ
0tBUVUVDU9c1DU3TNLQfjehpxD+YnjuR7dyPHXwHy1co2w==
"], "Byte", ColorSpace -> "RGB", Interleaving -> True],"Hover"->Image[CompressedData["
1:eJzV1E0KgkAYxvGhWrQJOkCbbtG2ZduiAyhZtDGwIDqKx/MDP1FRUZc2REE+
LZ6kVS/8h5mB3/adq6f1fiCEOI/lsVauS8NQbpupfGz18/Gga7uVftEOmrFQ
h/JzJpvIRqIzLakzpmm23/ZuLMuiobFtm4bGcRwaGtd1aWg8z6O9mcfd933a
07QvEwQBDU0YhjQ0URTR0MRxTEOTJAkNTZqmNDRZltHQ5HlOQ1MUBQ1NWZY0
NFVV0dDUdU1D0zQN7UcjehrxD6bnTmQ792MH3wFFhzOd
"], "Byte", ColorSpace -> "RGB", Interleaving -> True],"Pressed"->Image[CompressedData["
1:eJxTTMoPSmNiYGAo5gASQYnljkVFiZXBAkBOaF5xZnpeaopnXklqemqRRRIz
UFAGiHmBmIUBBfwngFHAzJkz/xOLkfVs27aNIB7Gev6TqOc/vfVs376dIEbX
s2fPHoIYXc/BgwcJYnQ9x44dI4jR9Zw+fZogRtdz/vx5ghhdz6VLlwhidD1X
r14liNH13LhxgyBG13P79m2CGF3PnTt3CGIK9TCQqIdhKOghsUwkVOZilMEA
mEXTyg==
"], "Byte", ColorSpace -> "RGB", Interleaving -> True]}
									]
								},
						ImageSize->
							Replace[OptionValue[WindowSize],{
								{w_,h_}:>
									{Replace[w,Automatic|Fit->400],100-70},
								w_Integer:>
									{w,100-70},
								_->
									{400,100-70}
								}],
						Alignment->{Left,Center}
						]
					},
		WindowSize->{400,400},
		DockedCells->
			Cell[
				BoxData@ToBoxes@
					Pane[
						key,
						{Scaled[.7],30},
						Alignment->{Center,Center},
						ImageSizeAction->"ResizeToFit"
						],
				"Panel",
				FontFamily->"Times",
				FontColor->Hue[.3,.03,.95],
				TextAlignment->Center,
				Background->Hue[.3,.4,.6],
				CellFrame->{{0,0},{1,0}}
				],
		WindowFrameElements->{"CloseBox"},
		WindowElements->None,
		WindowTitle->"",
		Background->White,
		ImageMargins->0,
		CellMargins->0
		];


(* ::Subsubsection::Closed:: *)
(*ClientInfoFile*)


$$serviceconnectionclientsecretsjsonfile=
	If[StringQ@#,
		FileNameJoin@{
			#,
			"client_secrets.json"
			},
		None
		]&@
	SelectFirst[
		{
			ParentDirectory@DirectoryName@$InputFileName,
			FileNameJoin@{
				$UserBaseDirectory,
				"ApplicationData",
				"ServiceConnections",
				"$ServiceConnection"
				}
			},
		FileExistsQ@
		FileNameJoin@{
			#,
			"client_secrets.json"
			}&
		]


$$serviceconnectionclientsecretsinfo=
	With[{
		raw=
	If[StringQ[#]&&FileExistsQ[#]&@$$serviceconnectionclientsecretsjsonfile,
		Import[$$serviceconnectionclientsecretsjsonfile, "RawJSON"],
		<|
			"installed"-><||>,
			"web"-><||>
			|>
		]
		},
		Lookup[raw, "installed",
			Lookup[raw, "web", <||>]
			]
		]


(* ::Subsubsection::Closed:: *)
(*Caching Flag*)


$$serviceconnectionclientdatacaching=
	Length@PacletManager`PacletFind["BTools"]>0


(* ::Subsubsection:: *)
(*Auth Credentials Get*)


$serviceconnectiongetclientdatafallback[cred_]:=
	If[FileExistsQ@
		FileNameJoin@{
			$TemporaryDirectory,
			"_service_connect_creds_",
			ToString@Hash@cred<>".mx"
			},
		Get@
			FileNameJoin@{
			$TemporaryDirectory,
			"_service_connect_creds_",
			ToString@Hash@cred<>".mx"
			},
		Replace[
			bannerCredDialog[cred],
			val_String?(StringLength@#>0&):>
				If[$$serviceconnectionclientdatacaching,
					$serviceconnectionstoreclientdatafallback[cred,val];
					val,
					val
					]
			]
		];


$serviceconnectiongetclientdatakeychain[cred_]:=
	Replace[
		ToExpression[
			Join[
				Names["*`KeychainGet"],
				Names["*`*`KeychainGet"]
				],
			StandardForm,
			Function[Null,
				If[Length@DownValues[#]==0,
					Nothing,
					#
					],
				HoldFirst
				]
			],
		{
			{s_, ___}:>s,
			_->$Failed
			}
		][
		"$ServiceConnection"->{None, StringJoin@Flatten@{cred}},
		True
		];


$serviceconnectiongetclientdata//Clear


$serviceconnectiongetclientdata[cred_, fallback_:Automatic, post_:Identity]:=
post@Lookup[
	$$serviceconnectionclientsecretsinfo,
	ToLowerCase@
	StringReplace[cred,
		l:LetterCharacter?LowerCaseQ~~d:LetterCharacter?(Not@*LowerCaseQ):>
			l<>"_"<>d
		],
	If[fallback===Automatic,
		Quiet[
			Check[
				Needs["BTools`"];
				$serviceconnectiongetclientdatakeychain[
					StringJoin@Flatten@{"$ServiceConnection",cred}],
				$serviceconnectiongetclientdatafallback[
					StringJoin@Flatten@{"$ServiceConnection",cred}]
				],
			{Get::noopen,Needs::nocont}
			],
		fallback
		]
	];


(* ::Subsubsection::Closed:: *)
(*Auth Credentials Store*)


$serviceconnectionstoreclientdatafallback[cred_,val_]:=
	With[{dir=
		FileNameJoin@{
				$TemporaryDirectory,
				"_service_connect_creds_"
				}
		},
		If[!DirectoryQ@dir,CreateDirectory@dir];
			Encode[
				Export[
					FileNameJoin@{dir,ToString@Hash@cred<>".m"},
					val
					],
				FileNameJoin@{dir,ToString@Hash@cred<>".mx"}
				];
			DeleteFile@FileNameJoin@{dir,ToString@Hash@cred<>".m"};
		];


$serviceconnectionstoreclientdatakeychain[cred_,val_]:=
	BTools`KeyChainAdd[
		"$ServiceConnection"->{cred,val}
		];


$serviceconnectionstoreclientdata[cred_,val_]:=
	Quiet[
		Check[
			Needs["BTools`"];
			$serviceconnectionstoreclientdatakeychain[
				"$ServiceConnection"->{None,StringJoin@Flatten@{cred}},
				val
				],
			$serviceconnectionstoreclientdatafallback[
				StringJoin@Flatten@{"$ServiceConnection",cred},
				val]
			],
		{Get::noopen,Needs::nocont}
		];


(* ::Subsubsection::Closed:: *)
(*Auth Credentials Clear*)


$serviceconnectionclearclientdatafallback[cred_]:=
	With[{dir=
		FileNameJoin@{
				$TemporaryDirectory,
				"_service_connect_creds_"
				}
		},
		DeleteFile@FileNameJoin@{dir,ToString@Hash@cred<>".mx"};
		];


$serviceconnectionclearclientdata[cred_]:=
	Quiet[
		Check[
			Needs["BTools`"];
			BTools`$KeyChain[{"$ServiceConnection",StringJoin@Flatten@{cred}}]=.,
			$serviceconnectionclearclientdatafallback[
				StringJoin@Flatten@{"$ServiceConnection",cred}
				]
			],
		{Get::noopen,Needs::nocont}
		];


(* ::Subsubsection::Closed:: *)
(*Multipart Encoding*)


$serviceconnectionMimeToFormat:=
	Replace[
		CloudObject;
		CloudObject`Private`mimeToFormat,
		_Symbol:>
			(CloudObject`Private`mimeToFormat=
				Quiet[
					DeleteCases[
						Flatten[
							Function[{format},
								Function[{mime},
									mime->format
									]/@ImportExport`GetMIMEType[format]
								]/@$ExportFormats],
						$Failed],
					FileFormat::fmterr
					])
		];


$serviceconnectiongetmultipartstring[mpdata_]:=
		With[{break=CreateUUID["divider-"]},
			With[{bs=
				StringRiffle[
					Flatten@
						{
								"--"<>break,
								Riffle[
									Map[{
										"Content-Type: "<>
											ToLowerCase@#[[1,2]],
										"",
										ToString@
											Replace[#[[2]],{
												f:(_File|_String)?FileExistsQ:>
													ReadString[f],
												data:{__Integer}|_ByteArray:>
													FromCharacterCode@Normal@data
												}]
										}&,
										mpdata
										],
									"--"<>break
									],
								"--"<>break<>"--"
							},
					"\n"
					]
				},
			<|
				"Headers"->{
					"Content-Type"->
						"multipart/related; boundary="<>break,
					"Content-Length"->
						ToString@Length@ToCharacterCode[bs,"UTF8"]
					},
				"Body"->
					bs
				|>
			]
		];


(* ::Subsubsection::Closed:: *)
(*Data Re-Encoding*)


$serviceconnectionreformatmultipartbodydata[baseCall_,id_,pars_]:=
	Block[{fetchParams=Association@pars},
		With[{
			bodyParams=
				ServiceConnections`Private`getQueryData[
					id,
					baseCall
					][[5]]
			},
		If[
			AnyTrue[Keys@bodyParams,
				KeyMemberQ[fetchParams,#]&
				],
			fetchParams["BodyData"]=
				KeySelect[fetchParams,
					MatchQ[Alternatives@@Keys@bodyParams]
					]
			];
		If[KeyMemberQ[fetchParams,"ParameterlessBodyData"],
			Replace[
					Quiet@
						Check[
							ImportString[fetchParams["ParameterlessBodyData"],"JSON"],
							ImportString[
								StringReplace[
									fetchParams["ParameterlessBodyData"],
									"\\n"->"\n"
									],
								"JSON"
								]
							],{
					r:{__Rule}:>
					(
						fetchParams["ParameterlessBodyData"]=.;
						fetchParams["BodyData"]=
						Association@Join[r,
							Replace[Lookup[fetchParams,"BodyData",{}],
								s_String:>
								Replace[Quiet@URLQueryDecode[s],
									Except[{__Rule}]->{}
									]
								]
							]
						),
					_:>
					If[KeyMemberQ[fetchParams,"BodyData"]&&
						StringQ@fetchParams["BodyData"],
						Replace[Quiet@URLQueryDecode[fetchParams["BodyData"]],
							r:{__Rule}:>
							(fetchParams["BodyData"]=Association@r)
							]
						]
					}],
			If[KeyMemberQ[fetchParams,"BodyData"]&&StringQ@fetchParams["BodyData"],
				Replace[Quiet@URLQueryDecode[fetchParams["BodyData"]],
					r:{__Rule}:>
					(fetchParams["BodyData"]=Association@r)
					]
				]
			];
		If[KeyMemberQ[fetchParams,"BodyData"]&&AssociationQ@fetchParams["BodyData"],
			If[KeyMemberQ[Association@fetchParams["BodyData"],"BodyContent"],
				fetchParams["MultipartData"]=
					Flatten@{
						Lookup[fetchParams,"MultipartData",{}],
						{"metadata","application/json; charset=UTF-8"}->
							ToCharacterCode@
								ExportString[
									Normal@
										KeySelect[fetchParams,
											MatchQ[
												Alternatives@@
													DeleteCases[Keys@bodyParams,
														"MIMEType"|"BodyContent"|"ParameterlessBodyData"
														]
												]
											],
									"JSON"
									],
						{
							"contentdata",
							Lookup[
								Association@fetchParams["BodyData"],
								"MIMEType",
								Replace[Association[fetchParams["BodyData"]]["BodyContent"],{
										f:(_File|_String)?FileExistsQ:>
											ToLowerCase@Replace[
												ImportExport`GetMIMEType[ToUpperCase@FileExtension@f],
												{
													{}->"application/octet-stream",
													{fil_}:>fil,
													{}->"application/octet-stream"
												}
												],
										_->"application/octet-stream"
								}]
								]
							}->
								ToCharacterCode@
									Replace[Association[fetchParams["BodyData"]]["BodyContent"],{
											f:(_File|_String)?FileExistsQ:>
												ReadString[f],
											(Hold|HoldComplete|HoldForm)[e_]:>
												Replace[e,
													{
														fi:(_File|_String)?FileExistsQ:>
															ReadString[fi],
														o:Except[_String]:>
															ToString[o,InputForm]
														}
													],
											e:Except[_String]:>
												ToString[e,InputForm]
											}]
						};
				fetchParams["BodyData"]=.
				];
			]
		];
	fetchParams
	]


$serviceconnectionreformatbodydata[baseCall_,id_,pars_]:=
	Block[{params=pars},
		With[{
			bodyData=
				Replace[
					Lookup[params,"BodyData",{}],
					Except[_String|_List]->{}
					],
			bodyParams=
				ServiceConnections`Private`getQueryData[
					id,
					baseCall
					][[5]]
			},
			heldBodyData
			If[Length@bodyParams>0,
			params=
				Normal@
				Merge[{
					params,
					"ParameterlessBodyData"->
						Function[
							If[StringQ@bodyData,
								StringJoin@{
									"[","\n",bodyData,",","\n",
									ExportString[Normal@#,"JSON", "Compact"->True]/.
										f_File:>
											ReadString[f],
									"\n","]"
									},
								ExportString[
									Join[
										bodyData,
										Normal@#/.
											f_File:>
												ReadString[f]
										],
									"JSON",
									"Compact"->True
									]
								]
							]@
							DeleteMissing@
								AssociationThread[
									Keys@bodyParams,
									Lookup[params,Values@bodyParams]
									]
					},
					Last
					]
				]
			];
			params
		];


(* ::Subsubsection::Closed:: *)
(*URLFetch Patch*)


$serviceconnectionpatchedurlfetchblock//Clear;


$serviceconnectionpatchedurlfetchblock[expr_]:=
	Internal`InheritedBlock[{URLFetch},
		Block[{$$serviceconnectionurlfetchpatch=<||>},
			Unprotect@URLFetch;
			URLFetch[
				url_,
				return:Except[_?OptionQ]...,
				post___?OptionQ
				]/;!TrueQ@$urlFetchInOverride:=
				Block[{
					$urlFetchInOverride=True,
					requestParmeters
					},
					$$serviceconnectionlastrequest=
						Merge[{
							KeyMap[
								Replace[{
									"BodyData"->"Body",
									"MultipartData"->"MultipartElements"
									}],
								Association@
									Replace[$$serviceconnectionurlfetchpatch,
										Except[_Association|{__Rule}]-><||>
										]
								],
							"URL"->url,
							post
							},
							Replace[
								DeleteCases[""]@Flatten@#,{
								{f_?(Not@*OptionQ)}:>f
								}]&
							];
					If[(* Correct for multipart POST glitch? *)
						KeyMemberQ[$$serviceconnectionlastrequest,"MultipartElements"]&&
							ToUpperCase@
									Lookup[
										$$serviceconnectionlastrequest,
										"Method",
										"Get"
										]==="POST",
							If[KeyMemberQ[$$serviceconnectionlastrequest,"Parameters"],
								$$serviceconnectionlastrequest["URL"]=
									URLBuild[
										$$serviceconnectionlastrequest["URL"],
										$$serviceconnectionlastrequest["Parameters"]
										];
								$$serviceconnectionlastrequest["Parameters"]=.
								]
						];
					$$serviceconnectionlastrequest=
						FilterRules[
							Normal@
								$$serviceconnectionlastrequest,
							Alternatives@@
								DeleteDuplicates[
									Join[ToString/@#,#]&@
									Join[
										Map[First,Options@URLFetch],
										{
											"URL"
											}]]
							];
					URLFetch[
						Lookup[$$serviceconnectionlastrequest,"URL"],
						return,
						Sequence@@
							FilterRules[
								$$serviceconnectionlastrequest,
								Except@"URL"
								]
						]
					];
			DownValues[URLFetch]=RotateRight@DownValues[URLFetch];
			Protect@URLFetch;
			expr
			]
		];
$serviceconnectionpatchedurlfetchblock~SetAttributes~HoldFirst;


$serviceconnectionpatchmultipartparams[
	baseCall_,
	id_,
	pars_
	]:=
	(
		$$serviceconnectionurlfetchpatch=
			$serviceconnectionreformatmultipartbodydata[
				baseCall,
				id,
				pars]
		)


(* ::Subsection:: *)
(*End*)


End[];

EndPackage[];
