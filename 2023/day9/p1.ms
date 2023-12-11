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

findDiffs = function(nums)
	diffs = []
	allZero = true
	for i in nums.indexes[0:-1]
		d = nums[i + 1] - nums[i]
		diffs.push(d)
		if d != 0 then allZero = false
	end for
	if not allZero then
		newDiffs = findDiffs(diffs)
		diffs.push diffs[-1] + newDiffs[0][-1]
		diffs = [diffs] + newDiffs
	else
		diffs = [diffs + [0]]
	end if
	return diffs
end function

total = 0
for line in lines
	differences = line.split(" ")
	differences.apply @val
	diffs = findDiffs(differences)
	final = differences[-1] + diffs[0][-1]
	total += final
end for
print total