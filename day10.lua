function look_and_say(str)
    local buf = {}
    local current = nil
    for n=1, #str do
        local c = tonumber(str:sub(n,n))
        if current == nil then
            current = {c=c, n=1}
        elseif current.c == c then
            current.n = current.n+1
        else
            table.insert(buf, tostring(current.n) .. tostring(current.c))
            current = {c=c, n=1}
        end
    end

    table.insert(buf, tostring(current.n) .. tostring(current.c))
    return table.concat(buf)
end

start = '3113322113'
str = start
for n=1, 40 do
    str = look_and_say(str)
end

part1 = #str

for n=41, 50 do
    str = look_and_say(str)
end

print("Part 1: ", part1)
print("Part 2: ", #str)
