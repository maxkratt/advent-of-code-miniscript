import "aoc"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

startTime = time

// Function to convert decimal number
// to binary using recursion
decimalToBinary = function(num)
	ans = []
	if num >= 1 then
		ans += decimalToBinary(floor(num / 2))
	end if
	ans.push(num % 2)
	return ans
end function

isNotEmptyString = function(i); if i != "" then return true; end function

satisfiesCondition = function(row, condition)
	items = row.split(".")
	items.filter @isNotEmptyString
	conditions = condition.split(",")
	if items.len != conditions.len then return false
	for i in items.indexes
		if i >= conditions.len or items[i].len != conditions[i].val then
			return false
		end if
	end for
	return true
end function

findCombinations = function(row)
	unknowns = row.split("?").len - 1
	combinations = []
	for i in range(0, 2 ^ unknowns - 1)
		bin = decimalToBinary(i)
		combinations.push ([0] * (unknowns - bin.len)) + bin[max(bin.len - unknowns, 0):]
	end for
	return combinations
end function

makeCombination = function(row, combination)
	combinationValues = [".", "#"]
	newRow = []
	combinationI = 0
	for r in row
		if r == "?" then
			newRow.push combinationValues[combination[combinationI]]
			combinationI += 1
		else
			newRow.push r
		end if
	end for
	return newRow.join("")
end function

total = 0
lineCount = 0
for line in lines
	parts = line.split(" ")
	lineCount += 1
	print lineCount + "/1000"
	combinations = findCombinations(parts[0])
	amountOfFitting = 0
	for combination in combinations
		c = makeCombination(parts[0], combination)
		fits = satisfiesCondition(c, parts[1])
		if fits then 
			amountOfFitting += 1
		end if
	end for
	total += amountOfFitting
end for
print "Total: " + total
print "Took " + (time - startTime) + " seconds."