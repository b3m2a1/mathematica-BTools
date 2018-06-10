
var tipuesearch;
$.getJSON(search_SiteURL+"/theme/search/search_index.json",
  function(data) { tipuesearch = data }
  );

var tipuesearch_options;
$.getJSON(search_SiteURL+"/theme/search/search_options.json",
  function(data) { tipuesearch_options = data }
  );
