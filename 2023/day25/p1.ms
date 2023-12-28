import "listUtil"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

wires = {}
for line in lines
	p = line.split(": ")
	p2 = p[1].split(" ")
	if not wires.hasIndex(p[0]) then wires[p[0]] = p2
	for component in p2
		if not wires[p[0]].contains(component) then wires[p[0]].push(component)
		if wires.hasIndex(component) then
			if not wires[component].contains(p[0]) then wires[component].push(p[0])
		else
			wires[component] = [p[0]]
		end if
	end for
end for

findConnectedTo = function(initialComponent)
	queue = [initialComponent]
	seen = []
	while queue
		component = queue.pop
		if seen.contains(component) then continue
		seen.push component
		for c in wires[component]
			if seen.contains(c) then continue
			queue.push c
		end for
	end while
	return seen
end function

getGroupLengths = function(wires)
	seen = findConnectedTo(wires.indexes[0])
	groups = [seen.len]
	for component in wires.indexes
		if not seen.contains(component) then
			connectedTo = findConnectedTo(component)
			groups.push connectedTo.len
			seen += connectedTo
		end if
	end for
	return groups
end function

removeWire = function(wires, connectionA, connectionB)
	wires[connectionA].remove wires[connectionA].indexOf(connectionB)
	wires[connectionB].remove wires[connectionB].indexOf(connectionA)
end function

// Found these wires by using GraphVis on the input and seeing which three 
// wires were connecting the two larger sides.
removeWire wires, "vkb", "jzj"
removeWire wires, "grh", "nvh"
removeWire wires, "hhx", "vrx"
g = getGroupLengths(wires)
print g.product