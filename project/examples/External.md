<a id="external-examples" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

# External Examples

Load the package

```mathematica
 <<BTools`External`
```

<a id="working-with-github" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Working with GitHub

You'll be prompted to put your info into an encoded keychain BTools implements:

![title-1640741396710622126](../../project/img/title-1640741396710622126.png)

Get the path to the repo

```mathematica
 GitHub["Path", "test-repo"]
```

	(*Out:*)
	
![title-5566786704425655860](../../project/img/title-5566786704425655860.png)

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
 GitHub["Delete", "test-repo",
 "GitHubImport"->False
 ]
```

	(*Out:*)
	
![title-8696902593167440952](../../project/img/title-8696902593167440952.png)

<a id="working-with-python" style="width:0;height:0;margin:0;padding:0;">&zwnj;</a>

## Working with Python

Start a  [SimpleHTTPServer](https://docs.python.org/2/library/simplehttpserver.html)  and open the landing page:

![title-6843185186968722183](../../project/img/title-6843185186968722183.png)