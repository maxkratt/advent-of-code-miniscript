import "aoc"
import "vector3"

st = time
sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

for l in lines.indexes
	line = lines[l].split("")
	line.apply @val
	lines[l] = line
end for
width = lines.len
height = lines[0].len

seenTiles = {}
alreadyBeenAt = function(x, y, stepCount, dirX, dirY)
	for s in range(1, stepCount)
		if seenTiles.hasIndex([x, y, s, dirX, dirY]) then return true
	end for

	return false
end function

queue = []

directions = [[0, 1], [1, 0], [-1, 0], [0, -1]]

heatLost = 1
queue.push [0, 0, 0, 0, 0, 0] // heat lost, x, y, step count, direction x, direction y
while queue.len
    tileData = queue.pull
    heatLost = tileData[0]
    x = tileData[1]
    y = tileData[2]
    steps = tileData[3]
    dirX = tileData[4]
    dirY = tileData[5]
    
    if x == width - 1 and y == height - 1 then
        break
    end if

    if alreadyBeenAt(x, y, steps, dirX, dirY) then
        continue
    end if

    seenTiles[[x, y, steps, dirX, dirY]] = 1

    for direction in directions
        nextDirX = direction.x
        nextDirY = direction.y
        nextX = nextDirX + x
        nextY = nextDirY + y
        sameDirection = false
        if nextDirX == dirX and nextDirY == dirY then sameDirection = true
        
        if nextDirX == -dirX and nextDirY == -dirY then continue
        if sameDirection and steps == 3 then continue
        if nextX < 0 or nextY < 0 or nextX >= width or  nextY >= height then continue
        
        if sameDirection then
            nextSteps = steps + 1
        else
            nextSteps = 1
        end if

        queue.push([heatLost + lines[nextX][nextY], nextX, nextY, nextSteps, nextDirX, nextDirY])
    end for
    queue.sort(0)
end while

print heatLost
print "Took " + (time - st) + " seconds"