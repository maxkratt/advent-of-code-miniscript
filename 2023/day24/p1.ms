import "aoc"

sourceDir = file.parent(_sourceFile) + "/"
useInput = 1
if useInput then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

findIntersection = function(x1, y1, slope1, x2, y2, slope2)
    intercept1 = y1 - slope1 * x1
    intercept2 = y2 - slope2 * x2
    x = (intercept2 - intercept1) / (slope1 - slope2)
    y = slope1 * x + intercept1
    return [x, y]
end function

testArea = [7, 27]
if useInput then testArea = [200000000000000, 400000000000000]

lineParts = []
for line in lines
	parts = line.split(" @ ")
	parts[0] = parts[0].split(", ")
	parts[1] = parts[1].split(", ")
	parts[0].apply @val
	parts[1].apply @val
	lineParts.push [[parts[0][0], parts[0][1]], [parts[1][0], parts[1][1]]]
end for

crossing = 0
for i in lineParts[0:-1].indexes
	l1 = lineParts[i]
	for l2 in lineParts[i + 1:]
		p = findIntersection(l1[0][0], l1[0][1], l1[1][1] / l1[1][0], l2[0][0], l2[0][1], l2[1][1] / l2[1][0])
		
		if not (testArea[0] <= p[0] <= testArea[1] and testArea[0] <= p[1] <= testArea[1]) then continue
		if l1[1][0] < 0 then 
			if not p[0] < l1[0][0] then continue
		else
			if not p[0] >= l1[0][0] then continue
		end if
		if l1[1][1] < 0 then 
			if not p[1] < l1[0][1] then continue
		else
			if not p[1] >= l1[0][1] then continue
		end if

		if l2[1][0] < 0 then 
			if not p[0] < l2[0][0] then continue
		else
			if not p[0] >= l2[0][0] then continue
		end if
		if l2[1][1] < 0 then 
			if not p[1] < l2[0][1] then continue
		else
			if not p[1] >= l2[0][1] then continue
		end if
		crossing += 1
	end for
end for

print crossing