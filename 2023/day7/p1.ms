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

cards = "A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, 2".split(", ")
cards.reverse
cardsMap = {}
for c in cards
	cardsMap[c] = cards.indexOf(c)
end for


getHandRank = function(hand)
	kinds = {}
	for card in hand
		if kinds.hasIndex(card) then
			kinds[card] += 1
		else
			kinds[card] = 1
		end if
	end for
	for kv in kinds
		if kv.value == 5 then
			return 6 // Five of a kind
		else if kv.value == 4 then
			return 5 // Four of a kind
		else if kv.value == 3 then 
			if kinds.values.contains(2) then
				return 4 // Full house
			else
				return 3 // Three of a kind
			end if
		else if kv.value == 2 then
			if kinds.values.contains(3) then 
				return 4
			else if kinds.len == 3 then
				return 2 // Two pair
			else
				return 1 // One pair
			end if
		end if
	end for
	return 0
end function

whichIsStronger = function(hand1, hand2)
	hand1 = hand1[0:5]
	hand2 = hand2[0:5]
	hand1Rank = getHandRank(hand1)
	hand2Rank = getHandRank(hand2)
	if hand1Rank > hand2Rank then
		return 1
	else if hand2Rank > hand1Rank then
		return -2
	else 
		for i in hand1.indexes
			if cardsMap[hand1[i]] > cardsMap[hand2[i]] then
				return 1
			else if cardsMap[hand2[i]] > cardsMap[hand1[i]] then
				return -2
			end if
		end for
	end if
	return 0
end function

lines.sortWithFunction @whichIsStronger
total = 0
for i in lines.indexes
	total += (i + 1) * lines[i][6:].val
end for
print total