Modified: 2017-07-23 04:00:03

## Notebook

```Mathematica
SSNew["Notebook"]
```

```Mathematica
$dock =
  GradientDockedCell[{
    Spacer[50],
    "Save Markdown" :>
     BTools`PelicanNotebookSave[],
    ("Build Page" :>
         If[
          StringLength[#StandardError] > 0,
          CellPrint@Cell[#StandardError, "Message", "MSG"]
          ] &@
       BTools`PelicanBuild[
        Echo@BTools`PelicanNotebookSave[]
        ]) -> {
      Method -> "Queued",
      "UUID" -> Automatic
      },
    ("Deploy Page" :>
       BTools`PelicanDeploy[
        BTools`PelicanBuild[
         BTools`PelicanNotebookSave[]
         ]
        ]) -> {Method -> "Queued"}
    },
   FrameMargins -> {{10, 10}, {0, 0}}
   ];
```

```Mathematica
SSEdit["Notebook", {
  DefaultNewCellStyle -> "Text",
  DockedCells -> $dock,
  NotebookEventActions :>
   {
    {"MenuCommand", "Save"} :>
     (
      NotebookSave[EvaluationNotebook[]];
      BTools`PelicanNotebookSave[]
      )
    }
  }]
```

## Metadata

```Mathematica
SSNew["Metadata", "Input"]
```

```Mathematica
SSEdit["Metadata", {
  Background -> GrayLevel[.98],
  CellFrame -> 1,
  CellFrameColor -> GrayLevel[.8],
  MenuCommandKey -> "9"
  }]
```

## Input

```Mathematica
SSNew["Input"]
```

```Mathematica
SSEdit["Input", {
  StyleKeyMapping -> {
    ">" -> "HiddenInput"
    },
  MenuCommandKey -> None
  }]
```

## HiddenInput

```Mathematica
SSNew["HiddenInput", "Input"]
```

```Mathematica
SSEdit["HiddenInput",
 System`GeneratedCellStyles -> {
   "Output" -> "HiddenOutput"
   }
 ]
```

## HiddenOutput

```Mathematica
SSNew["HiddenOutput", "Output"]
```

```Mathematica
SSEdit["HiddenOutput",
 DefaultDuplicateCellStyle -> "HiddenInput"
 ]
```