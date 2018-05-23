(* ::Package:: *)



GoogleAPIData::usage=
	"A manager for Google API data";


GoogleDrive::usage=
	"A standard head for accessing the Google Drive API";


GoogleAnalytics::usage=
	"A standard head for accessing the Google Analytics API";


Begin["`Private`"];


(* ::Subsection:: *)
(*GoogleAPIData*)



(* ::Subsubsection::Closed:: *)
(*Calls*)



$GoogleAPIDataCalls=
	<|
		"Username"->
			($GoogleAPIUsername&),
		"ClientID"->
			($GAClientID&),
		"ClientSecret"->
			($GAClientSecret&),
		"Authenticate"->
			GAOAuthenticate,
		"AuthenticationData"->
			GAOAuthTokenData,
		"SetUsername"->
			(If[StringQ@#&&
					StringMatchQ[
						StringTrim[#, "@gmail.com"], 
						(WordCharacter|"_"|"."|"-")..
						],
				$GoogleAPIUsername=#,
				$Failed
				]&),
		"ClearAuthentication"->
			GoogleAPIClearAuth,
		"LastError"->
			($GALastError&)
		|>;
GoogleAPIDataCallQ[call_String]:=
	KeyExistsQ[$GoogleAPIDataCalls, call];


PackageAddAutocompletions[
	"GoogleAPIData",
	{Keys@$GoogleAPIDataCalls}
	];


(* ::Subsubsection::Closed:: *)
(*GoogleAPIData*)



Options[GoogleAPIData]=
	{
		"Username"->Automatic,
		"ClientID"->Automatic
		};
GoogleAPIData[
	call_String?GoogleAPIDataCallQ,
	args:Except[_?OptionQ]...,
	ops___?OptionQ
	]:=
	$GoogleAPIDataCalls[call][args];


(* ::Subsection:: *)
(*GoogleDrive*)



(* ::Subsubsection::Closed:: *)
(*Calls*)



$GoogleDriveCalls=
	Join[
		$GoogleDriveCalls,
		<|
			"List"->
				(GAFileInfo[]&),
			"Search"->
				GAFileSearch,
			"Info"->
				GAFileInfo,
			"Upload"->
				GAFileUpload,
			"Update"->
				GAFileUpdate,
			"Download"->
				GAFileDownload,
			"DownloadURL"->
				GAFileDownloadURL,
			"Delete"->
				GAFileDelete,
			"Permissions"->
				GAFilePermissions,
			"CreatePermissions"->
				GAFileCreatePermissions,
			"UpdatePermissions"->
				GAFileUpdatePermissions,
			"DeletePermissions"->
				GAFileDeletePermissions,
			"Publish"->
				GAFilePublish,
			"Privatize"->
				GAFilePrivatize
			|>
		];
GoogleDriveCallQ[call_String]:=
	KeyExistsQ[$GoogleDriveCalls, call];


PackageAddAutocompletions[
	"GoogleDrive",
	{Keys@$GoogleDriveCalls}
	];


(* ::Subsubsection::Closed:: *)
(*GoogleDrive*)



GoogleDrive[
	call_String?GoogleDriveCallQ,
	"Function"
	 ]:=
	 $GoogleDriveCalls[call];
GoogleDrive[
	call_String?GoogleDriveCallQ,
	"Options"
	 ]:=
	 Options@Evaluate@$GoogleDriveCalls[call];


Options[GoogleDrive]=
	{
		"Return"->Automatic,
		"Username"->Automatic,
		"ClientID"->Automatic
		};
GoogleDrive[
	call_String?GoogleDriveCallQ,
	args:Except[_?OptionQ]...,
	ops___?OptionQ
	]:=
	Block[
		{
			$GAOAuthToken=
				GAOAuthenticate[
					Lookup[Flatten[{ops, Options@GoogleDrive}],
						"Username",
						Automatic
						],
					Lookup[Flatten[{ops, Options@GoogleDrive}],
						"ClientID",
						Automatic
						],
					"analytics"
					],
			$GAOAuthTokenDataTmp,
			retPart=
				Lookup[Flatten[{ops, Options@GoogleDrive}],
					"Return",
					Automatic
					],
			$GAActiveHead=GoogleDrive,
			res,
			fn=$GoogleDriveCalls[call]
			},
		res=
			fn[args, 
				Sequence@@FilterRules[{ops}, 
					Except[Alternatives@@Keys@Options@GoogleDrive]
					]
				];
		If[Head[res]===HTTPRequest,
			Switch[retPart, 
				"Body"|"BodyBytes"|"BodyByteArray",
					GACall[#, retPart]&,
				HTTPRequest,
					Identity,
				HTTPResponse,
					URLRead,
				_,
					GACall
				]@res,
			res
			]/;Head[res]=!=fn
		];


(* ::Subsection:: *)
(*GoogleAnalytics*)



(* ::Subsubsection::Closed:: *)
(*Calls*)



$GoogleAnalyticsCalls=
	Join[
		$GoogleAnalyticsCalls,
		<|
			
			|>
		];
GoogleAnalyticsCallQ[call_String]:=
	KeyExistsQ[$GoogleAnalyticsCalls, call];


PackageAddAutocompletions[
	"GoogleAnalytics",
	{Keys@$GoogleAnalyticsCalls}
	];


(* ::Subsubsection::Closed:: *)
(*GoogleAnalytics*)



GoogleAnalytics//Clear


GoogleAnalytics[
	call_String?GoogleAnalyticsCallQ,
	"Function"
	 ]:=
	 $GoogleAnalyticsCalls[call];
GoogleAnalytics[
	call_String?GoogleAnalyticsCallQ,
	"Options"
	 ]:=
	 Options@Evaluate@$GoogleAnalyticsCalls[call];


Options[GoogleAnalytics]=
	{
		"Return"->Automatic,
		"Username"->Automatic,
		"ClientID"->Automatic
		};
GoogleAnalytics[
	call_String?GoogleAnalyticsCallQ,
	args:Except[_?OptionQ]...,
	ops___?OptionQ
	]:=
	Block[
		{
			$GAOAuthToken=
				Replace[
					GAOAuthenticate[
						Lookup[Flatten[{ops, Options@GoogleAnalytics}],
							"Username",
							Automatic
							],
						Lookup[Flatten[{ops, Options@GoogleAnalytics}],
							"ClientID",
							Automatic
							],
						"analytics"
						],
					Except[_String]->""
					],
			$GAOAuthTokenDataTmp,
			retPart=
				Lookup[Flatten[{ops, Options@GoogleAnalytics}],
					"Return",
					Automatic
					],
			$GAActiveHead=GoogleAnalytics,
			res,
			fn=$GoogleAnalyticsCalls[call]
			},
		res=
			fn[args, 
				Sequence@@FilterRules[{ops}, 
					Except[Alternatives@@Keys@Options@GoogleAnalytics]
					]
				];
		If[Head[res]===HTTPRequest,
			Switch[retPart, 
				"Body"|"BodyBytes"|"BodyByteArray",
					GACall[#, retPart]&,
				HTTPRequest,
					Identity,
				HTTPResponse,
					URLRead,
				_,
					GACall
				]@res,
			res
			]/;Head[res]=!=fn
		];


End[];



