input = "hepxcrrq"

next_letter = {
    a='b',
    b='c',
    c='d',
    d='e',
    e='f',
    f='g',
    g='h',
    h='j',
    j='k',
    k='m',
    m='n',
    n='p',
    p='q',
    q='r',
    r='s',
    s='t',
    t='u',
    u='v',
    v='w',
    w='x',
    x='y',
    y='z',
    z='a'}

function succ(str)
    local s = ""
    local i = #str
    local carry = true

    while carry do
        local c = str:sub(i,i)
        s = next_letter[c] .. s
        carry = (c == 'z')
        i = i - 1
    end

    return str:sub(1, #str-#s) .. s
end

function valid(str)
    if str:match("[iol]") then return false end
    if not str:match("(.)%1.*(.)%2") then return false end
    local bytes = {str:byte(1,#str)}

    for i=1, #bytes-2 do
        if bytes[i+1] == bytes[i]+1 and bytes[i+2] == bytes[i]+2 then
            return true
        end
    end

    return false
end

part1 = input
while not valid(part1) do
    part1 = succ(part1)
end

part2 = succ(part1)
while not valid(part2) do
    part2 = succ(part2)
end

print("Part 1:", part1)
print("Part 2:", part2)
