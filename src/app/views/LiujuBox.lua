--  结算弹出界面--
local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local cardDataMgr     = import(".CardDataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local musicMgr = import(".MusicManager"):getInstance()



local LiujuBox = class("LiujuBox", display.newLayer)
function LiujuBox:ctor()
    local rootNode = cc.CSLoader:createNode("liuju.csb"):addTo(self)
    self.rootNode = rootNode
    rootNode:setPosition(display.center)
    layerMgr.LoginScene:addChild(self, 10000)
  
    --返回按钮、继续游戏按钮、分享按钮
    local btnBack = rootNode:getChildByName("Button_back")
    self.btnContiue = rootNode:getChildByName("Button_contiue")
    local btnShare = rootNode:getChildByName("Button_share")

    --返回按钮、
    btnBack:onClicked(
    function()
        musicMgr:playEffect("game_button_click.mp3", false)
        local mainlayer = layerMgr:getLayer(layerMgr.layIndex.MainLayer)
        mainlayer:btnCreateOrBack(true)

        dataMgr.isNormalEnd = true
--        musicMgr:playMusic("bg.mp3", true)
        layerMgr:showLayer(layerMgr.layIndex.MainLayer, params)
        TTSocketClient:getInstance():closeMySocket(netTb.SocketType.Game)
        layerMgr.LoginScene.btnTimers[31]:stopAllActions()
        self:removeSelf()
    end)

    --继续游戏按钮
    self.btnContiue:onClicked(
    function()
        musicMgr:playEffect("game_button_click.mp3", false)
        dataMgr.isNormalEnd = true
        print("btnContiue") 
        local snd = DataSnd:create(100, 2)
        snd:sendData(netTb.SocketType.Game)
        snd:release();
        dataMgr.status.player = 0    --回到游戏前状态
        self:removeSelf()
        --显示剩余钱
        local playlayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer, params)
        for i=1,4 do
            local svrId = dataMgr:getServiceChairId(i)
            playlayer.txtScore[i]:setString(dataMgr.onDeskData[svrId].LeftMoney)
        end
    end)

 
    self.nodeHead = {}   --3家头像节点, clientId 1,2,3,4去掉赢的人
    self.imgHead = {} 
    self.txtName = {}
    self.txtScore = {}
    --下标四个头像，从左到右1,2,3,4
    for i=1,4 do     --客户端椅子Id
        local tempName = "FileNode_head_"..i
        local svrIndex = dataMgr:getServiceChairId(i) --服务器id
        self.nodeHead[i] = rootNode:getChildByName(tempName) 
        self.imgHead[i] = self.nodeHead[i]:getChildByName("Image_head")  --头像
        self.nodeHead[i]:getChildByName("img_myself"):setVisible(false)     --本家，上，对，下
        self.nodeHead[i]:getChildByName("img_baopai"):setVisible(false)
        self.txtName[i] = self.nodeHead[i]:getChildByName("name_Text")
        self.txtScore[i] = self.nodeHead[i]:getChildByName("fen_Text")
                --显示名称
        self.txtName[i]:setString(dataMgr.onDeskData[svrIndex].szNickName)

        --剩余四家头像，
        local HeadPath =  cc.FileUtils:getInstance():getWritablePath().."headImage_"..i..".png"
        local headSize = self.imgHead[i]:getContentSize()
        local sp2 = display.createCircleSprite(HeadPath, "headshot_example.png"):addTo(self.imgHead[i])
        sp2:setPosition(headSize.width * 0.5, headSize.height * 0.5)
    end

    print("liujuBox gameEnd "..dataMgr.status.gameEnd)
    if dataMgr.status.gameEnd == 3 then   --逃跑
        self.btnContiue:setVisible(false)
        local playlayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer, params)
        --playlayer.imgLeave[clientId]:setVisible(true)
        --playlayer.imgReady[clientId]:setVisible(false)
        --display.spriteGray(playlayer.spHead[clientId])   --头像灰
        local delayAction     = cc.DelayTime:create(3)
        local callFuncAction1 = cc.CallFunc:create(
            function()
                TTSocketClient:getInstance():closeMySocket(netTb.SocketType.Game) 
                layerMgr.LoginScene.btnTimers[31]:stopAllActions()
                self:removeSelf()
                layerMgr:showLayer(layerMgr.layIndex.MainLayer, params)
            end)
        local sequenceAction  = cc.Sequence:create(delayAction, callFuncAction1)
        layerMgr.LoginScene.btnTimers[22]:runAction(sequenceAction)      --有人退出


    end
end


function LiujuBox.create(  )
    return LiujuBox.new()
end

return LiujuBox
