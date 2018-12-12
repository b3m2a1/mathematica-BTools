<a id="external-examples" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# External Examples

Load the package

```mathematica
 <<BTools`External`
```

<a id="working-with-github" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Working with GitHub

You'll be prompted to put your info into an encoded keychain BTools implements:

![external-1640741396710622126](./img/external-1640741396710622126.png)

Get the path to the repo

```mathematica
 GitHub["Path", "test-repo"]
```

    (*Out:*)
    
![external-5566786704425655860](./img/external-5566786704425655860.png)

Clone the repo:

```mathematica
 GitHub["Clone", "test-repo", FileNameJoin@{$TemporaryDirectory, "test-repo"},
  OverwriteTarget->True
  ]
```

    (*Out:*)
    
    "/private/var/folders/9t/tqc70b7d61v753jkdbjkvd640000gp/T/test-repo"

Delete the repo

```mathematica
 GitHub["Delete", "test-repo"]
```

    (*Out:*)
    
![external-8696902593167440952](./img/external-8696902593167440952.png)

More info on working with GitHub can be found on its  [example page](https://github.com/b3m2a1/mathematica-BTools/wiki/GitHub)

<a id="working-with-python" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Working with Python

Start a  [SimpleHTTPServer](https://docs.python.org/2/library/simplehttpserver.html)  and open the landing page:

```mathematica
PySimpleServerOpen[FileNameJoin@{BTools`Web`$WebSiteDirectory, "tutorial", "output"}];
```

![external-6843185186968722183](./img/external-6843185186968722183.png)