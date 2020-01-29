import re, strutils

# incoming text (read file via argument passed in via CLI) --file or -f
let txt = """
import { "x", "y" } from "xyz"
import * from "abc"
import { default as "$" } from "jq"
let x = 2
"""

let isStr = re"""\"(.)\""""
let isImportLine = re"import\s+{\s+.+\s+}"
let xlines = splitLines(txt)

var newLines: seq[string] = @[]
for line in xlines:
  if line =~ isImportLine:
    let beforeFromIndex = line.find("from")
    let linebeforeFrom = line[0 .. beforeFromIndex]
    let lineafterFrom = line[beforeFromIndex+1 .. line.high]
    let linebeforeFromNoStr = linebeforeFrom.replacef(isStr, "$1")
    let newLine = linebeforeFromNoStr & lineafterFrom
    newLines.add newLine
  else:
    newLines.add line

let newTxt = newLines.join "\n"
echo newTxt

# overwrite file with new source where malformed imports are fixed
# save as .js or .mjs file depending on -o option
