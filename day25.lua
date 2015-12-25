--[[
    Okay, let's try to be clever about this.
    If we can figure out what order the cell (3029, 2947) is in, then
    we can just repeat the function that many times and get the answer.
    For each cell in a given diagonal, the sum of x and y coordinates
    will be the same. We know that this sum for (3029, 2947) is 5976.
    Therefore, the row number of column 1 of that diagonal is 5975.
    Column 1 is a fairly simple sequence:
]]

function col1(n)
    return (n * (n-1)) / 2 + 1
end

--[[
    So, we know that the cell we're looking for is in column 3029,
    therefore it's that col1(5975) + 3028.
]]

function cell_val(x,y)
    return col1(x+y-1) + x - 1
end

local num = cell_val(3029, 2947)

--[[
    Now for the computationally-heavy part of this. We need to,
    starting with 20151125, do this a bunch of times, a little
    over 17 million:
]]

function next_key(key)
    return (key * 252533) % 33554393
end

local key = 20151125
for n=2, num do
    key = next_key(key)
end

print(key)
