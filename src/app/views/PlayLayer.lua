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

    cardMgr:initAllNodes(self)

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
    self.deskBgNode  = rootNode:getChildByName("FileNode_deskBg")
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
    self.imgShezi1 = self.nodeShezi:getChildByName("Image_1")
    self.imgShezi2 = self.nodeShezi:getChildByName("Image_2")
    --self.clock:setString("0"..8)

--ui
    self.deskUiNode  = rootNode:getChildByName("FileNode_deskUi")
    self.btnActions = {}
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

    for i=1,5 do
        local strName = "Button_"..i
        self.btnActions[i] = self.deskUiNode:getChildByName(strName)
    end

    self.txtLeftCard = self.deskUiNode:getChildByName("Text_leftCard")
    self.imgLeftCard = self.deskUiNode:getChildByName("Image_leftCard")
    --碰
    self.btnActions[1]:onClicked(
        function (  )
            
        end
        )

    --杠
    self.btnActions[2]:onClicked(
        function (  )
            
        end
        )

    --听
    self.btnActions[3]:onClicked(
        function (  )
            
        end
        )

    --过
    self.btnActions[4]:onClicked(
        function (  )
            
        end
        )

    --胡
    self.btnActions[5]:onClicked(
        function (  )
            
        end
        )


--invite 邀请好友界面
    self.inviteNode = rootNode:getChildByName("FileNode_invite")
    self.txtRoomNum = self.inviteNode:getChildByName("Text_room")


end
  
function PlayLayer.create()
    return PlayLayer.new()
end

--点击创建按钮
function PlayLayer:refresh( )
    for i=1,4 do
        self.imgLight[i]:setVisible(false)
        self.imgFeng[i]:setVisible(false)
        self.imgNowFeng[i]:setVisible(false)
        self.headNode[i]:setVisible(false)
    end

    cardMgr:hideAllCards()

    for i=1,5 do
        self.btnActions[i]:setVisible(false)
    end
    self.imgLeftCard:setVisible(false)
    self.txtLeftCard:setVisible(false)

end

--等待其他人加入，在自己进去之后，收到
function PlayLayer:waitJoin()

    self.nodeShezi:setVisible(false)
    self.inviteNode:setVisible(true)
    
    --self.txtRoomNum:setString(tostring(dataMgr.roomSet.dwRoomNum))
    self.txtRoomNum:setString(string.format("%07d", dataMgr.roomSet.dwRoomNum))

--cgpTest


end

--显示进来人
function PlayLayer:showPlayer(svrChairId )  
    dataMgr.joinPeople = dataMgr.joinPeople + 1
    
    local clientId = dataMgr.chair[svrChairId + 1]
    print("\n\nclientId   "..clientId)
    self.headNode[clientId]:setVisible(true)
    --self.txtScore[clientId]:setString(tostring(dataMgr.onDeskData[svrChairId].lScore))
   -- self.imgHead[clientId]:loadTexture("headshot_"..clientId..".png")

    if dataMgr.joinPeople == 4 then
        --todo
    end

end

--抓牌
function PlayLayer:zhuaPai()
        --test
        --local bankClient = dataMgr.chair[cardDataMgr.cardSend.wBankerUser]
        cardMgr:showWallCards()
        local bankClient = 3
        local delay1  = cc.DelayTime:create(0.3)
           
        local action = cc.Sequence:create(delay1 , cc.CallFunc:create(
            function ()
                for i=1, 53 do
                    cardMgr.wallCell[i]:setVisible(false)
                end
                for i=2,4 do
                    cardMgr.stndNode[i]:setVisible(true)
                end

            end))

        self:runAction(action)    
end

--发牌
function PlayLayer:sendCard()

    self.nodeShezi:setVisible(true)
    self.imgShezi1:setVisible(false)
    self.imgShezi2:setVisible(false)
    local timeLineShezi = cc.CSLoader:createTimeline("shezi.csb")
    self:runAction(timeLineShezi)
    timeLineShezi:gotoFrameAndPlay(0, false)
    timeLineShezi:setLastFrameCallFunc(
        function ()
            self.imgShezi1:setVisible(true)
            self.imgShezi2:setVisible(true)
            cardDataMgr.cardSend.bSice1 = 3
            cardDataMgr.cardSend.bSice2 = 4
            self.imgShezi1:loadTexture("sezi_value"..cardDataMgr.cardSend.bSice1..".png")
            self.imgShezi2:loadTexture("sezi_value"..cardDataMgr.cardSend.bSice2..".png")
            self:zhuaPai()
            local delay = cc.DelayTime:create(1.0)
            local action = cc.Sequence:create(delay, cc.CallFunc:create(
                function (  )
                    self.imgShezi1:setVisible(false)
                    self.imgShezi2:setVisible(false)



                end))
            self:runAction(action)




        end
    


      )




    cardDataMgr.bankClient = dataMgr.chair[cardDataMgr.cardSend.wBankerUser]
    self.inviteNode:setVisible(false)
    for i=1,4 do
        cardMgr.wallNode[i]:setVisible(true)
    end



end

--收到其他玩家出牌
function PlayLayer:rcvOutCard(outCard )
 --   
end


return PlayLayer
