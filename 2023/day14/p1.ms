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

highestPoints = [0] * lines[0].len
mapOfRocks = {}
for y in lines.indexes
	for x in lines[y].indexes
		if lines[y][x] == "O" then 
			highestPoints[x] += 1
			if mapOfRocks.hasIndex(highestPoints[x]) then
				mapOfRocks[highestPoints[x]] += 1
			else
				mapOfRocks[highestPoints[x]] = 1
			end if
		else if lines[y][x] == "#" then 
			highestPoints[x] = y + 1
		end if
	end for
end for

total = 0
for kv in mapOfRocks
	addend = kv.value * (lines.len - (kv.key - 1))
	total += addend
end for
print total