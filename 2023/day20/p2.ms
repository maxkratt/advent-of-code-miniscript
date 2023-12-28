import "stringUtil"
import "listUtil"
import "myaoc"

sourceDir = file.parent(_sourceFile) + "/"
if 1 then fname = sourceDir + "input.txt" else fname = sourceDir + "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop


// types: broadcaster = 0, % = 1, & = 2

// {"broadcaster": {"type":0, outputs:["cs", "ad"]}, 
// 	"cs": {"type":1, outputs:["ad"], "state": 1},
//	"ad": {"type":2, outputs:["cs"], "inputs": ["broadcast", "cs"], "states": [0, 1]}}


// Parse modules
modules = {} 
for line in lines
	module = {}
	name = line[1:line.indexOf(" ")]
	if line[0] == "%" then
		module["type"] = 1
		module["state"] = 0
	else if line[0] == "&" then
		module["type"] = 2
		module["inputs"] = []
		for l in lines
			outputs = l.split(" -> ")
			outputs = outputs[1].split(", ")
			outputterName = l[1:l.indexOf(" ")]
			if not "%&".contains(l[0]) then outputterName = "broadcaster"
			for o in outputs
				if o == name then module["inputs"].push(outputterName)
			end for
		end for
		module["states"] = [0] * module["inputs"].len
	else
		module["type"] = 0
		name = "broadcaster"
	end if
	l = line.split(" -> ")
	module["outputs"] = l[1].split(", ")
	modules[name] = module
end for

lastFirstPos = 0
sameFor = 0
pulse = function(moduleStack)
	newModuleStack = []
	for source_pulse_module in moduleStack
		moduleName = source_pulse_module[2]
		modulePulse = source_pulse_module[1]
		moduleSource = source_pulse_module[0]
		
		if moduleName == "th" and modulePulse == 1 then
			globals.occured[moduleSource] += 1
			if not globals.cycleLengths.hasIndex(moduleSource) then
				globals.cycleLengths[moduleSource] = globals.i
			end if

			if globals.occured.values.product == 1 then
				print cycleLengths
				print lcm(globals.cycleLengths.values)
				exit
			end if
		end if


		if not modules.hasIndex(moduleName) then 
			continue
		end if
		
		module = modules[moduleName]
		if module.type == 0 then // broadcaster
			for mod in module.outputs
				newModuleStack.push [moduleName, modulePulse, mod]
			end for
		else if module.type == 1 then // %
			if modulePulse == 1 then continue
			module.state = not module.state
			for mod in module.outputs
				newModuleStack.push [moduleName, module.state, mod]
			end for
		else // &
			module.states[module.inputs.indexOf(moduleSource)] = modulePulse
			pulseToSend = 1
			if module.states.sum == module.states.len then pulseToSend = 0
			for mod in module.outputs
				newModuleStack.push [moduleName, pulseToSend, mod]
			end for
		end if
	end for
	return newModuleStack
end function

// These are the modules that lead to "th"
occured = {"zl":0, "xf":0, "qn":0, "xn":0}
cycleLengths = {}

i = 0
while true
	i += 1
	modsToPulse = [["button", 0, "broadcaster"]] // [source name, pulse, module name] 0=low, 1=high
	while modsToPulse.len
		modsToPulse = pulse(modsToPulse)
	end while
	
end while

print "Final total: " + pulses.product
print "Took " + i + " button presses"