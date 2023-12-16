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

doColumnsMatch = function(field, col1, col2)
	for i in field.indexes
		if field[i][col1] != field[i][col2] then
			return false
		end if
	end for
	return true
end function

findVerticalReflection = function(field)
	for x in field[0].indexes[0:-1]
		if doColumnsMatch(field, x, x + 1) then
			mathed = true
			for x2 in field[0].indexes
				if (x + x2 + 1) >= field[0].len or (x - x2) < 0 then break
				if not doColumnsMatch(field, x + x2 + 1, x - x2) then
					mathed = false
					break
				end if
			end for
			if mathed then return x
		end if
	end for
	return null
end function

findHorizonalReflection = function(field)
	for y in field.indexes[0:-1]
		if field[y] == field[y + 1] then
			mathed = true
			fieldArea = field[y + 1:]
			for y2 in fieldArea.indexes
				if y - y2 < 0 then break
				if fieldArea[y2] != field[y - y2] then
					mathed = false
					break
				end if
			end for
			if mathed then return y	
		end if
	end for
	return null
end function

total = 0
segmentBreakAt = 0
for i in lines.indexes
	field = null
	if lines[i] == "" then
		field = lines[segmentBreakAt:i]
	else if i == lines.len - 1 then
		field = lines[segmentBreakAt:i + 1]
	end if
	if field != null then
		hor = findHorizonalReflection(field)
		vert = findVerticalReflection(field)
		if hor != null then total += (100 * (hor + 1))
		if vert != null then total += vert + 1
		segmentBreakAt = i + 1
	end if
end for
print total