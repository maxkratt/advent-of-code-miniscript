import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input" else fname = sourceDir + "example"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

maximumCubes = {"red": 12, "green": 13, "blue": 14}
foundCubesPerGame = []

for gameIndex in lines.indexes
	game = lines[gameIndex][7:]
	game = game.split(" ")
	foundCubesPerGame.push({})
	for i in game.indexes
		for cube in maximumCubes.indexes
			if game[i].contains(cube) then 
				if foundCubesPerGame[gameIndex].hasIndex(cube) then
					if foundCubesPerGame[gameIndex][cube] < game[i-1].val then
						foundCubesPerGame[gameIndex][cube] = game[i-1].val
					end if
				else
					foundCubesPerGame[gameIndex][cube] = game[i-1].val
				end if
				break
			end if
		end for
	end for
end for

powers = []
for cubes in foundCubesPerGame
	power = 1
	for cube in cubes
		power *= cube.value
	end for
	powers.push power
end for
print powers.sum