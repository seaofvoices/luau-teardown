local teardown = require('./teardown')

type Teardown = teardown.Teardown

local function join(...: Teardown): Teardown
    local packed = table.pack(...)
    local function teardownAll()
        teardown(table.unpack(packed, 1, packed.n))
    end
    return teardownAll
end

return join
