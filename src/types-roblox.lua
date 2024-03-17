local TeardownFn = require('./types-teardown-fn')

type TeardownFn = TeardownFn.TeardownFn

export type Teardown = TeardownFn | Instance | RBXScriptConnection | { Teardown } | thread | nil

return nil
