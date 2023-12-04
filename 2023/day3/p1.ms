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

spaceSeperatedNumbers = []
adjacents = []
checkAdjacency = function(lineIndex, columnIndex)
	adjacentToNonPeriod = false
	adjacentToSymbol = false
	for y in range(-1, 1)
		for x in range(-1, 1)
			targetY = l + y
			targetX = c + x
			if (targetY < 0 or targetY >= lines.len) or (targetX < 0 or targetX >= line.len) or (y == x == 0) then continue
			character = lines[targetY][targetX]
			if character != "." then
				adjacentToNonPeriod = true
				if character < "0" or character > "9" then
					adjacentToSymbol = true
				end if
			end if
		end for
	end for
	globals.adjacents.push {"adjacentToNonPeriod": adjacentToNonPeriod, "adjacentToSymbol":adjacentToSymbol}
	return {"adjacentToNonPeriod": adjacentToNonPeriod, "adjacentToSymbol":adjacentToSymbol}
end function

tempList = []
adjacentToSymbol = false
adjacentToNonPeriod = false
for l in lines.indexes
	line = lines[l]
	for c in line.indexes
		column = line[c]
		if c == 0 then
			if adjacentToSymbol then 
				spaceSeperatedNumbers += tempList
				spaceSeperatedNumbers.push " "
				adjacentToSymbol = false
				adjacentToNonPeriod = false
			end if
			tempList = []
			adjacentToSymbol = false
			adjacentToNonPeriod = false
		end if
		if "0" <= lines[l][c] <= "9" then
			adjacency = checkAdjacency(l, c)
			adjacentToNonPeriod = adjacency.adjacentToNonPeriod
			if adjacency.adjacentToSymbol then
				adjacentToSymbol = true
			end if
			if adjacentToNonPeriod then tempList.push(lines[l][c])
		else
			if adjacentToSymbol then 
				spaceSeperatedNumbers += tempList
				spaceSeperatedNumbers.push " "
				adjacentToSymbol = false
				adjacentToNonPeriod = false
			end if
			tempList = []
		end if
	end for
end for

spaceSeperatedNumbers = spaceSeperatedNumbers.join("")
spaceSeperatedNumbers = spaceSeperatedNumbers.split(" ")
print spaceSeperatedNumbers
total = 0
for num in spaceSeperatedNumbers
	total += num.val
end for
print total