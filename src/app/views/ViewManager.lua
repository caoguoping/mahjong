local CURRENT_MODULE_NAME = ...


local s_inst = nil
local ViewManager = class("ViewManager")

function ViewManager:getInstance()
    if nil == s_inst then
        s_inst = ViewManager.new()
        s_inst.Layers = {}
        s_inst.displayLayer = nil
        s_inst.loginScene = nil
        s_inst.lobbyScene = nil
    end
    return s_inst
end

return ViewManager
