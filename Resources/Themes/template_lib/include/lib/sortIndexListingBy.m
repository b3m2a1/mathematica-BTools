SortBy[
  Replace[
    $$templateLib["getTemplateArguments"][#]["IndexListing"],
    Except[{__}]:>  $$templateLib["getTemplateArguments"][#]["Articles"]
    ],
  #2
  ]&
