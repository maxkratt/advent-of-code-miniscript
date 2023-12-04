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

cards = {}
for	l in lines.indexes
	cards[l + 1] = 1
end for

for l in lines.indexes
	line = lines[l]
	splitLine = line.split(":")[1].split("|")
	winners = splitLine[0].split(" ")
	for i in range(winners.len - 1)
		if winners[i] == "" then winners.remove(i)
	end for
	guesses = splitLine[1].split(" ")
	for i in range(guesses.len - 1)
		if guesses[i] == "" then guesses.remove(i)
	end for
	// print " Checking card " + (l + 1) + ": " + cards[l + 1]
	score = 0
	for guess in guesses
		if winners.contains(guess) then
			score += 1
			if l + 1 + score > lines.len then break
			cards[l + 1 + score] += cards[l + 1]
		end if
	end for
end for

print cards.values.sum