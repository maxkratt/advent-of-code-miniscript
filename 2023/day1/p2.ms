import "stringUtil"

f = file.open("/usr/day1/input", "r")
lines = f.read
f.close()
strings = lines.split(char(10))
answers = []
numbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

findFirstAndLastDigits = function(stringContainingDigits)
    firstDigit = {"number": "", "index": 0}
    lastDigit = {"number": "", "index": 0}
    for i in range(0, stringContainingDigits.len - 1)
        letter = stringContainingDigits[i]
        if 58 > letter.code > 47 then
            if firstDigit.number.len == 0 then
                firstDigit.number = letter
                firstDigit.index = i
            end if
            lastDigit.number = letter
            lastDigit.index = i
        end if
    end for
    return {"firstDigit": firstDigit, "lastDigit": lastDigit}
end function

findFirstNumber = function(numbers, stringContainingNumbers)
    firstNumber = {"number": "", "index": 999}
    for i in range(0, numbers.len - 1)
        numberAsLetters = numbers[i]
        if stringContainingNumbers.contains(numberAsLetters) then
            index = stringContainingNumbers.indexOf(numberAsLetters)
            if index < firstNumber.index then
                firstNumber.index = index
                firstNumber.number = i + 1
            end if
        end if
    end for
    return firstNumber
end function

for stringy in strings
    // Ignore end of file
    if not stringy then continue

    // First and Last Digit
    firstAndLastDigits = findFirstAndLastDigits(stringy)
    firstDigit = firstAndLastDigits.firstDigit
    lastDigit = firstAndLastDigits.lastDigit

    // First Number
    firstNumber = findFirstNumber(numbers, stringy)
    // Last Number
    reversedNumbers = numbers[0:]
    for i in range(0, reversedNumbers.len - 1)
        reversedNumbers[i] = reversedNumbers[i].reverse
    end for
    lastNumber = findFirstNumber(reversedNumbers, stringy.reverse)
    lastNumber.index = stringy.len - lastNumber.index - 1
    
    // First and Last Number or Digit
    first = firstNumber.number
    if firstDigit.index < firstNumber.index then first = firstDigit.number
    last = lastNumber.number
    if lastDigit.index > lastNumber.index then last = lastDigit.number
    answers.push str(first) + str(last)
end for

total = 0
for answer in answers
    total += answer.val
end for
print total