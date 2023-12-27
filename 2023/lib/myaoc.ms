// Pauses the execution of the program until the user presses any key.
globals.pause = function
	while not key.get
		yield
	end while
end function

// Returns the Greatest Common Divisor of two numbers.
globals.gcd = function(n, m)
    if m == 0 then
        return n
	end if
    return gcd(m, n % m)
end function

// Returns the Least Common Multiple of numbers in a list.
globals.lcm = function(listOfNumbers)
	result = 1
	for i in listOfNumbers
		result = (result * i) / gcd(result, i)
	end for
	return result
end function