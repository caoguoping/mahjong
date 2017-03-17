--  打牌--
local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local cardMgr = import(".CardManager"):getInstance()
local cardDataMgr = import(".CardDataManager"):getInstance()


-- fileNode  1:me,   2:left,    3:up,     4:right
local testCv = {25, 18, 1, 2, 3, 8, 5, 5, 7, 9, 40, 41, 52, 74}


local PlayLayer = class("PlayLayer", display.newLayer)
function PlayLayer:ctor()
--all Node
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
    self.wallNode[4]  = rootNode:getChildByName("FileNode_wallRight")
    self.wallNode[3]  = rootNode:getChildByName("FileNode_wallUp")
    self.wallNode[2]  = rootNode:getChildByName("FileNode_wallLeft")
    self.stndNode[1]  = rootNode:getChildByName("FileNode_standMe")
    self.stndNode[4]  = rootNode:getChildByName("FileNode_standRight")
    self.stndNode[3]  = rootNode:getChildByName("FileNode_standUp")
    self.stndNode[2]  = rootNode:getChildByName("FileNode_standLeft")
    self.dachNode[1]  = rootNode:getChildByName("FileNode_dachuMe")
    self.dachNode[4]  = rootNode:getChildByName("FileNode_dachuRight")
    self.dachNode[3]  = rootNode:getChildByName("FileNode_dachuUp")
    self.dachNode[2]  = rootNode:getChildByName("FileNode_dachuLeft")
    self.pengNode[1]  = rootNode:getChildByName("FileNode_pengMe")
    self.pengNode[4]  = rootNode:getChildByName("FileNode_pengRight")
    self.pengNode[3]  = rootNode:getChildByName("FileNode_pengUp")
    self.pengNode[2]  = rootNode:getChildByName("FileNode_pengLeft")
    self.stndNodeMeBei = rootNode:getChildByName("FileNode_standMeBei")

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

--bg
    self.imgLight= {}
    self.imgFeng = {}
    self.imgNowFeng = {}
    for i=1,4 do
        local imgName = "Image_light_"..i
        local imgName1 = "Image_feng"..i
        local imgName2 = "Image_nowFeng"..i
        self.imgLight[i] = self.deskBgNode:getChildByName(imgName)
        self.imgFeng[i] = self.deskBgNode:getChildByName(imgName1)
        self.imgNowFeng[i] = self.deskBgNode:getChildByName(imgName2)
    end
    self.txtClock = self.deskBgNode:getChildByName("AtlasLabel_1")
    self.nodeShezi = self.deskBgNode:getChildByName("FileNode_shezi")
    --self.clock:setString("0"..8)

--ui
    local btnClose = self.deskUiNode:getChildByName("Button_Close")
    btnClose:onClicked(
        function ()
        layerMgr:showLayer(layerMgr.layIndex.MainLayer, params)
        TTSocketClient:getInstance():closeMySocket(netTb.SocketType.Game)
        end)

    self.headNode = {}
    self.txtScore = {}
    self.imgHead = {}
    for i=1,4 do
        local strName = "FileNode_"..i
        self.headNode[i] = self.deskUiNode:getChildByName(strName)
        self.txtScore[i] = self.headNode[i]:getChildByName("Text_score")
        self.imgHead[i] = self.headNode[i]:getChildByName("Image_head")
    end

--invite 邀请好友界面
    self.inviteNode = rootNode:getChildByName("FileNode_invite")
    self.txtRoomNum = self.inviteNode:getChildByName("Text_room")
--pai
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

end
  
function PlayLayer.create()
    return PlayLayer.new()
end

function PlayLayer:waitJoin()
   
    self.joinPeople = 0
    for i=1,4 do
        self.wallNode[i]:setVisible(false)
        self.stndNode[i]:setVisible(false)
        self.dachNode[i]:setVisible(false)
        self.pengNode[i]:setVisible(false)
    end
    self.stndNodeMeBei:setVisible(false)

    for i=1,4 do
        self.imgLight[i]:setVisible(false)
        self.imgFeng[i]:setVisible(false)
        self.imgNowFeng[i]:setVisible(false)
    end

    self.nodeShezi:setVisible(false)
    self.inviteNode:setVisible(true)
    self.txtRoomNum:setString(tostring(dataMgr.roomSet.dwRoomNum))

--cgpTest
    self.nodeShezi:setVisible(true)
    local timeLineShezi = cc.CSLoader:createTimeline("shezi.csb")
    self:runAction(timeLineShezi)
    timeLineShezi:gotoFrameAndPlay(0, false)
    timeLineShezi:setLastFrameCallFunc(
        function ()
            print("\n\n callFunc Ok")
       end
       
      )


end

--显示进来人
function PlayLayer:showPlayer(svrChairId )  
    self.joinPeople = self.joinPeople + 1
    local clientId = dataMgr.getServiceChairId(svrChairId)
    self.headNode[clientId]:setVisible(true)
    self.txtScore[clientId]:setString(tostring(dataMgr.onDeskData[svrChairId].lScore))
    self.imgHead[clientId]:loadTexture("headshot_"..clientId..".png")

    if self.joinPeople == 4 then
        --todo
    end

end

--抓牌
function PlayLayer:zhuaPai()

end

--发牌
function PlayLayer:sendCard()

    self.inviteNode:setVisible(false)
    for i=1,4 do
        self.wallNode[i]:setVisible(true)
    end



end

--收到其他玩家出牌
function PlayLayer:rcvOutCard(outCard )
 --   
end


return PlayLayer
