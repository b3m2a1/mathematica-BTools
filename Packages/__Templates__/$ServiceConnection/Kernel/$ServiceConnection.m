(* ::Package:: *)

Get["$ServiceConnectionFunctions`"]

Begin["$ServiceConnectionAPI`"]

Begin["`Private`"]

(******************************* $ServiceConnection *************************************)


(* Authentication information *)
$serviceconnectiondata[] = 
DeleteDuplicatesBy[First]@Flatten@{

	"ServiceName" -> "$ServiceConnection",
	"URLFetchFun" :> $ServiceConnectionURLFetch,
	
	If[$ServiceConnectionUseOAuth//TrueQ,
		{
			"OAuthVersion" -> "2.0",
			"AuthorizeEndpoint" -> $ServiceConnectionAuthEndpoint,
			"AccessEndpoint" -> $ServiceConnectionAccessEndpoint,
			"ClientInfo" -> {"Wolfram","Token"},
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
	    	"RedirectURI" -> 
						"https://www.wolfram.com/oauthlanding?service=$ServiceConnection",
	    	"AuthenticationDialog" :>
	    		(OAuthClient`tokenOAuthDialog[#,
							"$ServiceConnection",
							$serviceconnectiondata["icon"]
							]&)
	       }
	    ]
	   },
	  {
	  	"ClientInfo" :> 
	  		Replace[$ServiceConnectionClientInfo,
	  			{
	  				{}|Except[_List]->{},
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
	  				}]
	  	}],
		{
				Normal[
					DeleteCases[Except[{__}]]@
						<|
							"Gets" -> $ServiceConnectionGets,
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


(* ::Subsubsection:: *)
(*Call Data*)


KeyValueMap[
	Function[$serviceconnectiondata[#] := #2],
	$ServiceConnectionCalls
	]


(* ::Subsubsection:: *)
(*Cooked Data*)


$serviceconnectioncookeddata[req_, id_] :=
    $serviceconnectioncookeddata[req, id,{}]

$serviceconnectioncookeddata[___] :=
    $Failed
    
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
	   	 	Block[ {params = Association[args]},
		    		Replace[
		     	  processFunction[KeyClient`rawkeydata[id,baseCall,Normal@params]],{
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
