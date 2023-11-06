# luau-teardown

A utility package to clean up resources.

# Installation

Add `luau-teardown` in your dev-dependencies:

```bash
yarn add luau-teardown
```

Or if you are using `npm`:

```bash
npm install luau-teardown
```

# Teardown type

It is important to understand what a `Teardown` object is first, since this library operates on this type.

A `Teardown` object can be multiple things:

- A function that takes no arguments and returns nothing (a value of type `() -> ()`)
- An array of `Teardown` objects
- a `nil` value

When the global `LUA_ENV` is equal to `"roblox"`, a `Teardown` object can also be:

- An `RBXScriptConnection`, which is what returned by calling `Connect` on `Event`s
- An `Instance`

This type is accessible by writing:

```lua
local Teardown = require("@pkg/teardown")
type Teardown = Teardown.Teardown
```

# API

## `teardown`

The `teardown` function takes any amount of `Teardown` objects and cleans them:

- For functions: calls the function
- For `RBXScriptConnection`: disconnects the connection
- For `Instance`: calls `Destroy()` on the instance
- An array of `Teardown` objects: teardowns all Teardown elements
- a `nil` value: does nothing

For example, if you want to disconnect an array of connections

```lua
local connections = {}

for _, button in buttons do
	table.insert(connections, button.Activated:Connect(function() --[[ ... ]] end))
end

-- ... later, if we want to clean up all the connections

Teardown.teardown(connections)
```

## `join`

Creates a single `Teardown` object from all the given `Teardown` objects.

```lua
local interface: Instance = createInterfaceInstance()
local connections = connectEvents(interface)

local function customCleanup()
	-- do some custom clean up logic here
end

-- `join` will group all these Teardown objects into a single one
local joined = Teardown.join(connections, interface, customCleanup)

-- then, when we're ready we can clean connections, interface and
-- customCleanup at the same time with
Teardown.teardown(joined)
```
