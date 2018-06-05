Title: About
Modified: 2017-10-17 00:04:02
Slug: about

<a id="about-this-site" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## About This Site

This is a paclet server. It lists the currently available paclets at this site. You can download any paclet via the “Download” link on its page. Alternatively, you can install paclets via  [```PacletInstall```](https://www.wolframcloud.com/objects/b3m2a1.paclets/reference/PacletManager/ref/PacletInstall.html) .

There are three ways to do this:

* Via the paclet download link

	$paclet = 
	  "https://this.paclet.server/Paclets/paclet-name-and-version.paclet";\
	
	PacletInstall[$paclet]

* Via a paclet site:

	$pacletName = "NameOfPaclet";
	$pacletSite = "https://this.paclet.server";
	PacletInstall[$pacletName, "Site" -> $pacletSite]

* Via an update-able paclet site:

	$pacletName = "NameOfPaclet";
	PacletSiteAdd["https://this.paclet.server", "Paclet site description"];
	PacletInstall[$pacletName]

<a id="about-paclets" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## About Paclets

Paclets are the standard Mathematica package distribution format. They’re the source code for a package compressed with a PacletInfo.m file that provides meta-information about the package.

Paclets installed via  ```PacletInstall```  can automatically be loaded via  ```Get```  without passing the source name and provide all of the conveniences of a Mathematica application.