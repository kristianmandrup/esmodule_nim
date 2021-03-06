# ES modules for Nim

This Nim module aims to bridge Nim with ES modules

## Notice

Please note that this module requires PR [jsgen improvements for ES module support, JS decorators etc](https://github.com/nim-lang/Nim/pull/13381)
to function. Let's make it happen!

The main template of importance:

```nim
template esImportVar*(varName: untyped, name: string, nameOrPath: string) =
  {.emit: esImportImpl(name, nameOrPath).}
  var varName
  {.emit: "%GENID% = " & name & "$$ " .}
```

Which uses the `%GENID%` feature addition which provides a reference to the most recent generated JS variable identifier (ie. for `varName`).

## API

ES import

- `esImport(name, nameOrPath)` emits: `import { x as x$$ } from 'xyz'`
- `esImportDefault(name, nameOrPath)` emits: `import x$$ from 'xyz'`
- `esImportDefaultAs(name, nameOrPath)` emits: `import { default as x$$ } from 'xyz'`
- `esImportAll(nameOrPath)` emits: `import * from 'xyz'`

ES export

- `esExport(name)` emits: `export x`
- `esExportDefault(name)` emits: `export default x`

## Sample macro

```nim
macro esImportVar*(name: string, nameOrPath: string, body: untyped) :untyped =
  var importNode = quote do: 
    {.emit: esImportImpl(`name`, `nameOrPath`).}
  var assignNode = quote do: 
    {.emit: "%GENID% = " & `name` & "$$ " .}
  result = nnkStmtList.newTree([
    importNode,
    body,
    assignNode
  ])
```

Usage

```nim
esImportVar("x", "./x.mjs"):
  var x: string = ""
```

Will generate:

```js
import { x as x$$ } from "./x.mjs";
var x_129019 = [null];
x_129019 = x$$;
```

## Injecting and binding Nim vars

```nim
template esImportVar*(varName: untyped, name: string, nameOrPath: string) =
  var varName = {.emit: esImportImpl(name, nameOrPath).}

template esImportDefaultAsVar*(varName: untyped, name: string, nameOrPath: string) =
  var varName = {.emit: esImportDefaultAsImpl(name, nameOrPath).}  

template esImportDefaultVar*(varName: untyped, asName: string, nameOrPath: string) =
  var varName = {.emit: esImportDefaultAsImpl(asName, nameOrPath).}  
```

Var injection with import binding usage:

`esImportVar`

```nim
# nimx is the name of the nim var identifier injected into the nim code (compile time)
# x is the identifier imported from module xyz
# import { x as x$$ } from "xyz";
# var nimx = x$$;
esImportVar("nimx", "x", "xyz")
```

`esImportDefaultVar`

```nim
# import x$$ from "xyz";
# var nimx = x$$;
esImportDefaultVar("nimx", "x", "xyz")
```

`esImportDefaultAsVar`

```nim
# import { default as x$$ } from "xyz";
# var nimx = x$$;
esImportDefaultAsVar("nimx", "x", "xyz")
```

## Usage

The Nim JS compiler by default spits out all the Nim JS code inside a scope. 
This means that the`import` and `export` statements will be invalid, since they 
must be in global scope of the file.

Compile `x_import.nim` to nodejs compatible JavaScript using:

```sh
$ nim js -d:nodejs -r x_import.nim
# x_import.js
```

You can use the compiler generated `x_import.js` with either:

- NodeJS
- With transpilers and bundlers (babel, webpack etc)
- Modern browsers

See [Mozilla Developer guide on JavaScript modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) for an overview of where and how ES modules can be used.

## NodeJS in experimental ES module mode

To use the compiled with in NodeJS with experimental ES modules enabled:

- Rename compiled `js` file to `mjs`

```sh
$ mv x_import.js x_import.mjs
# import.mjs
```

Note: Files imported by an mjs file may only be other `mjs` files (turtles all the way down).

You can run the `mjs` file via Node using the `--experimental-modules` option

`node --experimental-modules x_import.mjs`

## Transpilers, bundlers

Compile the `js` files to compatible ES 5 JavaScript using `Babel <https://babeljs.io/>`_.
This can also be done via webpack etc. using a plugin (you might have to write it)

## Modern browsers

Use the js file "as is". In the browser, the import statements can be used anywhere.
A common use is to lazyload parts of the app, f.ex in a Micro Frontend architecture.

ES modules are available in browsers (since 2017)

- Safari 10.1+
- Chrome 61+
- Firefox 60+
- Edge 16+

All you need is `type=module` on the `script` element, and the browser will treat the inline or external script as an ECMAScript module.

Linking to ES module `mjs` file from html page:

```html
<script type="module" src="module.mjs"></script>
<script nomodule src="fallback.js"></script>
```

Browsers that understand `type=module` should ignore scripts with a `nomodule` attribute.
This means you can serve a module tree to module-supporting browsers while providing
a fall-back to other browsers.

