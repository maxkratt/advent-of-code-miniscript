import "stringUtil"
import "listUtil"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input" else fname = sourceDir + "example"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

impossibleGames = []
maximumCubes = {"red": 12, "green": 13, "blue": 14}

for gameIndex in lines.indexes
	game = lines[gameIndex][7:]
	game = game.split(" ")
	foundValidity = false
	for i in game.indexes
		if foundValidity then continue
		for cube in maximumCubes.indexes
			if game[i].contains(cube) then 
				if game[i-1].val > maximumCubes[cube] then
					print "Game " + (gameIndex + 1) + " invalid"
					impossibleGames.push gameIndex + 1
					foundValidity = true
					break
				end if
			end if
		end for
	end for
end for

possibleGames = []
for i in range(1, lines.len)
	if impossibleGames.contains(i) then continue
	possibleGames.push i
end for
print possibleGames
print possibleGames.sum