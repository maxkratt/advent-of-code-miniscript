import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

instructions =  lines[0]
nodes = {}
for line in lines[2:]
	nodes[line[0:3]] = [line[7:10], line[12:15]]
end for
print nodes

starting = "AAA"
ending = "ZZZ"
node = starting
steps = 0

while node != ending
	i = 0
	if instructions[steps % instructions.len] == "R" then i = 1
	node = nodes[node][i]
	steps += 1
end while
print steps