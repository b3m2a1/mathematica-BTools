Title: BTools
built: {2018, 11, 22, 2, 27, 21.122714}
context: BTools`
Date: 2018-11-22 02:27:21
history: 11.3,,
index: True
keywords: <||>
label: BTools
language: en
Modified: 2018-11-22 02:47:43
paclet: Mathematica
specialkeywords: <||>
status: None
summary: 
synonyms: <||>
tabletags: <||>
title: BTools
titlemodifier: 
tutorialcollectionlinks: <||>
type: Guide
uri: BTools/guide/BTools
windowtitle: BTools

<a id="btools" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# BTools

BTools is a too-many-use package that implements all the development-oriented things I've thought of. It's divided into subcontexts so that it doesn't flood the namespace with symbols when loaded. The chunks are:

* Paclets

* External

* Frameworks

* FrontEnd

* Web

* Developer

* Utilities

If you want anything documented let me know and I'll try to whip up some pages.

---

### Paclets

There are too many functions in this context, but the big ones are  ```PacletExecute``` ,  ```AppExecute``` , and the  ```PacletServer``` -related ones ( ```DocGen``` also does a ton, but it's on life support as I move to supporting more SimpleDocs-style docs)

    Names["BTools`Paclets`*"]

    (*Out:*)
    
    {"BTools`Paclets`AppDocGen","BTools`Paclets`AppExecute","BTools`Paclets`AppGit","BTools`Paclets`AppPacletExecute","BTools`Paclets`DocGen","BTools`Paclets`DocumentationSiteBuild","BTools`Paclets`DocumentationSiteDeploy","BTools`Paclets`PacletExecute","BTools`Paclets`PacletServerAdd","BTools`Paclets`PacletServerBuild","BTools`Paclets`PacletServerDeploy","BTools`Paclets`PacletServerExecute","BTools`Paclets`PacletServerInterface","BTools`Paclets`PacletServerRemove","BTools`Paclets`$DocGenSettings","BTools`Paclets`$PacletExecuteSettings","BTools`Paclets`$PacletServer","BTools`Paclets`$PacletServers"}

---

### External

The big ones here are  ```Git``` ,  ```GiitHub``` ,  ```GoogleDrive``` , and  ```GoogleAnalytics``` which are all moderately expansive API connections (esp.  ```GitHub``` ).

There are also utilities for playing with python, but nothing that  [PyTools](https://github.com/b3m2a1/mathematica-PyTools) can't do better. I do make use of the  ```PySimpleServer``` -stuff in many of the web related functions

    Names["BTools`External`*"]

    (*Out:*)
    
    {"BTools`External`Git","BTools`External`GitHub","BTools`External`GoogleAnalytics","BTools`External`GoogleAPIData","BTools`External`GoogleDrive","BTools`External`ProcessRead","BTools`External`ProcessRun","BTools`External`ProcessStart","BTools`External`PySimpleServerKill","BTools`External`PySimpleServerOpen","BTools`External`PySimpleServerRunning","BTools`External`PySimpleServerStart","BTools`External`PyVenvKill","BTools`External`PyVenvNew","BTools`External`PyVenvRun","BTools`External`PyVenvStart","BTools`External`SVN","BTools`External`TerminalRun","BTools`External`TerminalRunNonBlocking","BTools`External`TerminalShell","BTools`External`$PySimpleServer","BTools`External`$PyVenv"}

---

### Frameworks

There are only two functions here, one for hooking into the ServiceConnection framework and another for working with the DataPaclets framework. Conceivably more might come, but these are hard functions to write and get robust.

    Names["BTools`Frameworks`*"]

    (*Out:*)
    
    {"BTools`Frameworks`CuratedDataExport","BTools`Frameworks`CustomServiceConnection"}

---

### FrontEnd

These functions all make it nicer to work with the front end, in particular  ```StyleSheetNew``` and  ```StyleSheetEdit``` which make working with stylesheets much, much cleaner. All the  ```Indentation``` stuff is what allows batch indent and indentation replacement in my package stylesheets.

    Names["BTools`FrontEnd`*"]

    (*Out:*)
    
    {"BTools`FrontEnd`BatchIndentationEvent","BTools`FrontEnd`IndentationEvent","BTools`FrontEnd`MakeIndentable","BTools`FrontEnd`StyleDefinitionsValue","BTools`FrontEnd`StyleSheetApplyEdits","BTools`FrontEnd`StyleSheetCells","BTools`FrontEnd`StyleSheetDefaultStyles","BTools`FrontEnd`StyleSheetDelete","BTools`FrontEnd`StyleSheetDrop","BTools`FrontEnd`StyleSheetEdit","BTools`FrontEnd`StyleSheetEditAliases","BTools`FrontEnd`StyleSheetEditAutoReplacements","BTools`FrontEnd`StyleSheetEditEvents","BTools`FrontEnd`StyleSheetEditTaggingRules","BTools`FrontEnd`StyleSheetNew","BTools`FrontEnd`StyleSheetNotebookGet","BTools`FrontEnd`StyleSheetNotebookObject","BTools`FrontEnd`StyleSheetOpen","BTools`FrontEnd`StyleSheetParentNotebook","BTools`FrontEnd`StyleSheetStyles","BTools`FrontEnd`StyleSheetSync","BTools`FrontEnd`StyleSheetTemplate","BTools`FrontEnd`StyleSheetUpdate","BTools`FrontEnd`StyleSheetValue","BTools`FrontEnd`SyntaxHiglightingApplyStyling","BTools`FrontEnd`SyntaxHiglightingClearStyling","BTools`FrontEnd`SyntaxHiglightingStylesheet","BTools`FrontEnd`$DefaultStyleSheetNotebook","BTools`FrontEnd`$StyleSheetCellDisplayStyleOptions","BTools`FrontEnd`$StyleSheetIOCellStyles","BTools`FrontEnd`$StyleSheetSectionCellStyles","BTools`FrontEnd`$StyleSheetTextCellStyles","BTools`FrontEnd`$StyleSheetTitleCellStyles","BTools`FrontEnd`$SyntaxHighlightingStyles","BTools`FrontEnd`$SyntaxHiglightingCommands","BTools`FrontEnd`$SyntaxHiglightingConstants","BTools`FrontEnd`$SyntaxHiglightingContextStyling","BTools`FrontEnd`$SyntaxHiglightingFormattingHeads","BTools`FrontEnd`$SyntaxHiglightingFunctions","BTools`FrontEnd`$SyntaxHiglightingPunctuation","BTools`FrontEnd`$SyntaxHiglightingTypes"}

---

### Web

These functions support site building, mostly.

    Names["BTools`Web`*"]

    (*Out:*)
    
    {"BTools`Web`CSSGenerate","BTools`Web`MarkdownToXML","BTools`Web`NotebookMarkdownSave","BTools`Web`NotebookToMarkdown","BTools`Web`PelicanBuild","BTools`Web`PelicanDeploy","BTools`Web`PelicanNewFile","BTools`Web`PelicanNewSite","BTools`Web`PelicanNotebookSave","BTools`Web`PelicanNotebookToMarkdown","BTools`Web`PelicanThemes","BTools`Web`WebSiteBuild","BTools`Web`WebSiteContent","BTools`Web`WebSiteDeploy","BTools`Web`WebSiteFindTheme","BTools`Web`WebSiteInitialize","BTools`Web`WebSiteNewContent","BTools`Web`WebSiteNewTableOfContents","BTools`Web`WebSiteOptions","BTools`Web`WebSitePages","BTools`Web`WebSitePosts","BTools`Web`WebSites","BTools`Web`WebSiteSetOptions","BTools`Web`WebSiteThemes","BTools`Web`$WebSiteBuildErrors","BTools`Web`$WebSiteDirectory","BTools`Web`$WebSitePath","BTools`Web`$WebSiteThemePath"}

---

### Developer

These functions aren't really useful at top level, but they're very useful inside other code:

    Names["BTools`Developer`*"]

    (*Out:*)
    
    {"BTools`Developer`AddFunctionArgCount","BTools`Developer`AddFunctionAutocompletions","BTools`Developer`AddFunctionSyntaxInformation","BTools`Developer`AddFunctionUsageTemplate","BTools`Developer`AuthDialog","BTools`Developer`AutoFunctionInfo","BTools`Developer`BannerDialog","BTools`Developer`BannerDialogInput","BTools`Developer`BoxesToString","BTools`Developer`BoxQ","BTools`Developer`ContextRemove","BTools`Developer`ContextScopeBlock","BTools`Developer`EncodedCache","BTools`Developer`EncodedCacheLoad","BTools`Developer`GenerateFunctionInfo","BTools`Developer`KeychainAdd","BTools`Developer`KeychainConnect","BTools`Developer`KeychainGet","BTools`Developer`KeychainRemove","BTools`Developer`Newlineate","BTools`Developer`NewlineateCode","BTools`Developer`NewlineateCodeRecursive","BTools`Developer`NewlineateInput","BTools`Developer`NewlineateInputRecursive","BTools`Developer`NewlineateRecursive","BTools`Developer`OAuthDialog","BTools`Developer`PasswordDialog","BTools`Developer`PrettyString","BTools`Developer`SetArgCount","BTools`Developer`SetAutocompletions","BTools`Developer`SymbolDetermineType","BTools`Developer`SymbolNameMatchQ","BTools`Developer`SyncPath","BTools`Developer`$EncodedCache","BTools`Developer`$EncodedCacheDirectory","BTools`Developer`$EncodedCachePassword","BTools`Developer`$EncodedCacheSettings","BTools`Developer`$Keychain","BTools`Developer`$KeychainCloudAccounts","BTools`Developer`$KeychainDirectory","BTools`Developer`$KeychainPassword","BTools`Developer`$KeychainSettings","BTools`Developer`$SymbolNameTypes","BTools`Developer`$SymbolTypeNames"}

---

### Utilities

These are actually very useful functions, but are highly unlikely to be used within other code:

    Names["BTools`Utilities`*"]

    (*Out:*)
    
    {"BTools`Utilities`CtxFind","BTools`Utilities`DocFind","BTools`Utilities`FEAddResource","BTools`Utilities`FEAttachCell","BTools`Utilities`FEAttachCellSpec","BTools`Utilities`FEBoxEdit","BTools`Utilities`FEBoxGetOptions","BTools`Utilities`FEBoxObject","BTools`Utilities`FEBoxRead","BTools`Utilities`FEBoxRef","BTools`Utilities`FEBoxReplace","BTools`Utilities`FEBoxSelect","BTools`Utilities`FEBoxSetOptions","BTools`Utilities`FEChildren","BTools`Utilities`FEClickMouse","BTools`Utilities`FECopyScreen","BTools`Utilities`FEDragMouse","BTools`Utilities`FEExport","BTools`Utilities`FEFindFileOnPath","BTools`Utilities`FEFormatResource","BTools`Utilities`FEHiddenBlock","BTools`Utilities`FEImport","BTools`Utilities`FEKeyEventAdd","BTools`Utilities`FEKeyEventDrop","BTools`Utilities`FELoadResources","BTools`Utilities`FEMenuSetupAdd","BTools`Utilities`FEMenuSetupDrop","BTools`Utilities`FEMenuSetupGet","BTools`Utilities`FEMoveMouse","BTools`Utilities`FENextSibling","BTools`Utilities`FENotebooks","BTools`Utilities`FEPacketBrowser","BTools`Utilities`FEPacketExecute","BTools`Utilities`FEPackets","BTools`Utilities`FEParent","BTools`Utilities`FEPreviousSibling","BTools`Utilities`FEResetKeyEvents","BTools`Utilities`FEResetMenuSetup","BTools`Utilities`FEResourceBrowse","BTools`Utilities`FEResourceFind","BTools`Utilities`FEResourceGroup","BTools`Utilities`FEResourceKeys","BTools`Utilities`FEScreenPath","BTools`Utilities`FEScreenPosition","BTools`Utilities`FEScreenShot","BTools`Utilities`FESelectCells","BTools`Utilities`FESetMouseAppearance","BTools`Utilities`FESetSymbolColoring","BTools`Utilities`FESiblings","BTools`Utilities`FEToFileName","BTools`Utilities`FETokenBrowser","BTools`Utilities`FETokens","BTools`Utilities`FEUnicodeCharBrowser","BTools`Utilities`FEUserBaseFile","BTools`Utilities`FEValueBrowser","BTools`Utilities`FEValues","BTools`Utilities`FEWindowSize","BTools`Utilities`FileGrep","BTools`Utilities`FileSystemGrep","BTools`Utilities`FrontEndBlobIcon","BTools`Utilities`FrontEndFile","BTools`Utilities`FrontEndFiles","BTools`Utilities`FrontEndImage","BTools`Utilities`FrontEndImageBrowser","BTools`Utilities`FrontEndImageFiles","BTools`Utilities`GrepDirectory","BTools`Utilities`GrepSelect","BTools`Utilities`InternalDocumentationFiles","BTools`Utilities`InternalFiles","BTools`Utilities`InternalSystemFiles","BTools`Utilities`MsgFind","BTools`Utilities`OpsFind","BTools`Utilities`RefreshFETokens","BTools`Utilities`SpelunkCallsCases","BTools`Utilities`SpelunkDefinitions","BTools`Utilities`SpelunkGraph","BTools`Utilities`SpelunkObject","BTools`Utilities`SpelunkValues","BTools`Utilities`SpelunkValuesCases","BTools`Utilities`SpelunkValuesContains","BTools`Utilities`SystemArgSearch","BTools`Utilities`SystemContextSearch","BTools`Utilities`SystemExpressionsSearch","BTools`Utilities`SystemFunctionSearch","BTools`Utilities`SystemHeadSearch","BTools`Utilities`WithOverrideDefs","BTools`Utilities`$FEKeyEvents","BTools`Utilities`$FEKeyEventsDirectory","BTools`Utilities`$FEMenuSetup","BTools`Utilities`$FEMenuSetupDirectory","BTools`Utilities`$FEPacketList","BTools`Utilities`$FEResourceDirectory","BTools`Utilities`$FEResourceFiles","BTools`Utilities`$FEResourceGroups","BTools`Utilities`$FETokenList","BTools`Utilities`$FEValueList","BTools`Utilities`$FrontEndDirectory"}

---

### Others

All of these packages rely on lower-level packages and functions too, which have more specialized functions that might be useful:

    Names["BTools`*`*"]//Select[StringFreeQ[#, "Private"]&&StringCount[#, "`"]==3&]

    (*Out:*)
    
    {"BTools`Formatting`FormattingTools`ActionDropDown","BTools`Paclets`AppBuilder`AppAddContent","BTools`Paclets`AppBuilder`AppAddContextFiles","BTools`Paclets`AppBuilder`AppAddDocPage","BTools`Paclets`AppBuilder`AppAddGuidePage","BTools`Paclets`AppBuilder`AppAddPackage","BTools`Paclets`AppBuilder`AppAddPalette","BTools`Paclets`AppBuilder`AppAddStylesheet","BTools`Paclets`AppBuilder`AppAddTest","BTools`Paclets`AppBuilder`AppAddTutorialPage","BTools`Paclets`AppBuilder`AppComponentFiles","BTools`Paclets`AppBuilder`AppConfigRegenerate","BTools`Paclets`AppBuilder`AppConfigure","BTools`Paclets`AppBuilder`AppConfigureSubapp","BTools`Paclets`AppBuilder`AppContexts","BTools`Paclets`AppBuilder`AppDirectory","BTools`Paclets`AppBuilder`AppDocumentationTemplate","BTools`Formatting`FormattingTools`AppearanceReadyImage","BTools`Paclets`AppBuilder`AppExportTests","BTools`Paclets`AppBuilder`AppFileNames","BTools`Paclets`AppBuilder`AppFindFile","BTools`Paclets`AppBuilder`AppFindTestingNotebook","BTools`Paclets`AppBuilder`AppFromFile","BTools`Paclets`AppBuilder`AppFunctionDependencies","BTools`Paclets`AppBuilder`AppGenerateDocumentation","BTools`Paclets`AppBuilder`AppGenerateHTMLDocumentation","BTools`Paclets`AppBuilder`AppGeneratePackageSymbolNotebook","BTools`Paclets`AppBuilder`AppGenerateSymbolNotebook","BTools`Paclets`AppBuilder`AppGenerateTestingNotebook","BTools`Paclets`AppBuilder`AppGet","BTools`Paclets`AppBuilder`AppGitClone","BTools`Paclets`AppBuilder`AppGitCommit","BTools`Paclets`AppBuilder`AppGitHubConfigure","BTools`Paclets`AppBuilder`AppGitHubCreateRelease","BTools`Paclets`AppBuilder`AppGitHubDelete","BTools`Paclets`AppBuilder`AppGitHubPull","BTools`Paclets`AppBuilder`AppGitHubPush","BTools`Paclets`AppBuilder`AppGitHubRepo","BTools`Paclets`AppBuilder`AppGitHubSetRemote","BTools`Paclets`AppBuilder`AppGitInit","BTools`Paclets`AppBuilder`AppGitRealignRemotes","BTools`Paclets`AppBuilder`AppGitSafeCommit","BTools`Paclets`AppBuilder`AppGuideNotebook","BTools`Paclets`AppBuilder`AppGuidePages","BTools`Paclets`AppBuilder`AppGuides","BTools`Paclets`AppBuilder`AppIndexDocs","BTools`Paclets`AppBuilder`AppListTests","BTools`Paclets`AppBuilder`AppLocate","BTools`Paclets`AppBuilder`AppMainContext","BTools`Paclets`AppBuilder`AppNames","BTools`Paclets`AppBuilder`AppNeeds","BTools`Paclets`AppBuilder`AppNewTestingNotebook","BTools`Paclets`AppBuilder`AppPackage","BTools`Paclets`AppBuilder`AppPackageDependencies","BTools`Paclets`AppBuilder`AppPackageFunctions","BTools`Paclets`AppBuilder`AppPackageGenerateDocumentation","BTools`Paclets`AppBuilder`AppPackageGuideNotebook","BTools`Paclets`AppBuilder`AppPackageOpen","BTools`Paclets`AppBuilder`AppPackages","BTools`Paclets`AppBuilder`AppPackageSaveGuide","BTools`Paclets`AppBuilder`AppPackageSaveSymbolPages","BTools`Paclets`AppBuilder`AppPackageSymbolNotebook","BTools`Paclets`AppBuilder`AppPaclet","BTools`Paclets`AppBuilder`AppPacletBackup","BTools`Paclets`AppBuilder`AppPacletBundle","BTools`Paclets`AppBuilder`AppPacletContexts","BTools`Paclets`AppBuilder`AppPacletDirectoryAdd","BTools`Paclets`AppBuilder`AppPacletInfo","BTools`Paclets`AppBuilder`AppPacletInstallerURL","BTools`Paclets`AppBuilder`AppPacletServerPage","BTools`Paclets`AppBuilder`AppPacletSiteBundle","BTools`Paclets`AppBuilder`AppPacletSiteInfo","BTools`Paclets`AppBuilder`AppPacletSiteURL","BTools`Paclets`AppBuilder`AppPacletUninstallerURL","BTools`Paclets`AppBuilder`AppPacletUpload","BTools`Paclets`AppBuilder`AppPalettes","BTools`Paclets`AppBuilder`AppPath","BTools`Paclets`AppBuilder`AppPathFormat","BTools`Paclets`AppBuilder`AppPublish","BTools`Paclets`AppBuilder`AppReconfigureSubapp","BTools`Paclets`AppBuilder`AppRegenerateBundleInfo","BTools`Paclets`AppBuilder`AppRegenerateContextLoadFiles","BTools`Paclets`AppBuilder`AppRegenerateDirectories","BTools`Paclets`AppBuilder`AppRegenerateDocInfo","BTools`Paclets`AppBuilder`AppRegenerateGitExclude","BTools`Paclets`AppBuilder`AppRegenerateGitIgnore","BTools`Paclets`AppBuilder`AppRegenerateInit","BTools`Paclets`AppBuilder`AppRegenerateLoadInfo","BTools`Paclets`AppBuilder`AppRegeneratePacletInfo","BTools`Paclets`AppBuilder`AppRegenerateReadme","BTools`Paclets`AppBuilder`AppRegenerateUploadInfo","BTools`Paclets`AppBuilder`AppSaveGuide","BTools`Paclets`AppBuilder`AppSaveSymbolPages","BTools`Paclets`AppBuilder`AppStylesheet","BTools`Paclets`AppBuilder`AppStyleSheets","BTools`Paclets`AppBuilder`AppSubpacletUpload","BTools`Paclets`AppBuilder`AppSymbolNotebook","BTools`Paclets`AppBuilder`AppSymbolPage","BTools`Paclets`AppBuilder`AppSymbolPages","BTools`Paclets`AppBuilder`AppTutorialNotebook","BTools`Paclets`AppBuilder`AppTutorials","BTools`Paclets`DocGen`AutoGenerateDetails","BTools`Paclets`DocGen`AutoGenerateExamples","BTools`Paclets`DocGen`AutoGenerateUsage","BTools`PackageScope`Package`BackupFile","BTools`Formatting`FormattingTools`ButtonActionMenu","BTools`Formatting`FormattingTools`ButtonActionPopup","BTools`Formatting`FormattingTools`ButtonPopupMenu","BTools`Formatting`FormattingTools`ColoredActionMenu","BTools`Formatting`FormattingTools`ColoredButton","BTools`Formatting`FormattingTools`ColoredButtonAppearances","BTools`Formatting`FormattingTools`ColoredPanel","BTools`Formatting`FormattingTools`ColoredPanelAppearances","BTools`Formatting`FormattingTools`ColoredPopupMenu","BTools`Formatting`FormattingTools`ColorizationAdjust","BTools`Formatting`FormattingTools`ColorizedAppearances","BTools`Utilities`DocFind`ContextNotebook","BTools`Utilities`DocFind`ContextOrdering","BTools`PackageScope`Package`CreateSyncBundle","BTools`Utilities`DocFind`DocFile","BTools`Paclets`DocGen`DocGenGenerateDocumentation","BTools`Paclets`DocGen`DocGenGenerateGuide","BTools`Paclets`DocGen`DocGenGenerateHTMLDocumentation","BTools`Paclets`DocGen`DocGenGenerateSymbolPages","BTools`Paclets`DocGen`DocGenGenerateTutorial","BTools`Paclets`DocGen`DocGenHTMLCloudDeploy","BTools`Paclets`DocGen`DocGenIndexDocumentation","BTools`Paclets`DocGen`DocGenLoadFE","BTools`Paclets`DocGen`DocGenRefLink","BTools`Paclets`DocGen`DocGenSaveGuide","BTools`Paclets`DocGen`DocGenSaveSymbolPages","BTools`Paclets`DocGen`DocGenSettingsLookup","BTools`Paclets`DocGen`DocLinkBase","BTools`Paclets`DocGen`DocMetadata","BTools`Utilities`DocFind`DocsDialog","BTools`PackageScope`Package`DownloadFile","BTools`Developer`Package`EncodedCacheExport","BTools`Developer`Package`EncodedCacheFile","BTools`Developer`Package`EncodedCacheLoaded","BTools`Developer`Package`EncodedCacheOption","BTools`Developer`Package`EncodedCacheOptionsExport","BTools`Developer`Package`EncodedCacheOptionsFile","BTools`Developer`Package`EncodedCacheOptionsLoad","BTools`Developer`Package`EncodedCachePassword","BTools`Developer`Package`EncodedCachePasswordDialog","BTools`Developer`Package`EncodedCachePasswordExport","BTools`Developer`Package`EncodedCachePasswordFile","BTools`Developer`Package`EncodedCachePasswordLoad","BTools`External`Git`FormatGitHubPath","BTools`Utilities`DocFind`FormattedDefs","BTools`Utilities`DocFind`FormattedUsage","BTools`Formatting`FormattingTools`FramedActionMenu","BTools`Formatting`FormattingTools`FramedButton","BTools`Formatting`FormattingTools`FramedPopupMenu","BTools`Formatting`FormattingTools`FrameMasked","BTools`External`Google`GAAGetReport","BTools`External`Google`GAAnalyticsReportsCall","BTools`External`Google`GAAnalyticsReportsRequest","BTools`External`Google`GACall","BTools`External`Google`GADriveCall","BTools`External`Google`GADriveRequest","BTools`External`Google`GAErrorString","BTools`External`Google`GAFileCreatePermissions","BTools`External`Google`GAFileDelete","BTools`External`Google`GAFileDeletePermissions","BTools`External`Google`GAFileDownload","BTools`External`Google`GAFileDownloadURL","BTools`External`Google`GAFileInfo","BTools`External`Google`GAFilePermissions","BTools`External`Google`GAFilePrivatize","BTools`External`Google`GAFilePublish","BTools`External`Google`GAFileSearch","BTools`External`Google`GAFileUpdate","BTools`External`Google`GAFileUpdatePermissions","BTools`External`Google`GAFileUpload","BTools`External`Google`GAOAuthCodeURL","BTools`External`Google`GAOAuthenticate","BTools`External`Google`GAOAuthRefreshRequest","BTools`External`Google`GAOAuthTokenData","BTools`External`Google`GAParse","BTools`External`Google`GAPrepParams","BTools`External`Google`GARequest","BTools`Paclets`DocGen`GenerateMultiPackageOverview","BTools`Utilities`DocFind`GetUsage","BTools`External`Git`GitAdd","BTools`External`Git`GitAddRemote","BTools`External`Git`GitBranch","BTools`External`Git`GitClone","BTools`External`Git`GitCommit","BTools`External`Git`GitConfig","BTools`External`Git`GitCreate","BTools`External`Git`GitFetch","BTools`External`Git`GitHelp","BTools`External`Git`GitHubCreate","BTools`External`Git`GitHubCreateRelease","BTools`External`Git`GitHubDelete","BTools`External`Git`GitHubDeleteRelease","BTools`External`Git`GitHubDeleteReleaseAsset","BTools`External`Git`GitHubDeployments","BTools`External`Git`GitHubEditRelease","BTools`External`Git`GitHubEditReleaseAsset","BTools`External`Git`GitHubGetReleaseAsset","BTools`External`Git`GitHubImport","BTools`External`Git`GitHubPath","BTools`External`Git`GitHubPathParse","BTools`External`Git`GitHubPathQ","BTools`External`Git`GitHubQuery","BTools`External`Git`GitHubReleaseQ","BTools`External`Git`GitHubReleases","BTools`External`Git`GitHubRepoQ","BTools`External`Git`GitHubRepositories","BTools`External`Git`GitHubUploadReleaseAsset","BTools`External`Git`GitIgnore","BTools`External`Git`GitInit","BTools`External`Git`GitListRemotes","BTools`External`Git`GitListTree","BTools`External`Git`GitListTreeRecursive","BTools`External`Git`GitLog","BTools`External`Git`GitPull","BTools`External`Git`GitPullOrigin","BTools`External`Git`GitPush","BTools`External`Git`GitPushOrigin","BTools`External`Git`GitRegisterFunction","BTools`External`Git`GitRemoveRemote","BTools`External`Git`GitRepo","BTools`External`Git`GitRepoQ","BTools`External`Git`GitRepositories","BTools`External`Git`GitRun","BTools`External`Git`GitShowBranch","BTools`External`Git`GitStatus","BTools`External`Google`GoogleAPIClearAuth","BTools`Formatting`FormattingTools`GradientAppearance","BTools`Formatting`FormattingTools`GradientButtonAppearance","BTools`Formatting`FormattingTools`GradientDropDownAppearance","BTools`Formatting`FormattingTools`GradientPanelAppearance","BTools`Paclets`DocGen`GuideContextTemplate","BTools`Paclets`DocGen`GuideNotebook","BTools`Paclets`DocGen`GuideTemplate","BTools`Paclets`PacletTools`LoadPacletServers","BTools`Paclets`PacletTools`LocalPacletServerPattern","BTools`Developer`Package`MakeEncodedCacheSymbol","BTools`Paclets`DocGen`MultiPackageOverviewNotebook","BTools`Formatting`FormattingTools`NinePatchCreate","BTools`Utilities`DocFind`OpenDocs","BTools`Paclets`PacletTools`PacletAPIUpload","BTools`Paclets`PacletTools`PacletAutoPaclet","BTools`Paclets`PacletTools`PacletBundle","BTools`Paclets`PacletTools`PacletDownloadPaclet","BTools`PackageScope`Package`PacletExecuteSettingsLookup","BTools`Paclets`PacletTools`PacletFindBuiltFile","BTools`Paclets`PacletTools`PacletInfo","BTools`Paclets`PacletTools`PacletInfoAssociation","BTools`Paclets`PacletTools`PacletInfoExpression","BTools`PackageScope`Package`PacletInfoExpressionBundle","BTools`Paclets`PacletTools`PacletInfoGenerate","BTools`Paclets`PacletTools`PacletInstalledQ","BTools`PackageScope`Deprecated`PacletInstallerURL","BTools`Paclets`PacletTools`PacletInstallPaclet","BTools`Paclets`PacletTools`PacletLookup","BTools`Paclets`PacletTools`PacletOpen","BTools`Paclets`PacletTools`PacletRemove","BTools`Paclets`PacletTools`PacletServer","BTools`Paclets`PacletTools`PacletServerBundleSite","BTools`Paclets`PacletTools`PacletServerDataset","BTools`Paclets`PacletTools`PacletServerDelete","BTools`Paclets`PacletTools`PacletServerDeploymentURL","BTools`Paclets`PacletTools`PacletServerDirectory","BTools`Paclets`PacletTools`PacletServerExposedPaclets","BTools`Paclets`PacletTools`PacletServerFile","BTools`Paclets`PacletTools`PacletServerInitialize","BTools`Paclets`PacletTools`PacletServerURL","BTools`Paclets`PacletTools`PacletSiteBundle","BTools`Paclets`PacletTools`PacletSiteInfo","BTools`Paclets`PacletTools`PacletSiteInfoDataset","BTools`PackageScope`Deprecated`PacletSiteInstall","BTools`PackageScope`Deprecated`PacletSiteUninstall","BTools`Paclets`PacletTools`PacletSiteUpload","BTools`Paclets`PacletTools`PacletSiteURL","BTools`PackageScope`Deprecated`PacletUninstallerURL","BTools`Paclets`PacletTools`PacletUpload","BTools`PackageScope`Deprecated`PacletUploadInstaller","BTools`PackageScope`Deprecated`PacletUploadUninstaller","BTools`Formatting`FormattingTools`PopupDropDown","BTools`PackageScope`Package`RestoreFile","BTools`Paclets`DocGen`SaveMultiPackageOverview","BTools`Paclets`PacletTools`SetPacletFormatting","BTools`External`Git`SVNCheckOut","BTools`External`Git`SVNExport","BTools`External`Git`SVNFileNames","BTools`External`Git`SVNRun","BTools`Paclets`DocGen`SymbolPageContextTemplate","BTools`Paclets`DocGen`SymbolPageNotebook","BTools`Paclets`DocGen`SymbolPageTemplate","BTools`PackageScope`Package`SyncDownloadWork","BTools`PackageScope`Package`SyncPathQ","BTools`PackageScope`Package`SyncUploadWork","BTools`Paclets`DocGen`TutorialContextTemplate","BTools`Paclets`DocGen`TutorialNotebook","BTools`Paclets`DocGen`TutorialTemplate","BTools`PackageScope`Package`UploadFile","BTools`Paclets`AppBuilder`$AppCloudExtension","BTools`Paclets`AppBuilder`$AppDirectories","BTools`Paclets`AppBuilder`$AppDirectory","BTools`Paclets`AppBuilder`$AppDirectoryName","BTools`Paclets`AppBuilder`$AppDirectoryRoot","BTools`Paclets`AppBuilder`$AppDocGenMethodRouter","BTools`Paclets`AppBuilder`$AppExecuteMethods","BTools`Paclets`AppBuilder`$AppGitRouter","BTools`Paclets`AppBuilder`$AppPacletExecuteMethods","BTools`Paclets`AppBuilder`$AppPathMap","BTools`PackageScope`Package`$BackupDirectoryName","BTools`PackageScope`Package`$BundleMetaInformationFile","BTools`Paclets`PacletTools`$DefaultPacletServer","BTools`Paclets`DocGen`$DocGenActive","BTools`Paclets`DocGen`$DocGenColoring","BTools`Paclets`DocGen`$DocGenDirectory","BTools`Paclets`DocGen`$DocGenFE","BTools`Paclets`DocGen`$DocGenFooter","BTools`PackageScope`Package`$DocGenFunction","BTools`Paclets`DocGen`$DocGenLine","BTools`Paclets`DocGen`$DocGenLinkBase","BTools`Paclets`DocGen`$DocGenMessageStack","BTools`Paclets`DocGen`$DocGenTmpDirectory","BTools`Paclets`DocGen`$DocGenURLBase","BTools`Paclets`DocGen`$DocGenWebDocsDirectory","BTools`Paclets`DocGen`$DocGenWebDocsTmpDirectory","BTools`Paclets`DocGen`$DocGenWebResourceBase","BTools`Utilities`DocFind`$DockDocDialog","BTools`Developer`Package`$EncodedCacheDefaultOptions","BTools`Developer`Package`$EncodedCachePasswords","BTools`Paclets`PacletTools`$FormatPaclets","BTools`External`Google`$GAActiveHead","BTools`External`Google`$GAApplyRequests","BTools`External`Google`$GAClientID","BTools`External`Google`$GAClientSecret","BTools`External`Google`$GALastError","BTools`External`Google`$GAOAuthToken","BTools`External`Google`$GAParameters","BTools`External`Google`$GAParamMap","BTools`External`Google`$GAVersion","BTools`External`Git`$GitActions","BTools`External`Git`$GitCommandLog","BTools`External`Git`$GitHubActions","BTools`External`Git`$GitHubPassword","BTools`External`Git`$GitHubUsername","BTools`External`Git`$GitLogCommands","BTools`External`Git`$GitParamMap","BTools`External`Git`$GitRepo","BTools`External`Git`$GitRunFlags","BTools`External`Google`$GoogleAnalyticsCalls","BTools`External`Google`$GoogleAPIUsername","BTools`External`Google`$GoogleDriveCalls","BTools`Paclets`PacletTools`$PacletBuildDirectory","BTools`Paclets`PacletTools`$PacletBuildExtension","BTools`Paclets`PacletTools`$PacletBuildRoot","BTools`PackageScope`Package`$PacletExecuteExpressionMethods","BTools`PackageScope`Package`$PacletExecuteSiteMethods","BTools`PackageScope`Package`$PacletExecuteUploadMethods","BTools`Paclets`PacletTools`$PacletExtension","BTools`Paclets`PacletTools`$PacletFilePatterns","BTools`Paclets`PacletTools`$PacletRemovePatterns","BTools`Paclets`PacletTools`$PacletServerBase","BTools`Paclets`PacletTools`$PacletUploadAccount","BTools`Paclets`PacletTools`$PacletUploadPatterns","BTools`Paclets`PacletTools`$PacletUseKeychain","BTools`External`Git`$SVNActions","BTools`PackageScope`Package`$SyncUploads"}

Made with SimpleDocs