local typeof = require('./typeof')
local types = require('./types')

local cancelThread = if _G.LUA_ENV == 'roblox'
    then task.cancel
    elseif _G.LUA_ENV == 'lune' then (require)('@lune/task').cancel
    else nil

type Teardown = types.Teardown

local function teardown(...: Teardown)
    for i = 1, select('#', ...) do
        local element = select(i, ...)
        local elementType = type(element)

        if element == nil then
            -- nothing to do!
        elseif elementType == 'function' then
            element()
        elseif elementType == 'table' then
            for _, subElement in element do
                teardown(subElement)
            end
        elseif cancelThread ~= nil and elementType == 'thread' then
            cancelThread(element)
        elseif _G.LUA_ENV == 'roblox' and elementType == 'userdata' then
            local typeofType = typeof(element)
            if typeofType == 'RBXScriptConnection' then
                if element.Connected then
                    element:Disconnect()
                end
            elseif typeofType == 'Instance' then
                element:Destroy()
            else
                warn('unable to teardown value of type `' .. typeofType .. '`')
            end
        else
            warn('unable to teardown value of type `' .. elementType .. '`')
        end
    end
end

return teardown
