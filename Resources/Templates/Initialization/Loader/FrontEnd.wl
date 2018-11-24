(* ::Package:: *)

(* ::Subsection:: *)
(*FrontEnd*)


PackageFEHiddenBlock::usage="";
PackageFEUnhideSymbols::usage="";
PackageFERehideSymbols::usage="";
PackageFEUnhidePackage::usage="";
PackageFERehidePackage::usage="";


(* ::Subsubsection::Closed:: *)
(*Begin*)


Begin["`FrontEnd`"]


(* ::Subsubsection::Closed:: *)
(*PackageFEInstallStylesheets *)


PackageFEInstallStylesheets[]:=
  With[{
    base=
      FileNameJoin@{
        $PackageDirectory,
        "FrontEnd",
        "StyleSheets",
        $PackageName
        },
    target=
      FileNameJoin@{
          $UserBaseDirectory,
          "SystemFiles",
          "FrontEnd",
          "StyleSheets",
          $PackageName}
    },
    If[DirectoryQ@base,
      Do[
        Quiet@
          CreateFile[
            FileNameJoin@{
              target,
              FileNameDrop[f,FileNameDepth[base]]
              },
            CreateIntermediateDirectories->True
            ];
        CopyFile[f,
          FileNameJoin@{
            target,
            FileNameDrop[f,FileNameDepth[base]]
            },
          OverwriteTarget->True],
        {f,FileNames["*.nb",base,\[Infinity]]}
        ]
      ]
    ];


(* ::Subsubsection::Closed:: *)
(*PackageFEInstallPalettes *)


PackageFEInstallPalettes[]:=
  With[{
    base=
      FileNameJoin@{
        $PackageDirectory,
        "FrontEnd",
        "Palettes",
        $PackageName
        },
    target=
      FileNameJoin@{
          $UserBaseDirectory,
          "SystemFiles",
          "FrontEnd",
          "Palettes",
          $PackageName}
    },
    If[DirectoryQ@base,
      Do[
        Quiet@
          CreateFile[
            FileNameJoin@{
              target,
              FileNameDrop[f,FileNameDepth[base]]
              },
            CreateIntermediateDirectories->True
            ];
        CopyFile[f,
          FileNameJoin@{
            target,
            FileNameDrop[f,FileNameDepth[base]]
            },
          OverwriteTarget->True],
        {f,FileNames["*.nb",base,\[Infinity]]}
        ]
      ]
    ];


(* ::Subsubsection::Closed:: *)
(*PackageFEHiddenBlock*)


