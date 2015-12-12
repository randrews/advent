json = require 'json'

file = io.open('12-data.txt')
input = file:read("*a")
file:close()

sum = 0
for num in input:gmatch("([-]?%d+)") do
    sum = sum + tonumber(num)
end

print("Part 1:", sum)

obj = json:decode(input)

function has_red(obj)
    local red = false
    local str = false
    for k,v in pairs(obj) do
        if type(k) == 'string' then str = true end
        if v == 'red' then red = true end
    end
    return str and red
end

function sum_obj(obj)
    local sum = 0
    if has_red(obj) then return 0
    else
        for k,v in pairs(obj) do
            if type(v) == 'number' then
                sum = sum + v
            elseif type(v) == 'table' then
                sum = sum + sum_obj(v)
            end
        end
    end

    return sum
end

part2 = sum_obj(obj)

print("Part 2:", part2)
