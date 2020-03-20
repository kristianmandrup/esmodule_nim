import ../src/esmodule

esImportVar("x", "./x.mjs"):
  var x: string = "" 

dynVar:
  var y: string = "y"
  
# fails due to error in jsgen branch
# echo $x

echo $y
