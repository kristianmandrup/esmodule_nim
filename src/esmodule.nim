import macros, jsffi

# emits: import * from 'xyz'
proc esImportAllImpl(name: string, nameOrPath: string): string =
  result = "import * from "
  result.addQuoted nameOrPath

# import * from 'xyz'
proc esImportAll*(nameOrPath: cstring) {.
  {.emit: esImportAllImpl(nameOrPath).}

# emits: import xyz from 'xyz'
proc esImportDefaultImpl(name: string, nameOrPath: string): string =
  result = "import " & name & " from "
  result.addQuoted nameOrPath

# import xyz from 'xyz'
proc esImportDefault*(name: cstring, nameOrPath: cstring) {.
  {.emit: esImportDefaultImpl(name, nameOrPath).}

# emits: import { default as abc } from 'xyz'
proc esImportDefaultAsImpl(name: string, nameOrPath: string): string =
  result = "import { default as " & name & " } from "
  result.addQuoted nameOrPath

# import { default as abc } from 'xyz'
proc esImportDefaultAs*(name: cstring, nameOrPath: cstring) {.
  {.emit: esImportDefaultAsImpl(name, nameOrPath).}

# # emits: import { x } from 'xyz'
proc esImportImpl(name: string, nameOrPath: string, bindVar: bool): string =
  result = "import { " & name & "_ } from "
  result.addQuoted nameOrPath & ";\n"
  if bindVar
    result = result & "var " & name & " = " & name & "_;"

# import { x_ } from 'xyz'; var x = _x;
template esImport*(name: string, nameOrPath: string, bindVar: bool = true) =
  {.emit: esImportImpl(name, nameOrPath, bindVar).}

  