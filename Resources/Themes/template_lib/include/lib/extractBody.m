StringTrim[
  ExportString[
    FirstCase[#, XMLElement["body", _, _], #, Infinity],
    "XML"
    ],
  "<body>"|"</body>"
  ]&
