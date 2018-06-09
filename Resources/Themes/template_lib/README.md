# SiteBuilder Themes

The site builder package uses different themes to make its sites look a specific way

The core of these themes are static content (e.g. css, js, etc.) and templates

The templates are Wolfram XML templates that get processed into raw HTML.
In general there will be a base.html template and others will inherit from that.
There are a few things made available to the templates as they build:

* Content stack
* Template function library

## The stack

The stack is generally accessed via the # parameter.

Looking at the minimal theme you'll see that the #Articles accessor is passed.
This gives all the bits in the stack with the article.html template in its
  #Templates parameter

Every entry in the content stack has the following parameters:
*  #Summary
*  #Date
*  #Content
*  #URL
*  #Slug
*  #Templates
*  #FilePath
*  #SourceFile
*  #SiteName
*  #SiteURL

Then the agg stack provides aggregated content. It has the following:
*  #Pages            -- Entries with the page template
*  #Articles         -- Entries with the article template
*  #Archives         -- All entries sorted by date
*  #ContentStack     -- Accessor function to entries in the stack
*  #ContentData      -- Accessor function to attributes of pages in the stack
*  #SelectObjects    -- Picks objects whose templates contain a passed template
*  #NextObjectBy     -- Returns the next entry for a given sort and type
*  #PreviousObjectBy -- Returns the previous entry for a given sort and type

## Template function library

This is a set of functions accessed via the $$templateLib symbol
These functions provide cleaner access to higher-level WL features than templates
