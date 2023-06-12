# React CodeQL Analysis

This is a repo of CodeQL queries for the analysis of the React framework repo (https://github.com/facebook/react/). 
The goal is to reveal which public API might give access to the DOM element and how to 
exploit them.
In order to do so, we want to examine the taint-tracking path from said public API to the various DOM sinks. 

React codebase has a few quirks that need to be understood:

# Renderers
Although React is a really popular UI library for the web, it is technically not exclusive for the web (see React Native).
To facilitate this, React modularizes their platform-specific logic into what is called a __renderer__.
For the web, the relevant renderer is called `react-dom` and `react-dom-bindings`.
The core React logic however (hooks, etc.) resides on the `react` package.

Hence, if we were to analyze the source code for taint-tracking, the sinks (e.g. DOM manipulation) will be located on the renderer.
Specifically, the code for manipulating a certain React component is located in the 
`react-dom-bindings/src/ReactDOMComponent.js` file. 
The file contains functions for receiving update payload and setting the appropriate props 
on a big switch case with calls to lower-level DOM operations such as in 
`DOMPropertyOperations.js`, `setTextContent.js`, and `setInnerHTML.js`)

# Reconcilers
React keeps a virtual DOM to efficiently process updates to the real DOM component.
It is done by updating only the diff between the old and new virtual DOM. 
This part is called the __reconciler__ and it is easily the most complicated part of React
since they have been trying to introduce a new concurrent architecture with React Fiber.

https://youtu.be/NZoRlVi3MjQ

The reconciler will interact with the renderer through what is called __host config__ (you could read more about it in 
`react-reconciler`'s README).
It is an internal API that the renderer has to implement for the reconciler to commit an update to the DOM. 

However, the host config is not called by a regular export / import statement.
e.g. `react-dom-bindings/src/ReactFiberConfigDOM.js` is not directly exported by `react-reconciler/src/ReactFiberConfig.js`.
Instead, one of the shim on the `forks` folder will replace `ReactFiberConfig.js` at
build-time. 
This presents a challenge for CodeQL to track through the reconciler.

Fortunately, manually replacing the `ReactFiberConfig.js` file seem to do the trick. 

# Flow
React codebase uses a non-standard JavaScript syntax for type-checking with Flow.
It's sort of a competitor to TypeScript by Facebook. 
Since CodeQL only supports JavaScript and TypeScript, in some rare situations (I've 
encountered it in `react-dom-bindings`), the non-standard syntax could raise a CodeQL error.

The fix so far is to use a transpiler like https://github.com/Khan/flow-to-ts.
However, some manual effort is usually required if a warning / error is raised during 
translation.