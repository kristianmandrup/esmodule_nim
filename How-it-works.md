# How it works

Using the ES module bindings in Nim

```nim
import esmodules # custom binding module we created above

# import { x as x$$ } from 'xyz'
esImport("x", "./xyz")  

# reference constants imported (implicitly available)
var x {.importjs. "x$$"} # links to imported var
echo x
```

## Naive approach

The naive approach of using `{.importjs "import { # } from # }` would generate:

```js
import { "x" } from "./x";
```

This is unfortunately not valid JavaScript. To circumvent this, we use a more advanced technique.

```nim
proc esImportImpl(name: string, nameOrPath: string): string =
  result = "import { " & name & " } from "
  result.addQuoted nameOrPath

template esImport*(name: string, nameOrPath: string) =
  {.emit: esImportImpl(name, nameOrPath).}
```

Now it correctly outputs ``import { x } from "./x";`` which is valid ES module syntax.

We used regular string concatenation using ``&`` and then the method ``addQuoted`` to
ensure output of a quoted string.
