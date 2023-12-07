import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

pause = function
	while not key.get
		yield
	end while
end function

fullTime = lines[0].split(":")
fullTime = fullTime[1]
fullTime = fullTime.replace(" ", "", fullTime.len).val

distance = lines[1].split(":")
distance = distance[1]
distance = distance.replace(" ", "", distance.len).val

print "Starting at: " + time
startTime = time
print "Time: " + fullTime
print "Distance: " + distance

// Brute Force
firstWayToWin = 0
lastWayToWin = 0
t = 1
while t < fullTime
	taken = t * (fullTime - t)
	if taken > distance then
		print "holding button for " + t + " seconds is a winner!"
		firstWayToWin = t
		break
	end if
	t += 1
end while
t = fullTime - 1
while t > 1
	taken = t * (fullTime - t)
	if taken > distance then
		print "holding button for " + t + " seconds is a winner!"
		lastWayToWin = t
		break
	end if
	t -= 1
end while
waysToWin = lastWayToWin - firstWayToWin + 1
print waysToWin

endingTime = time
print "ending at " + endingTime + ", total time: " + (endingTime - startTime)