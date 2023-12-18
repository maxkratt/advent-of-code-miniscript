import "listUtil"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

points = []
for line in lines
	splitLine = line.split(":")[1].split("|")
	winners = splitLine[0].split(" ")
	for i in range(winners.len - 1)
		if winners[i] == "" then winners.remove(i)
	end for
	guesses = splitLine[1].split(" ")
	for i in range(guesses.len - 1)
		if guesses[i] == "" then guesses.remove(i)
	end for
	score = 0
	for guess in guesses
		if winners.contains(guess) then
			// print guess + " is a winner!"
			if score == 0 then 
				score = 1
			else
				score *= 2
			end if
		end if
	end for
	// print "match had a score of " + score
	points.push score
end for

print points.sum