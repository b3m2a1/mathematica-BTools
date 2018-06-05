(* ::Package:: *)

(* This is a conveniece file so Needs["App`Pkg`"] can be used *)
BeginPackage[
   StringRiffle[
     Flatten[{
        StringSplit[
          FileBaseName[Nest[DirectoryName, $InputFileName, $ContextDepth$]],
          "-"
          ][[1]],
        FileNameSplit[
          FileNameTake[
            StringTrim[$InputFileName, ".wl"],
            -$ContextDepth$
            ]
          ],
        ""
      }],
    "`"
    ],
   StringSplit[
    FileBaseName[Nest[DirectoryName, $InputFileName, $ContextDepth$]],
    "-"
    ][[1]]<>"`"
  ];
EndPackage[]

FrontEnd`Private`GetUpdatedSymbolContexts[]
