map = {}
f = io.open('18-data.txt')

local c = f:read(1)
local n = 0
while c do
    if c == '.' then map[n] = false; n = n+1
    elseif c == '#' then map[n] = true; n = n+1 end
    c = f:read(1)
end
f:close()

function life(map)
    local new = {}

    for y=0, 99 do
        for x=0, 99 do
            local count = 0

            if x > 0 and map[(x-1) + y*100] then count = count + 1 end
            if x < 99 and map[(x+1) + y*100] then count = count + 1 end
            if y > 0 and map[x + (y-1)*100] then count = count + 1 end
            if y < 99 and map[x + (y+1)*100] then count = count + 1 end
            if x > 0 and y > 0 and map[(x-1) + (y-1)*100] then count = count + 1 end
            if x > 0 and y < 99 and map[(x-1) + (y+1)*100] then count = count + 1 end
            if x < 99 and y > 0 and map[(x+1) + (y-1)*100] then count = count + 1 end
            if x < 99 and y < 99 and map[(x+1) + (y+1)*100] then count = count + 1 end

            if map[x+y*100] then
                new[x+y*100] = (count == 2 or count == 3)
            else
                new[x+y*100] = (count == 3)
            end
        end
    end

    return new
end

function stuck(map)
    local new = {}
    for n=0,9999 do
        new[n] = map[n]
    end

    new[0] = true
    new[99] = true
    new[0+100*99] = true
    new[99+100*99] = true
    return new
end

function population(map)
    local p = 0
    for n=0,9999 do
        if map[n] then p = p+1 end
    end
    return p
end

local current = map
for n=1,100 do
    current = life(current)
end

print("Part 1:", population(current))

local current = stuck(map)
for n=1,100 do
    current = stuck(life(current))
end

print("Part 2:", population(current))
