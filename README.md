<a id="btools" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# BTools

[![version](http://img.shields.io/badge/version-2.1.22-orange.svg)](https://github.com/b3m2a1/mathematica-BTools/PacletInfo.m)   [![license](http://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

The BTools application is a multi-use Mathematica application, largely devoted to simplifying the development process. The application has an autoloader primary file that exposed package-scoped helper functions and loads all of the packages in the  [Packages](Packages)  directory into the main context.

---

<a id="installation" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# Installation

The easiest way to install these packages is using a paclet server installation:

```mathematica
PacletInstall[
  "BTools",
  "Site"->
    "http://www.wolframcloud.com/objects/b3m2a1.paclets/PacletServer"
  ]
```

If you've already installed it you can update using:

```mathematica
PacletUpdate[
  "BTools",
  "Site"->
    "http://www.wolframcloud.com/objects/b3m2a1.paclets/PacletServer"
  ]
```

Alternately you can download this repo as a ZIP file and put extract it in  ```$UserBaseDirectory/Applications```

---

Examples and usages can be found on the  [Wiki](https://github.com/b3m2a1/mathematica-BTools/wiki)
