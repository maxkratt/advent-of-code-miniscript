
sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

st = time
gridW = lines[0].len
gridH = lines.len
moves = []
for row in lines.indexes
	if moves.len > 0 then break
	for col in lines[row].indexes
		if lines[row][col] == "S" then
			x = col - 1; y = row
			if 0 <= x < gridW and 0 <= y < gridH and lines[y][x] != "#" then moves.push [x, y]
			x = col + 1; y = row
			if 0 <= x < gridW and 0 <= y < gridH and lines[y][x] != "#" then moves.push [x, y]
			x = col; y = row - 1
			if 0 <= x < gridW and 0 <= y < gridH and lines[y][x] != "#" then moves.push [x, y]
			x = col; y = row + 1
			if 0 <= x < gridW and 0 <= y < gridH and lines[y][x] != "#" then moves.push [x, y]
			break
		end if
	end for
end for
remainingSteps = 64
while remainingSteps - 1 > 0
	remainingSteps -= 1
	newMoves = {}
	for move in moves
		x = move[0] - 1; y = move[1]
		if 0 <= x < gridW and 0 <= y < gridH and lines[y][x] != "#" then newMoves[[x, y]] = 1
		x = move[0] + 1; y = move[1]
		if 0 <= x < gridW and 0 <= y < gridH and lines[y][x] != "#" then newMoves[[x, y]] = 1
		x = move[0]; y = move[1] - 1
		if 0 <= x < gridW and 0 <= y < gridH and lines[y][x] != "#" then newMoves[[x, y]] = 1
		x = move[0]; y = move[1] + 1
		if 0 <= x < gridW and 0 <= y < gridH and lines[y][x] != "#" then newMoves[[x, y]] = 1
	end for
	moves = newMoves.indexes
end while
print "Final steps: " + moves.len
print "Took " + (time - st) + " seconds."