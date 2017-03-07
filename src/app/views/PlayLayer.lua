--  打牌--
local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local cardMgr = import(".CardManager"):getInstance()
local PlayLayer = class("PlayLayer", display.newLayer)

-- fileNode  1:me,   2:Right,    3:up,     4:left
local testCv = {25, 18, 1, 2, 3, 8, 5, 5, 7, 9, 40, 41, 52, 74}

function PlayLayer:ctor()
    local rootNode = cc.CSLoader:createNode("playScene.csb"):addTo(self)
    self.rootNode = rootNode

    self.wallNode = {}
    self.stndNode = {}
    self.dachNode = {}
    self.pengNode = {}
    self.wallCell = {}
    self.stndCell = {}
    self.dachCell = {}
    self.pengCell = {}

    self.deskBgNode  = rootNode:getChildByName("FileNode_deskBg")
    self.deskUiNode  = rootNode:getChildByName("FileNode_deskUi")
    self.wallNode[1]  = rootNode:getChildByName("FileNode_wallMe")
    self.wallNode[2]  = rootNode:getChildByName("FileNode_wallRight")
    self.wallNode[3]  = rootNode:getChildByName("FileNode_wallUp")
    self.wallNode[4]  = rootNode:getChildByName("FileNode_wallLeft")
    self.stndNode[1]  = rootNode:getChildByName("FileNode_standMe")
    self.stndNode[2]  = rootNode:getChildByName("FileNode_standRight")
    self.stndNode[3]  = rootNode:getChildByName("FileNode_standUp")
    self.stndNode[4]  = rootNode:getChildByName("FileNode_standLeft")
    self.dachNode[1]  = rootNode:getChildByName("FileNode_dachuMe")
    self.dachNode[2]  = rootNode:getChildByName("FileNode_dachuRight")
    self.dachNode[3]  = rootNode:getChildByName("FileNode_dachuUp")
    self.dachNode[4]  = rootNode:getChildByName("FileNode_dachuLeft")
    self.pengNode[1]  = rootNode:getChildByName("FileNode_pengMe")
    self.pengNode[2]  = rootNode:getChildByName("FileNode_pengRight")
    self.pengNode[3]  = rootNode:getChildByName("FileNode_pengUp")
    self.pengNode[4]  = rootNode:getChildByName("FileNode_pengLeft")
    self.stndNodeMeBei = rootNode:getChildByName("FileNode_standMeBei")
    self:resetNodeVisible()



--    

    --self:schedule(self,handler(self, self.checkAttackUpdate),2.0)
    --     if self:getPositionX() <= battleManager.hero:getPositionX() then
    --     self:unschedule()
    --     --切换到ui层处理
    --     self:changeParent(battleManager.battleUi,1024)
    --     self:setPosition(cc.p(battleManager.cameraPos.x + self:getPositionX(),battleManager.cameraPos.y + self:getPositionY()))
    --     local moveto = cc.MoveTo:create(1.0,cc.p(self.targetPos.x,self.targetPos.y))
    --     local scale  = cc.ScaleTo:create(1.0,0.5)
    --     local callBack = cc.CallFunc:create(handler(self, self.destroy))
    --     local action = cc.Spawn:create(cc.Sequence:create(moveto,callBack,nil),scale)
    --     self:runAction(action)
    -- else
    --     self:setLocalZOrder(display.height - self:getPositionY())
    -- end
    
    local btnClose = self.deskUiNode:getChildByName("Button_Close")
    btnClose:onClicked(
        function ()
        layerMgr:showLayer(layerMgr.Enum.MainLayer, params)
        TTSocketClient:getInstance():closeMySocket(girl.SocketType.Game)
        end)

    for i = 1, 4 do
        self.wallCell[i] = {}
        self.stndCell[i] = {}
        self.dachCell[i] = {}
        self.pengCell[i] = {}
        for j=1,4 do
            self.pengCell[i][j] = {}
        end
    end
    --堆牌
    for  i = 1,4 do
        for j = 1,36 do
            local imgName = "Image"..j
            self.wallCell[i][j] =  self.wallNode[i]:getChildByName(imgName)
        end
    end

    --碰牌  四个一组,pengCell[1][1][1]，共四组，5,6为13,14张
    for  i = 1,4 do
        self.pengCell[i][5] =  self.pengNode[i]:getChildByName("Image13")
        self.pengCell[i][6] =  self.pengNode[i]:getChildByName("Image14")
        for j = 1, 4 do
            local nodeName = "Node_"..j
            local nd =  self.pengNode[i]:getChildByName(nodeName)
            for k = 1, 4 do
                local imgName = "Image"..k
                local imgBg = nd:getChildByName(imgName)
                self.pengCell[i][j][k] = imgBg:getChildByName("Image_face")
            end
        end
    end

    --打出牌
    for i = 1, 4 do
        for j = 1, 24 do
            local imgName = "Image"..j
            local imgBg =  self.dachNode[i]:getChildByName(imgName) 
            self.dachCell[i][j] = imgBg:getChildByName("ImageFace")
        end
    end

    --站着的牌, 自己的站牌动态创建，在CardManager CardNodes
    for i=2,4 do
        for j=1,14 do
            local imgName = "Image"..j
            self.stndCell[i][j] = self.stndNode[i]:getChildByName(imgName)
        end
    end
    --自己的盖下去的牌
    for i=1,14 do
        local imgName = "Image"..i
        self.stndCell[1][i] = self.stndNodeMeBei:getChildByName(imgName)
    end


    -- wallCell[1][35]:setVisible(false)
    -- pengCell[2][3][4]:loadTexture("24.png")
    -- dachCell[4][14]:loadTexture("17.png")
    -- for i = 1,40000 do
    --     for i=1,14 do
    --         pengMeCell[1]:loadTexture("24.png")
    --     end
    -- end

    self:refresh(testCv)
end
  
function PlayLayer.create()
    return PlayLayer.new()
end

--抓牌
function PlayLayer:zhuaPai(cardValuesMe)

end

function PlayLayer:resetNodeVisible()
    for i=1,4 do
        self.wallNode[i]:setVisible(true)
        self.stndNode[i]:setVisible(false)
        self.dachNode[i]:setVisible(false)
        self.pengNode[i]:setVisible(false)
    end
    self.stndNodeMeBei:setVisible(false)
end

function PlayLayer:refresh(cardValuesMe)
    self:resetNodeVisible()
    self:zhuaPai(cardValuesMe)
    cardMgr:initCardNodes(cardValuesMe, self)

end


return PlayLayer
