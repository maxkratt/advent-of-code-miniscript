import "stringUtil"
import "listUtil"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop


getValue = function(s); return s.val; end function
pause = function
	while not key.get
		yield
	end while
end function

seeds = []
maps = {}
whichMapToAddTo = "seeds-to-soil"

for line in lines
	if line.startsWith("seeds") then
		seeds = line.split(" ")[1:]
		seeds.apply(@getValue)
	end if
	splitLine = line.split(" ")
	if line.contains("-to-") then
		whichMapToAddTo = splitLine[0]
	end if
	if splitLine.len == 3 then
		splitLine.apply(@getValue)
		if maps.hasIndex(whichMapToAddTo) then
			maps[whichMapToAddTo].push splitLine
		else
			maps[whichMapToAddTo] = [splitLine]
		end if
	end if
end for

lowestLocation = 99999999999999999
for seed in seeds
	current = seed
	for kv in maps
		for a in kv.value
			if a[1] <= current < a[1] + a[2] then
				current = a[0] + (current - a[1])
				break
			end if
		end for
	end for
	if current < lowestLocation then lowestLocation = current
end for
print lowestLocation