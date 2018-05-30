(* This is a convenience file to load all of the packages in this app *)
Map[
  Function[
    BeginPackage[
      StringSplit[
        FileBaseName[DirectoryName@$InputFileName],
        "-"
        ][[1]]<>"`"<>#<>"`",
      StringSplit[
        FileBaseName[DirectoryName@$InputFileName],
        "-"
        ][[1]]<>"`"
      ];
    EndPackage[]
    ],
  {
    "Paclets",
    "Utilities",
    "Formatting",
    "FrontEnd",
    "Frameworks",
    "External",
    "Web",
    "Developer"
    }
  ]

FrontEnd`Private`GetUpdatedSymbolContexts[]
