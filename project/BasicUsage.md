<a id="btools-usage" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# BTools Usage

This is a document to help support the usage of BTools. 

It is based on  [Issue #4 (Development use cases outline)](https://github.com/b3m2a1/mathematica-BTools/issues/4) . Updates are possible on request.

---

<a id="creation--development" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Creation / Development

Most of this will use be handled by the  ```Paclets```  context. We load that like:

```mathematica
<<BTools`Paclets`
```

### New Projects  [![status](http://img.shields.io/badge/Status-Implemented-green.svg)]( )

These can by handled by the general purpose  ```AppExecute``` . The interface is centralized to minimize the amount of memorization necessary.

To make a new paclet project run:

```mathematica
AppExecute["Configure", "NewApp"]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp"

You can change where paclets are made and loaded from with:

```mathematica
AppExecute["SetMainDirectory", dir]
```

### Project Content  [![status](http://img.shields.io/badge/Status-Implemented-green.svg)]( )

This has a few bits to it. We can get basic file names like:

```mathematica
AppExecute["FileNames", "BTools", "*Info.m", Infinity]
```

    (*Out:*)
    
    {"Config/BundleInfo.m","Config/DocInfo.m","Config/LoadInfo.m","Config/UploadInfo.m","PacletInfo.m","Private/Config/LoadInfo.m","Resources/Templates/TutorialSite/BuildInfo.m","Resources/Templates/TutorialSite/DeploymentInfo.m"}

Or we can get package names:

```mathematica
AppExecute["ListPackages", "BTools"]~Take~5
```

    (*Out:*)
    
    {"Developer/AuthDialogs","Developer/EncodedCache","Developer/FunctionInfoExtractor","Developer/SyncTools","External/GitConnection"}

Or stylesheets:

```mathematica
AppExecute["ListStylesheets", "BTools"]
```

    (*Out:*)
    
    {"BTools/CodeNotebook","BTools/CodePackage","BTools/CodePackagePlain","BTools/DocGen","BTools/MarkdownNotebook","BTools/PelicanMarkdown","BTools/SyntaxHighlighting"}

And there's some other stuff cooked in

### Create PacletInfo  [![status](http://img.shields.io/badge/Status-Ugly-yellow.svg)]( )

This is handled with a kinda ugly call pattern for now:

```mathematica
AppExecute["RegenerateConfig", "NewApp", "PacletInfo"]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp/PacletInfo.m"

To compound the injury we use a different function to extract info about it:

```mathematica
AppPacletExecute["PacletInfo", "NewApp"]
```

    (*Out:*)
    
    <|"Name"->"NewApp","Version"->"1.0.2","Extensions"-><|"Kernel"-><|"Root"->".","Context"->{"NewApp`"}|>|>,"Location"->"/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp"|>

The second function could easily handle the first case too. If you want to add parameters that's easy:

```mathematica
AppExecute["RegenerateConfig", 
  "NewApp", 
  "PacletInfo", 
  "Version"->"6.6.6", 
  "Extensions"-><|
    "PacletServer"-><|"Description"->"wow this is a dumb app"|>
    |>
  ]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp/PacletInfo.m"

### Git Init  [![status](http://img.shields.io/badge/Status-Implemented-green.svg)]( )

For this we can use the  ```AppGit```  function that wraps the  ```Git```  interface in the  ```External```  subcontext for use with app dev stuff:

```mathematica
AppGit["Init", "NewApp"]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp"

```mathematica
AppExecute["FileNames", "NewApp", "*git*"]
```

    (*Out:*)
    
    {".git",".gitignore"}

You can create a repository for this on GitHub with

```mathematica
AppGit["GitHubConfigure", "NewApp"]
```

    (*Out:*)
    
    "https://github.com/b3m2a1/mathematica-NewApp"

And delete it with

```mathematica
AppGit["GitHubDelete", "NewApp"]
```

    (*Out:*)
    
![basicusage-7425717185455079729](../../project/img/basicusage-7425717185455079729.png)

### Create Tests  [![status](http://img.shields.io/badge/Status-Missing-red.svg)]( )

Currently missing

---

<a id="pacletinfo" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## PacletInfo

### Paclet Info Modification  [![status](http://img.shields.io/badge/Status-Ugly-yellow.svg)]( )

Currently as described in the  [Create PacletInfo](#create-pacletinfo)  section.

### Paclet Info Extractors  [![status](http://img.shields.io/badge/Status-On%20Hold-yellow.svg)]( )

No real plans to go beyond what has been presented before

```mathematica
AppPacletExecute["PacletInfo", "BTools"]["Version"]
```

    (*Out:*)
    
    "2.1.12"

### Increment Version  [![status](http://img.shields.io/badge/Status-On%20Hold-yellow.svg)]( )

Currently done by default when regenerating PacletInfo expression

---

<a id="kernel" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Kernel

### Add Package  [![status](http://img.shields.io/badge/Status-Implemented-green.svg)]( )

Currently implemented under the  ```"AddContent"```  function in  ```AppExecute``` :

```mathematica
AppExecute["AddContent", "NewApp", 
  AppExecute["ListPackages", "BTools", "DropDirectory"->False][[1]]
  ]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp/Packages/AuthDialogs.m"

Generally will be auto-detected, but the path can be specified as desired:

```mathematica
AppExecute["AddContent", "NewApp", 
  "~/Desktop/garbage_collector.nb",
  "Packages"
  ]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp/Packages/garbage_collector.nb"

---

<a id="frontend" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## FrontEnd

### Add Stylesheet  [![status](http://img.shields.io/badge/Status-Implemented-green.svg)]( )

Currently implemented under the  ```"AddContent"```  function in  ```AppExecute``` :

```mathematica
AppExecute["AddContent", "NewApp", 
  AppExecute["ListStylesheets", "BTools", "DropDirectory"->False][[1]]
  ]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp/FrontEnd/StyleSheets/NewApp/CodeNotebook.nb"

Generally will be auto-detected, but the path can be specified as desired:

```mathematica
AppExecute["AddContent", "NewApp", 
  AppExecute["ListStylesheets", "BTools", "DropDirectory"->False][[1]],
  "Palettes"
  ]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp/FrontEnd/Palettes/CodeNotebook.nb"

---

<a id="documentation" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Documentation

### New Doc Page  [![status](http://img.shields.io/badge/Status-Needs%20Work-red.svg)]( )

Currently implemented the  ```DocGen```  interface. The  ```AppDocGen```  wrapper on this needs some work to account for recent changes in  ```DocGen```  modularization.

```mathematica
DocGen["SymbolPage", DocGen]
```

    (*Out:*)
    
![basicusage-8415866144166657194](../../project/img/basicusage-8415866144166657194.png)

![basicusage-8619797801934996806](../../project/img/basicusage-8619797801934996806.png)

```mathematica
DocGen["Guide", "BTools`Paclets`"]
```

    (*Out:*)
    
![basicusage-69428561328746212](../../project/img/basicusage-69428561328746212.png)

![basicusage-550941416480850982](../../project/img/basicusage-550941416480850982.png)

Pages can be saved to a directory by passing  ```Method```  options:

```mathematica
DocGen["SymbolPage", DocGen, 
  Method->
    {
      "Save", 
      Directory->AppExecute["Path", "NewApp", "Documentation", "English"]
      }
  ]
```

```mathematica
AppExecute["ListContent", "NewApp", "SymbolPages"]
```

    (*Out:*)
    
    {"DocGen"}

See more  [here](https://github.com/b3m2a1/mathematica-BTools/blob/master/project/examples/Paclets.md#documentation-building) .

### Build Documentation  [![status](http://img.shields.io/badge/Status-Ugly-yellow.svg)]( )

Multi-paclet docs can be built like:

```mathematica
DocGen["Paclet", 
  {
    "BTools`Paclets`",
    "BTools`Developer`"
    }
  ]
```

![basicusage-4666648522623206664](../../project/img/basicusage-4666648522623206664.png)

More info on this and the other options and methods if desired.