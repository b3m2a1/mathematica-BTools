Title: BTools
built: {2018, 11, 22, 2, 27, 21.122714}
context: BTools`
Date: 2019-02-07 13:48:54
history: 11.3,,
index: True
keywords: 
label: BTools
language: en
Modified: 2019-02-07 13:48:56
paclet: Mathematica
specialkeywords: 
status: None
summary: 
synonyms: 
tabletags: 
title: BTools
titlemodifier: 
tutorialcollectionlinks: 
type: Guide
uri: BTools/guide/BTools
windowtitle: BTools

<a id="btools" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# BTools

BTools is a too-many-use package that implements all the development-oriented things I've thought of. It's divided into subcontexts so that it doesn't flood the namespace with symbols when loaded. The chunks are:

*  Paclets

*  External

*  Frameworks

*  FrontEnd

*  Web

*  Developer

*  Utilities

If you want anything documented let me know and I'll try to whip up some pages, which will be deployed to the  [Wiki](https://github.com/b3m2a1/mathematica-BTools/wiki) or to a documentation paclet.

---

<a id="paclets" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

###Paclets

There are too many functions in this context, but the big ones are  ```PacletExecute``` ,  ```AppExecute``` , and the  ```PacletServer``` -related ones ( ```DocGen``` also does a ton, but it's on life support as I move to supporting more SimpleDocs-style docs)

    Names["BTools`Paclets`*"]//Length

    (*Out:*)
    
    24

---

<a id="external" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

###External

The big ones here are  ```Git``` ,  ```GiitHub``` ,  ```GoogleDrive``` , and  ```GoogleAnalytics``` which are all moderately expansive API connections (esp.  ```GitHub``` ).

There are also utilities for playing with python, but nothing that  [PyTools](https://github.com/b3m2a1/mathematica-PyTools) can't do better. I do make use of the  ```PySimpleServer``` -stuff in many of the web related functions

    Names["BTools`External`*"]//Length

    (*Out:*)
    
    22

---

<a id="frameworks" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

###Frameworks

There are only two functions here, one for hooking into the ServiceConnection framework and another for working with the DataPaclets framework. Conceivably more might come, but these are hard functions to write and get robust.

    Names["BTools`Frameworks`*"]//Length

    (*Out:*)
    
    2

---

<a id="frontend" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

###FrontEnd

These functions all make it nicer to work with the front end, in particular  ```StyleSheetNew``` and  ```StyleSheetEdit``` which make working with stylesheets much, much cleaner. All the  ```Indentation``` stuff is what allows batch indent and indentation replacement in my package stylesheets.

    Names["BTools`FrontEnd`*"]//Length

    (*Out:*)
    
    41

---

<a id="web" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

###Web

These functions support site building, mostly.

    Names["BTools`Web`*"]//Length

    (*Out:*)
    
    21

---

<a id="developer" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

###Developer

These functions aren't really useful at top level, but they're very useful inside other code:

    Names["BTools`Developer`*"]//Length

    (*Out:*)
    
    106

---

<a id="utilities" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

###Utilities

These are actually very useful functions, but are highly unlikely to be used within other code:

    Names["BTools`Utilities`*"]//Length

    (*Out:*)
    
    92

---

<a id="others" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

###Others

All of these packages rely on lower-level packages and functions too, which have more specialized functions that might be useful:

    Names["BTools`*`*"]//Select[StringFreeQ[#, "Private"]&&StringCount[#, "`"]==3&]//Length

    (*Out:*)
    
    372

---

<a id="relatedlinks" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Related Links

*  [BTools](https://github.com/b3m2a1/mathematica-BTools)

*  [BTools Wiki](https://github.com/b3m2a1/mathematica-BTools/wiki)

---

Made with  [SimpleDocs](https://github.com/b3m2a1/SimpleDocs)