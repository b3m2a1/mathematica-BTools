
/*
Tipue Search 7.0
Copyright (c) 2018 Tipue
Tipue Search is released under the MIT License
http://www.tipue.com/search
*/

// Stop words

var tipuesearch_stop_words;
$.getJSON(search_SiteURL+"/theme/search/search_stopwords.json",
  function(data) { tipuesearch_stop_words = data }
  );


// Word replace

var tipuesearch_replace;
$.getJSON(search_SiteURL+"/theme/search/search_replacements.json",
  function(data) { tipuesearch_replace = data }
  );

// Weighting

var tipuesearch_weight;
$.getJSON(search_SiteURL+"/theme/search/search_weights.json",
  function(data) { tipuesearch_weight = data }
  );

// Illogical stemming

var tipuesearch_stem;
$.getJSON(search_SiteURL+"/theme/search/search_stems.json",
  function(data) { tipuesearch_stem = data }
  );


// Related

var tipuesearch_related;
$.getJSON(search_SiteURL+"/theme/search/search_related.json",
  function(data) { tipuesearch_related = data }
  );

// Internal strings

var tipuesearch_string_1 = 'No title';
var tipuesearch_string_2 = 'Showing results for';
var tipuesearch_string_3 = 'Search instead for';
var tipuesearch_string_4 = '1 result';
var tipuesearch_string_5 = 'results';
var tipuesearch_string_6 = '<';
var tipuesearch_string_7 = '>';
var tipuesearch_string_8 = 'Nothing found.';
var tipuesearch_string_9 = 'Common words are largely ignored.';
var tipuesearch_string_10 = 'Related';
var tipuesearch_string_11 = 'Search too short. Should be one character or more.';
var tipuesearch_string_12 = 'Search too short. Should be';
var tipuesearch_string_13 = 'characters or more.';
var tipuesearch_string_14 = 'seconds';
var tipuesearch_string_15 = 'Open Image';
var tipuesearch_string_16 = 'Goto Page';


// Internals


// Timer for showTime

var startTimer = new Date().getTime();
