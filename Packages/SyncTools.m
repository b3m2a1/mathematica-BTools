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



`Package`PackageFEHiddenbBlock[

$BundleMetaInformationFile::usage="The meta info file created by CreateSyncBundle";
CreateSyncBundle::usage="Create a bundle with various bits of metadata for syncing";

]


SyncPath::usage=
	"A sync path finder for even non-standard dirs";


`Package`PackageFEHiddenbBlock[

UploadFile::usage="Uploads a directory to the cloud";
DownloadFile::usage="Downloads a directory from the cloud";
$BackupDirectoryName="The extension for backups to be sent to";
BackupFile::usage="Backs up a directory";
RestoreFile::usage="Restores a directory";

]


`Package`PackageFEHiddenbBlock[

$SyncUploads::usage="The spec of what to upload / download";
SyncUploadWork::usage="Uploads current work projects in one fell swoop";
SyncDownloadWork::usage="Downloads current work projects in one fell swoop";

]


Begin["`Private`"];


$SyncPathExtension="Mathematica";


$SyncDirectories={
	"Google Drive"|"GoogleDrive"|
		"google drive"|"googledrive":>
		FileNameJoin@{$HomeDirectory,"Google Drive"},
	"DropBox"|"Dropbox"|"dropbox":>
		FileNameJoin@{$HomeDirectory,"Dropbox"},
	"One Drive"|"One Drive"|"OneDrive"|"onedrive":>
		FileNameJoin@{$HomeDirectory,"OneDrive"}
	};
SyncPathQ//Clear;
SyncPathQ[s_String]:=
	StringMatchQ[s,(Alternatives@@Keys@$SyncDirectories)]||
	StringMatchQ[s,(Alternatives@@Keys@$SyncDirectories)~~":"~~__];
SyncPathQ[_]:=$Failed;


SyncPathBuild[{root_,ext__}]:=
	If[StringMatchQ[root,(Alternatives@@Keys@$SyncDirectories)],
		URLBuild@<|
			"Scheme"->root,
			"Path"->{ext}
			|>,
		URLBuild@{root,ext}
		];


SyncPath[s_String?(StringMatchQ[(Alternatives@@Keys@$SyncDirectories)])]:=
	FileNameJoin@{
		s/.$SyncDirectories,
		$SyncPathExtension
		};
SyncPath[s_String?(FileExistsQ)]:=
	s;
