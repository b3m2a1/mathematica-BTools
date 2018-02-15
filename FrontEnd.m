(* This is a conveniece file so Needs["ChemTools`Pkg`"] can be used *)
BeginPackage[
  FileBaseName[DirectoryName@$InputFileName]<>"`"<>
  FileBaseName[$InputFileName]<>"`",
  FileBaseName[DirectoryName@$InputFileName]<>"`"
  ];
EndPackage[]

FrontEnd`Private`GetUpdatedSymbolContexts[]
