require 'lpeg'
setmetatable(_ENV, { __index=lpeg})

lights = {}
lights2 = {}
for n = 1, 1000000 do
    lights[n] = false
    lights2[n] = 0
end

spc = S(" \t\n")^0
op = C( P("turn on") + P("turn off") + P("toggle") )
coord = (C(R('09')^1)/tonumber) * "," * (C(R('09')^1)/tonumber)

function docommand(operation, x1, y1, x2, y2)
    for y = y1, y2 do
        for x = x1, x2 do
            local n = x + 1000 * y
            if operation == "turn on" then
                lights[n] = true
            elseif operation == "turn off" then
                lights[n] = false
            elseif operation == "toggle" then
                lights[n] = not lights[n]
            end
        end
    end
end

function docommand2(operation, x1, y1, x2, y2)
    for y = y1, y2 do
        for x = x1, x2 do
            local n = x + 1000 * y
            if operation == "turn on" then
                lights2[n] = lights2[n] + 1
            elseif operation == "turn off" then
                lights2[n] = math.max(lights2[n] - 1, 0)
            elseif operation == "toggle" then
                lights2[n] = lights2[n] + 2
            end
        end
    end
end

cmd = op * spc * coord * spc * "through" * spc * coord
part1_cmd = cmd / docommand
part2_cmd = cmd / docommand2

local f = io.open("6-data.txt")

for line in f:lines() do
    part1_cmd:match(line)
    part2_cmd:match(line)
end

part1 = 0
part2 = 0

for n=1, 1000000 do
    if lights[n] then part1 = part1+1 end
    part2 = part2+lights2[n]
end

print("Part 1:", part1)
print("Part 2:", part2)
