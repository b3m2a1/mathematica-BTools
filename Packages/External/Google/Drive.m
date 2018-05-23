(* ::Package:: *)



$GoogleDriveCalls::usage="";


GADriveRequest::usage="";
GADriveCall::usage="";


GAFileInfo::usage="";
GAFileSearch::usage="";
GAFileUpload::usage="";
GAFileUpdate::usage="";
GAFileDownload::usage="";
GAFileDownloadURL::usage="";
GAFileDelete::usage="";
GAFilePermissions::usage="";
GAFileCreatePermissions::usage="";
GAFileUpdatePermissions::usage="";
GAFileDeletePermissions::usage="";
GAFilePublish::usage="";
GAFilePrivatize::usage="";


Begin["`Private`"];


GADriveRequest[
	path:_String|{__String}|Nothing:Nothing,
	query:_Rule|{___Rule}:{},
	assoc:_Association:<||>
	]:=
	GARequest[
		"Drive",
		path,
		query,
		assoc
		];
GADriveCall[
	path:_String|{__String}|Nothing:Nothing,
	query:_Rule|{___Rule}:{},
	assoc:_Association:<||>
	]:=
	GACall@
		GADriveRequest[
			path,
			query,
			assoc
			];


GoogleDrive::err="\n``";


If[!AssociationQ@$GoogleDriveCalls,
	$GoogleDriveCalls=<||>
	];


GAPullContent//Clear;


GAPullContent[a_Association]:=
	Replace[a["Content"],""->Null];
GAPullContent[params_][a_Association]:=
	Fold[
		Replace[#,{
			assoc_Association:>
				Lookup[assoc,#2],
			""->Null
			}]&,
		a,
		Flatten@{"Content",params}
		];


$GAApplyRequests=True;


GAPullContent[req_HTTPRequest,stuff___]:=
	If[$GAApplyRequests=!=False,
		Replace[GACall[req,stuff],
			a_Association:>GAPullContent@a
			],
		req
		]
GAPullContent[params_][req_HTTPRequest,stuff___]:=
	If[$GAApplyRequests=!=False,
		Replace[GACall[req,stuff],
			a_Association:>
				GAPullContent[params][a]
			],
		req
		];


GAFilesRequest[
	path:Nothing|_String|_Association|{(_String|_Association)..}:Nothing,
	query:_Rule|{___Rule}:{},
	assoc:_Association:<||>
	]:=
	Block[{$GAVersion=3},
		GADriveRequest[
			Replace[
				Flatten@{"files",path},
				a_Association:>
					Lookup[a,"ID",Nothing],
				1
				],
			query,
			assoc
			]
		];


GAFileIDQ[id_String]:=
	StringMatchQ[
		id,
		Repeated[
			WordCharacter,
			{20,28}
			]|(
			Repeated[
				WordCharacter,
				{5,15}
				]~~"-"~~
				Repeated[
					WordCharacter,
					{5,15}
					]
				)
		];
GAFileIDQ[___]:=
	False;


$GAFileInfoParams=
	{
	"action","appInstalled","capabilities.canComment",
	"capabilities.canCopy","capabilities.canEdit","capabilities.canEdit",
	"capabilities.canShare","changes","changes.getStartPageToken",
	"comments","contentHints.indexableText","contentHints.thumbnail.image",
	"contentHints.thumbnail.mimeType","createdTime","createdTime",
	"createdTime","displayName","domain",
	"emailAddress","files","files.export",
	"files.get","files.get","files.get",
	"id","imageMediaMetadata.time","keepForever",
	"lastModifyingUser.displayName","lastModifyingUser.displayName","maxImportSizes",
	"maxUploadSize","me","modifiedByMeTime",
	"modifiedTime","modifiedTime","modifiedTime",
	"modifiedTime","name","newStartPageToken",
	"nextPageToken","nextPageToken","nextPageToken",
	"nextPageToken","ownedByMe","owners.displayName",
	"permissions","photoLink","quotedFileContent.mimeType",
	"quotedFileContent.value","removed","replies",
	"resolved","revisions","revisions.get",
	"role","sharedWithMeTime","size",
	"size","spaces","starred",
	"storageQuota.limit","storageQuota.limit","storageQuota.usage",
	"storageQuota.usageInDrive","storageQuota.usageInDriveTrash","time",
	"trashed","user.displayName","user.permissionId",
	"viewedByMe","viewedByMeTime","viewersCanCopyContent",
	"webViewLink"
	};


