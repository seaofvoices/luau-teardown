local TeardownFn = require('./types-teardown-fn')

export type TeardownFn = TeardownFn.TeardownFn

if _G.LUA_ENV == 'roblox' then
    local types = require('./types-roblox')
    export type Teardown = types.Teardown
else
    local types = require('./types')
    export type Teardown = types.Teardown
end

local Teardown = {
    teardown = require('./teardown'),
    join = require('./join'),
}

return Teardown
