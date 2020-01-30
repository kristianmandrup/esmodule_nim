import macros, jsffi

# emits: import * from 'xyz'
proc esImportAllImpl(name: string, nameOrPath: string): string =
  result = "import * from "
  result.addQuoted nameOrPath & ";\n"

# import * from 'xyz'
proc esImportAll*(nameOrPath: cstring) {.
  {.emit: esImportAllImpl(nameOrPath).}

# emits: import xyz from 'xyz'
proc esImportDefaultImpl(name: string, nameOrPath: string, bindVar: bool = true): string =
  result = "import " & name & "_ from "
  result.addQuoted nameOrPath & ";\n"
  if bindVar
    result = result & "var " & name & " = " & name & "_;"

# import xyz from 'xyz'
proc esImportDefault*(name: cstring, nameOrPath: cstring, bindVar: bool = true) {.
  {.emit: esImportDefaultImpl(name, nameOrPath, bindVar).}

# emits: import { default as abc } from 'xyz'
proc esImportDefaultAsImpl(name: string, nameOrPath: string, bindVar: bool = true): string =
  result = "import { default as " & name & "$$ } from "
  result.addQuoted nameOrPath & ";\n"
  if bindVar
    result = result & "var " & name & " = " & name & "$$;"

# import { default as abc } from 'xyz'
proc esImportDefaultAs*(name: cstring, nameOrPath: cstring, bindVar: bool = true) {.
  {.emit: esImportDefaultAsImpl(name, nameOrPath, bindVar).}

# emits: import { x } from 'xyz'
proc esImportImpl(name: string, nameOrPath: string, bindVar: bool = true): string =
  result = "import { " & name & " as " & name & "$$ } from "
  result.addQuoted nameOrPath & ";\n"
  if bindVar
    result = result & "var " & name & " = " & name & "$$;"

# import { x_ } from 'xyz'; var x = x_;
template esImport*(name: string, nameOrPath: string, bindVar: bool = true) =
  {.emit: esImportImpl(name, nameOrPath, bindVar).}

## ES export

# emits: export x
proc esExportImpl(name: string): string =
  result = "export " & name & ";\n"

# export x
proc esExport*(name: cstring) {.
  {.emit: esExportImpl(name).}

# emits: export default x
proc esExportDefaultImpl(name: string): string =
  result = "export default " & name & ";\n"

# export x
proc esExportDefault*(name: cstring) {.
  {.emit: esExportDefaultImpl(name).}
