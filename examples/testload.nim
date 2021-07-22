import assimp, os

var file = "cube.ply"
if paramCount() == 1: file = paramStr(1)

echo repr aiImportFile(file, 0)