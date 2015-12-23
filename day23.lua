require 'lpeg'
setmetatable(_ENV, { __index=lpeg})

spc = S(" \t\n")^0
opcode = C(P"jio" + P"inc" + P"tpl" + P"jmp" + P"jie" + P"hlf")
register = C(S"ab")
num = C(S"+-"^0 * R('09')^1) / tonumber * spc

instruction = (opcode * spc * (register + num) * (P"," * spc * (register + num))^0) /
    function(op, arg1, arg2)
        return { opcode = op,
                 arg1 = arg1,
                 arg2 = arg2 }
    end

local f = io.open("23-data.txt")
program = {}
for line in f:lines() do
    local i = instruction:match(line)
    if i then table.insert(program, i)
    else print(line) end
end
f:close()



function run(program, state)
    local pc = 1

    while program[pc] do
        local i = program[pc]

        if i.opcode == 'jmp' then
            pc = pc + i.arg1
        elseif i.opcode == 'jie' then
            if state[i.arg1] % 2 == 0 then
                pc = pc + i.arg2
            else
                pc = pc + 1
            end
        elseif i.opcode == 'jio' then
            if state[i.arg1] == 1 then
                pc = pc + i.arg2
            else
                pc = pc + 1
            end
        elseif i.opcode == 'hlf' then
            state[i.arg1] = math.floor(state[i.arg1] / 2)
            pc = pc + 1
        elseif i.opcode == 'tpl' then
            state[i.arg1] = state[i.arg1] * 3
            pc = pc + 1
        elseif i.opcode == 'inc' then
            state[i.arg1] = state[i.arg1] + 1
            pc = pc + 1
        end
    end

    return state
end

part1 = run(program, {a=0, b=0})
print("Part 1:", part1.b)

part2 = run(program, {a=1, b=0})
print("Part 2:", part2.b)
