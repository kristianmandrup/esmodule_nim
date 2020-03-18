import macros, jsffi

# emits: import * from 'xyz'
proc esImportAllImpl(name: string, nameOrPath: string): string =
  result = "import * from "
  result.addQuoted nameOrPath & ";\n"

# import * from 'xyz'
proc esImportAll*(nameOrPath: cstring) {.
  {.emit: esImportAllImpl(nameOrPath).}

# emits: import xyz from 'xyz'
proc esImportDefaultImpl(name: string, nameOrPath: string): string =
  result = "import " & name & "_ from "
  result.addQuoted nameOrPath & ";\n"

# import xyz from 'xyz'
proc esImportDefault*(name: cstring, nameOrPath: cstring) {.
  {.emit: esImportDefaultImpl(name, nameOrPath).}

template esImportDefaultVar*(varName: untyped, name: string, nameOrPath: string) =
  var varName = {.emit: esImportDefaultImpl(name, nameOrPath).}  
  
# emits: import { default as abc } from 'xyz'
proc esImportDefaultAsImpl(asName: string, nameOrPath: string): string =
  result = "import { default as " & name & "$$ } from "
  result.addQuoted nameOrPath & ";\n"

# import { default as abc } from 'xyz'
proc esImportDefaultAs*(asName: cstring, nameOrPath: cstring) {.
  {.emit: esImportDefaultAsImpl(asName, nameOrPath).}

template esImportDefaultAsVar*(varName: untyped, asName: string, nameOrPath: string) =
  var varName = {.emit: esImportDefaultAsImpl(asName, nameOrPath).}  

# emits: import { x } from 'xyz'
proc esImportImpl(name: string, nameOrPath: string): string =
  result = "import { " & name & " as " & name & "$$ } from "
  result.addQuoted nameOrPath & ";\n"

# import { x_ } from 'xyz'; var x = x_;
template esImport*(name: string, nameOrPath: string) =
  {.emit: esImportImpl(name, nameOrPath).}

template esImportVar*(varName: untyped, name: string, nameOrPath: string) =
  {.emit: esImportImpl(name, nameOrPath).}
  var varName
  {.emit: "%GENID% = " & name & "$$ " .}
  
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
