# ES modules for Nim

This Nim module aims to bridge Nim with ES modules

## Usage

```sh
$ nim js d:nodejs tests/test1.nim
```

Generates a `tests/test1.nim` with malformed imports of the form:

```js
import { "x" } from "./x";
rawEcho(makeNimstrLit("Hello World"));
```

Replace ``import { "x" } from "./x";`` with ``import { x } from "./x";`` 

See `Nim Issue #13297 <https://github.com/nim-lang/Nim/issues/13297>`_

For now you can use the `module-name-replacer.nim` to convert a file with malformed ES module syntax
and strip the `"x"` import vars so they become proper identifiers.

TODO: Make the replacer into a CLI tool.