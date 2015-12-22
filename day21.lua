boss = {hp = 103,
        damage = 9,
        armor = 2}

weapons = {
    { cost = 8, damage = 4 },
    { cost = 10, damage = 5 },
    { cost = 25, damage = 6 },
    { cost = 40, damage = 7 },
    { cost = 74, damage = 8 }
}

armor = {
    { cost = 0, armor = 0 },
    { cost = 13, armor = 1 },
    { cost = 31, armor = 2 },
    { cost = 53, armor = 3 },
    { cost = 75, armor = 4 },
    { cost = 102, armor = 5 }
}

rings = {
    {cost = 0, damage = 0, armor = 0},
    {cost = 0, damage = 0, armor = 0},
    {cost = 25, damage = 1, armor = 0},
    {cost = 50, damage = 2, armor = 0},
    {cost = 100, damage = 3, armor = 0},
    {cost = 20, damage = 0, armor = 1},
    {cost = 40, damage = 0, armor = 2},
    {cost = 80, damage = 0, armor = 3},
}

function stats(weapon, armor, ring1, ring2)
    return {
        hp = 100,
        cost = weapon.cost + armor.cost + ring1.cost + ring2.cost,
        damage = weapon.damage + ring1.damage + ring2.damage,
        armor = armor.armor + ring1.armor + ring2.armor
    }
end

function winner(player, boss)
    local rounds = math.ceil(player.hp / (math.max(boss.damage-player.armor, 1)))
    return rounds * (math.max(player.damage-boss.armor, 1)) >= boss.hp
end

function try_all(callback)
    for _, w in ipairs(weapons) do
        for _, a in ipairs(armor) do
            for l = 1, #rings do
                for r = l+1, #rings do
                    callback(stats(w,a,rings[l],rings[r]))
                end
            end
        end
    end
end

local best_cost = math.huge

try_all(function(p)
        if p.cost < best_cost and winner(p, boss) then
            best_cost = p.cost
        end end)

print("Part 1:", best_cost)

local worst_cost = 0

try_all(function(p)
        if p.cost > worst_cost and not winner(p, boss) then
            worst_cost = p.cost
        end end)

print("Part 2:", worst_cost)
