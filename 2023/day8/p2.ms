sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

pause = function
	while not key.get
		yield
	end while
end function

instructions =  lines[0]
nodes = {}
for line in lines[2:]
	nodes[line[0:3]] = [line[7:10], line[12:15]]
end for

finalStarting = "A"
startingNodes = []
for node in nodes.indexes
	if node[-1] == finalStarting then
		startingNodes.push node
	end if
end for
finalEnding = "Z"

stepCounts = []

for n in startingNodes.indexes
	node = startingNodes[n]
	steps = 0
	while node[-1] != finalEnding
		i = 0
		if instructions[steps % instructions.len] == "R" then i = 1
		node = nodes[node][i]
		steps += 1
	end while
	stepCounts.push steps
end for

gcd = function(n, m)
    if m == 0 then
        return n
	end if
    return gcd(m, n % m)
end function

lcm = 1
for i in stepCounts
    lcm = (lcm * i) / gcd(lcm, i)
end for
print lcm