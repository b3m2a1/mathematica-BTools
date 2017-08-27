(Join@@
  Flatten@{
    #,
    Replace[Templating`$TemplateArgumentStack,{
        {___,a_}:>a,
        _-><||>
      }]
    })&
