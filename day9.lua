graph = {}

function parse_line(line, graph)
    local from, to, dist = line:match("(%w+) to (%w+) = (%d+)")

    if from then
        graph[from] = graph[from] or {}
        graph[to] = graph[to] or {}
        graph[from][to] = tonumber(dist)
        graph[to][from] = tonumber(dist)
    end
end

local f = io.open("9-data.txt")

for line in f:lines() do
    parse_line(line, graph)
end

function contains(haystack, needle)
    for _,v in ipairs(haystack) do
        if needle == v then return true end
    end
end

function walk(graph, initial, compare)
    local function inner(current, visited, total)
        local best = nil
        local best_node = nil

        for node, dist in pairs(graph[current]) do
            if not contains(visited, node) then
                local new = inner(node, {current, table.unpack(visited)}, dist)
                if not best or compare(best, new) then
                    best_node = node
                    best = new
                end
            end
        end

        if best_node then
            return total + best
        else
            return total
        end
    end

    return inner(initial, {}, 0)
end

local shortest = math.huge
local longest = 0

for node, _ in pairs(graph) do
    shortest = math.min(shortest, walk(graph, node, function(a,b) return b<a end))
    longest = math.max(longest, walk(graph, node, function(a,b) return b>a end))
end

print("Part 1: ", shortest)
print("Part 2: ", longest)
