local typeof = require('./typeof')
local types = require('./types')

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
        elseif _G.LUA_ENV == 'roblox' then
            if elementType == 'userdata' then
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
            elseif elementType == 'thread' then
                task.cancel(element)
            else
                warn('unable to teardown value of type `' .. elementType .. '`')
            end
        else
            warn('unable to teardown value of type `' .. elementType .. '`')
        end
    end
end

return teardown
