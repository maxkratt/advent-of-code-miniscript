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

expandUniverse = function(inputLines, galaxies)
	y = 0
	while y <= inputLines.len * 2
		if y >= inputLines.len then break
		foundGalaxyOnLine = false
		for galaxy in galaxies
			if galaxy.y == y then
				foundGalaxyOnLine = true
				break
			end if
		end for
		if not foundGalaxyOnLine then 
			inputLines.insert y, "." * inputLines[0].len
			for galaxy in galaxies
				if galaxy.y > y then
					galaxy[1] += 1
				end if
			end for
			y += 1
		end if
		y += 1
	end while

	x = 0
	while x <= inputLines[0].len * 2
		if x >= inputLines[0].len then break

		foundGalaxyInColumn = false
		for galaxy in galaxies
			if galaxy.x == x then
				foundGalaxyInColumn = true
				break
			end if
		end for

		if not foundGalaxyInColumn then 
			for i in inputLines.indexes
				inputLines[i] = inputLines[i].insert(x, ".")
			end for

			for galaxy in galaxies
				if galaxy.x > x then
					galaxy[0] += 1
				end if
			end for
			x += 1
		end if

		x += 1
	end while
end function

galaxies = findGalaxies(lines)
expandUniverse(lines, galaxies)

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
			distance += 1
		else if pos.x < finish.x then
			pos.x += 1
			distance += 1
		else if pos.y > finish.y then
			pos[1] -= 1
			distance += 1
		else if pos.y < finish.y then
			pos[1] += 1
			distance += 1
		else
			totalDistances += distance
			break
		end if
	end while
end for
print totalDistances
print "Took " + (time - startTime) + " seconds."