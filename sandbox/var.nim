import macros, jsffi

proc esImportDefaultImpl(name: string, nameOrPath: string): string =
  result = "import " & name & "_ from "
  result.addQuoted nameOrPath
  result.add ";\n"

# import xyz from 'xyz'
template esImportDefault*(name: string, nameOrPath: string) =
  {.emit: esImportDefaultImpl(name, nameOrPath).}

template emitVarAst(name: string): auto =
  # nnkPragma(
  #   nnkExprColonExpr(
  #     nnkIdent("emit"),
  #     nnkStrLit(name & " = " & name & "$$")
  #   )
  # )
  let varAst = quote do:
    {.emit: "var x = x$$".}
  echo varAst.treeRepr

# See: https://nim-lang.org/docs/macros.html
template esImportDefaultVar*(name: string,
    nameOrPath: string) =
  let importAst = quote do:
    {.emit: esImportDefaultImpl(name, nameOrPath).}
  # let jsVarName = newIdentNode(varName)
  # let nimVarName = newIdentNode(varName & "$$")
  let jsVarAst = emitVarAst(name)
  let varAst = nnkIdentDefs(
    nnkIdent(name),
  )
  result.add newNimNode(importAst)
  result.add newNimNode(varAst)
  result.add newNimNode(jsVarAst)


# esImportDefault("x", "./aba")
# esImportDefaultVar("x", "./aba")
emitVarAst("x")
