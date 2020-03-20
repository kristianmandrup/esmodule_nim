import macros, jsffi

# emits: import * from 'xyz'
proc esImportAllImpl(name: string, nameOrPath: string): string =
  result = "import * from "
  result.addQuoted(nameOrPath)
  result.add ";\n"

# import * from 'xyz'
template esImportAll*(nameOrPath: cstring) =
  {.emit: esImportAllImpl(nameOrPath).}

# emits: import xyz from 'xyz'
proc esImportDefaultImpl(name: string, nameOrPath: string): string =
  result = "import " & name & "_ from "
  result.addQuoted(nameOrPath)
  result.add ";\n"

# import xyz from 'xyz'
template esImportDefault*(name: cstring, nameOrPath: cstring) =
  {.emit: esImportDefaultImpl(name, nameOrPath).}

template esImportDefaultVar*(varName: untyped, name: string, nameOrPath: string) =
   {.emit: esImportDefaultImpl(name, nameOrPath).}  
   var varName: JsObject
   {.emit: "%GENID% = " & name & "$$ " .}
  
# emits: import { default as abc } from 'xyz'
template esImportDefaultAsImpl(name: string, nameOrPath: string): string =
  result = "import { default as " & name & "$$ } from "
  result.addQuoted(nameOrPath) 
  result.add ";\n"

# import { default as abc } from 'xyz'
template esImportDefaultAs*(asName: cstring, nameOrPath: cstring) =
  {.emit: esImportDefaultAsImpl(asName, nameOrPath).}

template esImportDefaultAsVar*(varName: untyped, asName: string, nameOrPath: string) =
  {.emit: esImportDefaultAsImpl(asName, nameOrPath).}  
  var varName: JsObject
  {.emit: "%GENID% = " & name & "$$ " .}

# emits: import { x } from 'xyz'
proc esImportImpl(name: string, nameOrPath: string): string =
  result = "import { " & name & " as " & name & "$$ } from "
  result.addQuoted(nameOrPath)
  result.add ";\n"

# import { x_ } from 'xyz'; var x = x_;
template esImport*(name: string, nameOrPath: string) =
  {.emit: esImportImpl(name, nameOrPath).}

template esImportVar*(varName: untyped, name: string, nameOrPath: string) =
  {.emit: esImportImpl(name, nameOrPath).}
  var varName: JsObject
  {.emit: "%GENID% = " & name & "$$ " .}
  
## ES export

# emits: export x
template esExportImpl(name: string): string =
  result = "export " & name & ";\n"

# export x
template esExport*(name: cstring) =
  {.emit: esExportImpl(name).}

# emits: export default x
template esExportDefaultImpl(name: string): string =
  result = "export default " & name & ";\n"

# export x
template esExportDefault*(name: cstring) =
  {.emit: esExportDefaultImpl(name).}
