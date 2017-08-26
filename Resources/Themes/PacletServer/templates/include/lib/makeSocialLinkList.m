TemplateApply@
  TemplateObject[{
    "<ul class=\"social-links right-bar-links list-inline\">",
    TemplateSequence[
      XMLTemplate@
        "<li class=\"right-bar-item\">\n<wolfram:slot id='1' /></li>",
      List@
        TemplateApply[
          $$templateLib["makeSiteElements"][
            Merge[{
                "class"->"social-link right-bar-link",
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
