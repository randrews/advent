local file = io.open("15-data.txt")
pantry = {}
names = {}
recipe = {}
for line in file:lines() do
    local name, cap, dur, fla, tex, cal =
        line:match("(%w+): capacity ([%d%-]+), durability ([%d%-]+), flavor ([%d%-]+), texture ([%d%-]+), calories ([%d%-]+)")

    if name then
        table.insert(names, name)
        recipe[name] = 1
        pantry[name]={name,
                      cap = tonumber(cap),
                      dur = tonumber(dur),
                      fla = tonumber(fla),
                      tex = tonumber(tex),
                      cal = tonumber(cal)}
    else print(line) end
end
file:close()

function dup(table)
    local copy = {}
    for k,v in pairs(table) do copy[k] = v end
    return copy
end

function value(recipe)
    local cap = 0
    local dur = 0
    local fla = 0
    local tex = 0

    for name, amt in pairs(recipe) do
        local ing = pantry[name]
        cap = cap + amt*ing.cap
        dur = dur + amt*ing.dur
        fla = fla + amt*ing.fla
        tex = tex + amt*ing.tex
    end

    if cap <= 0 or dur <= 0 or fla <= 0 or tex <= 0 then
        return 0
    else
        return cap * dur * fla * tex
    end
end

function improve(recipe)
    local orig = value(recipe)
    local best = nil
    local best_del = nil

    for _, name in ipairs(names) do
        local r = dup(recipe)
        r[name] = r[name] + 1
        local delta = value(r) - orig
        if not best or best_del < delta then
            best = r
            best_del = delta
        end
    end

    return best
end

function calories(recipe)
    local cal = 0
    for name, amt in pairs(recipe) do
        cal = cal + amt * pantry[name].cal
    end

    return cal
end

function find_best()
    local partitions = {}
    for n=1, #names-1 do partitions[n] = n end

    local function recipe_for_parts()
        local r = {}
        for i=1, #partitions do
            local name = names[i]
            local p = partitions[i]
            if i > 1 then p = p - partitions[i-1] end
            r[names[i]] = p
        end
        r[names[#names]] = 100 - partitions[#partitions]

        return r
    end

    local best = nil
    local best_value = nil

    while partitions[1] ~= 100 - #names + 1 do
        local r = recipe_for_parts(partitions)
        if calories(r) == 500 then
            local v = value(r)
            if not best or best_value < v then
                best = r
                best_value = v
            end
        end

        if partitions[#partitions] < 99 then
            partitions[#partitions] = partitions[#partitions] + 1
        else
            local movable = nil
            local max = 99
            for i=#partitions, 1, -1 do
                if partitions[i] < max then movable = i; break end
                max = max - 1
            end

            partitions[movable] = partitions[movable] + 1
            local curr = partitions[movable]
            for i=movable+1, #partitions do
                partitions[i] = curr + 1
                curr = curr + 1
            end
        end
    end

    return best_value
end

r = recipe
for n = #names+1, 100 do
    r = improve(r)
end

print("Part 1:", value(r))

print("Part 2:", find_best())
