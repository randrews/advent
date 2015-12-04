-- Lua 5.3, natch

local f = io.open("2-data.txt")

function slack(a,b,c)
    if c<a or c<b then
        return slack(b, c, a)
    else
        return a*b
    end
end

function ribbon(a,b,c)
    if c<a or c<b then
        return ribbon(b, c, a)
    else
        return 2*a + 2*b + a*b*c
    end
end

local total = 0
local rib = 0

for line in f:lines() do
    local a, b, c = line:match("(%d+)x(%d+)x(%d+)")
    a = tonumber(a)
    b = tonumber(b)
    c = tonumber(c)

    if a then
        local area = 2*a*b + 2*b*c + 2*a*c + slack(a,b,c)
        total = total + area
        rib = rib + ribbon(a,b,c)
    end
end

print('Paper', total)
print('Ribbon', rib)
