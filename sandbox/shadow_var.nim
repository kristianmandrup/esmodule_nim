import macros, jsffi

{.emit: """/*INCLUDESECTION*/import { x as x$$  } from './aba'""".}

var
  x {.importjs: "$ID = x$$".}: JsObject
