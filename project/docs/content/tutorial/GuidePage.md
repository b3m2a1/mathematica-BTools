We'll start as we did with the Symbol page by creating a new notebook and setting its stylesheet to  ```BTools › DocGen``` . Then we can make a guide template in a similar way to the symbol template:

![guidepage-1081249985859559647](./img/guidepage-1081249985859559647.png)

And here we basically have a few things to set up. First we title our guide whatever we want that to be, set the link-path of the guide (via the little blue link-like cell beneath the title), and attach a description to it.

![guidepage-3248925788977456682](./img/guidepage-3248925788977456682.png)

Then we supply a set of functions/symbols related to our guide in the next  ```"GuideFunctionSubsection"```  cell (generally labeled  ```"Guide Functions"``` ). Each of these cells should have the style  ```"GuideFunction"``` .

The last thing we need to do is set up the sections to our guide. This part is a little bit ill-designed. There are a few cases of things that can happen here. The simplest one is that we just list a bunch of function names. These will simply unravel into a list of functions in the generated page:

![guidepage-9149590983831141772](./img/guidepage-9149590983831141772.png)

turns into

![guidepage-3244026793906766231](./img/guidepage-3244026793906766231.png)

We can also supply descriptive text and this will simply turn into text outside the function list. It's also possible to supply a guide link and the functions listed will aggregate under this. The last possibility is to supply a function name and then a description and this will be aggregated in-line.

As an example:

![guidepage-4249346687643800768](./img/guidepage-4249346687643800768.png)

turns into

![guidepage-7944512974854825938](./img/guidepage-7944512974854825938.png)

The related links, guides, etc. work in the same way as in the symbol pages