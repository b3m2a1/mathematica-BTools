Title: NotebookToMarkdown
built: {2018, 11, 22, 0, 56, 23.523041}
context: BTools`Web`
Date: 2018-11-22 00:56:23
history: 11.3,,
index: True
keywords: <||>
label: NotebookToMarkdown
language: en
Modified: 2018-11-22 02:17:02
paclet: Mathematica
specialkeywords: <||>
status: None
summary: 
synonyms: <||>
tabletags: <||>
title: NotebookToMarkdown
titlemodifier: 
tutorialcollectionlinks: <||>
type: Symbol
uri: BToolsWeb/ref/NotebookToMarkdown
windowtitle: NotebookToMarkdown

<a id="notebooktomarkdown" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# NotebookToMarkdown

    NotebookToMarkdown[nb]

 Converts a notebook to Markdown

<a id="details" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Details

* ```NotebookToMarkdown``` has 2 call patterns

* ```NotebookToMarkdown``` has the following  [```Options```](/ref/Options.html)

  * ```"Directory"``` - the directory to treat as the root when exporting

    * ```Automatic```

  * ```"Path"``` - the path to the notebook from the root directory

    * ```Automatic```

  * ```"Name"``` - the name for the file

    * ```Automatic```

  * ```"Metadata"``` - the export metadata

    * ```Automatic```

  * ```"ContentExtension"``` - the extension for location content

    * ```Automatic```

  * ```"NotebookObject"``` - the notebook to treat as the source object

    * ```Automatic```

  * ```"Context"``` - the context for symbol resolution

    * ```Automatic```

  * ```"CellStyles"``` - the specification of what styles to export and how

    * ```Automatic```

  * ```"IncludeStyleDefinitions"``` - whether to bundle CSS for the notebook in the Markdown

    * ```Automatic```

  * ```"IncludeLinkAnchors"```  - whether to include  <pre >
<code>
<a></a>
</code>
</pre> tags in the Markdwon

    * ```Automatic```

  * ```"UseHTMLFormatting"``` - whether to export certain elements to HTML

    * ```Automatic```

  * ```"UseMathJAX"``` - whether to export formulae as MathJAX

    * ```False```

  * ```"UseImageInput"``` - whether to export IO as copyable images

    * ```False```

  * ```"PacletLinkResolutionFunction"``` - how to parse and structure paclet links

    * ```Automatic```

  * ```"ImageExportPathFunction"``` - how to parse and structure file links

    * ```Automatic```

  * ```"CodeIndentation"``` - what to use as the code indentation character

    * ```Automatic```

  * ```"ContentPathExtension"``` - the extension used for the path

    * ```Automatic```

* ```NotebookToMarkdown``` has the following  [```Messages```](/ref/Messages.html)

  * ```NotebookToMarkdown::nocont```

    * Can't handle notebook with implicit CellContext ``. Use a string instead.

<a id="examples" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

### Basic Examples

Load the package:

    Needs["BTools`Web`"]

Generate Markdown for a simple notebook:

    NotebookToMarkdown@
      Notebook[
        {
          Cell["This is Markdown!", "Text"],
          Cell[BoxData@ToBoxes@Hyperlink["A link!", "https://www.google.com"]]  
          }
        ]

<pre class="program"><code style="width: 100%; white-space: pre-wrap;">(*Out:*)
This is Markdown!

[A link!](https://www.google.com/)</code></pre>

Generate Markdown for the current notebook:

    NotebookToMarkdown[InputNotebook[]]//Snippet[#, 15]&

<pre >
<code>
(*Out:*)
<a id="notebooktomarkdown"
style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# NotebookToMarkdown

    NotebookToMarkdown[nb]

 Converts a notebook to Markdown

<a id="details" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Details

* ```NotebookToMarkdown``` has 2 call patterns

</code>
</pre>

### Options

This affects how links to paclet resources are exported:

    pacletNB=
      Notebook[
        {
          Cell@
            BoxData@
              ButtonBox["NotebookMarkdownSave",
                BaseStyle->{"Link", "Input"},
                ButtonData->"paclet:ref/NotebookMarkdownSave"
                ]
          }
        ];
    NotebookToMarkdown@pacletNB

<pre class="program"><code style="width: 100%; white-space: pre-wrap;">(*Out:*)
[```NotebookMarkdownSave```](https://www.wolframcloud.com/objects/b3m2a1.docs/reference/ref/NotebookMarkdownSave.html)</code></pre>

    NotebookToMarkdown[pacletNB, 
      "PacletLinkResolutionFunction"->(StringTrim[#, "paclet:"]&)
      ]

<pre class="program"><code style="width: 100%; white-space: pre-wrap;">(*Out:*)
[```NotebookMarkdownSave```](ref/NotebookMarkdownSave)</code></pre>

This changes which cells are exported and what function to use in the export

    NotebookToMarkdown[
      InputNotebook[],
      "CellStyles" ->{"Code"},
      "CodeIndentation"->""
      ]//Snippet[#, 10]&

<pre class="program"><code style="width: 100%; white-space: pre-wrap;">(*Out:*)
NotebookToMarkdown[nb]

Needs["BTools`Web`"]

NotebookToMarkdown@
  Notebook[
    {
      Cell["This is Markdown!", "Text"],
      Cell[BoxData@ToBoxes@Hyperlink["A link!", "https://www.google.com"]]  
      }</code></pre>

We can use a different export function (metadata is passed as the first argument, the object as the second):

    NotebookToMarkdown[
      InputNotebook[],
      "CellStyles" ->
        {
          "Text"->
            Function[{pathInfo, cell}, 
              StringReverse[First@FrontEndExecute@ExportPacket[cell, "PlainText"]]
              ]
          },
      "CodeIndentation"->""
      ]//Snippet[#, 10]&

    (*Out:*)
    
    "nwodkram ot koobeton a strevnoC \n\n:egakcap eht daoL\n\n:koobeton elpmis a rof nwodkraM etareneG\n\n:koobeton tnerruc eht rof nwodkraM etareneG\n\n:detropxe era secruoser telcap ot sknil woh stceffa sihT\n"

We can get the defaults by using the argument  ```ParentList``` . We can drop things by using  ```"Name"->None``` :

    NotebookToMarkdown[
      InputNotebook[],
      "CellStyles" ->{ParentList, "Text"->None, "Code"->None},
      "CodeIndentation"->""
      ]//Snippet[#, 10]&

<pre >
<code>
(*Out:*)

"<a id=\"notebooktomarkdown\"\nstyle=\"width:0;height:0;margin:0;padding:0;\">&zwnj;</a>\n\n# NotebookToMarkdown\n\n<a id=\"details\" style=\"width:0;height:0;margin:0;padding:0;\">&zwnj;</a>\n\n## Details\n\n* ```NotebookToMarkdown``` has 2 call patterns"
</code>
</pre>

### Definitions

Examine all definitions:

    GeneralUtilities`PrintDefinitionsLocal[NotebookToMarkdown]

<a id="see-also" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## See Also

[```NotebookMarkdownSave```](/ref/NotebookMarkdownSave.html)

Made with SimpleDocs