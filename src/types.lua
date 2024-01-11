if _G.LUA_ENV == 'roblox' then
    local types = require('./types-roblox')
    export type Teardown = types.Teardown
    return nil
end

local TeardownFn = require('./types-teardown-fn')

type TeardownFn = TeardownFn.TeardownFn

export type Teardown = TeardownFn | { Teardown } | nil

return nil
