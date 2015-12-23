boss = {hp = 55,
        damage = 8}

function new_state(hard)
    return {
        boss_hp = 55,
        boss_damage = 8,
        hp = 50,
        armor = 0,
        mana = 500,
        spent = 0,
        shield_counter = 0,
        poison_counter = 0,
        recharge_counter = 0,
        hard = hard
    }
end

function copy(obj)
    local new = {}
    for k,v in pairs(obj) do new[k]=v end
    return new
end

function magic_missile(state)
    state = copy(state)
    state.mana = state.mana - 53
    state.spent = state.spent + 53
    state.boss_hp = state.boss_hp - 4
    return state
end

function drain(state)
    state = copy(state)
    state.mana = state.mana - 73
    state.spent = state.spent + 73
    state.boss_hp = state.boss_hp - 2
    state.hp = state.hp + 2
    return state
end

function shield(state)
    state = copy(state)
    state.mana = state.mana - 113
    state.spent = state.spent + 113
    state.shield_counter = 6
    return state
end

function poison(state)
    state = copy(state)
    state.mana = state.mana - 173
    state.spent = state.spent + 173
    state.poison_counter = 6
    return state
end

function recharge(state)
    state = copy(state)
    state.mana = state.mana - 229
    state.spent = state.spent + 229
    state.recharge_counter = 5
    return state
end

function start_turn(state, whose)
    if whose == 'player' and state.hard then
        state.hp = state.hp - 1
        if state.hp <= 0 then return end
    end

    if state.shield_counter == 1 then
        state.armor = state.armor - 7
        state.shield_counter = 0
    elseif state.shield_counter > 0 then
        state.shield_counter = state.shield_counter - 1
        state.armor = 7
    end

    if state.poison_counter > 0 then
        state.boss_hp = state.boss_hp - 3
        state.poison_counter = state.poison_counter - 1
    end

    if state.recharge_counter > 0 then
        state.mana = state.mana + 101
        state.recharge_counter = state.recharge_counter - 1
    end
end

function boss_turn(state)
    if state.boss_damage <= state.armor then
        state.hp = state.hp - 1
    else
        state.hp = state.hp - (state.boss_damage - state.armor)
    end
end

function player_turn(state)
    -- First, handle start-of-turn stuff:
    start_turn(state, 'player')
    if state.hp <= 0 then return end -- Dead, bail

    -- Then, assemble a list of possible spells:
    local spells = {}

    if state.mana >= 53 then table.insert(spells, magic_missile) end
    if state.mana >= 73 then table.insert(spells, drain) end
    if state.mana >= 113 and state.shield_counter <= 0 then table.insert(spells, shield) end
    if state.mana >= 173 and state.poison_counter == 0 then table.insert(spells, poison) end
    if state.mana >= 229 and state.recharge_counter == 0 then table.insert(spells, recharge) end

    if #spells == 0 then return end -- We lost, bail.

    for _, spell in ipairs(spells) do
        local next_state = spell(state)
        if next_state.boss_hp <= 0 then -- We won!
            best_mana = math.min(best_mana, next_state.spent)
        else -- Not over yet:
            if next_state.spent >= best_mana then return end -- We're already past the best score
            start_turn(next_state, 'boss')
            boss_turn(next_state)
            if next_state.hp <= 0 then return end -- We died
            player_turn(next_state)
        end
    end
end

best_mana = math.huge
player_turn(new_state())

print("Part 1:", best_mana)

best_mana = math.huge
player_turn(new_state(true))

print("Part 2:", best_mana)
