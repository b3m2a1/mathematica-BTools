With[{args=#2},
  TemplateSequence[
    If[ValueQ@$$siteElementTemplate//TrueQ,
      $$siteElementTemplate,
      $$siteElementTemplate=
        XMLTemplate[File@"include/lib/templates/siteElement.html"]
      ],
    Merge[{args, #}, Last]&/@#
    ]
  ]&
