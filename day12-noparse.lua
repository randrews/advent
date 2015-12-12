file = io.open('12-data.txt')
input = file:read("*a")
file:close()

function sum_str(str)
    local sum = 0
    for num in str:gmatch("([-]?%d+)") do
        sum = sum + tonumber(num)
    end
    return sum
end

function cut_red(str)
    local left, right = str:find(":\"red\"")
    local left_brace = nil
    local right_brace = nil
    local stack = 0

    for i=left, 1, -1 do
        local c = str:sub(i,i)
        if c == "}" then stack = stack + 1
        elseif c == "{" and stack > 0 then stack = stack - 1
        elseif c == "{" and stack == 0 then
            left_brace = i
            break
        end
    end

    stack = 0
    for i=right, #str do
        local c = str:sub(i,i)
        if c == "{" then stack = stack + 1
        elseif c == "}" and stack > 0 then stack = stack - 1
        elseif c == "}" and stack == 0 then
            right_brace = i
            break
        end
    end

    local new_str = str:sub(1, left_brace) .. str:sub(right_brace, #str)
    if new_str:find(":\"red\"") then return cut_red(new_str)
    else return new_str end
end

print("Part 1:", sum_str(input))
print("Part 2:", sum_str(cut_red(input)))
