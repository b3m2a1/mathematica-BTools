StringJoin@
  Replace[
    Characters@
      StringTrim@
        StringDelete[
          Replace[#["Summary"], Except[_String]->""],
          _?(Not@*PrintableASCIIQ)
          ],
    <|
      "&" -> "&amp;", "<" -> "&lt;", ">" -> "&gt;",
      "\"" -> "&quot;",  "'" -> "&#39;"
      |>,
    {1}
    ]&
