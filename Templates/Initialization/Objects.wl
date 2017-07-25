(* ::Package:: *)

(* ::Subsection:: *)
(*Objects*)


(* ::Subsubsection::Closed:: *)
(*$PackageObjectBase*)


$PackageObjectBase=PackageFilePath["Objects"];


(* ::Subsubsection::Closed:: *)
(*PackageLocalObject*)


PackageLocalObject[name_]:=
	LocalObject[name,$PackageObjectBase];


(* ::Subsubsection::Closed:: *)
(*PackageLocalFile*)


PackageLocalFile[name_,path_]:=
	FileNameJoin@{
		$PackageObjectBase,
		name,
		path
		};


PackageLocalFile[name_]:=
	PackageLocalFile[
		name,
		Key["ExternalData"]@
			Get@PackageLocalFile["object.wl"]
		];


(* ::Subsubsection::Closed:: *)
(*PackageLocalPut*)


PackageLocalPut[expr__,name_]:=
	Put[
		Unevaluated@expr,
		PackageLocalObject[name]
		];


(* ::Subsubsection::Closed:: *)
(*PackageLocalExport*)


PackageLocalExport[name_,e__]:=
	Export[
		PackageLocalObject[name],
		e
		];


(* ::Subsubsection::Closed:: *)
(*PackageLocalEncode*)


PackageLocalEncode[name_]:=
	(
		Put[
			ReplacePart[Get@PackageLocalFile[name,"object.wl"],
				"ExternalData"->"encoded.mx"
				],
			PackageLocalFile[name,"object.wl"]
			];
		Encode[
			PackageLocalFile[name],
			PackageLocalFile[name,"encoded.mx"]
			];
		PackageLocalObject[name]
		);


PackageLocalEncode[name_,key_]:=
	(
		Put[
			ReplacePart[Get@PackageLocalFile[name,"object.wl"],
				"ExternalData"->"encoded.mx"
				],
			PackageLocalFile[name,"object.wl"]
			];
		Encode[
			PackageLocalFile[name],
			PackageLocalFile[name,"encoded.mx"],
			key
			];
		PackageLocalObject[name]
		);


(* ::Subsubsection::Closed:: *)
(*PackageLocalGet*)


PackageLocalGet[name_]:=
	Get@PackageLocalObject[name];


PackageLocalGet[name_,key_]:=
	Get[PackageLocalObject[name],key];


(* ::Subsubsection::Closed:: *)
(*PackageLocalImport*)


PackageLocalImport[name_,e___]:=
	Import[
		PackageLocalObject[name],
		e
		];
