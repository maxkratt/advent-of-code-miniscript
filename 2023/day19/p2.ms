import "aoc"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

for i in lines.indexes
	if lines[i].len == 0 then
		partRatingsStart = i + 1
		break
	end if
end for

workflowLines = lines[0:partRatingsStart - 1]

// Parse workflows
workflows = {}
for workflow in workflowLines
	name = workflow[0:workflow.indexOf("{")]
	insts = workflow.between("{", "}")
	insts = insts.split(",")
	instructions = []
	for inst in insts
		instruction = {"key":null, "op":null, "value":null, "dest":null}
		if inst.contains(">") then
			instruction.key = inst[0:inst.indexOf(">")]
			instruction.op = ">"
			instruction.value = inst.between(">",":").val
			instruction.dest = inst[inst.indexOf(":") + 1:]
		else if inst.contains("<") then
			instruction.key = inst[0:inst.indexOf("<")]
			instruction.op = "<"
			instruction.value = inst.between("<",":").val
			instruction.dest = inst[inst.indexOf(":") + 1:]
		else
			instruction.dest = inst
		end if
		instructions.push instruction
	end for
	workflows[name] = instructions
end for

acceptedParts = []
parts = [{"wf":"in", "x":[1, 4000], "m":[1, 4000], "a":[1, 4000], "s":[1, 4000]}]
clonePart = function(part)
	newPart = {}
	for kv in part
		if kv.value isa list then newPart[kv.key] = kv.value[0:] else newPart[kv.key] = kv.value
	end for
	return newPart
end function

while parts.len
	part = parts.pop
	if not workflows.hasIndex(part.wf) then continue
	workflow = workflows[part.wf]
	for inst in workflow
		if inst.op == "<" then
			if inst.value < part[inst.key][1] and inst.value > part[inst.key][0] then
				whatFits = clonePart(part)
				whatFits[inst.key][1] = inst.value - 1
				whatFits.wf = inst.dest
				part[inst.key][0] = inst.value
				if inst.dest == "A" then
					acceptedParts.push whatFits
				else if inst.dest == "R" then
				else
					parts.push whatFits
				end if
			end if
		else if inst.op == ">" then
			if inst.value > part[inst.key][0] and inst.value < part[inst.key][1] then
				whatFits = clonePart(part)
				whatFits[inst.key][0] = inst.value + 1
				whatFits.wf = inst.dest
				part[inst.key][1] = inst.value
				if inst.dest == "A" then
					acceptedParts.push whatFits
				else if inst.dest == "R" then
				else
					parts.push whatFits
				end if
			end if
		else if inst.dest == "A" then
			acceptedParts.push part
		else if inst.dest == "R" then
		else
			newPart = clonePart(part)
			newPart.wf = inst.dest
			parts.push newPart
		end if
	end for
end while 

// pprint acceptedParts
print "Found " + acceptedParts.len + " accepted parts."
total = 0
for p in acceptedParts
	partTotal = 1
	for v in p.values
		if v isa list then
			partTotal *= v[1] - v[0] + 1
		end if
	end for
	total += partTotal
end for
print "Total is " + total
