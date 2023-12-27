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

startTime = time

findGalaxies = function(inputLines)
	galaxies = []
	for y in inputLines.indexes
		for x in inputLines[y].indexes
			if inputLines[y][x] == "#" then galaxies.push([x, y])
		end for
	end for
	return galaxies
end function

expandUniverseRows = function(inputLines, galaxies)
	expandedRows = []
	for y in inputLines.indexes
		foundGalaxyOnLine = false
		for galaxy in galaxies
			if galaxy.y == y then
				foundGalaxyOnLine = true
				break
			end if
		end for
		if not foundGalaxyOnLine then 
			expandedRows.push y
		end if
	end for
	return expandedRows
end function

expandUniverseColumns = function(inputLines, galaxies)
	expandedColumns = []
	for x in inputLines[0].indexes
		foundGalaxyOnLine = false
		for galaxy in galaxies
			if galaxy.x == x then
				foundGalaxyOnLine = true
				break
			end if
		end for
		if not foundGalaxyOnLine then 
			expandedColumns.push x
		end if
	end for
	return expandedColumns
end function

galaxies = findGalaxies(lines)
expandedRows = expandUniverseRows(lines, galaxies)
expandedColumns = expandUniverseColumns(lines, galaxies)
expansionFactor = 1000000
pairs = galaxies.combinations(2)

totalDistances = 0
print pairs.len + " pairs to search through."
for pair in pairs
	start = pair[0]
	finish = pair[1]
	pos = start[0:]
	distance = 0
	while true
		if pos.x > finish.x then
			pos.x -= 1
			distToMove = 1
			if expandedColumns.indexOf(pos.x) != null then 
				distToMove = expansionFactor
			end if
			distance += distToMove
		else if pos.x < finish.x then
			pos.x += 1
			distToMove = 1
			if expandedColumns.indexOf(pos.x) != null then
				distToMove = expansionFactor
			end if
			distance += distToMove
		else if pos.y > finish.y then
			pos[1] -= 1
			distToMove = 1
			if expandedRows.indexOf(pos.y) != null then
				distToMove = expansionFactor
			end if
			distance += distToMove
		else if pos.y < finish.y then
			pos[1] += 1
			distToMove = 1
			if expandedRows.indexOf(pos.y) != null then
				distToMove = expansionFactor
			end if
			distance += distToMove
		else
			totalDistances += distance
			break
		end if
	end while
end for
print totalDistances
print "Took " + (time - startTime) + " seconds."