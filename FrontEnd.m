(* This is a conveniece file so Needs["App`Pkg`"] can be used *)
BeginPackage[
  StringSplit[
   FileBaseName[DirectoryName@$InputFileName],
   "-"
   ][[1]]<>"`"<>
  FileBaseName[$InputFileName]<>"`",
  FileBaseName[DirectoryName@$InputFileName]<>"`"
  ];
EndPackage[]

FrontEnd`Private`GetUpdatedSymbolContexts[]
