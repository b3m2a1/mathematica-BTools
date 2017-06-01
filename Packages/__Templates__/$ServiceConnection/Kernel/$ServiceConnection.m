(* ::Package:: *)

Get["$ServiceConnectionFunctions`"]

Begin["$ServiceConnectionAPI`"]

Begin["`Private`"]

(******************************* $ServiceConnection *************************************)


(* Authentication information *)
$serviceconnectionclientinfo=$ServiceConnectionClientInfo
$serviceconnectiondata[] = 
DeleteDuplicatesBy[First]@Flatten@{

	"ServiceName" -> "$ServiceConnection",
	"URLFetchFun" :> $ServiceConnectionURLFetch,
	"ClientInfo" :> 
		Replace[$serviceconnectionclientinfo,
			{
				{}|Except[_List]:>
					If[$ServiceConnectionUseOAuth//TrueQ,
						{"Wolfram","Token"},
						{}
						],
				o_?OptionQ:>
					OAuthDialogDump`Private`MultipleKeyDialog[
						"$ServiceConnection",
						Flatten@{o},
						With[{parms=
							DeleteCases[Except[_String|_Integer]]@
								AssociationThread[
									{
										"client_id",
										"redirect_uri",
										"state"
										},
									{
										$ServiceConnectionClientID,
										$ServiceConnectionRedirectURI,
										$ServiceConnectionState
										}
									]
							},
						If[Length@parms>0,
							URLBuild[
								$ServiceConnectionAuthEndpoint,
								Normal@parms
								],
							$ServiceConnectionAuthEndpoint
							]
						],
					$ServiceConnectionTermsOfServiceURL
					]
				}],
	If[$ServiceConnectionUseOAuth//TrueQ,
		{
			"OAuthVersion" -> "2.0",
			"AuthorizeEndpoint" -> $ServiceConnectionAuthEndpoint,
			"AccessEndpoint" -> $ServiceConnectionAccessEndpoint,
			"LogoutURL" -> $ServiceConnectionLogoutURL,
			If[TrueQ[OAuthClient`Private`$UseChannelFramework],
				{
					"RedirectURI"       -> "WolframConnectorChannelListen",
					"Blocking"          -> False,
					"VerifierLabel"     -> "code",
					"AuthenticationDialog"	:> "WolframConnectorChannel",
					"AuthorizationFunction"	-> "$ServiceConnection",
					"RedirectURLFunction"	->(#1&)
			   	 	},
				{
					"RedirectURI" -> "https://www.wolfram.com/oauthlanding?service=$ServiceConnection",
					"AuthenticationDialog" :>
						Replace[$servicesonnectionclientinfo,
							{
								{}|Except[_List]:>
									(OAuthClient`tokenOAuthDialog[#,
										"$ServiceConnection",
										Replace[
											$serviceconnectiondata["bigicon"],
											_serviceconnectiondata:>
												Replace[$serviceconnectiondata["icon"],
													_serviceconnectiondata:>
														Null
													]
											]
										]&),
								_->("fake-access-token"&)
								}]
				   }
	    		]
	   },
	  {}],
		{
			Normal[
				DeleteCases[Except[{__}]]@
					<|
						"Gets" -> 
							Flatten@{
								"RequestParameters","RequestData",$ServiceConnectionGets
								},
						"Posts" -> $ServiceConnectionPosts,
						"RawGets" -> $ServiceConnectionRawGets,
						"RawPosts" -> $ServiceConnectionRawPosts
						|>
				],
			If[$ServiceConnectionInformation=!=None,
				"Information" -> $ServiceConnectionInformation,
				Nothing
				]
			}
		}


$$serviceconnectionicon=$ServiceConnectionIcon;
With[{icon=
	If[ListQ@$$serviceconnectionicon,
		First@$$serviceconnectionicon,
		$$serviceconnectionicon]
		},
	If[icon=!=None,
		$serviceconnectiondata["icon"]:=
			Which[
				icon===Automatic,
					Replace[
						FrontEndExecute@
							FrontEnd`FindFileOnPath[
								"$serviceconnection.png",
								"PrivatePathsBitmaps"
								],{
						s_String:>Import[s],
						$Failed->None
						}],
				StringQ@icon&&FileExistsQ@icon,
					Import[icon],
				True,
					icon
				]
		]
	];
Replace[
	FrontEndExecute@
		FrontEnd`FindFileOnPath[
			"$serviceconnection@2.png",
			"PrivatePathsBitmaps"
			],{
	s_String:>
		($serviceconnectiondata["bigicon"]:=Import[s]),
	$Failed->None
	}];


(* ::Subsubsection:: *)
(*Call Data*)


KeyValueMap[
	Function[
		$serviceconnectiondata[#] := 
			ReplacePart[Association@#2,
				"BodyData":>
					Append["ParameterlessBodyData"->"ParameterlessBodyData"]@
					Replace[Lookup[#2,"BodyData",{}],
						l:{__String}:>
							Thread[l->l]
						]
				]
			],
	$ServiceConnectionCalls
	]


(* ::Subsubsection:: *)
(*Cooked Data*)


$serviceconnectioncookeddata[req_, id_] :=
    $serviceconnectioncookeddata[req, id,{}]

$serviceconnectioncookeddata[___] :=
    $Failed

$serviceconnectioncookeddata["RequestData",id_, {_->query_}]:=
	$serviceconnectioncookeddata["RequestData",id,query];
$serviceconnectioncookeddata["RequestParameters",id_, {_->query_}]:=
	$serviceconnectioncookeddata["RequestParameters",id,query];
	
$serviceconnectioncookeddata["RequestData",id_, _->query_]:=
	$serviceconnectioncookeddata["RequestData",id,query]
$serviceconnectioncookeddata["RequestParameters",id_, _->query_]:=
	$serviceconnectioncookeddata["RequestParameters",id,query]

$serviceconnectioncookeddata["RequestParameters",id_,All|{}]:=
	$serviceconnectioncookeddata["RequestParameters",id,
		Lookup[$serviceconnectiondata[],{"Gets","Posts"}]//Flatten//Sort
		];
$serviceconnectioncookeddata["RequestData",id_,All|{}]:=
	$serviceconnectioncookeddata["RequestData",id,
		Lookup[$serviceconnectiondata[],{"Gets","Posts"}]//Flatten//Sort
		];

$serviceconnectioncookeddata["RequestParameters",id_, queries:{__String}]:=
	AssociationThread[
		queries,
		$serviceconnectioncookeddata["RequestParameters",id,#]&/@Flatten@queries
		];		
$serviceconnectioncookeddata["RequestData",id_,queries:{__String}]:=
	AssociationThread[
		queries,
		$serviceconnectioncookeddata["RequestData",id,#]&/@Flatten@queries
		];
	

$serviceconnectioncookeddata["RequestParameters",id_, query_String]:=
	Replace[$serviceconnectioncookeddata["RequestData",id,query],
		a_Association:>
			<|
				"Parameters"->
					DeleteCases[
						Replace[Flatten@Lookup[a,{"Path","Parameters","BodyData","MultipartData"}],
							r_Rule:>First@r,
							1
							],
						"ParameterlessBodyData"
						],
				"Required"->Lookup[a,"RequiredParameters"]
				|>
		];
$serviceconnectioncookeddata["RequestData",id_, query_String]:=
	Replace[
		Replace[
			Quiet[
				Check[ServiceConnections`Private`getQueryData[id,query],$Failed],
				Lookup::invrl
				],
			$Failed:>
				Replace[
					Quiet[
						Check[ServiceConnections`Private`getQueryData[id,"Raw"<>query],$Failed],
						Lookup::invrl
					],
					$Failed:>
						FirstCase[
							Select[
								DownValues@$serviceconnectioncookeddata,
								!FreeQ[First@#,query]&
								],
							With[{fn=
								Switch[$ServiceConnectionClientName,
									"OAuthClient"|"oauthclient"|"OauthClient",
										OAuthClient`rawoauthdata,
									"KeyClient"|"keyclient",
										KeyClient`rawkeydata,
									"OtherClient"|"otherclient",
										OtherClient`rawotherdata
									]
								},
								HoldPattern[fn[_,q_,___]]:>
										$serviceconnectioncookeddata["RequestData",id, q]
								],
							Missing["UnkownRequest"]	
							]
					]
			],
			l_List:>
				AssociationThread[
					{
						"URL",
						"Method",
						"Path",
						"Parameters",
						"BodyData",
						"MultipartData",
						"Headers",
						"RequiredParameters",
						"RequiredPermissions",
						"ReturnContentData",
						"IncludeAuth"
						},
					l
					]
		];