$PackageFEHideExprSymbols=TrueQ[$PackageFEHideExprSymbols];
$PackageFEHideEvalExpr=TrueQ[$PackageFEHideEvalExpr];
PackageFEHiddenBlock[expr_,
  hide:True|False|Automatic:Automatic,
  eval:True|False|Automatic:Automatic
  ]/;TrueQ[$AllowPackageRecoloring]:=
  If[!$PackageDeclared&&ListQ@$PackageFEHiddenSymbols,
    With[{
      s=
        Cases[
          HoldComplete[expr],
          sym_Symbol?(
            Function[Null,
              MemberQ[$PackageContexts,Quiet[Context[#]]],
              HoldAllComplete
              ]
            ):>
            HoldPattern[sym],
          \[Infinity]
          ]
      },
      $PackageFEHiddenSymbols=
        {
          $PackageFEHiddenSymbols,
          s
          }
      ],
    Block[{feBlockReturn},
      Internal`SymbolList[False];
      feBlockReturn=If[Replace[eval,Automatic:>$PackageFEHideEvalExpr],expr];
      If[Replace[hide,Automatic:>$PackageFEHideExprSymbols],
        With[{
          s=
            Cases[
              HoldComplete[expr],
              sym_Symbol?(
                Function[Null,
                  MemberQ[$PackageContexts,Quiet[Context[#]]],
                  HoldAllComplete
                  ]
                ):>
                HoldPattern[sym],
              \[Infinity]
              ]
          },
          Replace[Thread[s,HoldPattern],
            Verbatim[HoldPattern][{sym__}]:>
              PackageFERehideSymbols[sym]
            ]
          ]
        ];
      Internal`SymbolList[True];
      feBlockReturn
      ]
    ];
PackageFEHiddenBlock[expr_,
  hide:True|False|Automatic:Automatic,
  eval:True|False|Automatic:Automatic
  ]/;Not@TrueQ[$AllowPackageRecoloring]:=
  If[eval, expr];
PackageFEHiddenBlock~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*PackageFEUnhideSymbols*)


PackageFEUnhideSymbols[syms__Symbol,
  cpath:{__String}|Automatic:Automatic,
  mode:"Update"|"Set":"Update"
  ]/;TrueQ[$AllowPackageRecoloring]:=
  With[{stuff=
    Map[
      Function[Null,
        {Context@#,SymbolName@Unevaluated@#},
        HoldAllComplete],
      HoldComplete[syms]
      ]//Apply[List]
    },
    KeyValueMap[
      FrontEndExecute@
      If[mode==="Update",
        FrontEnd`UpdateKernelSymbolContexts,
        FrontEnd`SetKernelSymbolContexts
        ][
        #,
        Replace[cpath,Automatic->$ContextPath],
        {{#,{},{},#2,{}}}
        ]&,
      GroupBy[stuff,First->Last]
      ];
    ];
PackageFEUnhideSymbols[names_String,
  mode:"Update"|"Set":"Update"]/;TrueQ[$AllowPackageRecoloring]:=
  Replace[
    Thread[ToExpression[Names@names,StandardForm,Hold],Hold],
    Hold[{s__}]:>PackageFEUnhideSymbols[s,mode]
    ];
PackageFEUnhideSymbols~SetAttributes~HoldAllComplete;


(* ::Subsubsection::Closed:: *)
(*PackageFERehideSymbols*)


PackageFERehideSymbols[syms__Symbol,
  cpath:{__String}|Automatic:Automatic,
  mode:"Update"|"Set":"Update"]/;TrueQ[$AllowPackageRecoloring]:=
  With[{stuff=
    Map[
      Function[Null,
        {Context@#,SymbolName@Unevaluated@#},
        HoldAllComplete],
      HoldComplete[syms]
      ]//Apply[List]
    },
    KeyValueMap[
      FrontEndExecute@
      If[mode==="Update",
        FrontEnd`UpdateKernelSymbolContexts,
        FrontEnd`SetKernelSymbolContexts
        ][
        #,
        Replace[cpath,
          Automatic->$ContextPath
          ],
        {{#,{},#2,{},{}}}
        ]&,
      GroupBy[stuff,First->Last]
      ];
    ];
PackageFERehideSymbols[names_String,
  mode:"Update"|"Set":"Update"]/;TrueQ[$AllowPackageRecoloring]:=
  Replace[
    Thread[ToExpression[Names@names,StandardForm,Hold],Hold],
    Hold[{s__}]:>PackageFERehideSymbols[s,mode]
    ];
PackageFERehideSymbols~SetAttributes~HoldAllComplete;


(* ::Subsubsection::Closed:: *)
(*PackageFEUnhidePackage*)


PackageFEUnhidePackage[
  package_String?FileExistsQ,
  a___
  ]/;TrueQ[$AllowPackageRecoloring]:=
  Replace[Thread[Lookup[$DeclaredPackages,package,{}],HoldPattern],
    Verbatim[HoldPattern][{syms__}]:>
      PackageFEUnhideSymbols[syms,a]
    ];
PackageFEUnhidePackage[spec:_String|_List,a___]/;TrueQ[$AllowPackageRecoloring]:=
  PackageFEUnhidePackage[PackageFilePath@Flatten@{"Packages",spec},a];


(* ::Subsubsection::Closed:: *)
(*PackageFERehidePackage*)


PackageFERehidePackage[
  package_String?FileExistsQ,
  a___
  ]/;TrueQ[$AllowPackageRecoloring]:=
  Replace[Thread[Lookup[$DeclaredPackages,package,{}],HoldPattern],
    Verbatim[HoldPattern][{syms__}]:>
      PackageFERehideSymbols[syms,a]
    ];
PackageFERehidePackage[spec:_String|_List,a___]/;TrueQ[$AllowPackageRecoloring]:=
  PackageFERehidePackage[PackageFilePath@Flatten@{"Packages",spec},a];


(* ::Subsubsection::Closed:: *)
(*End*)


End[]
