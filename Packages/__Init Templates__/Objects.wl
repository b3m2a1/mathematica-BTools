(* ::Package:: *)

(* ::Subsection:: *)
(*Objects*)


(* ::Subsubsection::Closed:: *)
(*$objectBase*)


$objectBase=appPath["Objects"];


(* ::Subsubsection::Closed:: *)
(*localObject*)


localObject[name_]:=
	LocalObject[name,$objectBase];


(* ::Subsubsection::Closed:: *)
(*localFile*)


localFile[name_,path_]:=
	FileNameJoin@{
		$objectBase,
		name,
		path
		};


localFile[name_]:=
	localFile[
		name,
		Key["ExternalData"]@
			Get@localFile["object.wl"]
		];


(* ::Subsubsection::Closed:: *)
(*localPut*)


localPut[expr__,name_]:=
	Put[
		Unevaluated@expr,
		localObject[name]
		];


(* ::Subsubsection::Closed:: *)
(*localExport*)


localExport[name_,e__]:=
	Export[
		localObject[name],
		e
		];


(* ::Subsubsection::Closed:: *)
(*localEncode*)


localEncode[name_]:=
	(
		Put[
			ReplacePart[Get@localFile[name,"object.wl"],
				"ExternalData"->"encoded.mx"
				],
			localFile[name,"object.wl"]
			];
		Encode[
			localFile[name],
			localFile[name,"encoded.mx"]
			];
		localObject[name]
		);


localEncode[name_,key_]:=
	(
		Put[
			ReplacePart[Get@localFile[name,"object.wl"],
				"ExternalData"->"encoded.mx"
				],
			localFile[name,"object.wl"]
			];
		Encode[
			localFile[name],
			localFile[name,"encoded.mx"],
			key
			];
		localObject[name]
		);


(* ::Subsubsection::Closed:: *)
(*localGet*)


localGet[name_]:=
	Get@localObject[name];


localGet[name_,key_]:=
	Get[localObject[name],key];


(* ::Subsubsection::Closed:: *)
(*localImport*)


localImport[name_,e___]:=
	Import[
		localObject[name],
		e
		];
