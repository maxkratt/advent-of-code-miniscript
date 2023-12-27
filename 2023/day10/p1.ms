import "stringUtil"
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

pos = startPos[0:]
lastPos = pos[0:]
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
			exit
		end if
		if connections[offsetPos].contains(pipe) then 
			lastPos = pos[0:]
			pos = posToCheck
			break
		end if
	end for
end for