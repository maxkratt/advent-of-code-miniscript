import "stringUtil"
import "listUtil"
import "aoc"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

printc = function(col, message)
	c = text.color
	text.color = col
	print message
	text.color = c
end function

getValue = function(s); return s.val; end function
pause = function
	while not key.get
		yield
	end while
end function

// scope1 - seed scope [5, 1], mapping scope [6, 32, 4]
sliceAndDiffScopes = function(scope1, scope2)
	scope1Start = scope1[0]
	scope2Start = scope2[1]
	scope1End = scope1Start + scope1[1]
	scope2End = scope2Start + scope2[2]
	difference = scope2[0] - scope2[1]
	notIncludedScopes = []
	includedScope = []
	if scope1Start < scope2End and scope2Start < scope1End then
		if scope1Start < scope2Start then
			notIncludedScopes.push [scope1Start, scope2Start - scope1Start]
		end if
		
		midStart = max(scope1Start, scope2Start)
		midEnd = min(scope1End, scope2End)
		includedScope = [midStart + difference, midEnd - midStart]

		if scope1End > scope2End then
			notIncludedScopes.push [scope2End, scope1End - scope2End]
		end if
		return {"notIncluded":notIncludedScopes, "included": includedScope}
	else
		return {"notIncluded":[scope1], "included":[]}
	end if
end function

seeds = []
maps = {}
whichMapToAddTo = "seeds-to-soil"

for line in lines
	if line.startsWith("seeds") then
		seeds = line.split(" ")[1:]
		seeds.apply(@getValue)
		newSeeds = []
		for i in range(0, seeds.len - 1, 2);
			 newSeeds.push [seeds[i], seeds[i + 1]]
		end for
		seeds = newSeeds
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

seedScopes = seeds
for kv in maps
	printc color.red, "############## " + kv.key + " ##############"

	newSeedScopes = []
	for scope in kv.value
		unmatchedSeeds = []

		for	seedScope in seedScopes

			newSeedScope = sliceAndDiffScopes(seedScope, scope)
			unmatchedSeeds += newSeedScope.notIncluded
			if newSeedScope.included != [] then
				newSeedScopes += [newSeedScope.included]
			end if
		end for
		seedScopes = unmatchedSeeds

	end for

	seedScopes += newSeedScopes[0:]
end for

minimum = 9999999999999
for e in seedScopes
	if e[0] < minimum then minimum = e[0]
end for

printc color.blue, "IT SUCCEDED!!! The Minimum is: " + minimum