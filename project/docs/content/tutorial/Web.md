BTools supports a number of web-content related functions. First load the package:

```mathematica
<<BTools`Web`
```

<a id="markdown-parsing" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Markdown Parsing

BTools uses a Markdown -> XML transform when making websites. This is all handled by the  ```MarkdownToXML```  function.

```mathematica
MarkdownToXML@
  ReadString@FileNameJoin@{NotebookDirectory[], "Web.md"}//Short[#, 5]&
```

    (*Out:*)
    
    XMLElement["html",<<1>>,{XMLElement["body",{},{XMLElement["p",{},{"BTools supports a number of web-content related functions. First load the package:"}],<<8>>,XMLElement["p",{},{"This is mostly used as the back-end for the MarkdownNotebook stylesheet. See the ",XMLElement["a",{"href"->""…"b"},{"Example Notebook"}],"  for more."}]}]}]

<a id="notebook-to-markdown" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notebook to Markdown

This is mostly used as the back-end for the MarkdownNotebook stylesheet. See the  [Example Notebook](Notebook-MarkdownNotebook.nb)  for more.

<a id="site-building" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Site Building

There is a full website building framework built into BTools. It works as a static site generator and generated all of the content seen  [here ](https://paclets.github.io/PacletServer/) automatically from a collection of notebooks. It also made every part of the tutorial  [here](https://www.wolframcloud.com/app/objects/b3m2a1.testing/tutorial) .

If there's interest let me know and I'll write a custom guide page for this.