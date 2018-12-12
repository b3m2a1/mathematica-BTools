The tutorial pages are almost the same as the symbol pages and the guide pages. The main change is that it's much more flexible.

There are a number of supported cell types:

* ```"TutorialSection"```

* ```"TutorialText"```

* ```"TutorialTableRow"```

* ```"TutorialTableColumn"```

* ```"TutorialImage"```

* ```"TutorialCaption"```

All of these can be mixed and matched in the body of the tutorial. The text, rows, and columns work much like they did for the details in a symbol page.

The sections allow different parts of the tutorial to be divided up will automatically provide links at the top to provide jumps to these.

Here's an example of the body of a tutorial in the template notebook:

![tutorialpage-1688204536338659540](./img/tutorialpage-1688204536338659540.png)

And here's the output:

![tutorialpage-1119209765911125577](./img/tutorialpage-1119209765911125577.png)

We can see the convenient jump link towards the top, the nice table, the bordered image with captions.

One useful thing is that the jump links try to automatically divide themselves into a nice grid:

![tutorialpage-8591682575280856722](./img/tutorialpage-8591682575280856722.png)

When using  ```"TutorialInput"```  cells the In-Out labels try to automatically assign themselves. They don't always do this perfectly so somtimes a bit of manual wrangling is necessary.

Outside of this nothing is really all that new.