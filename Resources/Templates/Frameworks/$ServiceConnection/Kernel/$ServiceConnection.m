(* ::Package:: *)

(* ::Section:: *)
(*$ServiceConnection Service Connection*)


(* ::Text:: *)
(**)


(*This is a service connection for $ServiceConnection built via template. It is designed to generalize building a service connection paclet, and so there may be odd form
atting and functionality that is never used.*)


(* ::Subsection:: *)
(*Standard Load*)


Get["$ServiceConnectionFunctions`"]


(* ::Subsubsection::Closed:: *)
(*Begin*)


Begin["$ServiceConnectionAPI`"]

Begin["`Private`"]


(* ::Subsubsection::Closed:: *)
(*Template Info*)


(* ::Text:: *)
(*Aliases to improve readability*)


$serviceconnectionurlfetchfun=
	$ServiceConnectionURLFetch;


$$serviceconnectionusecloud=
	$ServiceConnectionCloudCredentialsQ;


$serviceconnectionclientinfo=
	$ServiceConnectionClientInfo;


$$serviceconnectionclientname=
	$ServiceConnectionClientName;


$$serviceconnectionredirecturi:=
	$$serviceconnectionredirecturi=
		Replace[$ServiceConnectionRedirectURI,{
				Key[x_]:>$serviceconnectionprivateoauthpagelink[x],
				Delayed[x_]:>$serviceconnectionprivateoauthcloudlink[x]
				}];


$$serviceconnectionrawgetrequests=
	$ServiceConnectionRawGets;


$$serviceconnectionrawpostrequests=
	$ServiceConnectionRawPosts;


$$serviceconnectiongetrequests=
	$ServiceConnectionGets;


$$serviceconnectionpostrequests=
	$ServiceConnectionPosts;


$$serviceconnectioninformation=
	$ServiceConnectionInformation;


$$serviceconnectionuseoauth=
	$ServiceConnectionUseOAuth//TrueQ;


$$serviceconnectionclientid:=
	Replace[
		Replace[$ServiceConnectionClientID,{
			f_Function:>f[],
			Automatic:>
				$serviceconnectiongetclientdata["ClientID"],
			Key[k_]:>
				$serviceconnectiongetclientdata[k]
			}],{
		Except[_String]:>
			"not_supported"
		}];


$$serviceconnectionclientsecret:=
	Replace[
		Replace[$ServiceConnectionClientSecret,{
			f_Function:>f[],
			Automatic:>
				$serviceconnectiongetclientdata["ClientSecret"],
			Key[k_]:>
				$serviceconnectiongetclientdata[k]
			}],{
		Except[_String]:>
			"not_supported"
		}];


$$serviceconnectionauthendpoint:=
	$ServiceConnectionAuthEndpoint;


$$serviceconnectionaccessendpoint:=
	$ServiceConnectionAccessEndpoint;


$$serviceconnectionauthresponsetype:=
	Replace[$ServiceConnectionAuthResponseType,
		Except[_String]:>
			If[StringQ@$$serviceconnectionclientid,
				"code",
				None
				]
		];


$$serviceconnectionauthscope:=
	$ServiceConnectionAuthScope


$$serviceconnectionlogouturl=
	$ServiceConnectionLogoutURL;


$$serviceconnectiontermsofserviceurl=
	$ServiceConnectionTermsOfServiceURL;


$$serviceconnectionstate:=
	$$serviceconnectionstate=
		$ServiceConnectionState;


$$serviceconnectionauthorizationendpointurl[url_String]:=
	URLBuild@
	ReplacePart[#,
		"Query":>
			DeleteDuplicatesBy[First]@
				DeleteCases[_->(_Symbol|_String?(StringMatchQ[""|Whitespace]))]@
				#["Query"]
		]&@
		Merge[{
			"Query"->
				Normal@
				DeleteCases[Except[_String|_Integer]]@
					AssociationThread[
						{
							"client_id",
							"redirect_uri",
							"response_type",
							"state",
							"scope"
							},
						{
							$$serviceconnectionclientid,
							$$serviceconnectionredirecturi,
							$$serviceconnectionauthresponsetype,
							$$erviceconnectionstate,
							$$serviceconnectionauthscope
							}
						],
				URLParse@url
				},
				Replace[{f_}:>f]@*Flatten
				];
