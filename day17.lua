f = io.open('17-data.txt')
containers = {}
for line in f:lines() do
    table.insert(containers, tonumber(line))
end
f:close()

function combinations(size, containers, used_count)
    local count = 0
    local min_used = math.huge

    for n = 1, 2^#containers do
        local total = 0
        local used = 0
        for b = 0, #containers-1 do
            if n & 2^b > 0 then
                used = used + 1
                total = total + containers[b+1]
            end
        end
        if total == size and (not used_count or used == used_count) then
            count = count + 1
            min_used = math.min(used, min_used)
        end
    end

    return count, min_used
end

count, min_used = combinations(150, containers)
print("Part 1:", count)

part2, _ = combinations(150, containers, min_used)
print("Part 2:", part2)
