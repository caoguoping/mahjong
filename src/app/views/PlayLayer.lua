local CURRENT_MODULE_NAME = ...

local DataMgr     = import(".DataManager"):getInstance()
local LayerMgr = import(".LayerManager"):getInstance()

local PlayLayer = class("PlayLayer", display.newLayer)


function PlayLayer:ctor()
    local rootNode = cc.CSLoader:createNode("playScene.csb"):addTo(self)
    self.rootNode = rootNode
    local btnClose = rootNode:getChildByName("Button_Close")
    btnClose:onClicked(
        function ()
        LayerMgr:showLayer(LayerMgr.Enum.MainLayer, params)
        TTSocketClient:getInstance():closeMySocket(girl.SocketType.Game)
        end)

end
  
function PlayLayer.create()
    return PlayLayer.new()
end

function PlayLayer:refresh(params)
    
end


return PlayLayer
