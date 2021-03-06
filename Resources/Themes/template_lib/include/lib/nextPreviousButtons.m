With[{
    curr=#SourceFile
    },
  With[
    {
        nextObj=
          #NextObjectBy[curr,
            Replace[
              Replace[#["SortingFunction"],
                _Missing:>#["test"]
                ],
              _Missing:>(#["Date"]&)
              ],
            #Templates[[1]]
            ],
        prevObj=
          #PreviousObjectBy[curr,
            Replace[
              Replace[#["SortingFunction"],
                _Missing:>#["test"]
                ],
              _Missing:>(#["Date"]&)
              ],
            #Templates[[1]]
            ]
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
