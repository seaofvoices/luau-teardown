local jestGlobals = require('@pkg/jest-globals')
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

        expect(mock).never.toHaveBeenCalled(0)
    end)
end

return nil
