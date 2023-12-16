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
	mistakes = 0
	for y in field.indexes
		if field[y][col1] != field[y][col2] then
			if mistakes == 0 then
				mistakes += 1
			else	
				return [false, mistakes]
			end if
		end if
	end for
	return [true, mistakes]
end function

findVerticalReflection = function(field)
	for x in field[0].indexes[0:-1]
		mistakes = 0
		columnsMatch = doColumnsMatch(field, x, x + 1)
		if columnsMatch[0] then
			matched = true
			for x2 in field[0].indexes
				if (x + x2 + 1) >= field[0].len or (x - x2) < 0 then break
				columnsMatch = doColumnsMatch(field, x + x2 + 1, x - x2)
				mistakes += columnsMatch[1]
				if not columnsMatch[0] or columnsMatch[1] > 1 then
					matched = false
					break
				end if
			end for
			if mistakes == 1 then
				if matched then return x
			end if
		end if
	end for
	return null
end function

doRowsMatch = function(row1, row2)
	mistakes = 0
	for i in row1.indexes
		if row1[i] != row2[i] then mistakes += 1
		if mistakes > 1 then return [false, mistakes]
	end for
	return [true, mistakes]
end function

findHorizonalReflection = function(field)
	for y in field.indexes[0:-1]
		rowsMatching = doRowsMatch(field[y], field[y + 1])
		if rowsMatching[0] then
			matched = true
			mistakes = 0
			fieldArea = field[y + 1:]
			for y2 in fieldArea.indexes
				if y - y2 < 0 then break
				rowsMatching = doRowsMatch(fieldArea[y2], field[y - y2])
				mistakes += rowsMatching[1]
				if not rowsMatching[0] then
					matched = false
					break
				end if
			end for
			if mistakes == 1 then
				if matched then return y
			end if
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