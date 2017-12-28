With[{args=#2},
  TemplateSequence[
    XMLTemplate[File@"include/lib/templates/siteElement.html"],
    Merge[{args,#},Last]&/@#
    ]
  ]&