SyncPath[s_String?(
	StringMatchQ[(Alternatives@@Keys@$SyncDirectories)~~":"~~__]
	)]:=
	FileNameJoin@
		Flatten[
			{
				SyncPath[#],
				URLParse[#2]["Path"]
				}]&@@
				Replace[
					Replace[StringSplit[s,"://",2],
						{b_}:>
							Replace[StringSplit[s,":",2],
								{_,"//"}:>b
								]
						],
					{b_}:>{b,""}
					]


$SyncUploads:=
	<|
		"Apps"->
			<|
				"BundleFunction"->BundleApp,
				"BundleFiles":>
					Append[
						DeleteCases[
							Select[AppNames[],StringMatchQ[Except[WhitespaceCharacter|"."]..]],
							"ChemTools"
							],
							{
								"ChemTools",
								"RemovePaths"->{
									{"Extensions","psi4"},
									{"Extensions","DVR"},
									{"Extensions","cmake"},
									{"Extensions","spcat"},
									{"Extensions","openbabel"}
									}
								}
					],
				"UploadFunction"->UploadApp,
				"DownloadFunction"->DownloadApp,
				"UploadLocations"->{CloudObject,"Google Drive"}
				|>,
		"Projects"->
			<|
				"BundleFunction":>(
					Needs["MyProjects`"];
					MyProjects`BundleProject
					),
				"BundleFiles":>
					Select[MyProjects`ProjectNames[],
						Total@Cases[
						FileSystemMap[
							FileByteCount,
							MyProjects`FindProject@#,
							\[Infinity]],
						_Integer,\[Infinity]]<250000000&],
				"UploadFunction"->MyProjects`UploadProject,
				"UploadLocations"->{CloudObject,"Google Drive"}
				|>(*,
		"ACFramework"->
			<|
				
				|>*)
		|>


SyncUploadWork[apps_:"Apps"]:=
	Monitor[
		With[{
			bfunc=#BundleFunction,files=#BundleFiles,
			ufun=#UploadFunction,ulocs=#UploadLocations
			},
			Table[
				With[{arc=bfunc@@Flatten[{app},1]},
					Table[
						If[FileByteCount@arc<25000000||to=!=CloudObject,
							AbsoluteTiming@ufun[arc,"UploadTo"->to]
							],
						{to,ulocs}
						]
					],
				{app,files}
				]
			]&/@Lookup[$SyncUploads,Flatten@{apps}],
		FileBaseName@First@Flatten@{Replace[app,_Symbol:>"None"]}
		];


SyncDownloadWork[apps_:Automatic]:=
	Monitor[
		With[{
			files=#BundleFiles,
			dfun=#DownloadFunction
			},
			Table[
				dfun@app,
				{app,files}
				]
			]&/@Lookup[$SyncUploads,Flatten@{apps}],
		FileBaseName@First@Flatten@{Replace[app,_Symbol:>"None"]}
		];


$BundleMetaInformationFile="_sync_bundle_metadata.m";


Options[CreateSyncBundle]:={
	Root:>$HomeDirectory,
	Directory->Automatic,
	"RemovePaths"->{},
	"RemovePatterns"->".DS_Store"
	};
CreateSyncBundle[
	bundleName:_String?(StringMatchQ[Except[$PathnameSeparator]..])|Automatic:Automatic,
	paths:_String?FileExistsQ|{__String?FileExistsQ},
	metadata:_Rule|_RuleDelayed|_List|_Assocation:{},
	OptionsPattern[]
	]:=
	With[{
		fps=ExpandFileName/@Flatten@{paths},
		name=Replace[bundleName,Automatic:>FileBaseName@First@Flatten@{paths}],
		dir=OptionValue@Directory,
		rootPath=OptionValue@Root
		},
		With[{bundleDir=FileNameJoin@{Replace[dir,Automatic->$TemporaryDirectory],name}},
			If[dir===Automatic,Quiet@DeleteDirectory[bundleDir,DeleteContents->True]];
			If[!DirectoryQ@bundleDir,
				Quiet@CreateDirectory[bundleDir,CreateIntermediateDirectories->True]
				];
			With[{new=
				FileNameJoin@{
					bundleDir,
					StringTrim[StringTrim[#,rootPath],$RootDirectory]}
				},
				If[!DirectoryQ@DirectoryName@new,
					Quiet@CreateDirectory[DirectoryName@new,CreateIntermediateDirectories->True];
					];
				If[DirectoryQ@new,
					With[{d=#},
						CopyFile[#,
							StringReplace[#,d->new],
							OverwriteTarget->True]&/@
							FileNames["*",d]
						],
					CopyFile[#,new,
						OverwriteTarget->True]
					]
				]&/@fps;
			Export[
				FileNameJoin@{bundleDir,$BundleMetaInformationFile},
				Merge[{
					<|
						"Files"->(FileNameSplit/@StringReplace[fps,$HomeDirectory->"~"]),
						"Time"->Now,
						"User"->$UserName,
						"System"->$SystemID,
						"WolframID"->$WolframID,
						"UUID"->$WolframUUID
						|>,
					Association@metadata
					},
					Last
					]
				];
			Do[
				With[{p=FileNameJoin@Flatten@{bundleDir,p}},
					If[DirectoryQ@p,
						DeleteDirectory[p,
							DeleteContents->True],
						If[FileExistsQ@p,DeleteFile[p]]
						]
					],
				{p,
					Join[
						Flatten[{OptionValue["RemovePaths"]},1],
						FileNameDrop[#,FileNameDepth@bundleDir]&/@
							FileNames[OptionValue["RemovePatterns"],bundleDir,\[Infinity]]
						]}
				];
			With[{archiveFile=bundleDir<>".zip"},
				Quiet@DeleteFile@archiveFile;
				RenameFile[
					CreateArchive@bundleDir,
					archiveFile
					];
				If[dir===Automatic, DeleteDirectory[bundleDir,DeleteContents->True]];
				archiveFile
				]
			]
		];


(* ::CodeInput::Plain:: *)
UploadFile::filnex="File `` doesn't exist";
Options[UploadFile]:=
	Join[{
		"UploadTo"->CloudObject
		},
		Options@CloudExport
		];
UploadFile[
	file:_File|_String,
	directoryExtension_String,
	ops:OptionsPattern[]
	]:=
	If[FileExistsQ@file,
		With[{arc=
			If[DirectoryQ@file,
				Quiet@DeleteFile@FileNameJoin@{$TemporaryDirectory,FileBaseName@file<>".zip"};
				CreateArchive[file,$TemporaryDirectory],
				file
				]},
			Switch[OptionValue@"UploadTo",
				CloudObject,
					With[{o=
						CloudDeploy[None,
							URLBuild@{directoryExtension,
								FileNameTake@file},
							FilterRules[{ops},
								Options@CloudDeploy]
							]},
						CopyFile[arc,o]
						],
				"GitHub"|"Git"|"git"|"github",
					With[{repo=GitRepositories[arc]},
						Replace[repo,
							{r_,___}:>
								GitPushOrigin[r,"*"]
							]
						],
				_?SyncPathQ,
					With[{d=SyncPath[OptionValue@"UploadTo"]},
						If[DirectoryQ@d,
							Quiet@
								CreateDirectory[
									FileNameJoin@{
										d,
										"Mathematica",
										directoryExtension
										},
									CreateIntermediateDirectories->True
									];
							CopyFile[
								arc,
								FileNameJoin@{
									d,
									"Mathematica",
									directoryExtension,
									FileBaseName[file]<>".zip"
									},
								OverwriteTarget->True
								]
							]
						]
					]
			],
		Message[UploadFile::filnex,file];
		$Failed
	];


$BackupDirectoryName="_Backups"


BackupFile[
	file:(_File|_String)?FileExistsQ,
	where:(_File|_String)?DirectoryQ,
	backupsDir:_String|Automatic:Automatic]:=
	With[{
		backupFile=
			FileNameJoin@{
				where,
				Replace[backupsDir,Automatic:>$BackupDirectoryName],
				TemplateApply["`name`_`now`.zip",
					<|"name"->FileBaseName@file,
						"now"->
							Block[{$DateStringFormat=
											{
											"Day",":","Month",":","Year","@",
											"Hour",":","Minute",":","Second"
											}
										},
									DateString@Now
									]
					|>
					]
				}
		},
			If[Not@DirectoryQ@DirectoryName@backupFile,
				CreateDirectory@DirectoryName@backupFile
				];
			CreateArchive[file,backupFile]
		];


fileBackupInfo[backupFile_]:=
	With[{file=FileBaseName@backupFile},
		Replace[
			StringCases[file,{
				name__~~"_"~~date__~~"@"~~time__:>{name,date,time}
				}],{
			{{name_,date_,time_},___}:><|
				"Name"->name,
				"Date"->
					DateObject@Join[
						Reverse@ToExpression@StringSplit[date,":"],
						ToExpression@StringSplit[time,":"]
						],
				"File"->backupFile
				|>,
			_->None
			}]
		]


FileBackups[appName_:"",from:(_File|_String)?DirectoryQ]:=
	With[{backups=
		fileBackupInfo/@FileNames[appName<>"*.zip",from]},
		Sort[backups,(#["Date"]>#2["Date"])&]
		];


RestoreFile[
	name:_String?(StringMatchQ[Except[$PathnameSeparator]..]),
	from:(_File|_String)?DirectoryQ,
	to:(_File|_String)?DirectoryQ]:=
	With[{backup=
		Replace[FileBackups@name,
			{
				{a_,___}:>a,
				_:>$Failed
			}]
			},
		If[backup["Name"]===name,
			If[DirectoryQ@FileNameJoin@{to,name},
				DeleteDirectory[FileNameJoin@{to,name},DeleteContents->True]
				];
			ExtractArchive[backup["File"],to];
			FileNameJoin@{to,name},
			$Failed
			]
		];


RestoreFile[
	file_String?FileExistsQ,
	to_?DirectoryQ
	]:=
	With[{backup=fileBackupInfo@file},
		If[backup===None,
			$Failed,
			ExtractArchive[backup["File"],to]
			]
		]
		
		
		


Options[BackupCopyFile]:=
	Options@CopyFile;
BackupCopyFile[
		file:File[_String?FileExistsQ]|_String?FileExistsQ,
		givenName:(_String|Automatic):Automatic,
		to:File[_String?DirectoryQ]|_String?DirectoryQ,
		ops:OptionsPattern[]
		]:=
	With[{
		name=Replace[givenName,Automatic:>FileNameTake@file]
		},
		With[{
			dest=FileNameJoin@{to,name}
			},
			With[{
				backup=BackupFile[dest,to]
				},
				If[DirectoryQ@dest,
					DeleteDirectory[dest,DeleteContents->True]
					];
				Replace[
					CopyFile[
						file,
						dest,
						OverwriteTarget->OptionValue@OverwriteTarget
						],
					r:Except[_String?FileExistsQ]:>
						(
							RestoreFile[backup,to];
							r
						)
					]
				]
			]
		];


Options[DownloadFile]:=
	Join[
		Options@BackupCopyFile,
		{
			Root:>$HomeDirectory,
			MetaInformation->False,
			"DownloadFrom"->CloudObject
		}];
DownloadFile[
		file:(
				File[_String?(FileExtension@#==="zip"&)]|
				_String?(FileExtension@#==="zip"&)
				),
		givenName:(_String|Automatic):Automatic,
		to:File[_String?DirectoryQ]|_String?DirectoryQ|None:None,
		ops:OptionsPattern[]
		]:=
	With[{dir=FileNameJoin@{$TemporaryDirectory,FileBaseName@file}},
		Quiet@DeleteDirectory[dir,DeleteContents->True];
		If[Check[ExtractArchive[file,$TemporaryDirectory],$Failed]=!=$Failed,
			If[!OptionValue@MetaInformation,
				Quiet@DeleteFile[FileNameJoin@{$TemporaryDirectory,$BundleMetaInformationFile}]
				];
			If[to=!=None,
				BackupCopyFile[dir,givenName,to,FilterRules[{ops},Options@BackupCopyFile]],
				dir
				],
			Message[DownloadFile::nocont,file]
			]
		];


DownloadFile::srcerr="Unknown source type ``";
DownloadFile::filnf="File `` not found";
DownloadFile::nocont="Couldn't extract package contents from ``";


DownloadFile[
		file:_CloudObject|_URL|_String,
		givenName:(_String|Automatic):Automatic,
		to:File[_String?DirectoryQ]|_String?DirectoryQ,
		ops:OptionsPattern[]
		]:=
	With[{f=FileNameJoin@{$TemporaryDirectory,
			FileBaseName@Last@URLParse[file]["Path"]<>".zip"}},
		Check[
			Switch[OptionValue@"DownloadFrom",
				CloudObject,
					Switch[file,
						_CloudObject,CopyFile[file,f,OverwriteTarget->True],
						_URL,URLDownload[file,f],
						_String,
							If[MatchQ[Quiet@URLRead@file,_Failure],
								CopyFile[
										CloudObject@file,
										f,
										OverwriteTarget->True
										],
								URLDownload[file,f]
								]
						],
				_?SyncPath,
					Quiet@DeleteFile@f;
					CopyFile[
						SyncPath[
							URLBuild@{
								OptionValue@"DownloadFrom",
								"Mathematica",
								file<>".zip"
								}
							],
						f],
				_,
					Message[DownloadFile::srcerr,OptionValue@"DownloadFrom"]
				];
			If[FileExistsQ@f,
				DownloadFile[f,givenName,to,ops],
				Message[DownloadFile::filnf,file]
				],
			$Failed
			]
		];


DownloadFile[
	file_,
	givenName:(_String|Automatic):Automatic,
	to:File[_String?DirectoryQ]|_String?DirectoryQ,
	source:Except[_Rule],
	ops:OptionsPattern[]
	]:=
	DownloadFile[file,givenName,to,"DownloadFrom"->source,ops];


End[];



