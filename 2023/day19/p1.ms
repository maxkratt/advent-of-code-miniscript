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
parts = lines[partRatingsStart:]

// Parse machine parts
for i in parts.indexes
	part = parts[i].between("{", "}")
	categories = part.split(",")
	part = {}
	for category in categories
		c = category.split("=")
		part[c[0]] = c[1].val
		parts[i] = part
	end for
end for

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
for p in parts.indexes
	workflow = workflows["in"]
	part = parts[p]
	i = 0
	while true
		inst = workflow[i]
		if inst.op == "<" then
			i += 1
			if part[inst.key] >= inst.value then continue
		else if inst.op == ">" then
			i += 1
			if part[inst.key] <= inst.value then continue
		end if

		if inst.dest == "A" then
			acceptedParts.push p
			break
		else if inst.dest == "R" then
			break
		else
			i = 0
			workflow = workflows[inst.dest]
			continue
		end if
		i += 1
	end while 
end for
print "Found " + acceptedParts.len + " accepted parts."

total = 0
for p in acceptedParts
	partTotal = 0
	for v in parts[p].values
		partTotal += v
	end for
	total += partTotal
end for
print "Total is " + total
