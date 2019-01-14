Title: AppDocGen
built: {2019, 1, 13, 22, 13, 4.146422}
context: BTools`
Date: 2019-01-13 22:13:06
history: 11.3,,
index: True
keywords: 
label: AppDocGen
language: en
Modified: 2019-01-13 22:13:06
paclet: Mathematica
specialkeywords: 
status: None
summary: 
synonyms: 
tabletags: 
title: AppDocGen
titlemodifier: 
tutorialcollectionlinks: 
type: Symbol
uri: BTools/ref/AppDocGen
windowtitle: AppDocGen

<a id="appdocgen" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# AppDocGen

    AppDocGen[type, app]

 A high-level interface to generating application docs

<a id="details" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Details

*  AppDocGen has 1 call pattern

*  AppDocGen has the following Options

  *  Method

    *  Automatic

*  AppDocGen has the following Messages

  *  AppDocGen::nopkg

    *  Method `` requires 

*  AppDocGen has the following Attributes

  *  HoldRest

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<a id="basicexamples" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

###Basic Examples

Load the package:

    Needs["BTools`Paclets`"]

AppDocGen[type, app]

    AppDocGen["SymbolPage", "BTools`Paclets`Private`app_"]

<a id="options" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

###Options

<a id="method" class="Subsubsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

#### Method

Possible option values for Method include:

    AppDocGen["SymbolPage", "BTools`Paclets`Private`app_", Method -> Automatic]

<a id="definitions" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

###Definitions

Examine all definitions:

    GeneralUtilities`PrintDefinitionsLocal[AppDocGen]

<a id="relatedguides" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Related Guides

*  [SimpleDocs](../guide/SimpleDocs.html)

<a id="relatedtutorials" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Related Tutorials

*  [SimpleDocs](../tutorial/SimpleDocs.html)

<a id="relatedlinks" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Related Links

*  [SimpleDocs](https://github.com/b3m2a1/SimpleDocs)

*  [BTools](https://github.com/b3m2a1/mathematica-BTools)

*  [Ems](https://github.com/b3m2a1/Ems)

---

Made with  [SimpleDocs](https://github.com/b3m2a1/SimpleDocs)