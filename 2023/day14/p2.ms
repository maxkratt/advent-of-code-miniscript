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

for l in lines.indexes
	lines[l] = lines[l].split("")
end for

rollNorth = function(lines)	
	highestPoints = [0] * lines[0].len
	mapOfRocks = {}
	y = 0
	while y < lines.len
		for x in lines[y].indexes
			if lines[y][x] == "O" then 
				lines[y][x] = "."
				lines[highestPoints[x]][x] = "O"
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
		y += 1
	end while
	return mapOfRocks
end function

rollSouth = function(lines)	
	highestPoints = [lines.len] * lines[0].len
	mapOfRocks = {}
	y = lines.len - 1
	while y >= 0
		for x in lines[y].indexes
			if lines[y][x] == "O" then 
				highestPoints[x] -= 1
				lines[y][x] = "."
				lines[highestPoints[x]][x] = "O"
				if mapOfRocks.hasIndex(highestPoints[x]) then
					mapOfRocks[highestPoints[x]] += 1
				else
					mapOfRocks[highestPoints[x]] = 1
				end if
			else if lines[y][x] == "#" then 
				highestPoints[x] = y
			end if
		end for
		y -= 1
	end while
	return mapOfRocks
end function

rollWest = function(lines)
	highestPoints = [0] * lines.len
	mapOfRocks = {}
	y = 0
	while y < lines.len
		for x in lines[y].indexes
			if lines[y][x] == "O" then 
				lines[y][x] = "."
				lines[y][highestPoints[y]] = "O"
				highestPoints[y] += 1
				if mapOfRocks.hasIndex(highestPoints[y]) then
					mapOfRocks[highestPoints[y]] += 1
				else
					mapOfRocks[highestPoints[y]] = 1
				end if
			else if lines[y][x] == "#" then 
				highestPoints[y] = x + 1
			end if
		end for
		y += 1
	end while
	return mapOfRocks
end function

rollEast = function(lines)	
	highestPoints = [lines[0].len] * lines.len
	mapOfRocks = {}
	for y in lines.indexes
		x = lines[0].len - 1
		while x >= 0
			if lines[y][x] == "O" then
				highestPoints[y] -= 1
				lines[y][x] = "."
				lines[y][highestPoints[y]] = "O"
				if mapOfRocks.hasIndex(y + 1) then
					mapOfRocks[y + 1] += 1
				else
					mapOfRocks[y + 1] = 1
				end if
			else if lines[y][x] == "#" then 
				highestPoints[y] = x
			end if
			x -= 1
		end while
	end for
	return mapOfRocks
end function

mapOfRocks = {}
cycle = function(lines)
	newMap = {}
	rollNorth(lines)
	rollWest(lines)
	rollSouth(lines)
	globals.mapOfRocks = rollEast(lines)
end function

start = time

firstLines = lines.deepCopy

cache = []
cache.push lines.deepCopy
totalsCache = []

for i in range(1, 10000)
	r = text.row
	print "CYCLING #" + i
	text.row = r
	cycle lines

	total = 0
	for kv in mapOfRocks
		addend = kv.value * (lines.len - (kv.key - 1))
		total += addend
	end for
	totalsCache.push total

	if cache.contains(lines) then
		cycleStart = cache.indexOf(lines)
		period = i - cycleStart
		answerIndex = ((1000000000 - cycleStart) % period) + cycleStart - 1
		print "Answer is: " + totalsCache[answerIndex]
		print "Took " + (time - start) + " seconds."
		exit
	end if
	cache.push lines.deepCopy
end for