GAFileInfo[Optional[Automatic,Automatic]]:=
	GAPullContent["Files"]@
		GAFilesRequest[];
GAFileInfo[Full]:=
	GAPullContent["Files"]@
		GAFilesRequest["fields"->"files"];


GAFileInfo[
	fid:_String?GAFileIDQ,
	fields:_String|{___String}|None:None
	]:=
	GAPullContent@
		If[fields===None,
			GAFilesRequest[fid],
			GAFilesRequest[
				fid,
				"fields"->
					StringRiffle[
						Map[
							If[!LowerCaseQ@StringTake[#,1],
								ToLowerCase@StringTake[#,1]<>StringTake[#,{2,-1}],
								#
								]&,
							Flatten@{fields}
							],
						","
						]
				]
			];
GAFileInfo[
	a_Association?(KeyMemberQ["ID"]),
	fields:_String|{___String}|None:None
	]:=
	GAFileInfo[a["ID"],fields];
GAFileInfo[
	query_,
	fields:_String|{___String}|None:None
	]:=
	If[fields=!=None,
		GAFileInfo[#,fields]&/@#,
		#
		]&@GAFileSearch[query];


GAFileValueConvert//Clear
GAFileValueConvert[s_String]:=
	"'"<>s<>"'";
GAFileValueConvert[n_?NumberQ]:=
	ToString@n;
GAFileValueConvert[l_List]:=
	"[ "<>StringRiffle[GAFileValueConvert/@l,", "]<>" ]";
GAFileValueConvert[b:True|False]:=
	ToLowerCase@ToString@b
GAFileValueConvert[And[v__]]:=
	StringRiffle[Flatten@{"(",GAFileValueConvert/@v,")"}," and "];
GAFileValueConvert[Or[v__]]:=
	StringRiffle[Flatten@{"(",GAFileValueConvert/@v,")"}," or "];
GAFileValueConvert[Not[v_]]:=
	"not "<>GAFileValueConvert[v];
GAFileValueConvert[key_->v_]:=
	GAFileSearchConvert[key,v];
GAFileValueConvert[e_]:=ToString@e;


GAFileSearchConvert[key_,a_Association]:=
	StringRiffle[
		If[Lookup[a,"Order",1]<0//TrueQ,
			Reverse,
			Identity
			]@{
				key,
				Lookup[a,"Operator","="],
				GAFileValueConvert@Lookup[a,"Value"]
				},
			" "
			];


GAFileSearchConvert[key_,MemberQ[v_]]:=
	GAFileSearchConvert[key,
		<|
			"Operator"->"in",
			"Value"->v,
			"Order"->-1
			|>
		];
GAFileSearchConvert[key_,StringContainsQ[v_]]:=
	GAFileSearchConvert[key,
		<|
			"Operator"->"contains",
			"Value"->v
			|>
		];
GAFileSearchConvert[key_,o_String[v_]]:=
	GAFileSearchConvert[key,
		<|
			"Operator"->o,
			"Value"->v
			|>
		];
GAFileSearchConvert[key_,v_]:=
	GAFileSearchConvert[key,
		<|
			"Value"->v
			|>
		];


GAFileSearchStrings[a_Association]:=
	KeyValueMap[
		GAFileSearchConvert,
		a
		];


GAFileSearch[Verbatim[Verbatim][query_String]]:=
	GAPullContent["Files"]@
		GAFilesRequest["q"->query];
GAFileSearch[query:{__Rule}]:=
	GAFileSearch[
		Verbatim@
			StringRiffle[GAFileSearchStrings@Association@query," and "]
			];
GAFileSearch[Or[query__Rule]]:=
	GAFileSearch[
		Verbatim@
			StringRiffle[GAFileSearchStrings@Association[query]," or "]
			];
GAFileSearch[q_Rule]:=
	GAFileSearch[{q}];
GAFileSearch[Optional["Name","Name"],
	t:Except[_Rule],
	r___Rule]:=
	GAFileSearch[
		"name"->t,
		r]


GAFileUpload[
	file:(_String|_File)?FileExistsQ,
	metaData:_?OptionQ|Automatic|None:Automatic,
	mode:
		"File"|
		{"File"}|
		{"File","Metadata"}|
		{"Metadata","File"}|
		Automatic:
		Automatic,
	mimeType:_String|Automatic:Automatic,
	resumable:True|False|Automatic:False
	]:=
	With[{
		mD=Replace[metaData,Automatic:>{"name"->FileNameTake@file}],
		ulMode=
			Switch[
				Replace[mode,
					Automatic:>
						If[Length@Replace[metaData,Automatic:>{"name"->FileNameTake@file}]==0,
							"File",
							{"File","Metadata"}
							]
					],
				"File"|{"File"},
					"media",
				_,
					"multipart"
				],
		mT=Replace[mimeType,Automatic:>ImportExport`GetMIMEType@FileFormat[file]],
		bC=FileByteCount[file]
		},
		Block[{$GAVersion=3},
			GAPullContent@
			If[Not@Replace[resumable,Automatic:>bC>5*10^6],
				ReplacePart[#,
					{2,"Headers"}->
						Append[
							#[[2,"Headers"]],
							"Content-Length"->
								Length@#["BodyBytes"]
							]
					]&@
				GARequest[
					"UploadFile",
					Nothing,
					"uploadType"->
						ulMode,
					Switch[ulMode,
						"media",
							<|
								"Headers"->
									<|
										"Content-Type"->mT
										|>,
								"Body"->
										Import[Flatten[File@file,1,File],"Byte"]
								|>,
						"multipart",
							With[{break=CreateUUID["divider-"]},
								With[{bs=
									StringRiffle[
										{
												"--"<>break,
												"Content-Type: application/json; charset=UTF-8",
												"",
												ExportString[mD,"JSON"],
												"",
												"--"<>break,
												"Content-Type: "<>
													First[ToLowerCase/@Flatten@{mT}],
												"",
												ReadString[file],
												"",
												"--"<>break<>"--"
										},
									"\n"
									]
									},
								<|
									"Headers"->{
										"Content-Type"->"multipart/related; boundary="<>break
										},
									"Body"->
										bs
									|>
								]
							]
						]
					],
				ReplacePart[#,
					{2,"Headers"}->
						Append[
							#[[2,"Headers"]],
							"X-Upload-Content-Length"->
								Length@#["BodyBytes"]
							]
					]&@
				GARequest[
					"UploadFile",
					Nothing,
					"uploadType"->
						"resumable",
					Switch[ulMode,
						"media",
							<|
								"Headers"->{
									"X-Upload-Content-Type"->mT
									}
								|>,
						"multipart",
							With[{md=
								ExportString[mD,"JSON"]
								},
								<|
									"Headers"->{
										"Content-Type"->"application/json; charset=UTF-8",
										"X-Upload-Content-Type"->mT,
										"X-Upload-Content-Length"->bC
										},
									"Body"->md
									|>
								]
						]
					]
				]
			]
		];


GAFileUpdate[
	fid:_String?GAFileIDQ|_Association?(KeyMemberQ["ID"]),
	file:(_File|_String)?FileExistsQ,
	metaData:_?OptionQ|None:None,
	mimeType:_String|Automatic:Automatic,
	resumable:True|False|Automatic:False
	]:=
	With[{
		mD=Replace[metaData,Automatic:>{"name"->FileNameTake@file}],
		ulMode=
			Switch[
				If[Length@Replace[metaData,Automatic:>{"name"->FileNameTake@file}]==0,
					"File",
					{"File","Metadata"}
					],
				"File"|{"File"},
					"media",
				_,
					"multipart"
				],
		mT=Replace[mimeType,Automatic:>ImportExport`GetMIMEType@FileFormat[file]],
		bC=FileByteCount[file]
		},
		Block[{$GAVersion=3},
			GAPullContent@
			If[Not@Replace[resumable,Automatic:>bC>5*10^6],
				ReplacePart[#,
					{2,"Headers"}->
						Append[
							#[[2,"Headers"]],
							"Content-Length"->
								Length@#["BodyBytes"]
							]
					]&@
				GARequest[
					"UploadFile",
					If[AssociationQ@fid,fid["ID"],fid],
					"uploadType"->
						ulMode,
					Switch[ulMode,
						"media",
							<|
								"Method"->"PATCH",
								"Headers"->
									<|
										"Content-Type"->mT
										|>,
								"Body"->
										Import[Flatten[File@file,1,File],"Byte"]
								|>,
						"multipart",
							With[{break=CreateUUID["divider-"]},
								With[{bs=
									StringRiffle[
										{
												"--"<>break,
												"Content-Type: application/json; charset=UTF-8",
												"",
												ExportString[mD,"JSON"],
												"",
												"--"<>break,
												"Content-Type: "<>
													First[ToLowerCase/@Flatten@{mT}],
												"",
												ReadString[file],
												"",
												"--"<>break<>"--"
										},
									"\n"
									]
									},
								<|
									"Method"->"PATCH",
									"Headers"->{
										"Content-Type"->"multipart/related; boundary="<>break
										},
									"Body"->
										bs
									|>
								]
							]
						]
					],
				ReplacePart[#,
					{2,"Headers"}->
						Append[
							#[[2,"Headers"]],
							"X-Upload-Content-Length"->
								Length@#["BodyBytes"]
							]
					]&@
				GARequest[
					"UploadFile",
					If[AssociationQ@fid,fid["ID"],fid],
					"uploadType"->
						"resumable",
					Switch[ulMode,
						"media",
							<|
								"Method"->"PATCH",
								"Headers"->{
									"X-Upload-Content-Type"->mT
									}
								|>,
						"multipart",
							With[{md=
								ExportString[mD,"JSON"]
								},
								<|
									"Method"->"PATCH",
									"Headers"->{
										"Content-Type"->"application/json; charset=UTF-8",
										"X-Upload-Content-Type"->mT,
										"X-Upload-Content-Length"->bC
										},
									"Body"->md
									|>
								]
						]
					]
				]
			]
		];
GAFileUpdate[
	fid:_String?GAFileIDQ|_Association?(KeyMemberQ["ID"]),
	file:None:None,
	params:_?OptionQ:{},
	metaData:_?OptionQ
	]:=
	GAPullContent@
		GAFilesRequest[fid,
			params,
			<|
				"Method"->"PATCH",
				"Body"->metaData
				|>
			]


GAFileDownload[
	fid_String?GAFileIDQ,
	path:(_String|_File)?(DirectoryQ@*DirectoryName)|Automatic:Automatic
	]:=
	If[Between[#StatusCode,{200,299}],
		Export[
			Replace[path,{
				Automatic:>
					FileNameJoin@{
						$TemporaryDirectory,
						Key["Name"]@GAFileInfo[fid,"Name"]
						},
				_?DirectoryQ:>
					FileNameJoin@{
						path,
						Key["Name"]@GAFileInfo[fid,"Name"]
						}
				}],
			#BodyBytesArray,
			"Byte"
			],
		$Failed
		]&@
		GAPullContent[
			GAFilesRequest[
				fid,
				"alt"->"media"
				],
			"BodyByteArray"
			];
GAFileDownload[
	query_,
	path:(_String|_File)?(DirectoryQ@*DirectoryName)|Automatic:Automatic
	]:=
	With[{
		p=Replace[path,Automatic:>$TemporaryDirectory]
		},
		If[DirectoryQ@p,
			If[Length@#>1,
				GAFileDownload[
					#ID,
					(If[!DirectoryQ@DirectoryName@#,	
						CreateDirectory@DirectoryName@#
						];#)&@FileNameJoin@Flatten@{p,GAFilePath@#ID}
					]&/@#,
				GAFileDownload[#ID,
					(If[!DirectoryQ@DirectoryName@#,	
						CreateDirectory@DirectoryName@#
						];#)&@FileNameJoin@{p,#Name}
					]&@First@#
				],
			GAFileDownload[
				#ID,
				p
				]&@First@#
			]&@
			GAFileSearch[query]
		];


GAFileDownloadURL[fid_]:=
	GAFilesRequest[
		fid,
		"alt"->"media"
		]["URL"]


GAFileDelete[fid_String?GAFileIDQ]:=
	GAPullContent@
		GAFilesRequest[
			fid,
			<|
				"Method"->"DELETE"
				|>
			];
GAFileDelete[a_Association?(KeyMemberQ["ID"])]:=
	GAFileDelete@a["ID"];


GAFileParents[fid_String?GAFileIDQ]:=
	Lookup[
		GAFileInfo[fid,"parents"],
		"Parents",
		None
		]


GAFileChildren[fid_String?GAFileIDQ]:=
	Lookup[
		GAFileInfo[fid,"Children"],
		"Children",
		None
		]


GAFilePath[fid_String?GAFileIDQ]:=
	Key["Name"]@
		GAFileInfo[#,"Name"]&/@
			Rest@Cases[_String]@
				Reverse@
					FixedPointList[
						Replace[
							If[StringQ@#,
								GAFileParents@#,
								None
								],{
							{f_,___}:>f,
							{}->None
							}]&,
						fid
						]


GAFilePermissions[fid_String?GAFileIDQ]:=
	Fold[
		Lookup,
		GAPullContent@
			GAFilesRequest[
				{fid,"permissions"}
				],
		{"Content","Permissions"}
		];
GAFilePermissionsInfo[
	fid_String?GAFileIDQ,
	pid_String
	]:=
	GAPullContent@
		GAFilesRequest[
			{fid,"permissions",pid}
			];
GAFilePermissions[
	a_Association?(KeyMemberQ["ID"])
	]:=
	GAFilePermissions[a["ID"]];
GAFilePermissions[
	a_Association?(KeyMemberQ["ID"]),
	pid_String
	]:=
	GAFilePermissions[a["ID"],pid];
GAFilePermissions[
	fid:_String?GAFileIDQ|_Association?(KeyMemberQ["ID"]),
	pid_Association?(KeyMemberQ["ID"])
	]:=
	GAFilePermissions[fid,pid["ID"]]


GAPermissionsRoleQ[s_String]:=
	StringMatchQ[ToLowerCase@s,
		"organizer"|"owner"|"writer"|
			"commentator"|"reader"
		];
GAPermissionsGrantQ[s_String]:=
	StringMatchQ[ToLowerCase@s,
		"user"|"group"|"domain"|"anyone"
		];


GAFileCreatePermissions[
	fid_String?GAFileIDQ,
	role:_?GAPermissionsRoleQ:"reader",
	grant:_?GAPermissionsGrantQ:"user",
	params:_?OptionQ:{}
	]:=
	GAPullContent@
	GAFilesRequest[
		{fid,"permissions"},
		FilterRules[
			params,
			"emailMessage"|"sendNotificationEmail"|
				"supportsTeamDrives"|"transferOwnership"
			],
		<|
			"Method"->"POST",
			"Headers"->{
				"Content-Type"->"application/json"
				},
			"Body"->
				ExportString[
					FilterRules[
						Flatten@{
							"role"->role,
							"type"->grant,
							params
							},
						Except[
							"emailMessage"|"sendNotificationEmail"|
								"supportsTeamDrives"|"transferOwnership"
							]
						],
					"JSON"
					]
			|>
		];
GAFileCreatePermissions[
	a_Association?(KeyMemberQ["ID"]),
	role:_?GAPermissionsRoleQ:"reader",
	grant:_?GAPermissionsGrantQ:"user",
	params:_?OptionQ:{}
	]:=
	GAFileCreatePermissions[a["ID"],role,grant,params]


GAFileUpdatePermissions[
	fid_String?GAFileIDQ,
	pid_String,
	role:_?GAPermissionsRoleQ:"reader",
	params:_?OptionQ:{}
	]:=
	GAPullContent@
	GAFilesRequest[
		{fid,"permissions",pid},
		FilterRules[
			params,
			"removeExpiration"|"supportsTeamDrives"|
				"transferOwnership"
			],
		<|
			"Method"->"PATCH",
			"Headers"->{
				"Content-Type"->"application/json"
				},
			"Body"->
				FilterRules[
					Flatten@{
						"role"->role,
						params
						},
					Except[
						"removeExpiration"|"supportsTeamDrives"|
							"transferOwnership"
						]
					]
			|>
		];
GAFileUpdatePermissions[
	a_Association?(KeyMemberQ["ID"]),
	pid_String,
	role:_?GAPermissionsRoleQ:"reader",
	params:_?OptionQ:{}
	]:=
	GAFileUpdatePermissions[a["ID"],pid,role,params]


GAFileDeletePermissions[
	fid_String?GAFileIDQ,
	pid_String
	]:=
	GAPullContent@
		GAFilesRequest[
			{fid,"permissions",pid},
			<|
				"Method"->"DELETE"
				|>
			];
GAFileDeletePermissions[
	fid_String?GAFileIDQ,
	a_Association?(KeyMemberQ["ID"])
	]:=
	GAFileDeletePermissions[fid,a["ID"]]
GAFileDeletePermissions[
	a_Association?(KeyMemberQ["ID"]),
	pid:_String|_Association?(KeyMemberQ["ID"])
	]:=
	GAFileDeletePermissions[a["ID"],pid]


GAFilePublish[fid_,
	role:_?GAPermissionsRoleQ:"reader",
	allowDiscovery:True|False:True
	]:=
	GAFileCreatePermissions[fid,
		role,
		"anyone",
		"allowFileDiscovery"->allowDiscovery
		]


GAFilePrivatize[fid_]:=
	(GAFileDeletePermissions[fid,#]&/@
		Select[GAFilePermissions[fid],
			#Type=="anyone"&
			];);


End[];



