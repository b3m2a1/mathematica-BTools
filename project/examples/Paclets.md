<a id="making-a-new-application" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Making a new application

Load the package:

```mathematica
 <<BTools`Paclets`
```

Create a new application

```mathematica
 AppExecute["SetMainDirectory", $TemporaryDirectory]; 
 AppExecute["Configure", "NewApp"]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp"

Inspect what has been made in our new application:

```mathematica
 FileNameTake/@FileNames["*", AppExecute["Path", "NewApp"]]
```

    (*Out:*)
    
    {"Config","Documentation","FrontEnd","Kernel","NewAppLoader.m","NewApp.wl","Packages","PacletInfo.m","Private","project","Resources"}

```"Configure"```  automatically builds out the basic directories used as well as a load-script to load the contents of the  ```"Packages"```  subdirectory with autoloading and other development support functionality.

Then we'll add a package

```mathematica
 AppExecute["AddContent", "NewApp", FindFile["BTools`"]]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp/Packages/init.m"

And a stylesheet from BTools:

```mathematica
 AppExecute["AddContent", "NewApp", 
  AppExecute["Path", "BTools", "StyleSheets", "BTools", "CodePackage.nb"]
  ]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp/FrontEnd/StyleSheets/NewApp/CodePackage.nb"

Build the  ```"PacletInfo.m"```  file

```mathematica
 AppExecute["RegenerateConfig", "NewApp", "PacletInfo"]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp/PacletInfo.m"

And see what's inside:

```mathematica
 AppPacletExecute["PacletInfo", "NewApp"]
```

    (*Out:*)
    
    <|"Name"->"NewApp","Version"->"1.0.1","Extensions"-><|"Kernel"-><|"Root"->".","Context"->{"NewApp`"}|>,"FrontEnd"-><||>|>,"Location"->"/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/NewApp"|>

We could then upload this application to the cloud so others can download it:

```mathematica
 AppPacletExecute["Upload", "NewApp", CloudConnect->"b3m2a1.paclets@gmail.com"]
```

    (*Out:*)
    
    <|"PacletSiteFile"->CloudObject["http://www.wolframcloud.com/objects/b3m2a1.paclets/NewApp/PacletSite.mz",Permissions->"Public",Permissions->"Public"],"PacletFiles"->{CloudObject[]}|>

Someone could install the app like

```mathematica
 PacletInstall[
  "NewApp",
  "Site"->"http://www.wolframcloud.com/objects/b3m2a1.paclets/NewApp"
  ]
```

    (*Out:*)
    
![paclets-3060751501420587715](../../project/img/paclets-3060751501420587715.png)

<a id="working-with-paclets" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Working with Paclets

Install a paclet from GitHub

```mathematica
 PacletExecute["Install", "github:szhorvat/MaTex"]
```

    (*Out:*)
    
![paclets-8090201827297721276](../../project/img/paclets-8090201827297721276.png)

Find the names of all the paclets available on a server:

```mathematica
 PacletExecute["SiteDataset", 
  "https://www.wolframcloud.com/objects/b3m2a1.paclets/PacletServer"][All, "Name"]//
    DeleteDuplicates
```

    (*Out:*)
    
![paclets-2372610212413813325](../../project/img/paclets-2372610212413813325.png)

Create a paclet directory from a package:

```mathematica
 pacDir=PacletExecute["AutoGeneratePaclet", $TemporaryDirectory, FindFile["FEInfoExtractor`"]]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/FEInfoExtractor"

Upload this paclet to the cloud

```mathematica
 PacletExecute["Upload",
  pacDir,
  "ServerName"->"TestPaclets",
   CloudConnect->"TestingAccount"
  ][["PacletFiles", 1]]
```

    (*Out:*)
    
    CloudObject[]

<a id="documentation-building" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Documentation Building

Autogenerate documentation:

```mathematica
 DocGen[DocGen]
```

![paclets-3944086624101741822](../../project/img/paclets-3944086624101741822.png)

Autogenerate an overview guide for a context

```mathematica
 DocGen["Guide", "PacletManager`"]
```

    (*Out:*)
    
![paclets-6456334289508492125](../../project/img/paclets-6456334289508492125.png)

Autogenerate documentation paclets from a set of contexts:

```mathematica
 <<OAuth` 
 DocGen["Paclet", 
  {
    "OtherClient`",
    "KeyClient`",
    "OAuthClient`",
    "OAuth`"
    },
  Method->{
    Directory->$TemporaryDirectory
    }
  ]
```

![paclets-8350260503414164841](../../project/img/paclets-8350260503414164841.png)

Generate a template notebook for writing a tutorial

![paclets-8031869743256385252](../../project/img/paclets-8031869743256385252.png)

The  ```"SymbolPage"``` ,  ```"Guide"``` , and  ```"Tutorial"```  types support  ```"Template"``` ,  ```"Notebook"``` , and  ```"Save"```  methods.

We can write content in the template notebook and use the bar on the top to generate a tutorial.

![paclets-265881908806275627](../../project/img/paclets-265881908806275627.png)

<a id="frontend-resources" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Front-End Resources

On the front-end side, the  [CodePackage](FrontEnd/StyleSheets/BTools/CodePackage.nb)  stylesheet provides a convenient stylesheet for developing packages. 

It provides a number of useful custom styles, customizable syntax coloring, block indentation, and package annotations in its  ```AutoGeneratedPackage``` .

You can see an example notebook  [here](Notebook-CodePackage.nb) .

There are two child stylesheets that remove a few functionalities of CodePackage, CodeNotebook, and CodePackagePlain. The first removes the  ```AutoGeneratedPackage``` , the second just removes the  ```DockedCells``` .

The  [DocGen](FrontEnd/StyleSheets/BTools/DocGen.nb)  stylesheet supports the DocGen package. It provides a toolbar for adding common templates, a hopefully simple-enough flow. Examples of a documentation template notebook can be found  [here](Notebook-DocGen.nb) .