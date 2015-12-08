require 'lpeg'
setmetatable(_ENV, { __index=lpeg})

signals = {}
cache = {}

char = (R('09') + R('az')) / function() return 1 end
escape = (P("\\\\") + P("\\\"")) / function() return 1 end
hex = (P("\\") * "x" * char * char) / function() return 1 end
str = (P("\"") * (char + escape + hex)^0 * P("\"")) / function(...) return #{...} end

function wrap(str)
    local buf = ""
    for n = 1, #str do
        local ch = str:sub(n,n)
        if ch == "\"" or ch == "\\" then
            buf = buf .. "\\"
        end

        buf = buf .. ch
    end

    return "\"" .. buf .. "\""
end

local f = io.open("8-data.txt")

total_code = 0
total_chars = 0
total_wrapped = 0

for line in f:lines() do
    chars = str:match(line)
    total_chars = total_chars + chars
    total_code = total_code + #line
    total_wrapped = total_wrapped + #(wrap(line))
end

print("Part 1: ", total_code - total_chars)
print("Part 2: ", total_wrapped - total_code)
