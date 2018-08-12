Function[
  $$["ArticleInfoItems"]=
    Lookup[$$,
      "ArticleInfoItems",
      {
        "Date",
        "Modified",
        "Author",
        "Category",
        "Tags"
        }
      ];
  $$["Article"]=
    If[AssociationQ@#,
      #,
      Merge[Select[#, OptionQ], Last]
      ];
  $$["Date"]=
    Which[
      DateObjectQ@$$["Article", "Date"],
        DateString[$$["Article", "Date"], "DateShort"],
      StringQ@$$["Article", "Date"],
        $$["Article", "Date"],
      True,
        None
      ];
  $$["Modified"]=
    Which[
      DateObjectQ@$$["Article", "Modified"],
        DateString[$$["Article", "Modified"], "DateShort"],
      StringQ@$$["Article", "Modified"],
        $$["Article", "Modified"],
      True,
        None
      ];
  $$["Authors"]=
    Which[
      ListQ@$$["Article", "Authors"],
        $$["Article", "Authors"],
      StringQ@$$["Article", "Authors"],
        {$$["Article", "Authors"]},
      True,
        None
      ];
  $$["Categories"]=
    Which[
      ListQ@$$["Article", "Categories"],
        $$["Article", "Categories"],
      StringQ@$$["Article", "Categories"],
        {$$["Article", "Categories"]},
      True,
        None
      ];
  $$["Tags"]=
    Which[
      ListQ@$$["Article", "Tags"],
        $$["Article", "Tags"],
      StringQ@$$["Article", "Tags"],
        {$$["Article", "Tags"]},
      True,
        None
      ];
  ]
