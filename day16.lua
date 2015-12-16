require 'lpeg'
setmetatable(_ENV, { __index=lpeg})

spc = S(" \t\n")^0
key = C(R('az')^1) * spc
num = C(R('09')^1) / tonumber * spc

kv = (key * P(":") * spc * num)
props = (kv * P(",")^-1 * spc)^0 /
    function(...)
        local t = {}
        local kvs = {...}
        for i=1, #kvs, 2 do
            t[kvs[i]] = kvs[i+1]
        end
        return t
    end

sue = P("Sue") * spc * num * P(":") * spc * props

sues = {}

file = io.open("./16-data.txt")
for line in file:lines() do
    local num, props = sue:match(line)

    if num then sues[num] = props end
end

file:close()

function sue_match(sue, props)
    for k,v in pairs(sue) do
        if props[k] ~= v then return false end
    end

    return true
end

function part2_match(sue, props)
    for k,v in pairs(sue) do
        if k == 'cats' or k == 'trees' then
            if v <= props[k] then return false end
        elseif k == 'pomeranians' or k == 'goldfish' then
            if v >= props[k] then return false end
        else
            if props[k] ~= v then return false end
        end
    end
    return true
end

for id, p in pairs(sues) do
    if sue_match(p, {
                     children=3,
                     cats=7,
                     samoyeds=2,
                     pomeranians=3,
                     akitas=0,
                     vizslas=0,
                     goldfish=5,
                     trees=3,
                     cars=2,
                     perfumes=1
                }) then
        print("Part 1:", id)
        break
    end
end

for id, p in pairs(sues) do
    if part2_match(p, {
                       children=3,
                       cats=7,
                       samoyeds=2,
                       pomeranians=3,
                       akitas=0,
                       vizslas=0,
                       goldfish=5,
                       trees=3,
                       cars=2,
                       perfumes=1
    }) then
        print("Part 2:", id)
        break
    end
end
