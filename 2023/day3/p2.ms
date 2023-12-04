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

isDigit = function(character)
	return "0" <= character <= "9"
end function

getAdjacentNumbers = function(lineIndex, columnIndex)
	adjacentNumbers = []
	for y in range(-1, 1)
		gotNumber = false
		for x in range(-1, 1)
			
			if x == 1 and y == 0 then gotNumber = false
			targetY = l + y
			targetX = c + x
			if (targetY < 0 or targetY >= lines.len) or (targetX < 0 or targetX >= line.len) or (y == x == 0) then continue
			character = lines[targetY][targetX]
			if gotNumber then 
				if not isDigit(character) then gotNumber = false
				continue
			end if
			if not isDigit(character) then continue

			num = ""
			newTargetX = targetX
			while newTargetX >= 0 and isDigit(lines[targetY][newTargetX])
				num = lines[targetY][newTargetX] + num 
				newTargetX -= 1
			end while
			newTargetX = targetX + 1
			while newTargetX < globals.lines[0].len and isDigit(lines[targetY][newTargetX])
				num += lines[targetY][newTargetX]
				newTargetX += 1
			end while

			adjacentNumbers.push num.val
			if num != "" then gotNumber = true
		end for
	end for
	return adjacentNumbers
end function

gearRatios = []
for l in lines.indexes
	line = lines[l]
	for c in line.indexes
		column = line[c]
		if column == "*" then 
			adjacentNumbers = getAdjacentNumbers(l, c)
			if adjacentNumbers.len == 2 then
				gearRatios.push adjacentNumbers[0] * adjacentNumbers[1]
			end if
		end if
	end for
end for

print "gearRatios = " + gearRatios
print "total = " + gearRatios.sum