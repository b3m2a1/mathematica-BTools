$$templateLib["makeSiteElements"][
  Merge[{
    "rel"->"stylesheet",
    If[!StringStartsQ[#["href"], "http"],
      ReplacePart[#,
        "href"->
          URLBuild[{"theme","css", #["href"]}]
        ],
      #
      ],
    "type"->"link"
    },
    Last
    ]&/@Replace[#,l_List:>Replace[l,s_String:><|"href"->s|>,1]],
  #2
  ]&
