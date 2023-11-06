local TeardownFn = require('./types-teardown-fn')

type TeardownFn = TeardownFn.TeardownFn

export type Teardown = TeardownFn | { Teardown } | nil

return nil
