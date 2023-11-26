-- todo: since jest-lua isn't publish on npm yet, the require won't work
-- on CI. Wrapping `require` in parentheses makes the Luau type checker
-- accept the require even if it can't resolve it.
local jestGlobals = (require)('@pkg/jest-globals')
local teardown = require('../teardown')

local expect = jestGlobals.expect
local it = jestGlobals.it
local jest = jestGlobals.jest

it('teardowns a nil value', function()
    expect(function()
        teardown(nil)
    end).never.toThrow()
end)

it('teardowns a function', function()
    local mock, fnMock = jest.fn()
    teardown(fnMock)

    expect(mock).toHaveBeenCalledTimes(1)
end)

it('teardowns an array containing 2 functions', function()
    local mock1, fnMock1 = jest.fn()
    local mock2, fnMock2 = jest.fn()

    teardown({ fnMock1, fnMock2 })

    expect(mock1).toHaveBeenCalledTimes(1)
    expect(mock2).toHaveBeenCalledTimes(1)
end)

if _G.LUA_ENV == 'roblox' then
    it('disconnects an event connection', function()
        local event = Instance.new('BindableEvent')

        local mock, fnMock = jest.fn()

        teardown(event.Event:Connect(fnMock) :: any)

        event:Fire()

        task.wait()

        expect(mock).never.toHaveBeenCalled()
    end)

    it('does not disconnect an already disconnected event connection', function()
        local event = Instance.new('BindableEvent')

        local mock, fnMock = jest.fn()

        local connection = event.Event:Connect(fnMock) :: any

        event:Fire()
        task.wait()

        connection:Disconnect()

        teardown(connection)

        expect(mock).toHaveBeenCalledTimes(1)
    end)
end

return nil
