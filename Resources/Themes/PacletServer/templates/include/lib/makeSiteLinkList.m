TemplateApply@
  TemplateObject[{
    "<ul class=\"list-inline row\">",
    TemplateSequence[
      XMLTemplate@
        "<li class=\"list-inline-item\">\n<wolfram:slot id='1' /></li>",
      List@
        TemplateApply[
          $$templateLib["makeSiteElements"][
            Merge[{#,"type"->"a"},Last]&/@#,
            #2
            ],
          #2
          ]
      ],
    "</ul>"
    },
    InsertionFunction->"HTMLFragment",
    CombinerFunction -> Function@StringRiffle[#,"\n"]
    ]&
