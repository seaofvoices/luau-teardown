local TeardownFn = require('./types-teardown-fn')
local teardown = require('./teardown')
local types = require('./types')

type TeardownFn = TeardownFn.TeardownFn
type Teardown = types.Teardown

local function createFn(...: Teardown): TeardownFn
    local packed = table.pack(...)
    local function teardownFn()
        teardown(table.unpack(packed, 1, packed.n))
    end
    return teardownFn
end

return createFn
