With[{
    curr=#ContentData[#SourceFile]
    },
  With[
    {
        nextObj=#NextObjectBy[curr, #test, #Templates[[1]]],
        prevObj=#PreviousObjectBy[curr, #test, #Templates[[1]]]
        },
    XMLTemplate[File["include/lib/templates/next-previous.html"]]@
      Join[
        #,
        <|
          "NextPageURL"->
            nextObj["URL"],
          "NextPageTitle"->
            nextObj["Title"],
          "PreviousPageURL"->
            prevObj["URL"],
          "PreviousPageTitle"->
            prevObj["Title"]
          |>
        ]
    ]
  ]&
