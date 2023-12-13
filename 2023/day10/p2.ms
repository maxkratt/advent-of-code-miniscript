import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "myaoc"
import "vector3"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

connections = { [0, -1]: "F|7S", 
				[0, 1]: "L|JS",
				[1, 0]: "J-7S",
				[-1, 0]: "L-FS", }

positions = { "S": [[-1, 0], [0, -1], [1, 0], [0, 1]], 
			  "-": [[-1, 0], [1, 0]],
			  "|": [[0, -1], [0, 1]],
			  "L": [[1, 0], [0, -1]],
			  "J": [[-1, 0], [0, -1]],
			  "F": [[1, 0], [0, 1]],
			  "7": [[-1, 0], [0, 1]]}

getChar = function(position)
	return lines[position.y][position.x]
end function

startPos = [0,0]
for i in lines.indexes
	for j in lines[i].indexes
		c = lines[i][j]
		if c == "S" then
			startPos = [j, i]
		end if
	end for
end for
print "Animal entered at: " + startPos


findPath = function
	pipes = {}
	pos = startPos[0:]
	lastPos = pos[0:]
	initialOffset = null
	
	for step in range(1, 100000)
		for offsetPos in positions[lines[pos.y][pos.x]]
			posToCheck = pos[0:]
			posToCheck.add offsetPos
			if posToCheck.y < 0 or posToCheck.y >= lines.len or 
				posToCheck.x < 0 or posToCheck.x >= lines[posToCheck.y].len then
				continue
			end if
			if posToCheck == lastPos then
				continue
			end if
			pipe = getChar(posToCheck)
			if pipe == "S" and lastPos != pos then
				print "FOUND LOOP! TOOK " + step + " STEPS!"
				print "Farthest Point is " + (step / 2) + " steps away."
				if not pipes.hasIndex(posToCheck.y) then pipes[posToCheck.y] = {}
				finalOffset = pos[0:]
				finalOffset[0] -= posToCheck[0]
				finalOffset[1] -= posToCheck[1]
				startingPipe = "S"
				for kv in positions
					if kv.value.contains(finalOffset) and kv.value.contains(initialOffset) then
						startingPipe = kv.key
					end if
				end for
				pipes[posToCheck.y][posToCheck.x] = startingPipe
				print "Starting pipe should be " + startingPipe
				return pipes
			end if
			if connections[offsetPos].contains(pipe) then 
				if step == 1 then
					initialOffset = posToCheck[0:]
					initialOffset[0] -= startPos[0]
					initialOffset[1] -= startPos[1]
				end if
				lastPos = pos[0:]
				pos = posToCheck
				if not pipes.hasIndex(pos.y) then pipes[pos.y] = {}
				pipes[pos.y][pos.x] = pipe
				break
			end if
		end for
	end for
end function

pipes = findPath
areasInPath = 0
print
print "Finding area of pipes"
for y in lines.indexes
	line = lines[y]
	for x in line.indexes
		c = line[x]
		if not pipes.hasIndex(y) then continue
		if not pipes[y].hasIndex(x) then
			pipesFound = {"7":0, "|":0, "L": 0, "F": 0, "J": 0}
			for i in range(x + 1, line.len - 1)
				if not pipes[y].hasIndex(i) then continue
				if "7|LFJS".contains(line[i]) then 
					pipesFound[pipes[y][i]] += 1
				end if
			end for
			if ((pipesFound["|"] + min(pipesFound["7"], pipesFound["L"]) + min(pipesFound["F"], pipesFound["J"])) % 2) != 0 then
				areasInPath += 1
			end if
		end if
	end for
end for
print areasInPath + " areas in the path."