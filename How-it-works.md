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

## Auto bind vars

Ideally we would like to improve the compilation output to include a var binding to the imported constant
A naive approach:

```nim
# emits: import { x as x$$ } from 'xyz';
# emits: var x = $xx; (optional var binding)
proc esImportImpl(name: string, nameOrPath: string, bindVar: bool): string =
  result = "import { " & name & "$$ } from "
  result.addQuoted nameOrPath & ";\n"
  if bindVar
    result = result & "var " & name & " = " & name & "$$;"

# import { x as x$$ } from 'xyz';
# var x = x$$;
template esImport*(name: string, nameOrPath: string, bindVar: bool = true) =
  {.emit: esImportImpl(name, nameOrPath, bindVar).}
```

Unfortunately the `var` will only be output to the `js` file and not be present in the Nim program.
To do this correctly we would need to use a macro that operates on the AST to generate Nim code programmatically.

Please help write a macro that generates proper `var` binding (should be possible!?)
