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

times = lines[0].split(":")
times = times[1].split(" ")
times.removeVal "", 1
times.apply @getValue

distances = lines[1].split(":")
distances = distances[1].split(" ")
distances.removeVal "", 1
distances.apply @getValue

print times
print distances
waysToWinEach = []

for i in times.indexes
	waysToWin = 0
	for t in range(1, times[i] - 1)
		taken = t * (times[i] - t)
		if taken > distances[i] then
			// print "holding button for " + t + " seconds is a winner!"
			waysToWin += 1
		end if
	end for
	waysToWinEach.push waysToWin
	print waysToWin + " ways to win race " + (i + 1)
end for

print waysToWinEach.product