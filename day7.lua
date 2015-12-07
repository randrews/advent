require 'lpeg'
setmetatable(_ENV, { __index=lpeg})

signals = {}
cache = {}

spc = S(" \t\n")^0
signal = C(R('az')^1) * spc
value = C(R('09')^1) / tonumber * spc

function parse_boolean_op(signal1, operator, signal2)
    return { type = "boolean",
             operator = operator,
             signal1 = signal1,
             signal2 = signal2 }
end

function parse_shift(signal, operator, value)
    return { type = "shift",
             signal = signal,
             operator = operator,
             value = value }
end

function parse_complement(signal)
    return { type = "complement",
             signal = signal }
end

function parse_literal(value)
    return { type = "literal",
             value = value }
end

function parse_mirror(signal)
    return { type = "mirror",
             signal = signal }
end

function add_definition(def, target)
    signals[target] = def
end

boolean_op = ( (signal + value) * C(P("AND") + P("OR")) * spc * (signal + value) ) / parse_boolean_op
shift = ( signal * C(P("LSHIFT")+P("RSHIFT")) * spc * value ) / parse_shift
complement = ( P("NOT") * spc * signal ) / parse_complement
literal = ( value ) / parse_literal
mirror = ( signal ) / parse_mirror
definition = ((boolean_op + shift + complement + literal + mirror) * spc * "->" * spc * C(signal)) / add_definition

function eval_signal(signal)
    local result = nil
    if type(signal) == 'number' then
        return signal
    elseif cache[signal] then
        return cache[signal]
    else
        local def = signals[signal]

        if not def then
            error("Undefined signal " .. signal)
        end

        if def.type == 'literal' then
            result = def.value

        elseif def.type == 'mirror' then
            result = eval_signal(def.signal)

        elseif def.type == 'complement' then
            result = ~(eval_signal(def.signal))

        elseif def.type == 'shift' then
            if def.operator == 'LSHIFT' then
                result = eval_signal(def.signal) << def.value
            else
                result = eval_signal(def.signal) >> def.value
            end

        elseif def.type == 'boolean' then
            local sig1 = eval_signal(def.signal1)
            local sig2 = eval_signal(def.signal2)
            
            if def.operator == 'AND' then
                result = sig1 & sig2
            elseif def.operator == 'OR' then
                result = sig1 | sig2
            end
        end
    end

    if result then
        cache[signal] = result
        return result
    else
        error(string.format("Unrecognized signal definition for %s: %s", signal, inspect(signals[signal])))
    end
end

local f = io.open("7-data.txt")

for line in f:lines() do
    if not definition:match(line) then
        print("Couldn't parse line:", line)
    end
end

part1 = eval_signal('a')
print("Part 1:", part1)
cache = {}
definition:match(part1 .. " -> b")
print("Part 2:", eval_signal('a'))
