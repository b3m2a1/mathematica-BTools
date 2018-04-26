Select[
  Replace[
    $$templateLib["templateArgumentLookup"][#, "IndexListing"],
    Except[_List]:>$$templateLib["templateArgumentLookup"][#, "Articles"]
    ],
  #2
  ]&
