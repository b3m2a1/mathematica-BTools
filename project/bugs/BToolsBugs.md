<a id="integratebtoolsand" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# Integrate BTools and BugTracker

    timestamp: Mon 25 Jun 2018 00:20:48

    timestamp: 

    ID: 1

    package: BTools

    owner: 

    keywords: integrations, bugs, testing

<a id="description" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Description

BTools should have a way to directly add bugs to projects

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<<Example>>

<a id="notes" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notes

<<Note>>

<a id="bugsvalidation" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# Bugs & Validation

    timestamp: Mon 25 Jun 2018 00:21:30

    timestamp: 

    ID: 2

    package: BugTracker

    owner: 

    keywords: validation

<a id="description" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Description

Bugs should be able to have attached validation tests 

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<<Example>>

<a id="notes" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notes

<<Note>>

<a id="addtestingframework" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# Add testing framework to BTools

    timestamp: Mon 25 Jun 2018 00:22:13

    timestamp: 

    ID: 3

    package: BTools

    owner: 

    keywords: testing

<a id="description" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Description

BTools needs to hook into MUnit in some nice way to allow that integration

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<<Example>>

<a id="notes" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notes

Should be able to do a few things:

Find the testing notebook

Create a testing notebook

Add a test ? (Probably easier via interface)

Export tests ? (Probably easier via interface)

Import tests

Link test resources

Run validation tests

<a id="rssfeederfor" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# RSS feeder for SiteBuilder

    timestamp: Tue 26 Jun 2018 13:43:01

    timestamp: Fri 29 Jun 2018 15:25:50

    ID: 4

    package: BTools

    owner: 

    keywords: rss-feed

<a id="description" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Description

SiteBuilder needs an RSS feeder so that it can hook into all sorts of integrations, in particular the StackExchange chat system.

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<<Example>>

<a id="notes" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notes

<<Note>>

<a id="splitformattingpackage" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# Split Formatting package into high- and low-level stuff

    timestamp: Wed 27 Jun 2018 12:56:44

    timestamp: Wed 27 Jun 2018 14:07:39

    ID: 5

    package: BTools

    owner: 

    keywords: formatting, splits

<a id="description" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Description

The formatting package is bloated and should be partitioned into the high-level utilities like GradientButton and the lower stuff like GradientButtonAppearance / unusued stuff like ColoredButton

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<<Example>>

<a id="notes" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notes

<<Note>>

<a id="pacletserverupdatedates" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# PacletServer update dates

    timestamp: Fri 29 Jun 2018 15:25:30

    timestamp: Fri 29 Jun 2018 15:50:30

    ID: 6

    package: BTools

    owner: 

    keywords: paclets, dates

<a id="description" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Description

PacletServer should provide update times for packages

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<<Example>>

<a id="notes" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notes

Turns out it was already on there...

<a id="notebooktomarkdown" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# Notebook to Markdown needs context aware HTML

    timestamp: Mon 23 Jul 2018 03:55:31

    timestamp: 

    ID: 7

    package: BTools

    owner: 

    keywords: markdown

<a id="description" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Description

The Notebook to Markdown system should use HTML in PrintUsage cells but not in Input, by modifying the pathInfo passed through

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<<Example>>

<a id="notes" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notes

<<Note>>

<a id="integratebugtrackerwith" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# Integrate BugTracker with packages and with GitHub

    timestamp: Wed 28 Nov 2018 16:52:49

    timestamp: 

    ID: 8

    package: BugTracker

    owner: 

    keywords: bugs

<a id="description" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Description

The bug tracker should be set up as a dependency paclet to be dropped into a BTools style package. It should also provide a way to upload to GitHub in the packages projects folder.

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<<Example>>

<a id="notes" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notes

<<Note>>

<a id="addpackageconfigto" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# Add $PackageConfig to Paclet Loader

    timestamp: Mon 10 Dec 2018 16:15:37

    timestamp: 

    ID: 9

    package: BTools

    owner: 

    keywords: paclets, config

<a id="description" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Description

https://github.com/b3m2a1/mathematica-BTools/issues/14

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<<Example>>

<a id="notes" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notes

<<Note>>

<a id="addeasydependency" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# Add easy dependency system

    timestamp: Mon 17 Dec 2018 02:13:27

    timestamp: Thu 20 Dec 2018 00:58:54

    ID: 10

    package: BTools

    owner: 

    keywords: dependencies

<a id="description" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Description

Based on the drop-in dependency structure introduced for the SimpleDocs package it should be possible to easily and programmatically add dependencies to packages and to get them to update cleanly too.

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<<Example>>

<a id="notes" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notes

Handled, but still has a few flaws in terms of utility

Should be able to just list dependencies

<a id="wikipagesneeded" class="Section" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# Wiki Pages needed for Git and other popular functions

    timestamp: Sun 23 Dec 2018 03:31:40

    timestamp: 

    ID: 11

    package: BTools

    owner: 

    keywords: wiki, docs, git

<a id="description" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Description

https://github.com/b3m2a1/mathematica-BTools/issues/15#issuecomment-449552396

<a id="examples" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Examples

<<Example>>

<a id="notes" class="Subsection" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Notes

<<Note>>