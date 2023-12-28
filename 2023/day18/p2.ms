import "aoc"
import "vector3"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

digVertices = []
digLength = 0
pos = [0,0]
for line in lines
	l = line.between("#", ")")
	dir = l[-1]
	l = l[0:-1]
	steps = hexVal(l)
	if dir == "0" then
		pos[0] += steps
	else if dir == "2" then
		pos[0] -= steps
	else if dir == "3" then
		pos[1] -= steps
	else if dir == "1" then
		pos[1] += steps
	end if
	digLength += steps
	digVertices.push pos[0:]
end for

totalArea = 0
for i in digVertices.indexes
	p1 = digVertices[i - 1]
	p2 = digVertices[i]
	totalArea += p1.x * p2.y - p2.x * p1.y
end for
totalArea /= 2
totalArea = totalArea + digLength / 2 + 1
print totalArea
