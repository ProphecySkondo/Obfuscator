local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local b64decode = {}

for i = 1, #b64chars do
    b64decode[string.sub(b64chars, i, i)] = i - 1
end

local function decode(data)
    data = data:gsub("[^" .. b64chars .. "=]", "") -- Remove invalid chars
    local bytes = {}

    data = data:gsub("=", "") -- Strip padding

    for i = 1, #data, 4 do
        local c1 = b64decode[string.sub(data, i, i)] or 0
        local c2 = b64decode[string.sub(data, i + 1, i + 1)] or 0
        local c3 = b64decode[string.sub(data, i + 2, i + 2)] or 0
        local c4 = b64decode[string.sub(data, i + 3, i + 3)] or 0

        local n = bit32.bor(
            bit32.lshift(c1, 18),
            bit32.lshift(c2, 12),
            bit32.lshift(c3, 6),
            c4
        )

        table.insert(bytes, string.char(bit32.band(bit32.rshift(n, 16), 0xFF)))
        if i + 2 <= #data then
            table.insert(bytes, string.char(bit32.band(bit32.rshift(n, 8), 0xFF)))
        end
        if i + 3 <= #data then
            table.insert(bytes, string.char(bit32.band(n, 0xFF)))
        end
    end

    return table.concat(bytes)
end

return decode
