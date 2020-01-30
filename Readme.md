# ES modules for Nim

This Nim module aims to bridge Nim with ES modules

## API

ES import

- `esImport(name, nameOrPath)` emits: `import { x } from 'xyz'`
- `esImportDefault(name, nameOrPath)` emits: `import x from 'xyz'`
- `esImportDefaultAs(name, nameOrPath)` emits: `import { default as x } from 'xyz'`
- `esImportAll(nameOrPath` emits: `import * from 'xyz'`

ES export

- `esExport(name)` emits: `export x`
- `esExportDefault(name)` emits: `export default x`

## Usage

Using the ES module bindings in Nim

```nim
import esmodules # custom binding module we created above

# import { x } from 'xyz'
esImport("x", "./x")  

# reference constants imported (implicitly available)
var xx {.importjs. "x"} # links to imported var
echo xx
```

The Nim JS compiler by default spits out all the Nim JS code inside a scope, 
so that `import` and `export` statements are invalid (must be in global/outer scope of file).

Compile ``x_import.nim`` to nodejs compatible JavaScript using: 

```sh 
$ nim js -d:nodejs -r x_import.nim
```

```js
// ... Nim compiler generated code

import { "x" } from "./x";
var xx = x;
rawEcho(xx);
```

The imported file ``x`` must be an ``mjs`` file as well (turtles all the way down).

You can run the ``mjs`` file via Node using the ``--experimental-modules`` option

`node --experimental-modules my-game.mjs`

Alternatively compile the ``mjs`` files to compatible ES 5 JavaScript using `Babel <https://babeljs.io/>`_.

## How it works

The naive approach of using ``{importjs "import { # } from # }`` would generate: 

``import { "x" } from "./x";`` which is not what we desire.

To circumvent this, we use a more advanced technique.

```nim
proc esImportImpl(name: string, nameOrPath: string): string =
  result = "import { " & name & " } from "
  result.addQuoted nameOrPath

template esImport*(name: string, nameOrPath: string) =
  {.emit: esImportImpl(name, nameOrPath).}
```

Now it correctly outputs ``import { x } from "./x";`` as we desired. 

Note that we used regular string concatenation using ``&`` and then the method ``addQuoted`` to
ensure output of a quoted string.

## Auto bind vars

We can improve the compiler output to include a var binding to the imported constant

```nim
# # emits: import { x } from 'xyz'
proc esImportImpl(name: string, nameOrPath: string, bindVar: bool): string =
  result = "import { " & name & "_ } from "
  result.addQuoted nameOrPath & ";\n"
  if bindVar
    result = result & "var " & name & " = " & name & "_;"

# import { x_ } from 'xyz'; var x = _x;
template esImport*(name: string, nameOrPath: string, bindVar: bool = true) =
  {.emit: esImportImpl(name, nameOrPath, bindVar).}
```

