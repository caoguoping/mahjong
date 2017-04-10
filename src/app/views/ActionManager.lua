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
    local playLayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer, params)
    self.nodeAction = playLayer.rootNode:getChildByName("FileNode_action")   --特效节点

    self.actNode = {}  --[1,7] 补花，碰，杠，胡，杠开， 天胡，地胡
    for i=1,7 do
        self.actNode[i] = self.nodeAction:getChildByName("FileNode_"..i)
        self.actNode[i]:setVisible(false)
    end
    self.timeLine = {}

    self.timeLine[1] = cc.CSLoader:createTimeline("actBuhua.csb")
    self.timeLine[2] = cc.CSLoader:createTimeline("actPeng.csb")
    self.timeLine[3] = cc.CSLoader:createTimeline("actGang.csb")
    self.timeLine[4] = cc.CSLoader:createTimeline("actHupai.csb")
    self.timeLine[5] = cc.CSLoader:createTimeline("actGanghoukaihua.csb")
    self.timeLine[6] = cc.CSLoader:createTimeline("actTianhu.csb")
    self.timeLine[7] = cc.CSLoader:createTimeline("actDihu.csb")

    for i=1,7 do
        self.nodeAction:runAction(self.timeLine[i])
        self.timeLine[i]:setLastFrameCallFunc(
        function ()
            self.actNode[i]:setVisible(false)
        end
        )
    end

    --self.actNode[2]:setVisible(true)
   -- playLayer:runAction(self.timeLine[2])
  -- self:playAction(2, 1)
end

-- function ActionManager:createTimeLine(fileName, father)
--     local timeLine = cc.CSLoader:createTimeline(fileName)
--     father:runAction(timeLine)
--     timeLineShezi:gotoFrameAndPlay(0, false)
-- end

function ActionManager:playAction(actIndex, clientId)
    print("\nclientId "..clientId)
    self.actNode[actIndex]:setVisible(true)
    self.timeLine[actIndex]:gotoFrameAndPlay(0, false)
    
    self.nodeAction:setPositionX(girl.effPosX[clientId])
    self.nodeAction:setPositionY(girl.effPosY[clientId])
    print(girl.effPosX[clientId].." Pos "..girl.effPosY[clientId])
    --self.nodeAction:setPositionX(girl.effPosX[clientId])
    --self.nodeAction:setPositionY(girl.effPosY[clientId])

end



return ActionManager
