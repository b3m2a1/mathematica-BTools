
var tipuesearch;
$.getJSON("../theme/search/search_index.json",
  function(data) { tipuesearch = data }
  );

var tipuesearch_options;
$.getJSON("../theme/search/search_options.json",
  function(data) { tipuesearch_options = data }
  );
