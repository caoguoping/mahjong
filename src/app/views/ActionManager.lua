--特效管理

local dataMgr     = import(".DataManager"):getInstance()
local cardDataMgr     = import(".CardDataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()

local CURRENT_MODULE_NAME = ...

local s_inst = nil
local ActionManager = class("ActionManager")

function ActionManager:getInstance()
    if nil == s_inst then
        s_inst = ActionManager.new()
        s_inst:init()
    end
    return s_inst
end

function ActionManager:init()
    local playLayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer, params)    --定时器运行 在deskBg层
    self.nodeAction = playLayer.rootNode:getChildByName("FileNode_action")   --特效节点

        --peng,gang,hu等特效
    self.animate = playLayer.rootNode:getChildByName("ArmatureNode_1")
    self.outNode = {}
    self.outNode[1]  =  playLayer.rootNode:getChildByName("FileNode_dachuMe")    --打出牌节点，上面运行箭头特效
    self.outNode[2]  =  playLayer.rootNode:getChildByName("FileNode_dachuLeft")
    self.outNode[3]  =  playLayer.rootNode:getChildByName("FileNode_dachuUp")
    self.outNode[4]  =  playLayer.rootNode:getChildByName("FileNode_dachuRight")

    self.actionName = {
    "buhua",
    "peng",
    "gang",
    "hu",
    "gangkai",
    "dihu",
    "tianhu",
}

     --箭头
    self.jianTouNodes = {}
    self.jianTouTimeLines = {}
    for i=1,4 do
        self.jianTouNodes[i] = cc.CSLoader:createNode("jianTou.csb"):addTo(self.outNode[i])
        self.jianTouTimeLines[i] = cc.CSLoader:createTimeline("jianTou.csb")
        self.outNode[i]:runAction( self.jianTouTimeLines[i])
        self.jianTouNodes[i]:setVisible(false)
    end

    --loading 
    -- self.loadingNode = cc.CSLoader:createNode("loadingLoad.csb"):addTo(layerMgr.LoginScene, 10000)
    -- self.loadingTimeLines = cc.CSLoader:createTimeline("loadingLoad.csb")
    -- layerMgr.LoginScene:runAction( self.loadingTimeLines)
    -- self.loadingNode:setVisible(false)

end

-- function ActionManager:playAction(actIndex, clientId)
--     self.actNode[actIndex]:setVisible(true)
--     self.timeLine[actIndex]:gotoFrameAndPlay(0, false)
--     self.nodeAction:setPositionX(girl.effPosX[clientId])
--     self.nodeAction:setPositionY(girl.effPosY[clientId])
-- end

function ActionManager:playAction(actIndex, clientId)
    self.animate:setVisible(true)
    self.animate:getAnimation():play(self.actionName[actIndex], -1, 0)
    self.animate:setPositionX(girl.effPosX[clientId])
    self.animate:setPositionY(girl.effPosY[clientId])
    local seq = cc.Sequence:create(
                cc.DelayTime:create(1.0),
                cc.CallFunc:create(
                function ()
                    self.animate:setVisible(false) 
                    --self.animate:getAnimation():stop()
                end)
                )

    local playLayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer, params)    --定时器运行 在deskBg层
   playLayer.deskUiNode:runAction(seq)   
end


--clientId ==0时
function ActionManager:playJianTou(clientId, posx, posy)
    for i=1,4 do
        self.jianTouNodes[i]:setVisible(false)
    end
    if clientId ~= 0 then
        self.jianTouNodes[clientId]:setVisible(true)
        self.jianTouTimeLines[clientId]:gotoFrameAndPlay(0, true)
        self.jianTouNodes[clientId]:setPosition(posx, posy + 30)
    end
end

function ActionManager:playLoading( posx, posy )
    -- self.loadingNode:setVisible(true)
    -- self.loadingTimeLines:gotoFrameAndPlay(0, true)
    -- self.loadingNode:setPosition(display.width * 0.5 + posx, display.height *0.5 + posy)
end

function ActionManager:stopLoading(  )
    -- if self.loadingNode then
    --     self.loadingNode:setVisible(false)
    -- end
    
end



return ActionManager
