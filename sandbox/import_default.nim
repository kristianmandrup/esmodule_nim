import macros, jsffi

proc esImportDefaultImpl(name: string, nameOrPath: string): string =
  result = "import " & name & "_ from "
  result.addQuoted nameOrPath
  result.add ";\n"

# import xyz from 'xyz'
template esImportDefault*(name: string, nameOrPath: string) =
  {.emit: esImportDefaultImpl(name, nameOrPath).}

template esImportDefaultVar*(varName: untyped, name: string, nameOrPath: string) =
  var varName = {.emit: esImportDefaultImpl(name, nameOrPath).}

esImportDefault("x", "./aba")
# var x {.importjs "# = x_".}: JsObject
# echo x
esImportDefaultVar("Stuff", "aba/bcb")
