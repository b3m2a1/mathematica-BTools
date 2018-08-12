With[{vars={##}},
  TemplateApply@
    TemplateObject[
      {
        TemplateApply[
          "<`ListType` class=\"`ListClass`\" id=\"`ListID`\">",
          Join[
            <|
              "ListType"->"ul",
              "ListClass"->"list-inline row",
              "ListID"->""
              |>,
            If[Length@vars==2, <||>, vars[[1]]]
            ]
          ],
        TemplateSequence[
          XMLTemplate@
            TemplateApply[
              "<li class=\"`ItemClass`\">\n<wolfram:slot/></li>",
              Join[
                <|
                  "ItemClass"->"list-inline-item"
                  |>,
                If[Length@vars==2, <||>, vars[[1]]]
                ]
              ],
          List@
            TemplateApply[
              $$templateLib["makeSiteElements"][
                Merge[{#, "type"->"a"}, Last]&/@If[Length@vars==2, vars[[1]], vars[[2]]],
                If[Length@vars==2, vars[[2]], vars[[3]]]
                ],
              If[Length@vars==2, vars[[2]], vars[[3]]]
              ]
          ],
          TemplateApply[
            "</`ListType`>",
            Join[
              <|
                "ListType"->"ul"
                |>,
              If[Length@vars==2, <||>, vars[[1]]]
              ]
            ]
        },
      InsertionFunction->"HTMLFragment",
      CombinerFunction -> Function@StringRiffle[#,"\n"]
      ]
  ]&
