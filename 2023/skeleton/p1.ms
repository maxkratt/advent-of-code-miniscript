// began 07:00:00
// ended 
// total 

import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

sourceDir = file.parent(_sourceFile) + "/"
if 0 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

print "HI!"