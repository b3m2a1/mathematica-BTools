Replace[
  #@
    Replace[#[#2],
      t_TemplateObject:>
        TemplateApply[t, #]
      ],
  {
    TemplateObject[{
      Templating`Evaluator`PackagePrivate`apply[_,
        a_
        ]
      }]:>
        Block[
          {
            Templating`PackageScope`$TemplateEvaluate=True
            },
          a
          ],
    TemplateObject[{s_, ___}]:>s
    }
  ]&
