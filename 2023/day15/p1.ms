import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "myaoc"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

hash = function(s)
	value = 0
	for c in s
		value += code(c)
		value *= 17
		value %= 256
	end for
	return value
end function

total = 0
splitLines = lines[0].split(",")
for l in splitLines
	total += hash(l)
end for
print total