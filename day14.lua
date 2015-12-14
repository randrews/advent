deer = {}

local file = io.open("14-data.txt")
for line in file:lines() do
    local name, speed, con, rest = line:match("(%w+) can fly (%d+) km/s for (%d+) seconds, but then must rest for (%d+)")
    if name then
        table.insert(deer, {
                         name = name,
                         speed = tonumber(speed),
                         con = tonumber(con),
                         rest = tonumber(rest),
                         state = 'flying',
                         remaining = tonumber(con),
                         distance = 0,
                         points = 0
        })
    end
end

function tick(deer)
    local maxdistance = 0

    for _, d in ipairs(deer) do
        if d.state == 'flying' then
            d.distance = d.distance + d.speed
            d.remaining = d.remaining - 1
            if d.remaining == 0 then
                d.state = 'resting'
                d.remaining = d.rest
            end
        else
            d.remaining = d.remaining - 1
            if d.remaining == 0 then
                d.state = 'flying'
                d.remaining = d.con
            end
        end
        maxdistance = math.max(maxdistance, d.distance)
    end

    for _,d in ipairs(deer) do
        if d.distance == maxdistance then
            d.points = d.points + 1
        end
    end
end

function race(deer, time)
    local times = {}

    for _, d in ipairs(deer) do
        local cycles = math.floor(time / (d.con + d.rest))
        local last = math.min(d.con, time % (d.con + d.rest))

        times[d.name] = d.speed * d.con * cycles + d.speed * last
    end

    return times
end

times = race(deer, 2503)
local max = 0; for _,v in pairs(times) do max = math.max(max, v) end

print("Part 1:", max)

for n = 1, 2503 do tick(deer) end

local maxpoints = 0
for _,d in ipairs(deer) do maxpoints = math.max(maxpoints, d.points) end

print("Part 2:", maxpoints)
