With[{args=#2},
  TemplateSequence[
    XMLTemplate[File@"include/lib/siteElement.html"],
    Merge[{args,#},Last]&/@#
    ]
  ]&
