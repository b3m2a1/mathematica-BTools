We'll build custom documentation for the function  ```PacletInstall```

First we open a template for it:

```mathematica
temp=DocGen["SymbolPage", PacletInstall, Method->"Template"]//CreateDocument
```

![docbasics-5778284418044881266](./img/docbasics-5778284418044881266.png)

Then we edit the call signatures to be a bit more helpful:

![docbasics-7961018109066995051](./img/docbasics-7961018109066995051.png)

(The differently styled cells are simply inline cells. They will be appropriately converted.)

Next we can play with the details:

![docbasics-2608699212668213311](./img/docbasics-2608699212668213311.png)

Add some examples:

![docbasics-2921825495856490040](./img/docbasics-2921825495856490040.png)

Note the orange brackets—these indicate that we're making examples cells. If you use  the wrong cell style you can change it in the  ```"Insert Style"```  menu in the top bar. The In-and-Out labels on the left were changed using the  ```"Insert Object"```  menu.

Finally we'll change the linked content on the bottom:

![docbasics-5334310472412684969](./img/docbasics-5334310472412684969.png)

And now we can build our page a few ways. The most basic is to just use the  ```"Generate"```  button in the top bar and select  ```"Ref Page"``` :

![docbasics-1316293891126157419](./img/docbasics-1316293891126157419.png)

If we want more control we can also generate it via the  ```DocGen```  function:

```mathematica
DocGen["SymbolPage", Evaluate@temp, CellContext->Notebook]
```

    (*Out:*)
    
![docbasics-22969401790492181](./img/docbasics-22969401790492181.png)

This allows us to directly save this in a different location

```mathematica
DocGen["SymbolPage", Evaluate@temp, 
  CellContext->Notebook,
  Method->{"Save", Directory->$TemporaryDirectory}
  ]
```

    (*Out:*)
    
    {{"/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/ReferencePages/Symbols/PacletInstall.nb"}}

And we can save without the path extension parts:

```mathematica
fil=
  DocGen["SymbolPage", Evaluate@temp, 
    CellContext->Notebook,
    Method->{"Save", Directory->$TemporaryDirectory, Extension->False}
    ][[1, 1]]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/PacletInstall.nb"