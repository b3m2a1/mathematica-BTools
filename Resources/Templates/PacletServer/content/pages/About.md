Title: About
Modified: 2017-08-27 03:55:59
Slug: about

<a id="about-this-site" >&zwnj;</a>

## About This Site

This is a paclet server. It lists the currently available paclets at this site. You can download any paclet via the “Download” link on its page. Alternatively, you can install paclets via  [```PacletInstall```](https://www.wolframcloud.com/objects/b3m2a1.paclets/reference/PacletManager/ref/PacletInstall.html) .

There are two ways to do this:

* Via the paclet download link

	$paclet = 
	  "https://this.paclet.server/Paclets/paclet-name-and-version.paclet";\
	
	PacletInstall[$paclet]

* Via a the paclet site:

	$pacletName = "NameOfPaclet";
	PacletSiteAdd["https://this.paclet.server", "Paclet site description"];
	PacletInstall[$pacletName]

<a id="about-paclets" >&zwnj;</a>

## About Paclets

Paclets are the standard Mathematica package distribution format. They’re the source code for a package compressed with a PacletInfo.m file that provides meta-information about the package.

Paclets installed via  ```PacletInstall```  can automatically be loaded via  ```Get```  without passing the source name and provide all of the conveniences of a Mathematica apllication.