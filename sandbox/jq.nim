import macros, jsffi

# import the document object and the console
var document {.importc, nodecl.}: JsObject
var console {.importc, nodecl.}: JsObject
# import the "$" function
proc jq(selector: JsObject): JsObject {.importcpp: "$(#)".}

# Use jQuery to make the following code run, after the document is ready.
# This uses an experimental ``.()`` operator for ``JsObject``, to emit
# JavaScript calls, when no corresponding proc exists for ``JsObject``.
proc main =
  jq(document).ready(proc() =
    console.log("Hello JavaScript!")
  )
