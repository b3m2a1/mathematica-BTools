(* ::Package:: *)

(* ::Subsection:: *)
(*Dependencies*)


$Name::nodep="Couldn't load dependency `` of type ``";


(* ::Subsubsection::Closed:: *)
(*PackageExtendContextPath*)


PackageExtendContextPath[cp:{__String}]:=
	(
		Unprotect[$PackageContextPath];
		$PackageContextPath=
			DeleteCases[
				DeleteDuplicates@
					Join[$PackageContextPath, cp],
				"System`"|"Global`"
				];
		(* Should I protect it again? *)
		)


(* ::Subsubsection::Closed:: *)
(*PackageInstallPackageDependency*)


Options[PackageInstallPackageDependency]=
	{
		"Permanent"->False
		};
PackageInstallPackageDependency[dep_String, ops:OptionsPattern[]]:=
	Block[{retcode, site, path, file, tmp},
		path=
			StringSplit[StringTrim[dep, "`"]<>If[FileExtension[dep]=="", ".m", ""], "`"];
		site=
			Replace[OptionValue["Site"],
				{
					s_String?(
						URLParse[#, "Domain"]==="github.com"&
						):>
					URLBuild@
						<|
							"Scheme"->"http",
							"Domain"->"raw.githubusercontent.com",
							"Path"->
								Function[If[Length[#]==2, Append[#, "master"], #]]@
									DeleteCases[""]@URLParse[s, "Path"]
							|>,
					_->
						"http://raw.githubusercontent.com/paclets/PackageServer/master/Listing"
					}
				];
			file=
				If[TrueQ@OptionValue["Permanent"],
					FileNameJoin@{$UserBaseDirectory, "Applications", Last@path},
					FileNameJoin@{$TemporaryDirectory, "Applications", Last@path}
					];
			tmp=CreateFile[];
			Monitor[
				retcode=URLDownload[URLBuild[Prepend[site], path], tmp, "StatusCode"],
				Internal`LoadingPanel[
					TemplateApply[
						"Loading package `` from site ``",
						{URLBuild@path, site}
						]
					]
				];
			If[retcode<300,
				CopyFile[tmp, file,
					OverwriteTarget->Not@TrueQ@OptionValue["Permanent"]
					];
				DeleteFile[tmp];
				file,
				Message[$Name::nodep, dep, "Package"];
				DeleteFile[tmp];
				$Failed
				]
			];


(* ::Subsubsection::Closed:: *)
(*PackageLoadPackageDependency*)


Options[PackageLoadPackageDependency]=
	Options[PackageInstallPackageDependency];
PackageLoadPackageDependency[dep_String, ops:OptionsPattern[]]:=
	Internal`WithLocalSettings[
		BeginPackage[dep];,
		If[Quiet@Check[Needs[dep], $Failed]===$Failed&&
				Quiet@Check[
					Get[FileNameJoin@@
						StringSplit[
							StringTrim[dep, "`"]<>If[FileExtension[dep]=="", ".m", ""], 
							"`"
							]
						], 
					$Failed]===$Failed,
			Replace[PackageInstallPacletDependency[dep, ops],
				f:_String|_File:>Get[f]
				]
			];
		PackageExtendContextPath@
			Select[$Packages, StringStartsQ[dep]];,
		EndPackage[];
		]


(* ::Subsubsection::Closed:: *)
(*PackageInstallPacletDependency*)


Options[PackageInstallPacletDependency]=
	Options[PacletInstall];
PackageInstallPacletDependency[dep_String, ops:OptionsPattern[]]:=
	Check[
		Block[{site, pac},
			pac=
				StringTrim[dep, "`"];
			site=
				Replace[OptionValue["Site"],
					{
						s_String?(
							URLParse[#, "Domain"]==="github.com"&
							):>
						URLBuild@
							<|
								"Scheme"->"http",
								"Domain"->"raw.githubusercontent.com",
								"Path"->
									Function[If[Length[#]==2, Append[#, "master"], #]]@
										DeleteCases[""]@URLParse[s, "Path"]
								|>,
						None->
							Automatic,
						_->
							"http://raw.githubusercontent.com/paclets/PacletServer/master"
						}
					];
				Monitor[
					PacletInstall[
						pac,
						"Site"->site,
						ops
						],
					Internal`LoadingPanel[
						TemplateApply[
							"Loading paclet `` from site ``",
							{pac, site}
							]
						]
					]
				],
		Message[$Name::nodep, dep, "Paclet"];
		$Failed
		]


(* ::Subsubsection::Closed:: *)
(*PackageLoadPacletDependency*)


Options[PackageLoadPacletDependency]=
	Options[PackageInstallPacletDependency];
PackageLoadPacletDependency[dep_String?StringEndsQ["`"], ops:OptionsPattern[]]:=
	Internal`WithLocalSettings[
		BeginPackage[dep];,
		Quiet@
			If[Check[Needs[dep], $Failed]===$Failed,
				Replace[PackageInstallPacletDependency[dep, ops],
					_PacletManager`Paclet:>Needs[dep]
					]
				];
		PackageExtendContextPath@
			Select[$Packages, StringStartsQ[dep]];,
		EndPackage[];
		]


(* ::Subsubsection::Closed:: *)
(*PackageLoadResourceDependency*)


(* ::Text:: *)
(*Nothing I've implemented yet, but could be very useful for installing resources for a paclet*)
