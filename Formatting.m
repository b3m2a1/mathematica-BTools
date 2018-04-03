(* This is a conveniece file so Needs["App`Pkg`"] can be used *)
BeginPackage[
  StringSplit[
   FileBaseName[DirectoryName@$InputFileName],
   "-"
   ][[1]]<>"`"<>
   FileBaseName[$InputFileName]<>"`",
   StringSplit[
    FileBaseName[DirectoryName@$InputFileName],
    "-"
    ][[1]]<>"`"
  ];
EndPackage[]

FrontEnd`Private`GetUpdatedSymbolContexts[]
