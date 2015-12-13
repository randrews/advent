deltas = {}

local file = io.open('13-data.txt')
for line in file:lines() do
    local a, gl, n, b = line:match("(%w+) would (%w+) (%d+) happiness units by sitting next to (%w+)")

    if a then
        if not deltas[a] then deltas[a] = {} end
        if gl == 'lose' then n = -tonumber(n) else n = tonumber(n) end
        deltas[a][b] = n
    end
end

people = {}
for k,_ in pairs(deltas) do table.insert(people,k) end

function contains(haystack, needle)
    for _,v in ipairs(haystack) do
        if needle == v then return true end
    end
end

function permutations(arr)
    local p = {}

    local function inner(visited, current)
        if #visited == #arr then
            table.insert(p, visited)
        else
            for _, el in ipairs(arr) do
                if not contains(visited, el) then
                    local new = {table.unpack(visited)}
                    table.insert(new, el)
                    inner(new, el)
                end
            end
        end
    end

    for i=1, #arr do
        inner({arr[i]}, arr[i])
    end

    return p
end

function happiness(arrangement)
    local total = 0
    for i=1, #arrangement do
        local left = i-1
        local right = i+1
        if left < 1 then left = #arrangement end
        if right > #arrangement then right = 1 end

        
        total = total + (deltas[arrangement[i]][arrangement[left]] or 0)
            + (deltas[arrangement[i]][arrangement[right]] or 0)
    end
    return total
end

local best = nil
for _, p in ipairs(permutations(people)) do
    if not best then best = happiness(p)
    else best = math.max(best, happiness(p)) end
end

print("Part 1:", best)

table.insert(people, "me")
deltas.me = {}

local part2 = nil
for _, p in ipairs(permutations(people)) do
    if not part2 then part2 = happiness(p)
    else part2 = math.max(part2, happiness(p)) end
end

print("Part 2:", part2)
