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

hash = function(s)
	value = 0
	for c in s
		value += code(c)
		value *= 17
		value %= 256
	end for
	return value
end function

boxes = {}
box = {
	"order": [],
	"mapping": {},
}
box.make = function(order, mapping)
	newBox = new box
	newBox.order = order
	newBox.mapping = mapping
	return newBox
end function

printBoxes = function(boxes)
	print "BOXES:"
	for kv in boxes
		print " box " + kv.key
		print "  mapping: " + kv.value.mapping
		print "  order: " + kv.value.order
	end for
end function

total = 0
splitLines = lines[0].split(",")
for l in splitLines
	if l.contains("=") then
		line = l.split("=")
		boxLabel = line[0]
		boxIndex = hash(boxLabel)
		boxValue = line[-1]
		if boxes.hasIndex(boxIndex) then
			if not boxes[boxIndex].mapping.hasIndex(boxLabel) then
				boxes[boxIndex].order.push(boxLabel)
			end if
			boxes[boxIndex].mapping[boxLabel] = boxValue.val
		else
			boxes[boxIndex] = box.make([boxLabel], {boxLabel: boxValue.val})
		end if
	else
		line = l.split("-")
		boxLabel = line[0]
		boxIndex = hash(boxLabel)
		if boxes.hasIndex(boxIndex) then
			if boxes[boxIndex].mapping.hasIndex(boxLabel) then
				boxes[boxIndex].order.removeVal boxLabel
				boxes[boxIndex].mapping.remove boxLabel
			end if
		end if
	end if
end for

total = 0 
for kv in boxes
	if kv.value.order.len == 0 then continue 
	for lens in kv.value.mapping
		lensValue = (1 + kv.key) * lens.value * (kv.value.order.indexOf(lens.key) + 1)
		total += lensValue
	end for
end for
print total