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

start = [lines[0].indexOf("."), 0]
goal = [lines[-1].indexOf("."), lines.len - 1]

directions = [[1, 0], [0, 1], [-1, 0], [0, -1]]

paths = []
junctions = {}
for y in lines.indexes
    for x in lines[y].indexes
        if lines[y][x] == "#" then continue
        validDirs = 0
        for direction in directions
            x2 = x + direction.x
            y2 = y + direction.y
            nPos = [x2, y2]
            if 0 <= x2 < lines[0].len and 0 <= y2 < lines.len and lines[y2][x2] != "#" then
                validDirs += 1
            end if
            if validDirs > 2 then junctions[[x, y]] = {}
        end for
    end for
end for
// pprint junctions

step = function(startPos, steps = 0, lastPos = null)
    validDirs = []
    for direction in directions
        x = startPos.x + direction.x
        y = startPos.y + direction.y
        nPos = [x, y]
        if x < 0 or x >= lines[0].len or y < 0 or y >= lines.len or lastPos == nPos then continue
        if lines[y][x] == "#" then continue
        validDirs.push nPos
    end for
    if validDirs.len == 1 then 
        s = step(validDirs[0], steps + 1, startPos)
        steps = s[0]
        sp = s[1]
        lp = s[2]
    else
        sp = startPos
        lp = lastPos
    end if
    return [steps, sp, lp]
end function

makePath = function(start, dir)
    steps = step([start.x + dir.x, start.y + dir.y], 0, start)
    path = {"steps": steps[0] + 1,
        "enter":start,
        "enterB":[start.x + dir.x, start.y + dir.y],
        "exit":steps[1],
        "exitB":steps[2],
    }
    paths.push path
    return path
end function

getPath = function(pointB)
    for path in paths
        if path.enterB == pointB or path.exitB == pointB then return path 
    end for
    return null
end function

// Find starting and ending paths and remove them from their junctions
startingPath = makePath(start, [0, 1])
line = lines[startingPath.exitB[1]]
line = line[0:startingPath.exitB[0]] + "#" + line[startingPath.exitB[0] + 1:]
lines[startingPath.exitB[1]] = line
startingJunction = startingPath.exit
endingPath = makePath(goal, [0, -1])
line = lines[endingPath.exitB[1]]
line = line[0:endingPath.exitB[0]] + "#" + line[endingPath.exitB[0] + 1:]
lines[endingPath.exitB[1]] = line
endingJunction = endingPath.exit

// Create all paths
for junction in junctions
    for direction in directions
        nPos = [junction.key.x + direction.x, junction.key.y + direction.y]
        if lines[nPos.y][nPos.x] != "#" then
            if not getPath(nPos) then
                path = makePath(junction.key, direction)
                junctions[junction.key][direction] = path
                junctions[path.exit][[path.exitB[0] - path.exit[0], path.exitB[1] - path.exit[1]]] = path
            end if
        end if
    end for
end for

longestSteps = 0
// Find longest path through junctions
stepJunction = function(junction, seen = null, steps = 0)
    if seen == null then seen = []
    if junction == endingJunction then
        if steps > longestSteps then 
            globals.longestSteps = steps
            print "Found new longest steps " + longestSteps
        end if
    end if
    seen.push junction
    for path in globals.junctions[junction].values
        if path.enter == junction then
            if not seen.contains(path.exit) then
                stepJunction(path.exit, seen[0:], steps + path.steps)
            end if
        else
            if not seen.contains(path.enter) then
                stepJunction(path.enter, seen[0:], steps + path.steps)
            end if
        end if
    end for
    return
end function

stepJunction(startingJunction, [], startingPath.steps + endingPath.steps)
print longestSteps
print "Took " + (time - startTime) + " seconds"