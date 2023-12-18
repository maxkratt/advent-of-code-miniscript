import "stringUtil"

f = file.open("/usr/day1/input", "r")
lines = f.read
f.close()
strings = lines.split(char(10))
answers = []

for stringy in strings
    if not stringy then continue
    firstDigit = -1
    for i in range(0, stringy.len - 1)
        letter = stringy[i]
        if 58 > letter.code > 47 then
            if firstDigit == -1 then
                firstDigit = letter
            end if
            lastDigit = letter
        end if
    end for
    answers.push firstDigit + lastDigit
end for

total = 0
for answer in answers
    total += answer.val
end for
print total