-- Day 19

replacements = {}
medicine = nil

local f = io.open('19-data.txt')
for line in f:lines() do
    local start, replace = line:match("(%w+) => (%w+)")

    if start then
        table.insert(replacements, {start, replace})
    elseif line:match("%w") then
        medicine = line
    end
end
f:close()

function count_instances(needle, haystack)
    local n = 0

    for _ in haystack:gmatch(needle) do
        n = n + 1
    end

    return n
end

function generate(medicine, replacements)
    local products = {}
    local products_arr = {}
    for _, replacement in ipairs(replacements) do
        local first, last
        while true do
            first, last = medicine:find(replacement[1], last or 1, true)
            if first then
                local a = medicine:sub(1, first-1)
                local b = replacement[2]
                local c = medicine:sub(last+1, #medicine)
                local str = string.format("%s%s%s",a,b,c)

                if not products[str] then
                    table.insert(products_arr, str)
                end

                products[str] = true
                last = last + 1
            else break end
        end
    end
    return products, products_arr
end

function part1()
    local n=0
    for k,_ in pairs(generate(medicine, replacements)) do n = n + 1 end
    return n
end

print("Part 1:", part1())

function part2(start, goal, rules)
    local finish_forms = {}
    for _,rule in ipairs(rules) do
        if rule[2] == goal then finish_forms[rule[1]] = true end
    end

    local final_steps = nil

    local function f(molecule, step)
        if finish_forms[molecule] then
            final_steps = step
            error()
        end

        local _, strs = generate(molecule, rules)
        for _, str in ipairs(strs) do
            f(str, step + 1)
        end
    end

    local err = pcall(f,start, 1)
    return final_steps
end

local rules = {
    {"CRnFYFYFAr", "H"},
    {"CRnFYMgAr", "H"},
    {"CRnMgYFAr", "H"},
    {"SiRnFYFAr", "Ca"},
    {"SiRnMgAr", "Ca"},
    {"NRnFYFAr", "H"},
    {"CRnFYFAr", "O"},
    {"TiRnFAr", "B"},
    {"CRnAlAr", "H"},
    {"ThRnFAr", "Al"},
    {"CRnMgAr", "O"},
    {"SiRnFAr", "P"},
    {"NRnMgAr", "H"},
    {"NRnFAr", "O"},
    {"CRnFAr", "N"},
    {"PRnFAr", "Ca"},
    {"ORnFAr", "H"},
    {"TiTi", "Ti"},
    {"ThCa", "Th"},
    {"CaSi", "Si"},
    {"SiTh", "Ca"},
    {"CaCa", "Ca"},
    {"TiMg", "Mg"},
    {"SiAl", "F"},
    {"OTi", "O"},
    {"TiB", "B"},
    {"HSi", "N"},
    {"PMg", "F"},
    {"HCa", "H"},
    {"BCa", "B"},
    {"CaP", "P"},
    {"PTi", "P"},
    {"ThF", "Al"},
    {"NTh", "H"},
    {"CaF", "F"},
    {"PB", "Ca"},
    {"HP", "O"},
    {"BF", "Mg"},
    {"OB", "H"},
    {"BP", "Ti"},
    {"HF", "e"},
    {"NAl", "e"},
    {"OMg", "e"}
}

-- rules = {}
-- for _, rule in ipairs(replacements) do
--     table.insert(rules, {rule[2], rule[1]})
-- end
-- table.sort(rules, function(a,b) return #a[1] > #b[1] end)

print("Part 2:", part2(medicine, 'e', rules))
