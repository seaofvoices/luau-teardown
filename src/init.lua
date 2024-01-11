local TeardownFn = require('./types-teardown-fn')
local createFn = require('./createFn')
local join = require('./join')
local teardown = require('./teardown')
local types = require('./types')

export type TeardownFn = TeardownFn.TeardownFn

export type Teardown = types.Teardown

local Teardown = {
    fn = createFn,
    teardown = teardown,
    join = join,
}

return Teardown
