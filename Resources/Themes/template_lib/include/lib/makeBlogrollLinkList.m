TemplateApply@
  TemplateObject[{
    "<ul class=\"blogroll-links right-bar-links list-inline\">",
    TemplateSequence[
      XMLTemplate@
        "<li class=\"right-bar-item\">\n<wolfram:slot id='1' /></li>",
      List@
        TemplateApply[
          $$templateLib["makeSiteElements"][
            Merge[{
                "class"->"blogroll-link right-bar-link",
                "target"->"_blank",
                #,
                "type"->"a"},Last]&/@#,
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
