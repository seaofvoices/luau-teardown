[![checks](https://github.com/seaofvoices/luau-teardown/actions/workflows/test.yml/badge.svg)](https://github.com/seaofvoices/luau-teardown/actions/workflows/test.yml)
![version](https://img.shields.io/github/package-json/v/seaofvoices/luau-teardown)
[![GitHub top language](https://img.shields.io/github/languages/top/seaofvoices/luau-teardown)](https://github.com/luau-lang/luau)
![license](https://img.shields.io/npm/l/luau-teardown)
![npm](https://img.shields.io/npm/dt/luau-teardown)

# luau-teardown

A utility package to clean up resources.

# Installation

Add `luau-teardown` in your dependencies:

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
- A `thread`, which is usually created using the [task library](https://create.roblox.com/docs/reference/engine/libraries/task)

When the global `LUA_ENV` is equal to `"roblox"`, a `Teardown` object can also be:

- A `RBXScriptConnection`, which is what returned by calling `Connect` on `Event`s
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
- a `thread` value: calls `task.cancel` with the thread
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

## `fn`

Creates a function that will teardown all the given `Teardown` objects.

```lua
local cleanUp = Teardown.fn(connections, thread)

-- ...

cleanUp() -- teardown all the previously passed objects
```

This function can be useful with [React](https://github.com/jsdotlua/react-lua) `useEffect` hooks:

```lua
useEffect(function()
	return Teardown.fn(
		task.spawn(function()
			-- ... do something
		end)
	)
end)
```
