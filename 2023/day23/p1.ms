import "aoc"
import "vector3"

// Edited the input, replace the starting point with v and the ending point with ^

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

start = [lines[0].indexOf("v"), 0]
goal = [lines[-1].indexOf("^"), lines.len - 1]

directions = {
	".":[[0, 1], [1, 0], [-1, 0], [0, -1]],
	">":[[1, 0]],
	"<":[[-1, 0]],
	"v":[[0, 1]],
	"^":[[0, -1]],
}

step = function(pos, seen, steps = 0)
	if pos == goal then
		print "GOAL in " + steps
		if steps > globals.longestSteps then globals.longestSteps = steps
		return true
	end if

	seen[pos] = steps

	paths = []
	for direction in directions[lines[pos.y][pos.x]]
		nextPos = [direction.x + pos.x, direction.y + pos.y]
		if seen.hasIndex(nextPos) or lines[nextPos.y][nextPos.x] == "#" then continue
		paths.push nextPos
	end for
	for path in paths
		if paths.len > 1 then
			newSeen = {}
			seen.stuffInto newSeen
			step path, newSeen, steps + 1
		else
			step path, seen, steps + 1
		end if
	end for

end function

longestSteps = 0
step start, {}
print longestSteps