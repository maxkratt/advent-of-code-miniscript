import "aoc"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

cache = {}

count = function(cfg, nums)
	if cfg == "" then
		if nums == [] then return 1 else return 0
	end if

	if nums == [] then
		if cfg.contains("#") then return 0 else return 1
	end if

	key = [cfg, nums]

	if cache.hasIndex(key) then return cache[key]

	result = 0
	
	if ".?".contains(cfg[0]) then
		result += count(cfg[1:], nums)
	end if
	
	if "#?".contains(cfg[0]) then
		if nums[0] <= cfg.len and not cfg[:nums[0]].contains(".") and (nums[0] == cfg.len or cfg[nums[0]] != "#") then
			result += count(cfg[nums[0] + 1:], nums[1:])
		end if
	end if

	cache[key] = result
	return result
end function

st = time
total = 0
for line in lines
	parts = line.split(" ")
	cfg = parts[0]
	nums = parts[1].split(",")
	nums.apply @val

	cfg = ([cfg] * 5).join("?")
	nums *= 5

	total += count(cfg, nums)
end for
print total
print "Took " + (time - st) + " seconds"