KeyValueMap[
	With[{
		callName=#,
		baseCall=Lookup[#2,"Call"],
		processFunction=
			If[AssociationQ@#2,
				Lookup[#2,"Import",Identity],
				#2
				],
		postFunction=
			If[AssociationQ@#2,
				Lookup[#2,"Post",Identity],
				#2
				]
		},
		If[!MissingQ@baseCall,
			$serviceconnectioncookeddata[callName, id_,args_] :=
				postFunction@
	   	 	Block[{ params = Association[args] },
		    		Replace[
		     	  processFunction[
		     	  	Switch[$ServiceConnectionClientName,
						"OAuthClient"|"oauthclient"|"OauthClient",
							OAuthClient`rawoauthdata,
						"KeyClient"|"keyclient",
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
								If[Length@bodyParams>0,
								params=
									Normal@
									Merge[{
										params,
										"ParameterlessBodyData"->
											Function[
												If[StringQ@bodyData,
													StringJoin@{
														"[\n",bodyData,",\n",
														ExportString[Normal@#,"JSON"]/.
															f_File:>
																Import[f,"Text"],
														"\n]"
														},
													ExportString[
														Join[
															bodyData,
															Normal@#/.
																f_File:>
																	Import[f,"Text"]
															],
														"JSON"
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
							KeyClient`rawkeydata,
						"OtherClient"|"otherclient",
							OtherClient`rawotherdata
						][id,baseCall,Normal@params]],{
			       a:_?AssociationQ|{__?AssociationQ}:>
			       	Dataset[a]
			       }]
			    ],
			 $serviceconnectioncookeddata[callName, id_,args_] :=
			 	processFunction[id,args]
			 ]
		]&,
	$ServiceConnectionCookingFunctions
	];

$serviceconnectionsendmessage[___]:=$Failed

End[]

End[]

SetAttributes[{},{ReadProtected, Protected}];

(* Return three functions to define oauthservicedata, oauthcookeddata, oauthsendmessage*)

{
	$ServiceConnectionAPI`Private`$serviceconnectiondata,
	$ServiceConnectionAPI`Private`$serviceconnectioncookeddata,
	$ServiceConnectionAPI`Private`$serviceconnectionsendmessage
	}
