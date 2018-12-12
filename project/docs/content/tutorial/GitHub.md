<a id="github-examples" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# GitHub Examples

Load the package

```mathematica
<<BTools`External`
```

The main function here is  ```GitHub``` , which is a general purpose wrapper encapsulating everything to do with the  [github API](https://developer.github.com/v3/) .

<a id="general-form" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## General Form

A request is generally formatted like so:

```mathematica
GitHub["Name", params...]
```

You can also specify a return format. These can be any of

*  ```"HTTPRequest"``` — the  [```HTTPRequest```](https://reference.wolfram.com/language/ref/HTTPRequest.html) to be passed

*  ```"HTTPResponse"``` — the  [```HTTPResponse```](https://reference.wolfram.com/language/ref/HTTPResponse.html) returned

*  ```"ResultJSON"``` — the result imported as  ```"JSON"```

*  ```"ImportedResult"``` — the JSON result imported as formatted  ```Association``` . This is default return format.

*  ```"ResultObject"``` — the result imported as  ```"ResultObject"``` ( ```Success``` or  ```Failure``` )

There are also two special parameters that may be requested in place of the  ```params``` :

*  ```"Function"``` — the function that constructs the  ```HTTPRequest```

*  ```"Options"``` — the  ```Options``` the function takes (generally these correspond to the parameters the API will take)

<a id="direct-api-access" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### Direct API Access

For things that aren't implemented by the framework already there's a format to pass one's own requests:

```mathematica
GitHub[
  {path...},
  {params...},
  <|headers...|>,
  ops...
  ]
```

Here's an example to access the yet-unlinked  [gitignore endpoints](https://developer.github.com/v3/gitignore/) :

```mathematica
GitHub[
  {"gitignore", "templates"},
  "ResultJSON"
  ]
```

    (*Out:*)
    
    <|"StatusCode"->200,"Content"->{"Actionscript","Ada","Agda","Android","AppEngine","AppceleratorTitanium","ArchLinuxPackages","Autotools","C","C++","CFWheels","CMake","CUDA","CakePHP","ChefCookbook","Clojure","CodeIgniter","CommonLisp","Composer","Concrete5","Coq","CraftCMS","D","DM","Dart","Delphi","Drupal","EPiServer","Eagle","Elisp","Elixir","Elm","Erlang","ExpressionEngine","ExtJs","Fancy","Finale","ForceDotCom","Fortran","FuelPHP","GWT","GitBook","Go","Godot","Gradle","Grails","Haskell","IGORPro","Idris","Java","Jboss","Jekyll","Joomla","Julia","KiCAD","Kohana","Kotlin","LabVIEW","Laravel","Leiningen","LemonStand","Lilypond","Lithium","Lua","Magento","Maven","Mercury","MetaProgrammingSystem","Nim","Node","OCaml","Objective-C","Opa","OracleForms","Packer","Perl","Phalcon","PlayFramework","Plone","Prestashop","Processing","PureScript","Python","Qooxdoo","Qt","R","ROS","Rails","RhodesRhomobile","Ruby","Rust","SCons","Sass","Scala","Scheme","Scrivener","Sdcc","SeamGen","SketchUp","Smalltalk","SugarCRM","Swift","Symfony","SymphonyCMS","TeX","Terraform","Textpattern","TurboGears2","Typo3","Umbraco","Unity","UnrealEngine","VVVV","VisualStudio","Waf","WordPress","Xojo","Yeoman","Yii","ZendFramework","Zephir","gcov","nanoc","opencart","stella"}|>

Here's a more complex example to hook which will create a new release:

```mathematica
GitHub[
 {"repos", "b3m2a1", "test", "releases"},
 <|
  "Method" -> "Post",
  "Body" ->
   ExportString[{"tag_name" -> "v0.0.1", "name" -> "test"}, "JSON"],
  "Headers" ->
   {"Authorization" -> Automatic}
  |>,
 "ResultObject"
 ]
```

<a id="authorization" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### Authorization

The github API uses an  ```"Authorization"``` header for authenticated requests. If you want to use the cached authorization that the built-in methods use you can pass:

```mathematica
"Authorization"->{Automatic, Automatic}
```

If you just want to pass your username and be prompted to enter your password pass

```mathematica
"Authorization"->{username, Automatic}
```

And finally if you want to pass your username and password directly you can do that with

```mathematica
"Authorization"->{username, password}
```

<a id="authentication-and-configuration" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Authentication and Configuration

An attempt is made in the API to make authentication details and configuration details accessible. Here are a the options:

<a id="getconfig" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### GetConfig

Gets configuration details (note that default config is different from what you will see here):

```mathematica
GitHub["GetConfig"]
```

    (*Out:*)
    
    <|"Username"->"b3m2a1","EncodePassword"->False,"UseKeychain"->True,"CachePassword"->True,"LockPasswordCache"->False|>

Here's what each of these parameters does:

*  ```"Username"``` — stores the current user (if this is changed it should be done with  ```"SetUsername"``` )

*  ```"EncodePassword"``` — whether to encode passwords into a  ```GitHubPath``` object (can be used for push without SSH)

*  ```"UseKeychain"``` — whether to use the BTools  ```$Keychain``` object or not (defaults to  ```False``` as the keychain stores permanently)

*  ```"CachePassword"``` — whether to store passwords in the session or not

*  ```"LockPasswordCache"``` — currently unused, but will be a companion to the  ```"LockPasswordCache"``` method

<a id="setconfig" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### SetConfig

```mathematica
GitHub["SetConfig", "UseKeychain"->False]
```

    (*Out:*)
    
    <|"Username"->"b3m2a1","EncodePassword"->False,"UseKeychain"->False,"CachePassword"->True,"LockPasswordCache"->False|>

```mathematica
GitHub["SetConfig", {"UseKeychain"->False, "LockPasswordCache"->True}]
```

    (*Out:*)
    
    <|"Username"->"b3m2a1","EncodePassword"->False,"UseKeychain"->False,"CachePassword"->True,"LockPasswordCache"->True|>

<a id="currentuser" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### CurrentUser

```mathematica
GitHub["CurrentUser"]
```

    (*Out:*)
    
    "b3m2a1"

<a id="setusername" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### SetUsername

```mathematica
GitHub["SetUsername", "test"]
```

<a id="getpassword" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### GetPassword

This will open up a dialog to get the password if it doesn't have it:

```mathematica
GitHub["GetPassword"]
```

![github-1874608336607830462](./img/github-1874608336607830462.png)

    (*Out:*)
    
    "password"

Any time a new username is provided a new password will be requested

<a id="clearpassword" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### ClearPassword

Useful because the passwords associated to a username is cached by default

```mathematica
GitHub["ClearPassword", "asd"]
```

<a id="setpassword" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### SetPassword

```mathematica
GitHub["SetPassword", "password"]
```

<a id="getauthorizationheader" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### GetAuthorizationHeader

This provides the authorization token GitHub requires for the current user

```mathematica
GitHub["GetAuthorizationHeader"]
```

    (*Out:*)
    
    "Basic dGVzdDpwYXNzd29yZA=="

You can see how the token is constructed:

```mathematica
Developer`DecodeBase64@"dGVzdDpwYXNzd29yZA=="
```

    (*Out:*)
    
    "test:password"

<a id="repositories" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Repositories

There are a number of requests related to repositories.  ```GitHub``` implements everything  [here](https://developer.github.com/v3/repos/) (and if it's missing something create an issue and it will be added).

<a id="listrepositories" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### ListRepositories

```mathematica
res = GitHub["ListRepositories", "ResultObject"]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-4479466270502396487.png' alt='github-4479466270502396487' /></p>
</span>
</code>
</pre>

```mathematica
res["Result"][[1, "FullName"]]
```

    (*Out:*)
    
    "b3m2a1/BugTracker"

```mathematica
GitHub["ListRepositories", "kubaPod", "ResultObject"]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-8941333856016630695.png' alt='github-8941333856016630695' /></p>
</span>
</code>
</pre>

<a id="getrepository" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### GetRepository

```mathematica
GitHub["GetRepository", "b3m2a1/BugTracker", "ResultObject"]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-756638439692915082.png' alt='github-756638439692915082' /></p>
</span>
</code>
</pre>

CreateRepository

```mathematica
GitHub["CreateRepository", "test", "ResultObject"]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-4922254358508617453.png' alt='github-4922254358508617453' /></p>
</span>
</code>
</pre>

<a id="editrepository" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### EditRepository

```mathematica
GitHub["EditRepository", 
  "b3m2a1/test", 
  "Name"->"test", 
  "Description"->"a test repo",
  "ResultObject"
  ]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-273489049608989970.png' alt='github-273489049608989970' /></p>
</span>
</code>
</pre>

<a id="deleterepository" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### DeleteRepository

```mathematica
GitHub["DeleteRepository", "test", "ResultObject"]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-7772922015420866670.png' alt='github-7772922015420866670' /></p>
</span>
</code>
</pre>

<a id="listcontributors" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### ListContributors

```mathematica
GitHub["ListContributors", "paclets/PacletServer", "ResultObject"]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-5705547431485621005.png' alt='github-5705547431485621005' /></p>
</span>
</code>
</pre>

<a id="forks" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Forks

<a id="listforks" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### ListForks

```mathematica
GitHub["ListForks", "paclets/PacletServer", "ResultObject"]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-2421180881204356391.png' alt='github-2421180881204356391' /></p>
</span>
</code>
</pre>

<a id="createfork" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### CreateFork

```mathematica
GitHub["Fork", "kubaPod/DevTools", "ResultObject"]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-2839330886057410087.png' alt='github-2839330886057410087' /></p>
</span>
</code>
</pre>

Delete the fork:

```mathematica
GitHub["DeleteRepository", "DevTools", "ResultObject"]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-7772922015420866670.png' alt='github-7772922015420866670' /></p>
</span>
</code>
</pre>

<a id="releases" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Releases

<a id="createrelease" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### CreateRelease

```mathematica
rel =
  GitHub["CreateRelease", 
    "b3m2a1/BugTracker",
    "v1.0.2", 
    "Name"->"test",
    "ResultObject"
    ]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-7778441936909920135.png' alt='github-7778441936909920135' /></p>
</span>
</code>
</pre>

<a id="editrelease" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### EditRelease

```mathematica
GitHub["EditRelease", 
  "b3m2a1/BugTracker",
  rel["ID"],
  "Description"->"test release",
  "ResultObject"
  ]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-8442215317818773729.png' alt='github-8442215317818773729' /></p>
</span>
</code>
</pre>

<a id="deleterelease" class="Subsubsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

### DeleteRelease

```mathematica
GitHub["DeleteRelease", 
  "b3m2a1/BugTracker",
  rel["ID"],
  "ResultObject"
  ]
```

<pre >
<code>
(*Out:*)

<span>
 <p><img src='./img/github-1444829963234262499.png' alt='github-1444829963234262499' /></p>
</span>
</code>
</pre>

<a id="full-listing" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Full Listing

The full listing of supported requests can be extracted from the dispatcher  ```Association``` :

```mathematica
BTools`External`Git`$GitHubActions//Keys
```

    (*Out:*)
    
    {"AddFile","BranchInfo","ClearPassword","Clone","Configure","Create","CreateBlob","CreateIssue","CreateIssueComment","CreatePullRequest","CreateReadme","CreateReference","CreateRelease","CreateRepository","CreateTag","CurrentUser","Delete","DeleteFile","DeleteIssueComment","DeleteReference","DeleteRelease","DeleteReleaseAsset","DeleteRepository","Deployments","Edit","EditFile","EditIssue","EditIssueComment","EditRelease","EditReleaseAsset","EditRepository","Fork","GetAllReferences","GetAuthorizationHeader","GetBlob","GetCommit","GetConfig","GetDirectory","GetFile","GetFileSHA","GetIssue","GetPassword","GetReadme","GetReference","GetRelease","GetReleaseAsset","GetRepository","GetTag","GetTree","ListBranches","ListContributors","ListForks","ListIssueComments","ListIssues","ListMyRepositories","ListPullRequests","ListReleaseAssets","ListRepositories","ListUserIssues","Merge","Path","PathQ","PullRequestInfo","Push","RawPath","RawURL","Releases","RepoQ","Repositories","SetConfig","SetPassword","SetUsername","SVNPath","SVNURL","UpdateReference","UploadReleaseAsset","URL"}