$$serviceconnectionauthorizationendpointurl[e_]:=e


(* ::Text:: *)
(*These are requisitioned in case I need to re-overload them with more complex functionality*)


$$serviceconnectionaccesstokenendpoint:=
	$$serviceconnectionaccessendpoint;


$$serviceconnectionauthorizationendpoint:=
	$$serviceconnectionauthendpoint


$$serviceconnectionaccesstokenrequestor:=
	Replace[$ServiceConnectionAccessTokenRequestor,
		Except[_Function|_String]->Automatic
		]


$$serviceconnectionaccesstokenextractor:=
	Replace[$ServiceConnectionAccessTokenExtractor,
		Except[_Function|_String]->"JSON/2.0"
		]


(* ::Subsubsection:: *)
(*Auth Info*)


(* ::Text:: *)
(*Primary auth information*)


$serviceconnectiondata[] =
	DeleteDuplicatesBy[First]@Flatten@{
		"ServiceName" -> "$ServiceConnection",
		"URLFetchFun" :> $serviceconnectionurlfetchfun,
		"ClientInfo" :>
			Replace[$serviceconnectionclientinfo,
				{
					{}|Except[_List]:>
						If[$$serviceconnectionuseoauth,
							{"Wolfram","Token"},
							{}
							],
					o_?OptionQ:>
						OAuthDialogDump`Private`MultipleKeyDialog[
							"$ServiceConnection",
							Flatten@{o},
							$$serviceconnectionauthorizationendpointurl@
								$$serviceconnectionauthorizationendpoint,
							$$serviceconnectiontermsofserviceurl
							]
					}],
		If[$$serviceconnectionuseoauth,
			{
				"OAuthVersion" -> "2.0",
				"AuthorizeEndpoint" :>
					$$serviceconnectionauthorizationendpoint,
				"AccessEndpoint" :>
					$$serviceconnectionaccesstokenendpoint,
				"LogoutURL" :> $$serviceconnectionlogouturl,
				If[TrueQ[OAuthClient`Private`$UseChannelFramework],
					(* ------- FUTURIZED (?) FORM INTEGRATING WITH CHANNELS ------ *)
					{
						"RedirectURI"       -> "WolframConnectorChannelListen",
						"Blocking"          -> False,
						"VerifierLabel"     -> "code",
						"AuthenticationDialog"	:> "WolframConnectorChannel",
						"AuthorizationFunction"	-> "$ServiceConnection",
						"RedirectURLFunction"	->(#1&)
				   	},
					(* ------- STANDARD (?) FORM FOR OAUTH ------ *)
					{
						"ConsumerKey":>
							$$serviceconnectionclientid,
						"ConsumerSecret":>
							$$serviceconnectionclientsecret,
						"AccessTokenRequestor":>
							$$serviceconnectionaccesstokenrequestor,
						"AccessTokenExtractor":>
							$$serviceconnectionaccesstokenextractor,
						"AutomaticScope":>
							$$serviceconnectionauthscope,
						"ScopeParameter":>
							$$serviceconnectionauthscope,
						"RedirectURI" :>
							Replace[$$serviceconnectionredirecturi,{
								Key[x_]:>$serviceconnectionprivateoauthpagelink[x],
								Except[_String|_Function]->
									"https://www.wolfram.com/oauthlanding?service=$ServiceConnection"
								}],
						"AuthenticationDialog" :>
							Replace[$$servicesonnectionclientinfo,
								{
									{}|Except[_List]:>
										(
										OAuthClient`tokenOAuthDialog[
												$$serviceconnectionauthorizationendpointurl@#,
												"$ServiceConnection",
												Replace[
													$serviceconnectiondata["bigicon"],
													_serviceconnectiondata:>
														Replace[$serviceconnectiondata["icon"],
															_serviceconnectiondata:>
																Sequence@@{}
															]
													]
												]&),
									_->($serviceconnectionprivateoauthtokenfile[]&)
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
									"RequestParameters","RequestData",
									$$serviceconnectiongetrequests
									},
							"Posts" -> $$serviceconnectionpostrequests,
							"RawGets" -> $$serviceconnectionrawgetrequests,
							"RawPosts" -> $$serviceconnectionrawpostrequests
							|>
					],
				If[$$serviceconnectioninformation=!=None,
					"Information" -> $$serviceconnectioninformation,
					Nothing
					]
				}
			}


(* ::Subsubsection::Closed:: *)
(*icons*)


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


(* ::Subsubsection::Closed:: *)
(*Raw Import Functions*)


$$serviceconnectioncalls=$ServiceConnectionCalls;


KeyValueMap[
	Function[
		$serviceconnectiondata[#] :=
			ReplacePart[
				Association@#2
				(*Join[
					<|
						"ResultsFunction"->$serviceconnectionurlfetchfun
	   	 		|>,
					Association@#2
					]*),
				"BodyData":>
					Append["ParameterlessBodyData"->"ParameterlessBodyData"]@
					Replace[Lookup[#2,"BodyData",{}],
						l:{__String}:>
							Thread[l->l]
						]
				]
			],
	$$serviceconnectioncalls
	]


(* ::Subsubsection:: *)
(*Request Data*)


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
						Replace[
							DeleteMissing@
								Flatten@
									Lookup[a,{"Path","Parameters","BodyData","MultipartData"}],
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
									HoldPattern[
										Switch[$$serviceconnectionclientname,
											"OAuthClient"|"oauthclient"|"OauthClient",
												OAuthClient`rawoauthdata,
											"KeyClient"|"keyclient",
												KeyClient`rawkeydata,
											"OtherClient"|"otherclient",
												OtherClient`rawotherdata
											]
										]
									},
									HoldPattern[fn[_,q_,___]]:>
										$serviceconnectioncookeddata["RequestData",id, q]
									],
								Quiet[
									Check[$serviceconnectionpsuedodata[id,query], Missing["UnknownRequest"]],
									Lookup::invrl
									],
								Infinity
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


(* ::Subsubsection:: *)
(*Cooked Data Functions*)


(* ::Text:: *)
(*This is the heart of the paclet. Take the template parameters and turn them into request functions.*)


$$serviceconnectioncookingfunctions=$ServiceConnectionCookingFunctions;
KeyValueMap[
	With[{
		callName=#,
		baseCall=Lookup[#2,"Call"],
		defaultPars=
			Association@Flatten@List@Lookup[#2,"Default",{}],
		reqParams=Lookup[#2,"Required",{}],
		paramList=Lookup[#2,"Parameters",{}],
		prePreFunction=
			If[AssociationQ@#2,
				Lookup[#2,"CleanArguments",Identity],
				#2
				],
		preFunction=
			If[AssociationQ@#2,
				Lookup[#2,"Pre",#3&],
				#2
				],
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
		With[{
			basePseudo=
				{
						"URL"->Lookup[#2,"URL",Missing["NotAvailable"]],
						"Method"->Lookup[#2,"Method",Missing["NotAvailable"]],
						"Path"->Lookup[#2,"Path",{}],
						"Parameters"->paramList,
						"BodyData"->Lookup[#2,"BodyData",Missing["NotAvailable"]],
						"MultipartData"->Lookup[#2,"MultipartData",Missing["NotAvailable"]],
						"Headers"->Lookup[#2,"Headers",{}],
						"RequiredParameters"->reqParams,
						"RequiredPermissions"->Lookup[#2,"RequiredPermissions",{}],
						"ReturnContentData"->Lookup[#2,"ReturnContentData",False],
						"IncludeAuth"->Lookup[#2,"IncludeAuth",True]
						}
			},
		If[!MissingQ@baseCall,
			(* insert parameter data for later lookup *)
			$serviceconnectionpsuedodata[id_,callName]:=
				Merge[
					{
						Replace[
							$serviceconnectioncookeddata["RequestData",id,baseCall],
							_Missing->{}
							],
						basePseudo
						},
					Replace[{{s_String,_}:>s,{_,e_}:>e,l_:>DeleteDuplicates[Join@@l]}]
					];
			$serviceconnectioncookeddata[callName, id_,args_] :=
				postFunction@
	   	 	Block[{
	   	 		params = prePreFunction@Join[defaultPars,Association[args]],
	   	 		$$serviceconnectionlastrequest
	   	 		},
	   	 		ServiceConnections`Private`urlfetchFun[id]=
	   	 			$serviceconnectionurlfetchfun;
	   	 	If[MatchQ[$$serviceconnectionclientname,"KeyClient"|"keyclient"],
	   	 		params=
	   	 			$serviceconnectionreformatbodydata[
								If[MatchQ[baseCall,_Function],baseCall[params],baseCall],
									id,
									params
									]
							];
		    	Replace[
		     	  processFunction[
		     	  	Switch[$$serviceconnectionclientname,
									"OAuthClient"|"oauthclient"|"OauthClient",
										OAuthClient`rawoauthdata,
									"KeyClient"|"keyclient",
										KeyClient`rawkeydata,
									"OtherClient"|"otherclient",
										OtherClient`rawotherdata
									][id,
										If[MatchQ[baseCall,_Function],baseCall[params],baseCall],
										Normal@
											preFunction[
												If[MatchQ[baseCall,_Function],
													baseCall[params],
													baseCall],
												id,
												params
												]
										]
									],{
			       a:_?AssociationQ|{__?AssociationQ}:>
			       	Dataset[a]
			       }]
			    ],
			 $serviceconnectionpsuedodata[_,callName]=
			 	basePseudo;
			 $serviceconnectioncookeddata[
	 			"RequestData",
 				_,
 				callName]:=
 				<|
 					"URL"->Missing["NotAvailable"],
 					"Method"->Missing["NotAvailable"],
 					"Path"->Missing["NotAvailable"],
 					"Parameters"->paramList,
 					"BodyData"->Missing["NotAvailable"],
 					"MultipartData"->Missing["NotAvailable"],
 					"Headers"->Missing["NotAvailable"],
 					"RequiredParameters"->reqParams,
 					"RequiredPermissions"->Missing["NotAvailable"],
 					"ReturnContentData"->Missing["NotAvailable"],
 					"IncludeAuth"->Missing["NotAvailable"]
 					|>;
			 $serviceconnectioncookeddata[callName, id_,args_] :=
			 	Block[{
			 		params =
			 			preFunction[
				 			callName,
				 			id,
				 			Join[defaultPars,Association[args]]
				 			],
			 		req = reqParams,
			 		pars = paramList,
			 		$$serviceconnectionlastrequest
			 		},
			 		Catch[
			 			With[{missing=
				 			Select[req,
				 				With[{p=#},
				 					!AnyTrue[Keys@params,StringMatchQ[#,p]&]
				 					]&
				 				]
				 			},
				 			If[Length@missing>0,
				 				Message[
				 					ServiceExecute::nparam,
				 					#
				 					]&/@missing;
									Throw@$Failed
				 				]
				 			];
				 		With[{extra=
				 			Select[Keys@params,
				 				With[{k=#},
				 					!AnyTrue[pars,StringMatchQ[k,#]&]
				 					]&
				 				]
				 			},
				 			If[Length@extra>0,
				 				Message[
				 					ServiceExecute::noget,
				 					#,
				 					"$ServiceConnection"
				 					]&/@extra;
									Throw@$Failed
				 				]
				 			];
							processFunction[id,params]
			 			]
			 		]
			 ]
			]
		]&,
	$$serviceconnectioncookingfunctions
	];


$serviceconnectionpsuedodata[_,_]:=$Failed


(* ::Subsubsection::Closed:: *)
(*Send Message*)


$serviceconnectionsendmessage[___]:=$Failed


(* ::Subsection::Closed:: *)
(*End*)


End[]

End[]

SetAttributes[{},{ReadProtected, Protected}];

(* Return three functions to define oauthservicedata, oauthcookeddata, oauthsendmessage*)

{
	$ServiceConnectionAPI`Private`$serviceconnectiondata,
	$ServiceConnectionAPI`Private`$serviceconnectioncookeddata,
	$ServiceConnectionAPI`Private`$serviceconnectionsendmessage
	}
