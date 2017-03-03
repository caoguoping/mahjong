local CURRENT_MODULE_NAME = ...

local DataMgr     = import(".DataManager"):getInstance()
local LayerMgr = import(".LayerManager"):getInstance()

local PlayLayer = class("PlayLayer", display.newLayer)

-- fileNode
local deskBgNode     = nil
local deskUiNode     = nil
local wallMeNode     = nil
local wallLeftNode   = nil
local wallUpNode     = nil
local wallRightNode  = nil
local standMeNode    = nil
local standLeftNode  = nil
local standUpNode    = nil
local standRightNode = nil
local dachuMeNode    = nil
local dachuLeftNode  = nil
local dachuUpNode    = nil
local dachuRightNode = nil
local pengMeNode     = nil
local pengLeftNode   = nil
local pengUpNode     = nil
local pengRightNode  = nil

local wallMeCell = {}
local wallMeCell = {}
local wallMeCell = {}
local wallMeCell = {}

function PlayLayer:ctor()
    local rootNode = cc.CSLoader:createNode("playScene.csb"):addTo(self)
    self.rootNode = rootNode
    deskBgNode     = rootNode:getChildByName("FileNode_deskBg")
    deskUiNode     = rootNode:getChildByName("FileNode_deskUi")
    wallMeNode     = rootNode:getChildByName("FileNode_wallMe")
    wallLeftNode   = rootNode:getChildByName("FileNode_wallLeft")
    wallUpNode     = rootNode:getChildByName("FileNode_wallUp")
    wallRightNode  = rootNode:getChildByName("FileNode_wallRight")
    standMeNode    = rootNode:getChildByName("FileNode_standMe")
    standLeftNode  = rootNode:getChildByName("FileNode_standLeft")
    standUpNode    = rootNode:getChildByName("FileNode_standUp")
    standRightNode = rootNode:getChildByName("FileNode_standRight")
    dachuMeNode    = rootNode:getChildByName("FileNode_dachuMe")
    dachuLeftNode  = rootNode:getChildByName("FileNode_dachuLeft")
    dachuUpNode    = rootNode:getChildByName("FileNode_dachuUp")
    dachuRightNode = rootNode:getChildByName("FileNode_dachuRight")
    pengMeNode     = rootNode:getChildByName("FileNode_pengMe")
    pengLeftNode   = rootNode:getChildByName("FileNode_pengLeft")
    pengUpNode     = rootNode:getChildByName("FileNode_pengUp")
    pengRightNode  = rootNode:getChildByName("FileNode_pengRight")

    self:resetNodeVisible()


--bg
    

--ui
    local btnClose = deskUiNode:getChildByName("Button_Close")
    btnClose:onClicked(
        function ()
        LayerMgr:showLayer(LayerMgr.Enum.MainLayer, params)
        TTSocketClient:getInstance():closeMySocket(girl.SocketType.Game)
        end)

    --wallMe

end
  
function PlayLayer.create()
    return PlayLayer.new()
end

function PlayLayer:resetNodeVisible()
    wallMeNode    :setVisible(true)
    wallLeftNode  :setVisible(true)
    wallUpNode    :setVisible(true)
    wallRightNode :setVisible(true)
    standMeNode   :setVisible(false)
    standLeftNode :setVisible(false)
    standUpNode   :setVisible(false)
    standRightNode:setVisible(false)
    dachuMeNode   :setVisible(false)
    dachuLeftNode :setVisible(false)
    dachuUpNode   :setVisible(false)
    dachuRightNode:setVisible(false)
    pengMeNode    :setVisible(false)
    pengLeftNode  :setVisible(false)
    pengUpNode    :setVisible(false)
    pengRightNode :setVisible(false)
end

function PlayLayer:refresh(params)
    self:resetNodeVisible()


end


return PlayLayer
