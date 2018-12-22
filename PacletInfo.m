(* ::Package:: *)

Paclet[
  Name -> "BTools",
  Version -> "2.1.38",
  Creator -> "b3m2a1@gmail.com",
  WolframVersion -> "11+",
  URL -> "https://github.com/b3m2a1/mathematica-BTools",
  Description -> "A suite of development tools",
  Thumbnail -> "PacletIcon.png",
  Extensions -> {
    	{
     		"Kernel",
     		"Root" -> ".",
     		"Context" -> {"BTools`"}
     	},
    	{
     		"Resource",
     		"Root" -> "Resources",
     		"Resources" -> {
       			"Icons",
       			"Images",
       			"PaletteGenerators",
       			"Templates",
       			"Themes",
       			{
        				"PacletIcon",
        				"Icons/PacletIcon.png"
        			},
       			{
        				"PacletSiteIcon",
        				"Icons/PacletSiteIcon.png"
        			},
       			{
        				"GoogleOAuthExample",
        				"Images/GoogleOAuthExample.png"
        			},
       			{
        				"AppManagerPaletteGenerator",
        				"PaletteGenerators/AppManagerPaletteGenerator.nb"
        			},
       			{
        				"CuratedDataHelperGenerator",
        				"PaletteGenerators/CuratedDataHelperGenerator.nb"
        			},
       			{
        				"DocumentationGenerator",
        				"PaletteGenerators/DocumentationGenerator.nb"
        			},
       			{
        				"EncodedCacheManagerGenerator",
        				"PaletteGenerators/EncodedCacheManagerGenerator.nb"
        			},
       			{
        				"HTMLHelperGenerator",
        				"PaletteGenerators/HTMLHelperGenerator.nb"
        			},
       			{
        				"PacletServerManagerGenerator",
        				"PaletteGenerators/PacletServerManagerGenerator.nb"
        			},
       			{
        				"PaletteTemplate",
        				"PaletteGenerators/PaletteTemplate.nb"
        			},
       			{
        				"PelicanHelperGenerator",
        				"PaletteGenerators/PelicanHelperGenerator.nb"
        			},
       			{
        				"ServiceConnectionHelperGenerator",
        				"PaletteGenerators/ServiceConnectionHelperGenerator.nb"
        			},
       			{
        				"SiteBuilderGenerator",
        				"PaletteGenerators/SiteBuilderGenerator.nb"
        			},
       			{
        				"ContextLoader",
        				"Templates/ContextLoader.wl"
        			},
       			{
        				"CuratedDataTemplate",
        				"Templates/CuratedDataTemplate.nb"
        			},
       			{
        				"init",
        				"Templates/Initialization/init.m"
        			},
       			{
        				"Main",
        				"Templates/Initialization/Main.wl"
        			},
       			{
        				"README",
        				"Templates/README.nb"
        			},
       			{
        				"ServiceConnectionTemplate",
        				"Templates/ServiceConnectionTemplate.nb"
        			},
       			{
        				"Frameworks",
        				"Templates/Frameworks"
        			},
       			{
        				"CuratedData",
        				"Templates/Frameworks/CuratedData"
        			},
       			{
        				"$ServiceConnection",
        				"Templates/Frameworks/$ServiceConnection"
        			},
       			{
        				"Initialization",
        				"Templates/Initialization"
        			},
       			{
        				"Loader",
        				"Templates/Initialization/Loader"
        			},
       			{
        				"SiteBuilder",
        				"Templates/SiteBuilder"
        			},
       			{
        				"DocumentationSite",
        				"Templates/SiteBuilder/DocumentationSite"
        			},
       			{
        				"PacletServer",
        				"Templates/SiteBuilder/PacletServer"
        			},
       			{
        				"TutorialSite",
        				"Templates/SiteBuilder/TutorialSite"
        			},
       			{
        				"WebSite",
        				"Templates/SiteBuilder/WebSite"
        			},
       			{
        				"minimal",
        				"Themes/minimal"
        			},
       			{
        				"static",
        				"Themes/minimal/static"
        			},
       			{
        				"templates",
        				"Themes/minimal/templates"
        			},
       			{
        				"template_lib",
        				"Themes/template_lib"
        			},
       			{
        				"include",
        				"Themes/template_lib/include"
        			},
       			{
        				"tipuesearch",
        				"Themes/template_lib/tipuesearch"
        			}
       		}
     	},
    	{
     		"FrontEnd",
     		"Prepend" -> True
     	},
    	{
     		"PacletServer",
     		"Tags" -> {
       			"documentation",
       			"front-end",
       			"paclets",
       			"web"
       		},
     		"Categories" -> {"Development"},
     		"Description" ->
      "A general purpose package that implements useful functionality for application development. Features include: distribution tools, documentation generation, front-end manipulation, and application editing",
     		"License" -> "MIT"
     	},
    	{
     		"Documentation",
     		"Language" -> "English",
     		"MainPage" -> "Guides/BTools"
     	}
    }
 ]
