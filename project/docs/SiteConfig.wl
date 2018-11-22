(* ::Package:: *)

(* Created with the Wolfram Language : www.wolfram.com *)
{
      "SiteName"->"Documentation",
  	(*"SiteCreator"\[Rule]...,*)
  	"Theme"->"bootstrap-docs",
  	"BootstrapTheme"->"mma",
      (*"IncludeSidebar"->True,*)
  	(*"SiteLogo"\[Rule]"site-logo.png",*)
  	(*"BannerImage"->"banner.png",*)
  	(*"BannerHeight"\[Rule]Scaled[.2],*)
  	"PrettyPrint"->True,(* use prettify.js as a code highlighter *)
  	"CodeLanguage"->"mma",(* use the given language in prettify *)
  	"PatchFonts"->True,(* use Mathematica fonts for special symbols*)
  	"SplitInOut"->True,(* split in and out code *)
  	"AttachIDs"->True,(* add IDs to nodes based on type *)
  	"EnableSearch"->True,(* use tipue search *)
  	(*"GoogleAnalytics"->"UA-000000000-0",*)(* link to Google analytics *)
  	(*"DisqusSiteName"->"..."*)(* use the given Disqus site for comments *)  	
  	(*"ContentFluid"\[Rule]True,*)
  	(*"ContentClass"\[Rule]"well",*)
  	(*"SidebarClass"\[Rule]"panel",*)
  	(*"NavbarInvert"\[Rule]True,*)
  	"SummaryLength"->{1, "Lines"},
  	"DeployOptions"->
  		{
  			(*CloudConnect->"DeploymentsAccount"*)(* connect before deployment*)
  			},
  	"BuildOptions"->
  		{
  		  "ContentDirectories"->{"ref", "tutorial", "guide", "pages"},
  	      "ContentDirectoryTemplates"->
        	  AssociationThread[
        	    {"ref", "tutorial", "guide"},
        	    {"function", "tutorial", "guide"}
        	    ],
        	"GenerateAggregations"->False,
  		  "GenerateIndex"->True
  			(*"SearchPageOptions"->
  				{
  					"Options"->{"WholeWords"->False}
  					}*)(* options for tipue search *)
  			}
  	}
