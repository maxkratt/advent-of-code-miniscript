import "vector3"

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

isPosOutOfBounds = function(position)
	if position.x < 0 or position.x >= lines[0].len or position.y < 0 or position.y >= lines.len then
		return true
	end if
	return false
end function

lightPaths = {}
path = function(pos, dir)
	if isPosOutOfBounds(pos) then return
	if lightPaths.hasIndex(pos) then
		if lightPaths[pos].contains(dir) then return
		lightPaths[pos].push dir
	else
		lightPaths[pos] = [dir]
	end if
	c = lines[pos.y][pos.x]
	if dir == [1, 0] then
		if c == "/" then 
			path [pos.x, pos.y - 1], [0, -1]
		else if c == "\" then
			path [pos.x, pos.y + 1], [0, 1]
		else if c == "|" then
			path [pos.x, pos.y + 1], [0, 1]
			path [pos.x, pos.y - 1], [0, -1]
		else
			path [pos.x + dir.x, pos.y + dir.y], dir
		end if
	else if dir == [-1, 0] then
		if c == "/" then
			path [pos.x, pos.y + 1], [0, 1]
		else if c == "\" then
			path [pos.x, pos.y - 1], [0, -1]
		else if c == "|" then
			path [pos.x, pos.y - 1], [0, -1]
			path [pos.x, pos.y + 1], [0, 1]
		else
			path [pos.x + dir.x, pos.y + dir.y], dir
		end if
	else if dir == [0, 1] then
		if c == "/" then
			path [pos.x - 1, pos.y], [-1, 0]
		else if c == "\" then
			path [pos.x + 1, pos.y], [1, 0]
		else if c == "-" then
			path [pos.x - 1, pos.y], [-1, 0]
			path [pos.x + 1, pos.y], [1, 0]
		else
			path [pos.x + dir.x, pos.y + dir.y], dir
		end if
	else if dir == [0, -1] then
		if c == "/" then
			path [pos.x + 1, pos.y], [1, 0]
		else if c == "\" then
			path [pos.x - 1, pos.y], [-1, 0]
		else if c == "-" then
			path [pos.x + 1, pos.y], [1, 0]
			path [pos.x - 1, pos.y], [-1, 0]
		else
			path [pos.x + dir.x, pos.y + dir.y], dir
		end if
	end if
end function

path [0,0], [1,0]
print lightPaths.len