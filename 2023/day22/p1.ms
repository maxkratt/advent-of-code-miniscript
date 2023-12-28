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

parseblocks = function(lines)
	blocks = []
	for line in lines
		ends = line.split("~")
		start = ends[0].split(",")
		start.apply @val
		finish = ends[1].split(",")
		finish.apply @val
		blocks.push [start, finish]
	end for
	return blocks
end function

sortByZ = function(block1, block2)
	block1Z = min(block1[0].z, block1[1].z)
	block2Z = min(block2[0].z, block2[1].z)
	return block1Z - block2Z
end function

rangeOfBlock = function(block)
	if block[0].x != block[1].x then
		return {"axis":0,"range":range(block[0].x, block[1].x)}
	else if block[0].y != block[1].y then
		return {"axis":1,"range":range(block[0].y, block[1].y)}
	else
		return {"axis":2,"range":range(block[0].z, block[1].z)}
	end if
end function

getFieldDimensions = function(blocks)
	fieldX = [0, 0]
	fieldY = [0, 0]
	for block in blocks
		bStartX = min(block[0].x, block[1].x)
		bEndX = max(block[0].x, block[1].x)
		bStartY = min(block[0].y, block[1].y)
		bEndY = max(block[0].y, block[1].y)
		fieldX[0] = min(bStartX, fieldX[0])
		fieldX[1] = max(bEndX, fieldX[1])
		fieldY[0] = min(bStartY, fieldY[0])
		fieldY[1] = max(bEndY, fieldY[1])
	end for
	width = fieldX[1] - fieldX[0] + 1
	height = fieldY[1] - fieldY[0] + 1
	return {"width":width, "height":height}
end function

st = time

blocks = parseblocks(lines)
blocks.sortWithFunction @sortByZ
field = getFieldDimensions(blocks)

resetHighestPoints = function(field)
	globals.highestPoints = []
	for w in range(1, field.width)
		globals.highestPoints.push [0] * field.height
	end for
end function
resetHighestPoints field

printHighestPoints = function
	print "  " + range(0, globals.highestPoints[0].len - 1, 1).join("  ")
	for x in globals.highestPoints.indexes
		print x, " "
		for y in globals.highestPoints[x].indexes
			s = "0" + globals.highestPoints[y][x]
			print s[-2:], " "
		end for
		print 
	end for
end function

dropBlocks = function(blocks, highestPoints, stopOndrop = false)
	for b in blocks.indexes
		block = blocks[b]
		blockWas = block[0][0:]
		blockRange = rangeOfBlock(block)
		if blockRange.axis == 2 then
			was = highestPoints[block[0].x][block[0].y]
			block[0][2] = highestPoints[block[0].x][block[0].y] + 1
			highestPoints[block[0].x][block[0].y] += blockRange.range.len
			block[1][2] = highestPoints[block[0].x][block[0].y]
		else if blockRange.axis == 1 then
			highestPoint = 0
			for y in blockRange.range
				highestPoint = max(highestPoint, highestPoints[block[0].x][y])
			end for
			for y in blockRange.range
				highestPoints[block[0].x][y] = highestPoint + 1
			end for
			block[0][2] = highestPoint + 1
			block[1][2] = highestPoint + 1
		else
			highestPoint = 0
			for x in blockRange.range
				highestPoint = max(highestPoint, highestPoints[x][block[0].y])
			end for
			for x in blockRange.range
				highestPoints[x][block[0].y] = highestPoint + 1
			end for
			block[0][2] = highestPoint + 1
			block[1][2] = highestPoint + 1
		end if

		if stopOndrop and blockWas != block[0][0:] then
			block[0] = blockWas
			return true
		end if
	end for
	return false
end function

dropBlocks blocks, highestPoints
blocks.sortWithFunction @sortByZ
originalB = blocks.deepCopy

filterByZ = {}
filterByZ.startingAt = true
filterByZ.z = 0
filterByZ.filter = function(block)
	return block[filterByZ.startingAt].z == filterByZ.z
end function
getBlocksOnZ = function(blocks, z, startingOnZ = true)
	filterByZ.z = z
	filterByZ.startingAt = not startingOnZ
	return blocks.filtered(@filterByZ.filter)
end function

blocksThatCanBeRemoved = 0
for b in blocks.indexes
	block = blocks[b]
	blocks.remove b
	resetHighestPoints field
	if not dropBlocks(blocks, highestPoints, true) then
		print "Block " + b + " can be removed."
		blocksThatCanBeRemoved += 1
	end if
	blocks = originalB.deepCopy
end for
print "Total: " + blocksThatCanBeRemoved
print "Took " + (time - st) + " seconds"