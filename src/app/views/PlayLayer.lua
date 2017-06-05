--  打牌--
local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local cardMgr = import(".CardManager"):getInstance()
local cardDataMgr = import(".CardDataManager"):getInstance()
local musicMgr = import(".MusicManager"):getInstance()
local actMgr = import(".ActionManager"):getInstance()
-- fileNode  1:me,   2:left,    3:up,     4:right
local PlayLayer = class("PlayLayer", display.newLayer)
function PlayLayer:ctorBg( )
    self.deskBgNode  = self.rootNode:getChildByName("FileNode_deskBg")    --用以定时器的运行
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
    self.txtClock = self.deskBgNode:getChildByName("AtlasLabel_clock")
    self.nodeShezi = self.deskBgNode:getChildByName("FileNode_shezi")
    self.imgShezi1 = self.nodeShezi:getChildByName("Image_1")
    self.imgShezi2 = self.nodeShezi:getChildByName("Image_2")
end
function PlayLayer:ctorUi(  )
    self.deskUiNode  = self.rootNode:getChildByName("FileNode_deskUi")       --用以播放碰，杠，胡等特效
    self.btnActions = {}

    --返回房间按钮， 如果是房主不断socket,隐藏，创建房间按钮变为返回按钮    ;如果是加入的人则退出房间，断socket
    --发牌时后，按钮不可见
    self.btnBacks = self.deskUiNode:getChildByName("Button_back")
    --返回按钮实际处理函数
    local funcRealBack =  function ()
            musicMgr:playEffect("game_button_click.mp3", false)
            if dataMgr.roomSet.bIsCreate == 1 then    --房主
                local snd = DataSnd:create(3, 13)
                snd:wrByte(1)   --起立
                snd:sendData(netTb.SocketType.Game)
                snd:release()
                layerMgr:showLayer(layerMgr.layIndex.MainLayer, params)
                local mainlayer = layerMgr:getLayer(layerMgr.layIndex.MainLayer)
                mainlayer:btnCreateOrBack(false)
                mainlayer:refresh()
                print("backHome fangzhu")
            else --非房主
                TTSocketClient:getInstance():closeMySocket(netTb.SocketType.Game)
                layerMgr.LoginScene.btnTimers[31]:stopAllActions()
                layerMgr:showLayer(layerMgr.layIndex.MainLayer, params)
                local mainLayer = layerMgr:getLayer(layerMgr.layIndex.MainLayer)
                mainLayer:refresh()
                print("backHome no fangzhu")
            end
        end
    self.btnBacks:onClicked(
        --二级弹框
        function ()
            musicMgr:playEffect("game_button_click.mp3", false)
            local popupbox =  import(".popUpBox",CURRENT_MODULE_NAME).create() 
            if dataMgr.roomSet.bIsCreate == 1 then    --房主
                popupbox:setInfo(Strings.backRoomFangzhu)
            else
                popupbox:setInfo(Strings.backRoomJoin)
            end

            local btnOk, btnCancel  = popupbox:getBtns(2)
            btnOk:onClicked(function (  )
                musicMgr:playEffect("game_button_click.mp3", false)
                popupbox:remove()
                funcRealBack()
            end)
            btnCancel:onClicked(function (  )
                musicMgr:playEffect("game_button_click.mp3", false)
                popupbox:remove()
            end)
        end
    )

    self.headNode = {}  --头像节点
    self.txtScore = {}  --总积分
    self.txtSvrChair = {}  --服务器椅子ID，测试用
    self.imgHead = {}   --头像
    self.imgReady = {}  --准备
    self.imgEscape = {}   --逃跑
    self.imgLeave = {}    --离开
    self.imgFangzhu = {} --房主
    self.spHead = {}   --裁剪后的头像精灵  clientId
    self.imgNode = {}
    self.imgPop = {} --聊天图片
    self.textNode = {} --聊天文字
    self.textBg = {}
    self.textPop = {}

    local personInfoX = {120, 120, 620, 860}
    local personInfoY = {150, 550, 570, 400}

    local imageX = {200, 200, 900, 1060}
    local imageY = {186, 550, 550, 370}

    local textX = {330, 330, 780, 880}
    local textY = {220, 530, 570, 450}

    
    for i=1,4 do   --下标为clientId
        local strName = "FileNode_"..i
        self.headNode[i] = self.deskUiNode:getChildByName(strName)
        self.txtScore[i] = self.headNode[i]:getChildByName("Text_score")
        self.txtSvrChair[i] = self.headNode[i]:getChildByName("Text_svrId")
        self.imgHead[i] = self.headNode[i]:getChildByName("Image_head")
        self.imgReady[i] = self.headNode[i]:getChildByName("Image_ready")
        self.imgEscape[i] = self.headNode[i]:getChildByName("Image_escape")
        self.imgLeave[i] = self.headNode[i]:getChildByName("Image_leave")
        self.imgFangzhu[i] = self.headNode[i]:getChildByName("Image_fangzhu")
        self.imgFangzhu[i]:setVisible(false)

        self.imgNode[i] = cc.CSLoader:createNode("chatImagePop.csb"):addTo(self)
        self.imgPop[i] =  self.imgNode[i]:getChildByName("Image_1")
        self.imgPop[i]:setPosition(cc.p(imageX[i], imageY[i]))
        self.imgPop[i]:setVisible(false)

        self.textNode[i] = cc.CSLoader:createNode("chatTextPop.csb"):addTo(self)
        self.textNode[i]:setPosition(cc.p(textX[i], textY[i]))
        self.textNode[i]:setVisible(false)
        self.textBg[i] = self.textNode[i]:getChildByName("Text_bg")
        self.textPop[i] = self.textNode[i]:getChildByName("Text_1")

        self.imgHead[i]:onTouch(
        function(event)
            if "began" == event.name then
                layerMgr.boxes[layerMgr.boxIndex.PersonInfoBox] = import(".PersonInfoBox",CURRENT_MODULE_NAME).create()
                layerMgr.boxes[layerMgr.boxIndex.PersonInfoBox]:init(i, personInfoX[i], personInfoY[i])
            elseif "ended" == event.name or "cancelled" == event.name then
                layerMgr:removeBoxes(layerMgr.boxIndex.PersonInfoBox)
                print("\n---------------------------------------------------------------------- ")
                printf("--------------------------     %d     ---------------------------------", dataMgr.myBaseData.dwUserID)
            end
        end)
        
    end 



   --剩余牌
    self.txtLeftCard = self.deskUiNode:getChildByName("Text_leftCard")
    self.imgLeftCard = self.deskUiNode:getChildByName("Image_leftCard")

    --比下胡
    self.imgBixiahu = self.deskUiNode:getChildByName("Image_bixiahu")
    self.imgBixiahu:setVisible(false)
    --花
    self.huaNode = {}
    self.txtHuaNum = {}
    for i=1,4 do
        local strTmp = "FileNode_hua_"..i
        self.huaNode[i] = self.deskUiNode:getChildByName(strTmp)
        self.txtHuaNum[i] = self.huaNode[i]:getChildByName("Text_num")
    end   

    --剩余局数
    local nodeField = self.deskUiNode:getChildByName("FileNode_field")   
    self.txtAllJushu = nodeField:getChildByName("Text_totalField")   
    self.txtNowJushu = nodeField:getChildByName("Text_nowField")   

    --时间戳， 
    self.txtLastTime = self.deskUiNode:getChildByName("Text_timeLastHeart")
    self.txtTimeSub = self.deskUiNode:getChildByName("Text_timeSub")
    self.txtLastTime:setVisible(false)
    self.txtTimeSub:setVisible(false)

    ---打开游戏记录
    local btnRecodr = nodeField:getChildByName("Button_Records")
    btnRecodr:onClicked(
        function ()
            musicMgr:playEffect("game_button_click.mp3", false)
        layerMgr.boxes[layerMgr.boxIndex.ZhanJiBox] = import(".ZhanJiBox",CURRENT_MODULE_NAME).create()
        end
    )

    --更多信息节点， 托管，设置，帮助
    self.moreInfoNode = self.deskUiNode:getChildByName("FileNode_moreInfo")

    self.btnMore = self.moreInfoNode:getChildByName("Button_more")
    self.btnSetting = self.moreInfoNode:getChildByName("Button_setting")
    self.btnHelp = self.moreInfoNode:getChildByName("Button_help")
    self.btnAuto = self.moreInfoNode:getChildByName("Button_auto")
    self.imgMoreBg = self.moreInfoNode:getChildByName("Image_bg")
    self:setMoreInfo(false)

    self.btnMore:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:clickInfoMore()
        end
    )

    self.btnSetting:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            layerMgr.boxes[layerMgr.boxIndex.SettingBox] = import(".SettingBox",CURRENT_MODULE_NAME).create()
        end
    )

    self.btnHelp:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            layerMgr.boxes[layerMgr.boxIndex.RulesBox] = import(".RulesBox",CURRENT_MODULE_NAME).create()
        end
    )

    self.btnAuto:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            if dataMgr.status.player == 1 then  --游戏开始后方可托管
                self:setAutoStatus(true)
                self:autoPlay()
            else
                layerMgr:showSystemMessage("游戏开始后方可托管", 300, 100, cc.c4f(255,255,255,255), true)
            end
        end
    )

    -- --聊天按钮
    self.chatNode = self.rootNode:getChildByName("FileNode_chat")
    self.openButton = self.chatNode:getChildByName("open_button")
    self.closeButton = self.chatNode:getChildByName("close_button")
    self.chatButton = self.chatNode:getChildByName("chat_button")
    self.voiceButton = self.chatNode:getChildByName("voice_button")
    self.chatBg = self.chatNode:getChildByName("chat_bg")
    self:setChatVisible(false)

    self.isChatOpen = false

    self.openButton:onClicked(
        function ( )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:setChatVisible(true)
        end
    )

    self.closeButton:onClicked(
        function ( )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:setChatVisible(false)
        end
    )

    self.chatButton:onClicked(
        function ( )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:clickChatButton()
        end
    )

    self.voiceButton:onClicked(
        function ( )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:clickVoiceButton()
        end
    )

    --托管
    self:initAuto()


end
function PlayLayer:ctorUiBtns(  )
    --碰杠听胡过btn
    for i=1,5 do
        local strName = "Button_"..i
        self.btnActions[i] = self.deskUiNode:getChildByName(strName)
    end
    self.btnActions[1]:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:clickPeng()
        end
        )

    --杠
    self.btnActions[2]:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:clickGang()
        end
        )

    --听
    self.btnActions[3]:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:clickTing()
        end
        )

    --胡
    self.btnActions[4]:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:clickHu()
        end
        )

    --过
    self.btnActions[5]:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:clickGuo()
        end
        )
end




    --invite 邀请好友界面
function PlayLayer:ctorInvite(  )

    self.inviteNode = self.rootNode:getChildByName("FileNode_invite")
    self.txtRoomNum = self.inviteNode:getChildByName("Text_room")
    self.imgJinyuanzi = self.inviteNode:getChildByName("Image_jinyuanzi")
    self.imgChangkaihuai = self.inviteNode:getChildByName("Image_changkaihuai")

    --解散房间 ,只发消息 ， 将房卡退回，收到状态变化，桌子号为无效时，解散房间， 
    self.btnDisRoom = self.inviteNode:getChildByName("Button_dismissRoom")
    local funDisRoom = function (  )
            --self.btnDisRoom:setTouchEnabled(false)  --禁用， 2s再开启
           
            musicMgr:playEffect("game_button_click.mp3", false)
            local snd = DataSnd:create(3, 12)
            snd:sendData(netTb.SocketType.Game)
            snd:release()

            --(3, 501)  userId, kindId  请求道具数量
            local snd = DataSnd:create(3, 501)
            snd:wrDWORD(dataMgr.myBaseData.dwUserID)
            snd:wrDWORD(10)
            print("funDisRoom ******************  send 3, 501 ")
            snd:sendData(netTb.SocketType.Login)
            snd:release()
            
            local mainlayer = layerMgr:getLayer(layerMgr.layIndex.MainLayer)
            mainlayer:btnCreateOrBack(true)
            mainlayer:refresh()

            -- local seq = cc.Sequence:create(
            --             cc.DelayTime:create(2.0),
            --             cc.CallFunc:create(
            --                 function ()
            --                     self.btnDisRoom:setTouchEnabled(true)
            --                 end)
            --             )
            -- self.btnDisRoom:runAction(seq)
    end

    self.btnDisRoom:onClicked(
        --二级弹框
        function ()
            musicMgr:playEffect("game_button_click.mp3", false)
            local popupbox =  import(".popUpBox",CURRENT_MODULE_NAME).create() 
            popupbox:setInfo(Strings.dismissRoom)
            local btnOk, btnCancel  = popupbox:getBtns(2)
            btnOk:onClicked(
                function (  )
                    musicMgr:playEffect("game_button_click.mp3", false)
                    btnOk:setTouchEnabled(false)
                    popupbox:remove()
                    funDisRoom()
            end)
            btnCancel:onClicked(function (  )
                musicMgr:playEffect("game_button_click.mp3", false)
                popupbox:remove()
            end)
        end
        )


    --邀请微信好友
    local btnWeChat = self.inviteNode:getChildByName("Button_weChat")
    btnWeChat:onClicked( 
        function ()
            
            musicMgr:playEffect("game_button_click.mp3", false)
            local targetPlatform = cc.Application:getInstance():getTargetPlatform()
            if  device.platform == "android" then
                print(" android !!!!!!")
                --path, roomNum, type, isToAllfriends
                --//图片路径  ，roomNum,  type (1邀请好友打牌  2分享战绩)，  isToAllFriends(1分享到朋友圈，0分享给好友)
                --Helpers:callWechatShareJoin("/sdcard/headshot_example.png","http://101.37.20.36:8383/index.html", dataMgr.roomSet.dwRoomNum , 0) 
                Helpers:callWechatShareJoin("/sdcard/headshot_example.png","http://majiang.nettl.cn/jump.html", dataMgr.roomSet.dwRoomNum , 0) 
            elseif  device.platform == "ios" then
                --whj 添加ios微信分享邀请好友
                print("IOS···")
                Helpers:weichatShare("/sdcard/headshot_example.png", "http://majiang.nettl.cn/jump.html", dataMgr.roomSet.dwRoomNum, 0)
                --Helpers:weichatShare("/sdcard/headshot_example.png", "http://192.168.3.15:8888/index.html", dataMgr.roomSet.dwRoomNum, 0)
            else
                print("windows!!!!!!")
            end
        end)
end

function PlayLayer:ctor()
    local rootNode = cc.CSLoader:createNode("playScene.csb"):addTo(self)
    self.rootNode = rootNode
    cardMgr:initAllNodes(self)
    self:ctorBg()
    self:ctorUi()
    self:ctorUiBtns()
    self:ctorInvite()
end
--设置更多信息是否打开
function PlayLayer:setMoreInfo(isOpen)
    dataMgr.status.isMoreInfoOpen = isOpen
    if isOpen  then    --展开
        self.btnSetting:setVisible(true)
        self.btnHelp:setVisible(true)
        self.btnAuto:setVisible(true)
        self.imgMoreBg:setVisible(true)
    else
        self.btnSetting:setVisible(false)
        self.btnHelp:setVisible(false)
        self.btnAuto:setVisible(false)
        self.imgMoreBg:setVisible(false)
    end
end

--点击更多信息按钮
function PlayLayer:clickInfoMore(  )
    if self.imgMoreBg:isVisible() then
        self:setMoreInfo(false)         
    else
        self:setMoreInfo(true)
    end
end

--设置聊天按钮显示
function PlayLayer:setChatVisible(isOpen)
    if isOpen then
        self.openButton:setVisible(false)
        self.closeButton:setVisible(true)
        self.chatButton:setVisible(true)
        self.voiceButton:setVisible(true)
        self.chatBg:setVisible(true)
    else
        self.openButton:setVisible(true)
        self.closeButton:setVisible(false)
        self.chatButton:setVisible(false)
        self.voiceButton:setVisible(false)
        self.chatBg:setVisible(false)
    end
end

--点击聊天按钮
function PlayLayer:clickChatButton( )
    print("----------聊天按钮")
    self:setChatVisible(false)
    layerMgr.boxes[layerMgr.boxIndex.ChatUIBox] = import(".ChatUIBox",CURRENT_MODULE_NAME).create()
end

--点击语音按钮
function PlayLayer:clickVoiceButton( )
    print("----------语言按钮")
    self:setChatVisible(false)
    local popupbox =  import(".popUpBox",CURRENT_MODULE_NAME).create()
    popupbox:setInfo(Strings.notopen)
    local btnOk = popupbox:getBtns(1)
    btnOk:onClicked(
        function (  )
            popupbox:remove()
        end
    )
end

--设置托管状态
function PlayLayer:setAutoStatus( enable )
    self.autoImage:setVisible(enable)
    self.btnCancelAuto:setVisible(enable)
    dataMgr.status.auto = enable
end


--点击碰牌按钮
function PlayLayer:clickPeng(  )
    for i=1,5 do
        self.btnActions[i]:setVisible(false)
    end
    local snd = DataSnd:create(200, 3)
    snd:wrByte(1)     --0x01
    snd:wrByte(self.actCard)
    snd:wrByte(self.actCard)
    snd:wrByte(self.actCard)
    snd:sendData(netTb.SocketType.Game)
    snd:release()    
end
--点击杠牌按钮
function PlayLayer:clickGang(  )
    for i=1,5 do
        self.btnActions[i]:setVisible(false)
    end
    local snd = DataSnd:create(200, 3)
    print("点击杠牌，获得保存的值 self.gangSaveValue, self.actCard", self.gangSaveValue, self.actCard)
    snd:wrByte(self.gangSaveValue)     --保存过的
    snd:wrByte(self.actCard)
    snd:wrByte(self.actCard)
    snd:wrByte(self.actCard)
    snd:sendData(netTb.SocketType.Game)
    snd:release()    
end
--点击听牌按钮
function PlayLayer:clickTing(  )
    for i=1,5 do
        self.btnActions[i]:setVisible(false)
    end
    local snd = DataSnd:create(200, 2)
    local svrChairId = dataMgr:getServiceChairId(1) - 1
    snd:wrByte(svrChairId)     --任何一个字节
    snd:sendData(netTb.SocketType.Game)
    snd:release()     
end
--点击胡牌按钮
function PlayLayer:clickHu(  )
    for i=1,5 do
        self.btnActions[i]:setVisible(false)
    end
    local snd = DataSnd:create(200, 3)
    snd:wrByte(32)      --0x20
    snd:wrByte(self.huCard)
    snd:wrByte(self.huCard)
    snd:wrByte(self.huCard)
    print("\n hu card "..self.huCard)
    snd:sendData(netTb.SocketType.Game)
    snd:release()
end
--点击过牌按钮
function PlayLayer:clickGuo(  )
    for i=1,5 do
        self.btnActions[i]:setVisible(false)
    end
    self.btnActions[5]:setVisible(false)
    local snd = DataSnd:create(200, 3)
    snd:wrByte(0)    --0x00
    snd:wrByte(0)
    snd:wrByte(0)
    snd:wrByte(0)
    snd:sendData(netTb.SocketType.Game)
    snd:release();    
end
--初始化托管按钮
function PlayLayer:initAuto(  )
    self.autoImage = self.deskUiNode:getChildByName("Image_auto")
    self.btnCancelAuto = self.deskUiNode:getChildByName("Button_cancelAuto")
    self.autoImage:setVisible(false)
    self.btnCancelAuto:setVisible(false)

    self.btnCancelAuto:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)

            self:setAutoStatus(false)
        end)    
end
function PlayLayer.create()
    return PlayLayer.new()
end
function PlayLayer:playJianTou(clientId, posx, posy )
    actMgr:playJianTou(clientId, posx, posy)
end
--点击创建或加入按钮,更新界面和数据
function PlayLayer:createRefresh(  )
    for i=1,4 do
        self.imgLight[i]:setVisible(false)
        self.imgFeng[i]:setVisible(false)
        self.imgNowFeng[i]:setVisible(false)
        self.headNode[i]:setVisible(false)
        self.huaNode[i]:setVisible(false)
    end

    cardMgr:hideAllCards()
    cardDataMgr:refresh()

    for i=1,5 do
        self.btnActions[i]:setVisible(false)
    end
    self.imgLeftCard:setVisible(false)
    self.txtLeftCard:setVisible(false)
    cardMgr:setImgTouchCard(false)
    
    for i=1,4 do
        dataMgr.onDeskData[i].dwUserID = 0    --用于是否是第一次进入界面
    end

    self:refresh( )

end
--创建或加入时显示局数和进园子,钱
function PlayLayer:showJushuAndJinyunzi(  )

    for i=1,4 do
        dataMgr.onDeskData[i].LeftMoney = dataMgr.roomSet.wScore       --剩余钱
    end

    dataMgr.roomSet.currentJushu = 0
    dataMgr.roomSet.AllJushu = dataMgr.roomSet.bJuShu * 4
    if dataMgr.roomSet.bIsJinyunzi == 1 then
        self.imgJinyuanzi:setVisible(true)
        self.imgChangkaihuai:setVisible(false)
    elseif dataMgr.roomSet.bIsJinyunzi == 2 then
        self.imgJinyuanzi:setVisible(false)
        self.imgChangkaihuai:setVisible(true)
    end

    self.txtAllJushu:setString(dataMgr.roomSet.AllJushu)
    self.txtNowJushu:setString(dataMgr.roomSet.currentJushu)   
end
--每局胡牌或非正常结束时执行一次,更新界面和数据
function PlayLayer:refresh( )
    self.imgBixiahu:setVisible(false)

    cardMgr:hideAllCards()
    cardMgr:removeHandCards()
    cardDataMgr:refresh()

    for i=1,5 do
        self.btnActions[i]:setVisible(false)
    end

    --隐藏箭头
    actMgr:playJianTou(0, 0, 0 )

    --隐藏所有人物信息， 补花信息
    for i=1,4 do
        self.imgReady[i]:setVisible(false)
        self.imgEscape[i]:setVisible(false)
        self.imgLeave[i]:setVisible(false)
        self.huaNode[i]:setVisible(false)
    end



    self:stopClock()   --停定时器
    self.txtClock:setString("0")

    self.autoImage:setVisible(false)
    self.btnCancelAuto:setVisible(false)
    dataMgr.status.auto = false   -- 托管?
    dataMgr.status.isMeOut= 0
    dataMgr.status.isMeOption = 0
    dataMgr.status.isMoreInfoOpen = true

end
--等待其他人加入，在自己进去之后，收到
function PlayLayer:JoinInit()

    self.nodeShezi:setVisible(false)
    self.inviteNode:setVisible(true)
    self.txtRoomNum:setString(string.format("%06d", dataMgr.roomSet.dwRoomNum))
end
function PlayLayer:createScoreChange(svrId, isAdd, changeScore )
    local clientId = dataMgr.chair[svrId]
    local csbName = "minusScore.csb"
    if isAdd == 1 then
        csbName = "addScore.csb"
    end

    dataMgr.onDeskData[svrId].LeftMoney = dataMgr.onDeskData[svrId].LeftMoney + changeScore


    local nodeScore = cc.CSLoader:createNode(csbName):addTo(self.deskUiNode)
    local txtScore = nodeScore:getChildByName("AtlasLabel_bigScore")
    txtScore:setString(math.abs(changeScore))
    nodeScore:setPosition(girl.scorePosX[clientId] - 0.5 * display.width , girl.scorePosY[clientId] - 0.5 * display.height)



    local seq = cc.Sequence:create(
                cc.Spawn:create(
                    cc.MoveBy:create(1.0, cc.p(20, 20))
                    ),
                cc.FadeOut:create(0.3),
                cc.CallFunc:create(
                function ()
                    self.txtScore[clientId]:setString(dataMgr.onDeskData[svrId].LeftMoney)    --刷新积分
                    nodeScore:removeFromParent()    
                end)
                )
    nodeScore:runAction(seq)
end
--显示进来人   svrChairId[1, 4],  showOrHide  ,true 显示，   false 隐藏
function PlayLayer:showPlayer(svrChairId ,showOrHide)  
    if showOrHide then

        dataMgr.joinPeople = dataMgr.joinPeople + 1
        print("joinPeople "..dataMgr.joinPeople)
        local clientId = dataMgr.chair[svrChairId]
        self.headNode[clientId]:setVisible(true)

        --裁剪头像
        local headPath = cc.FileUtils:getInstance():getWritablePath().."headImage_"..clientId..".png"
        local headSize = self.imgHead[clientId]:getContentSize()
        local sp = display.createCircleSprite(headPath, "headshot_example.png"):addTo(self.imgHead[clientId])
        sp:setPosition(headSize.width * 0.5, headSize.height * 0.5)
        self.spHead[clientId] = sp

      --  print("left money "..dataMgr.onDeskData[svrChairId].LeftMoney)
        self.txtScore[clientId]:setString(dataMgr.onDeskData[svrChairId].LeftMoney)
        self.imgReady[clientId]:setVisible(true)

        --self.txtSvrChair[clientId]:setString(tostring(svrChairId))  --test for name
    else
        dataMgr.joinPeople = dataMgr.joinPeople - 1
        local clientId = dataMgr.chair[svrChairId]
        self.headNode[clientId]:setVisible(false)
    end

    if dataMgr.joinPeople == 4 then
        --发送准备
        local snd = DataSnd:create(100, 2)
        print("\n  ^^^^^^^^^^^^^^^^^^^^^ zhunbei , 100, 2")
        snd:sendData(netTb.SocketType.Game)
        snd:release()
    end

end
--起牌
function PlayLayer:qiPai()
    musicMgr:playEffect("tuipai.mp3", false)
        local bankClient = 3
        local delay1  = cc.DelayTime:create(0.3)
           
        local action = cc.Sequence:create(delay1 , cc.CallFunc:create(
            function ()
                for i=1, 53 do
                    cardMgr.wallCell[i]:setVisible(false)
                end

                -- cardMgr.wallCell[55]:setVisible(false)
                -- cardMgr.wallCell[54]:setVisible(false)
                for i=1,4 do
                    cardMgr.stndNode[i]:setVisible(true)
                end

                cardDataMgr.totalOutNum = 53


            end))

        layerMgr.LoginScene.btnTimers[23]:runAction(action)    
end
--胡牌
function PlayLayer:huPai(gameEndData)
    
    self:stopClock()  --定时器
    cardMgr:removeHandCards()
    for i=1,4 do
        cardMgr.stndNode[i]:setVisible(false)
    end

    for i=1,4 do
        local svrChairId = dataMgr:getServiceChairId(i)
        self.txtScore[i]:setString(dataMgr.onDeskData[svrChairId].LeftMoney)
    end
    

    local mySvrId = dataMgr:getServiceChairId(1)  --已转 我 1，到4
    local winClient = 1   --要显示的赢家的客户端ID,默认是自己
    local winSvr = mySvrId   --赢家的服务器ID  
    local fanSave = gameEndData.wFanCount[winSvr]
    for i=2,4 do  --i 为客户端id
        local tempWinSvr = dataMgr:getServiceChairId(i)
        
        if gameEndData.wFanCount[tempWinSvr] > fanSave then
            winSvr = tempWinSvr
            winClient = i
            fanSave = gameEndData.wFanCount[tempWinSvr]
        end
  --    print("\n\n\ntempWinSvr "..tempWinSvr.." fanSave "..fanSave.."  i  "..i.." winClient "..winClient)
    end
    if fanSave ~= 0 then  --有赢家
        actMgr:playAction(4, winClient)
    end
    --放下牌
    --碰杠的总数目
    local pengGangNum = {}
    for svr=1,4 do   --4家svrChairId
        --杠
        local clientId = dataMgr.chair[svr]  --客户端ChairId
        pengGangNum[svr] = 0
       
        for i=1,4 do          --4堆
            if girl.isCardValue(gameEndData.cbCardGang[svr][i]) then
                pengGangNum[svr] = pengGangNum[svr] + 1
                for j=1,4 do     --每堆的4张牌
                    cardMgr.pengCell[clientId][pengGangNum[svr]][j]:setVisible(true)
                    cardMgr.pengCellFace[clientId][pengGangNum[svr]][j]:setVisible(true)
                  --  print("gameEndData.cbCardGang svr "..svr.."  i "..i.." j "..j)
                    cardMgr.pengCellFace[clientId][pengGangNum[svr]][j]:loadTexture(gameEndData.cbCardGang[svr][i]..".png")
                end
            else
               break
            end
        end

        --碰
        for i=1,4 do    --4堆
            if girl.isCardValue(gameEndData.cbCardPeng[svr][i]) then
                pengGangNum[svr] = pengGangNum[svr] + 1
                for j=1,3 do
                    cardMgr.pengCellFace[clientId][pengGangNum[svr]][j]:loadTexture(gameEndData.cbCardPeng[svr][i]..".png")
                end
            else
               break
            end
        end

        --手牌
        local leftHandCounts = gameEndData.cbCardCount[svr]
       -- print("leftHandCounts "..leftHandCounts.."  svr "..svr)
        if svr == winSvr then   --赢家14张
            cardMgr.pengCell[clientId][5]:setVisible(true)
            cardMgr.pengCellFace[clientId][5]:setVisible(true)
            cardMgr.pengCellFace[clientId][5]:loadTexture(gameEndData.cbCardData[svr][leftHandCounts  - 1]..".png")  --第13张
            cardMgr.pengCell[clientId][6]:setVisible(true)
            cardMgr.pengCellFace[clientId][6]:setVisible(true)
            cardMgr.pengCellFace[clientId][6]:loadTexture(gameEndData.cbCardData[svr][leftHandCounts]..".png")          --第14张
        else
            cardMgr.pengCell[clientId][5]:setVisible(true)
            cardMgr.pengCellFace[clientId][5]:setVisible(true)
            cardMgr.pengCellFace[clientId][5]:loadTexture(gameEndData.cbCardData[svr][leftHandCounts]..".png")  --第13张
        end

        pengGangNum[svr] = pengGangNum[svr] + 1  --接着的节点显示 ,已碰 + 1
        for i=pengGangNum[svr], 4 do    
            for j=1,3 do
                cardMgr.pengCell[clientId][i][j]:setVisible(true)
                cardMgr.pengCellFace[clientId][i][j]:setVisible(true)
                cardMgr.pengCellFace[clientId][i][j]:loadTexture(gameEndData.cbCardData[svr][(i - pengGangNum[svr])* 3 + j]..".png")  
            end
        end
    end


    local delay1  = cc.DelayTime:create(girl.delayTime.showHupaiRst)
    local action = cc.Sequence:create(delay1 , cc.CallFunc:create(
        function ()

            if fanSave ~= 0 then
                if dataMgr.isNormalEnd == true then
                    musicMgr:playCardValueEffect(dataMgr.myBaseData.cbGender ,dataMgr.myBaseData.young,  13)  --胡牌
                    local jiesuanBox = import(".JiesuanBox",CURRENT_MODULE_NAME).create()
                    print("step into jiesuanBox  in playerLayer")
                    jiesuanBox:initData(gameEndData)
                    layerMgr.boxes[layerMgr.boxIndex.JiesuanBox] = jiesuanBox
                    --清理手牌
                    self:refresh()
                end
            else   --流局
                local liuju = import(".LiujuBox",CURRENT_MODULE_NAME).create()
                print("step into LiujuBox  in playerLayer")
                layerMgr.boxes[layerMgr.boxIndex.LiujuBox] = liuju
                --清理手牌
                self:refresh()
            end

        end))
    self:runAction(action)  
end
--发牌立即执行
function PlayLayer:sendCardImmediately(  )
    musicMgr:playEffect("saizi.mp3", false)
    for i=1,4 do
        self.imgReady[i]:setVisible(false)
    end
    
    --更新当前局数
    dataMgr.roomSet.currentJushu = dataMgr.roomSet.currentJushu + 1
        self.txtNowJushu:setString(dataMgr.roomSet.currentJushu)

    self.btnBacks:setVisible(false)
   --一开始就禁止触摸
    cardMgr:setImgTouchCard(false)   

    -- --堆牌每个小牌重新赋值
    local sice1 = cardDataMgr.cardSend.bSice1
    local sice2 = cardDataMgr.cardSend.bSice2
    local startDir = math.min(sice1, sice2)
    local theSum = sice1 + sice2
    local startIndex = (startDir - 1) * 36 + (theSum - 1) * 2  --相当于0
    for  i = 1,4 do
        for j = 1,36 do
            local imgName = "Image"..j
            local realPos = ((i - 1) * 36 + j - startIndex + 144) % 144
            if realPos == 0 then
                realPos = 144
            end
            cardMgr.wallCell[realPos] =  cardMgr.wallNode[i]:getChildByName(imgName)
            --print(realPos.." ")
        end
    end
    for i=1,144 do
        cardMgr.wallCell[i]:setVisible(true)
    end

    --剩余牌
    self.imgLeftCard:setVisible(true)
    self.txtLeftCard:setVisible(true)

    --东南西北
    for i=1,4 do
        local strTemp = "feng"..dataMgr.direction[i]..".png"
        local strTemp2 = "nowFeng"..dataMgr.direction[i]..".png"
        self.imgFeng[i]:loadTexture(strTemp)
        self.imgFeng[i]:setVisible(true)
        self.imgNowFeng[i]:loadTexture(strTemp2)
    end

    --大牌堆节点
    self.inviteNode:setVisible(false)
    for i=1,4 do
        cardMgr.wallNode[i]:setVisible(true)
    end
end
--发牌动画结束后执行
function PlayLayer:sendCardAfter( drawValue )
    --1.0秒后骰子消失，进入牌的处理
    self.imgShezi1:setVisible(false)
    self.imgShezi2:setVisible(false)

    --补花
    for i=1,4 do
        self.huaNode[i]:setVisible(true)
        self.txtHuaNum[i]:setString(cardDataMgr.huaNum[i])     --补花
        
        --总牌
        --cardDataMgr.totalOutNum = cardDataMgr.totalOutNum + cardDataMgr.huaNum[i]   --总牌加上补花
    end
    self.txtLeftCard:setString(tostring(144 - cardDataMgr.totalOutNum))  --剩余牌
    
    cardMgr:inithandCards(drawValue)     --初始化手牌

    --天胡，暗杠
    local actOption =  girl.getBitTable( cardDataMgr.cardSend.cbUserAction) 
    self.gangSaveValue = 0
    local haveOption = 0  --  1有操作, 0 没有
    if actOption[3] == 1 then   --暗杠
        self.btnActions[2]:setVisible(true)
        self.gangSaveValue = 4
        haveOption = 1
        self.actCard =cardMgr:getAGangValue(drawValue)
        dataMgr.optType = 2   --杠
        print("发牌暗杠值:  self.gangSaveValue self.actCard,",  self.gangSaveValue, self.actCard)
    end

    if actOption[6] == 1 then   --自摸
        self.btnActions[4]:setVisible(true)
        haveOption = 1
        self.huCard = drawValue
        dataMgr.optType = 4   --胡
    end

    if haveOption == 1 then   --有操作   肯定是庄家
        self.btnActions[5]:setVisible(true) 
        self:whichTurn(1)
        dataMgr.status.isMeOption = 1
        cardMgr:setImgTouchCard(false)      --庄家起牌后有操作，禁止点击
        print("setImgTouchCardFalse")
    else   --没有操作，
        --我是庄家
        if cardDataMgr.bankClient == 1 then
            cardDataMgr.outType = 0  --摸牌 
            dataMgr.status.isMeOut = 1  --我出牌     
            self:whichTurn(1)

        else
            self:whichTurn(cardDataMgr.currentDrawer)
        end
    end
    --玩家状态，打牌中
    dataMgr.status.player = 1

end
--发牌
function PlayLayer:sendCard(drawValue)
    self:sendCardImmediately()

   --掷骰子
    self.nodeShezi:setVisible(true)
    self.imgShezi1:setVisible(false)
    self.imgShezi2:setVisible(false)
    local timeLineShezi = cc.CSLoader:createTimeline("shezi.csb")
    self:runAction(timeLineShezi)
    timeLineShezi:gotoFrameAndPlay(0, false)
    timeLineShezi:setLastFrameCallFunc(
        function ()
            --骰子的动画完毕，显示两个骰子值
            self.imgShezi1:setVisible(true)
            self.imgShezi2:setVisible(true)
            self.imgShezi1:loadTexture("sezi_value"..cardDataMgr.cardSend.bSice1..".png")
            self.imgShezi2:loadTexture("sezi_value"..cardDataMgr.cardSend.bSice2..".png")
            
            self:qiPai()    --起牌在掷骰子动画后执行

            local delay = cc.DelayTime:create(1.0)
            local action = cc.Sequence:create(delay, cc.CallFunc:create(
                function (  )
                    self:sendCardAfter(drawValue)
                end))
            self:runAction(action)
        end
      )
end
--轮到谁打   
function PlayLayer:whichTurn( clientId )
    for i=1,4 do
        self.imgLight[i]:setVisible(false)
        self.imgNowFeng[i]:setVisible(false)
    end
    self:stopClock() --先停掉计时器
    self.imgLight[clientId]:setVisible(true)
    self.imgNowFeng[clientId]:setVisible(true)

    if dataMgr.status.auto and clientId == 1 then
        dataMgr.timeLeft = girl.delayTime.autoThinkTime
    else
        dataMgr.timeLeft = girl.delayTime.thinkTime
    end
    self.txtClock:setString(dataMgr.timeLeft)

    self.deskBgNode:schedule(self.deskBgNode,
        function()
            self:clockShow()
        end
        ,1.0
        )
end



function PlayLayer:stopClock(  )
    --print("stopClock")
    self.deskBgNode:stopAllActions()
end
--optType  0 打牌  1 碰  2 杠  3 听   4 胡   5 过
function PlayLayer:clockShow( )    --每个人的定时器

    dataMgr.timeLeft = dataMgr.timeLeft - 1 
    --print("timeleft "..dataMgr.timeLeft)
    local timeShow = dataMgr.timeLeft
    if timeShow <= 0 then
        timeShow = 0
    end
    self.txtClock:setString(tostring(timeShow))    --只显示0上
    --时间结束了
   -- print("timeLeft ", dataMgr.timeLeft)
    if dataMgr.timeLeft < 0 then
        print("time < 0, and Me gaoshiqing")
        print("isMeOption "..dataMgr.status.isMeOption.."  ieMeOut "..dataMgr.status.isMeOut)
        if dataMgr.status.isMeOption == 1 or dataMgr.status.isMeOut == 1 then
            self:stopClock()
            self:autoPlay()
        end
    end
end
function PlayLayer:autoPlay(  )
    
    local isAuto = 0    -- 0不是自动打牌，其他人的
    print("autoPlay isMeOption isMeOut", dataMgr.status.isMeOption , dataMgr.status.isMeOut)

    if dataMgr.status.isMeOption == 1 then   --有操作
        if dataMgr.optType == 4 then    --胡
            print("自动胡牌")
            dataMgr.status.isMeOption = 0
            self:clickHu()
            isAuto = 1
        elseif dataMgr.optType == 2 then   --杠
            print("自动杠牌")
            dataMgr.status.isMeOption = 0
            self:clickGang()
            isAuto = 1
        elseif dataMgr.optType == 1 then -- 碰
            print("自动过牌")
            dataMgr.status.isMeOption = 0
            self:clickGuo()    --过
            isAuto = 1
        end 

    else   --没有操作
        if dataMgr.status.isMeOut == 1 then   --轮到我出牌
            print("自动打牌")
            cardMgr:outCard(14)   --打最后一张牌 
            isAuto = 1
        end
    end

    --自动出牌
    if isAuto == 1 then
        --self:stopClock()
        self:setAutoStatus(true)
    end   
end
--我碰牌
function PlayLayer:optMePeng(clientOpt, clientPro, optCard)

    musicMgr:playCardValueEffect(dataMgr.myBaseData.cbGender ,dataMgr.myBaseData.young,  11)  --碰

    local pengGangNum = cardDataMgr.pengGangNum[1]
    --碰的牌起始位置 
    local startIndex = girl.getTableSortIndex(cardDataMgr.handValues, optCard) 
    print("optMePeng startIndex "..startIndex)

    local handCount = 13 - pengGangNum * 3    --手牌的张数，没去掉要放下的两张
    --碰要放下的牌
    local saveNode1 = cardMgr.handCards[startIndex]
    local saveNode2 = cardMgr.handCards[startIndex + 1]
    --删除table，
    table.remove(cardMgr.handCards, startIndex)
    table.remove(cardDataMgr.handValues,  startIndex)
    table.remove(cardMgr.handCards, startIndex)  --自动前移一位
    table.remove(cardDataMgr.handValues,  startIndex)

    --此时handCard已经不包含碰的牌的节点

    handCount = handCount - 2   --去除碰的两张后，如11,8
    --修改值
    cardDataMgr.pengGangNum[1] = cardDataMgr.pengGangNum[1] + 1
    cardDataMgr.pengNum[1] = cardDataMgr.pengNum[1] + 1
    cardDataMgr.pengGangValue[1][cardDataMgr.pengGangNum[1]] = optCard
    cardDataMgr.pengValue[1][cardDataMgr.pengNum[1]] = optCard
    cardDataMgr.outType = 1  --碰牌
    --放下的两张牌，上移，延时，删除
    local actionOpen1 = cc.Sequence:create(
        cc.MoveBy:create(0.2, cc.p(0, girl.cardHeight)),
        cc.DelayTime:create(0.2),
        --cc.Hide:create(),
        cc.CallFunc:create(
            function ()
                saveNode1:removeFromParent()
            end
        )
    )
    local actionOpen2 = cc.Sequence:create(
        cc.MoveBy:create(0.2, cc.p(0, girl.cardHeight)),
        cc.DelayTime:create(0.2),
        --cc.Hide:create(),
        cc.CallFunc:create(
            function ()
                 saveNode2:removeFromParent()
            end
        )
    )
    saveNode1:runAction(actionOpen1)
    saveNode2:runAction(actionOpen2)
    -- print("\n before runAction(action)")
    -- for i, v in pairs(cardMgr.handCards) do
    --     print(i, v)
    -- end
     --碰的牌放下后，右边右移1(含最后一张)
    for i = startIndex, handCount  do
        local action = cc.Sequence:create(
            cc.DelayTime:create(0.2), 
            cc.MoveBy:create(0.2, cc.p(girl.cardWidth, 0))
            )
        cardMgr.handCards[i]:runAction(action) 
    end

    --碰的牌放下后的左边右移3位
   -- if startIndex > 1 then
    for i=1, startIndex -1 do
        local action = cc.Sequence:create(
            cc.DelayTime:create(0.2), 
            cc.MoveBy:create(0.2, cc.p(girl.cardWidth * 3, 0))
        )
        cardMgr.handCards[i]:runAction(action) 
    end
    --end

    --最后一张补移一个Gap
    --if  handCount >= startIndex then
    local actionLast = cc.Sequence:create(
            cc.DelayTime:create(0.2), 
            cc.MoveBy:create(0.2, cc.p(girl.GapWidth, 0))
            )
    cardMgr.handCards[handCount]:runAction(actionLast) 
    --end


    --0.4秒后显示桌面的碰牌
    local action2 = cc.Sequence:create( 
        cc.DelayTime:create(0.4), 
        cc.CallFunc:create(
            function ()
                --显示碰牌
                for i=1,3 do
                    cardMgr.pengCell[1][pengGangNum + 1][i]:setVisible(true) 
                    cardMgr.pengCellFace[1][pengGangNum + 1][i]:loadTexture(optCard..".png")
                end

                --掩藏被碰家的一张出牌
                local outNum = cardDataMgr.outNum[clientPro]
                cardMgr.outCell[clientPro][outNum]:setVisible(false)
                cardDataMgr.outNum[clientPro] = outNum - 1

                dataMgr.status.isMeOut = 1
                cardMgr:setImgTouchCard(true)     --打开触摸，容许出牌
                --0.4秒后开启定时器和触摸
                local playlayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer)
                playlayer:whichTurn(1)
            end
        )
    )
    self:runAction(action2)
end
function PlayLayer:optMeMGang(clientOpt, clientPro, optCard)

    cardDataMgr.kongContinue = cardDataMgr.kongContinue + 1
    print("kongContinue in optMeMGANG ", cardDataMgr.kongContinue )

    musicMgr:playCardValueEffect(dataMgr.myBaseData.cbGender ,dataMgr.myBaseData.young,  12)  --杠

    local pengGangNum = cardDataMgr.pengGangNum[1]
    --碰杠的牌起始位置
    local startIndex = girl.getTableSortIndex(cardDataMgr.handValues, optCard) 
    local handCount = 13 - pengGangNum * 3    --手牌的张数，去掉了碰杠和进的一张牌

    local action = cc.Sequence:create(
        cc.MoveBy:create(0.2, cc.p(0, girl.cardHeight)),
        cc.DelayTime:create(0.2),
        cc.Hide:create() 
    )
    cardMgr.handCards[startIndex]:runAction(action)
    cardMgr.handCards[startIndex + 1]:runAction(action)
    cardMgr.handCards[startIndex + 2]:runAction(action)

    local action2 = cc.Sequence:create(
        cc.DelayTime:create(0.2), 
        cc.CallFunc:create(
            function ()
            --左边右移3位
                if startIndex > 1 then
                    for i=1, startIndex -1 do
                        cardMgr.handCards[i]:runAction(cc.MoveBy:create(0.2, cc.p(girl.cardWidth*3, 0))) 
                    end
                end
            end
        ),
        cc.DelayTime:create(0.2), 
        cc.CallFunc:create(
            function ()
                --显示明杠牌
                for i=1,4 do
                    cardMgr.pengCell[1][pengGangNum + 1][i]:setVisible(true) 
                    cardMgr.pengCellFace[1][pengGangNum + 1][i]:loadTexture(optCard..".png")
                end
                --掩藏被明杠玩家的一张出牌
                local outNum = cardDataMgr.outNum[clientPro]
                cardMgr.outCell[clientPro][outNum]:setVisible(false)
                cardDataMgr.outNum[clientPro] = outNum - 1
            end
        ),
        cc.DelayTime:create(0.1), 
        cc.CallFunc:create(
            function ()
                --删除牌，修改值
                cardMgr.handCards[startIndex]:removeFromParent()
                cardMgr.handCards[startIndex + 1]:removeFromParent()
                cardMgr.handCards[startIndex + 2]:removeFromParent()
                table.remove(cardMgr.handCards, startIndex)
                table.remove(cardMgr.handCards, startIndex)  --自动前移一位
                table.remove(cardMgr.handCards, startIndex)  --自动前移一位
                table.remove(cardDataMgr.handValues,  startIndex)
                table.remove(cardDataMgr.handValues,  startIndex)
                table.remove(cardDataMgr.handValues,  startIndex)
                cardDataMgr.pengGangNum[1] = cardDataMgr.pengGangNum[1] + 1
                cardDataMgr.pengGangValue[1][cardDataMgr.pengGangNum[1]] = optCard      --明杠

                cardDataMgr.gangNum[1] = cardDataMgr.gangNum[1] + 1
                cardDataMgr.gangValue[1][cardDataMgr.gangNum[1]] = optCard
               

            end
        )
    )
    self:runAction(action2)
end
--暗杠
function PlayLayer:optMeAGang(clientOpt, clientPro, optCard)
   
    cardDataMgr.kongContinue = cardDataMgr.kongContinue + 1

    musicMgr:playCardValueEffect(dataMgr.myBaseData.cbGender ,dataMgr.myBaseData.young,  12)  --杠
--1).已有三张， 摸到第四张
    if cardMgr.cardDraw.cardValue == optCard then
        print("暗杠抓到第4张 insertIndex, handCount ")
        --摸完牌才能暗杠， 杠完再摸一张，再打一张牌，
        local pengGangNum = cardDataMgr.pengGangNum[1]
        --暗杠的牌起始位置，  
        local startIndex = girl.getTableSortIndex(cardDataMgr.handValues, optCard)
        local handCount = 13 - pengGangNum * 3    --手牌的张数，去掉了碰杠和进的一张牌

        local agangSavaNode1 = cardMgr.handCards[startIndex]
        local agangSavaNode2 = cardMgr.handCards[startIndex + 1]
        local agangSavaNode3 = cardMgr.handCards[startIndex + 2]
        local agangSavaNode4 = cardMgr.cardDraw


        --修改值
        table.remove(cardMgr.handCards, startIndex)
        table.remove(cardMgr.handCards, startIndex)  --自动前移一位
        table.remove(cardMgr.handCards, startIndex)  --自动前移一位

        table.remove(cardDataMgr.handValues,  startIndex)
        table.remove(cardDataMgr.handValues,  startIndex)
        table.remove(cardDataMgr.handValues,  startIndex)


        for i,v in ipairs(cardDataMgr.handValues) do
            --print(i,v)
        end

        for i,v in ipairs(cardMgr.handCards) do
            --print(i,v)
        end

        --杠牌向上移动
        local action = cc.Sequence:create(
            cc.MoveBy:create(0.2, cc.p(0, girl.cardHeight)),
            cc.DelayTime:create(0.2),
            cc.Hide:create() 
        )
        agangSavaNode1:runAction(action)
        agangSavaNode2:runAction(action)
        agangSavaNode3:runAction(action)
        agangSavaNode4:runAction(action)



        local action2 = cc.Sequence:create(
            cc.DelayTime:create(0.2), 
            cc.CallFunc:create(
                function ()
                --左边右移3位
                    if startIndex > 1 then
                        for i=1, startIndex -1 do
                            cardMgr.handCards[i]:runAction(cc.MoveBy:create(0.2, cc.p(girl.cardWidth*3, 0))) 
                        end
                    end
                end
            ),
            cc.DelayTime:create(0.2), 
            cc.CallFunc:create(
                function ()
                    --显示杠牌
                    for i=1,4 do
                        cardMgr.pengCell[1][pengGangNum + 1][i]:setVisible(true) 
                        cardMgr.pengCellFace[1][pengGangNum + 1][i]:loadTexture(optCard..".png")
                    end
                end
            ),
            cc.DelayTime:create(0.1), 
            cc.CallFunc:create(
                function ()
                    --删除牌节点
                    agangSavaNode1:removeFromParent()
                    agangSavaNode2:removeFromParent()
                    agangSavaNode3:removeFromParent()
                    agangSavaNode4:removeFromParent()

                    cardDataMgr.pengGangNum[1] = cardDataMgr.pengGangNum[1] + 1
                    cardDataMgr.pengGangValue[1][cardDataMgr.pengGangNum[1]] = optCard    --暗杠
                    cardDataMgr.gangNum[1] = cardDataMgr.gangNum[1] + 1
                    cardDataMgr.gangValue[1][cardDataMgr.gangNum[1]] = optCard

                end
            )
        )
        self:runAction(action2) 
    else
--已有四张，摸牌时 
        --摸完牌才能暗杠， 杠完再摸一张，再打一张牌，
        --local pengGangNum = cardDataMgr.pengGangNum[1]
       
        --抓的牌插入的起始位置 
        --[[
            1.在杠牌放下之前，先把抓的牌插入手牌中，待插入节点的右边（含）右移一位
            2.抓的牌设置位置
            3.抓的牌插入table
            4.保存杠的牌的4个node，从table中移除4张杠牌，修改数据
            5.杠的牌的移动，放下，和删除


        ]]
        local insertIndex = girl.getTableSortIndex(cardDataMgr.handValues, cardMgr.cardDraw.cardValue)   --杠之前
        local handCount = 13 - cardDataMgr.pengGangNum[1] * 3    --手牌的张数，去掉了碰杠和进的一张牌 
        print("暗杠全4张 抓的牌 insertIndex, handCount ",  cardMgr.cardDraw.cardValue, insertIndex, handCount)

        --抓的牌插入手牌
        --待插入节点的右边（含）右移一位
        for i = insertIndex, handCount do   
            cardMgr.handCards[i]:setPositionX(cardMgr.handCards[i]:getPositionX() + girl.cardWidth)
        end

        cardMgr.cardDraw:setPositionX(girl.posx[insertIndex + cardDataMgr.pengGangNum[1] * 3])

        table.insert(cardMgr.handCards,  insertIndex, cardMgr.cardDraw)
        table.insert(cardDataMgr.handValues,  insertIndex, cardMgr.cardDraw.cardValue)
        handCount = handCount + 1

     

        --杠牌的起始位置，已经加入了抓的牌
        local startIndex = girl.getTableSortIndex(cardDataMgr.handValues, optCard)
        local agangSavaNode1 = cardMgr.handCards[startIndex]
        local agangSavaNode2 = cardMgr.handCards[startIndex + 1]
        local agangSavaNode3 = cardMgr.handCards[startIndex + 2]
        local agangSavaNode4 = cardMgr.handCards[startIndex + 3]

        table.remove(cardMgr.handCards, startIndex)
        table.remove(cardMgr.handCards, startIndex)  --自动前移一位
        table.remove(cardMgr.handCards, startIndex)  --自动前移一位
        table.remove(cardMgr.handCards, startIndex)  --自动前移一位
        table.remove(cardDataMgr.handValues,  startIndex)
        table.remove(cardDataMgr.handValues,  startIndex)
        table.remove(cardDataMgr.handValues,  startIndex)
        table.remove(cardDataMgr.handValues,  startIndex)
--修改碰杠的数目
        cardDataMgr.pengGangNum[1] = cardDataMgr.pengGangNum[1] + 1
        cardDataMgr.pengGangValue[1][cardDataMgr.pengGangNum[1]] = optCard
        cardDataMgr.gangNum[1] = cardDataMgr.gangNum[1] + 1
        cardDataMgr.gangValue[1][cardDataMgr.gangNum[1]] = optCard

        handCount = handCount - 4    --减掉了移除的4张杠牌

        for i,v in ipairs(cardMgr.handCards) do
            print(i,v)
        end
        print("++++++++++++++++++++++++++++++++")
        for i,v in ipairs(cardDataMgr.handValues) do
            print(i,v.cardValue)
        end  



        --4张杠牌的移动
        local action = cc.Sequence:create(
            cc.MoveBy:create(0.2, cc.p(0, girl.cardHeight)),
            cc.DelayTime:create(0.2),
            cc.Hide:create() 
        )
        agangSavaNode1:runAction(action)
        agangSavaNode2:runAction(action)
        agangSavaNode3:runAction(action)
        agangSavaNode4:runAction(action)
        local action2 = cc.Sequence:create(
            cc.DelayTime:create(0.2), 
            cc.CallFunc:create(
                function ()
                --左边右移3位
                    if startIndex > 1 then
                        for i=1, startIndex -1 do
                            cardMgr.handCards[i]:runAction(cc.MoveBy:create(0.2, cc.p(girl.cardWidth*3, 0))) 
                        end
                    end
                --右边左移1位
                    --for i=startIndex + 4, handCount do
                    for i=startIndex, handCount do
                        cardMgr.handCards[i]:runAction(cc.MoveBy:create(0.2, cc.p(-girl.cardWidth, 0))) 
                    end
                end
            ),
            cc.DelayTime:create(0.2), 
            cc.CallFunc:create(
                function ()
                    --显示杠牌
                    for i=1,4 do
                        cardMgr.pengCell[1][cardDataMgr.pengGangNum[1]][i]:setVisible(true) 
                        cardMgr.pengCellFace[1][cardDataMgr.pengGangNum[1]][i]:loadTexture(optCard..".png")
                    end
                end
            ),
            cc.DelayTime:create(0.1), 
            cc.CallFunc:create(
                function ()
                    --删除牌
                    agangSavaNode1:removeFromParent()
                    agangSavaNode2:removeFromParent()
                    agangSavaNode3:removeFromParent()
                    agangSavaNode4:removeFromParent()
                end
            )
        )
        self:runAction(action2)          
    end
end
-- --获取碰杠牌的index，1， 2， 3， 4
-- function PlayLayer:getPGangIndex(clientId, pGangValue )
    
--     for i=1,#cardDataMgr.pengValue[clientId] do
--         if cardDataMgr.pengValue[clientId][i] == pGangValue   then
--             return i
--         end
--     end
-- end

--获取碰杠牌的index，1， 2， 3， 4
function PlayLayer:getPGangIndex(clientId, pGangValue )
    
    for i=1,#cardDataMgr.pengGangValue[clientId] do
        if cardDataMgr.pengGangValue[clientId][i] == pGangValue   then
            return i
        end
    end
end

--自己碰杠操作
function PlayLayer:optMePGang(clientOpt, clientPro, optCard)
    musicMgr:playCardValueEffect(dataMgr.myBaseData.cbGender ,dataMgr.myBaseData.young,  12)  --杠
    --摸完牌才能碰杠， 杠完再摸一张，再打一张牌，
    --local pengGangNum = cardDataMgr.pengGangNum[1]
    --暗杠的牌起始位置，  
    --local handCount = 13 - pengGangNum * 3    --手牌的张数，去掉了碰杠和进的一张牌
    --删除要杠的牌，  补的一张牌就在后面的一个消息里
--抓的牌就是碰杠的牌
    if cardMgr.cardDraw.cardValue == optCard then
       -- print("cardMgr.cardDraw.cardValue == optCard "..cardMgr.cardDraw.cardValue.."  "..optCard)
        cardMgr.cardDraw:removeFromParent()
        --显示碰杠的牌，。。。cgpTest
        local pIndex = self:getPGangIndex(1, optCard)
        print("3zhang zhua 1 penggangIndex "..pIndex)
        cardMgr.pengCell[1][pIndex][4]:setVisible(true)
        cardMgr.pengCellFace[1][pIndex][4]:loadTexture(optCard..".png")
    else      --有碰杠没有杠，下次抓牌时,非抓牌的碰杠
        local handCount = #cardMgr.handCards   --手牌长度， 不包括抓的牌
        local outIndex = nil
        local cardPengGang = nil
        for i=1, handCount do  --手牌
            if cardMgr.handCards[i].cardValue == optCard then    --要碰杠的值
                outIndex = i
                cardPengGang = cardMgr.handCards[i]
            end
        end

        --删除碰杠牌
        cardPengGang:removeFromParent()
        table.remove(cardMgr.handCards, outIndex)
        table.remove(cardDataMgr.handValues,  outIndex) 

        handCount = handCount - 1    --已经删除了一个，
        --右边的左移一位，不包括抓的牌
        for i = outIndex, handCount do   --
            cardMgr.handCards[i]:setPositionX(cardMgr.handCards[i]:getPositionX() - girl.cardWidth)
        end
        --抓的牌进行插入操作
        local insertIndex = girl.getTableSortIndex(cardDataMgr.handValues, cardMgr.cardDraw.cardValue) 

        --插入节点需要移动的步数
        local moveStep = handCount + 1 - insertIndex   

         print("penggang insert index ###### ",insertIndex, "handCount", handCount,  "moveStep", moveStep)  

        for i = insertIndex, handCount do   --待插入节点的右边（含）右移一位
            cardMgr.handCards[i]:setPositionX(cardMgr.handCards[i]:getPositionX() + girl.cardWidth)
        end

        --抓的牌
        cardMgr.cardDraw:setPositionX(girl.posx[insertIndex + cardDataMgr.pengGangNum[1] * 3])
        table.insert(cardMgr.handCards,  insertIndex, cardMgr.cardDraw)
        table.insert(cardDataMgr.handValues,  insertIndex, cardMgr.cardDraw.cardValue)

        --显示碰杠的牌
        local pIndex = self:getPGangIndex(1, optCard)
        print("4zhang  penggangIndex "..pIndex)
        cardMgr.pengCell[1][pIndex][4]:setVisible(true)
        cardMgr.pengCellFace[1][pIndex][4]:loadTexture(optCard..".png")



    end 
end
--其他玩家碰
function PlayLayer:optOtherPeng( clientOpt, clientPro, optCard )

    local svrChair = dataMgr:getServiceChairId(clientOpt)
    musicMgr:playCardValueEffect(dataMgr.onDeskData[svrChair].cbGender ,dataMgr.onDeskData[svrChair].young,  11)  --碰
    --开启定时器
    local playlayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer)
    playlayer:whichTurn(clientOpt)


    local  pengGangNum = cardDataMgr.pengGangNum[clientOpt]   
    cardMgr.stndCell[clientOpt][14]:setVisible(true)
    local startDown = pengGangNum * 3
    for i=startDown + 1, startDown + 3 do
        cardMgr.stndCell[clientOpt][i]:setVisible(false)
    end
    for i=1,3 do
        cardMgr.pengCell[clientOpt][pengGangNum + 1][i]:setVisible(true)
        cardMgr.pengCellFace[clientOpt][pengGangNum + 1][i]:loadTexture(optCard..".png")
    end
    cardDataMgr.pengGangNum[clientOpt] = pengGangNum + 1
    cardDataMgr.pengNum[clientOpt] = cardDataMgr.pengNum[clientOpt] + 1
    cardDataMgr.pengValue[clientOpt][cardDataMgr.pengNum[clientOpt]] = optCard
    cardDataMgr.pengGangValue[clientOpt][cardDataMgr.pengGangNum[clientOpt]] = optCard

    --掩藏被碰家的一张出牌
    local outNum = cardDataMgr.outNum[clientPro]
    cardMgr.outCell[clientPro][outNum]:setVisible(false)
    cardDataMgr.outNum[clientPro] = outNum - 1

end



--其他玩家明杠
function PlayLayer:optOtherMGang( clientOpt, clientPro, optCard )
    local svrChair = dataMgr:getServiceChairId(clientOpt)
    musicMgr:playCardValueEffect(dataMgr.onDeskData[svrChair].cbGender ,dataMgr.onDeskData[svrChair].young,  12)  --杠
    local  pengGangNum = cardDataMgr.pengGangNum[clientOpt]  
    local gangNum =  cardDataMgr.gangNum[clientOpt]
    --cardMgr.stndCell[clientOpt][14]:setVisible(true)
    local startDown = pengGangNum * 3
    for i=startDown + 1, startDown + 3 do
        cardMgr.stndCell[clientOpt][i]:setVisible(false)
    end
    for i=1,4 do
        cardMgr.pengCell[clientOpt][pengGangNum + 1][i]:setVisible(true)
        cardMgr.pengCellFace[clientOpt][pengGangNum + 1][i]:loadTexture(optCard..".png")
    end
    cardDataMgr.pengGangNum[clientOpt] = pengGangNum + 1
    cardDataMgr.gangNum[clientOpt] = gangNum + 1
    cardDataMgr.gangValue[clientOpt][gangNum + 1] = optCard
    cardDataMgr.pengGangValue[clientOpt][cardDataMgr.pengGangNum[clientOpt]] = optCard

    --掩藏被碰家的一张出牌
    local outNum = cardDataMgr.outNum[clientPro]
    cardMgr.outCell[clientPro][outNum]:setVisible(false)
    cardDataMgr.outNum[clientPro] = outNum - 1
    
end
--其他玩家暗杠
function PlayLayer:optOtherAGang(clientOpt, clientPro, optCard)
    local svrChair = dataMgr:getServiceChairId(clientOpt)
    musicMgr:playCardValueEffect(dataMgr.onDeskData[svrChair].cbGender ,dataMgr.onDeskData[svrChair].young,  12)  --杠
    local  pengGangNum = cardDataMgr.pengGangNum[clientOpt]   
    local gangNum =  cardDataMgr.gangNum[clientOpt]
    --cardMgr.stndCell[clientOpt][14]:setVisible(true)
    local startDown = pengGangNum * 3     --放下牌的起始位置，放下四张牌
    for i=startDown + 1, startDown + 4 do  
        cardMgr.stndCell[clientOpt][i]:setVisible(false)
    end
    for i=1,4 do
        cardMgr.pengCell[clientOpt][pengGangNum + 1][i]:setVisible(true)
        cardMgr.pengCellFace[clientOpt][pengGangNum + 1][i]:loadTexture(optCard..".png")
    end
    cardDataMgr.pengGangNum[clientOpt] = pengGangNum + 1
    cardDataMgr.gangNum[clientOpt] = gangNum + 1
    cardDataMgr.gangValue[clientOpt][gangNum + 1] = optCard
    cardDataMgr.pengGangValue[clientOpt][cardDataMgr.pengGangNum[clientOpt]] = optCard
end
--其他玩家碰杠
function PlayLayer:optOtherPGang(clientOpt, clientPro, optCard)
    --显示碰杠的牌，。。。cgpTest
        local svrChair = dataMgr:getServiceChairId(clientOpt)
    musicMgr:playCardValueEffect(dataMgr.onDeskData[svrChair].cbGender ,dataMgr.onDeskData[svrChair].young,  12)  --杠   
    local pIndex = self:getPGangIndex(clientOpt, optCard)
    cardMgr.pengCell[clientOpt][pIndex][4]:setVisible(true)
    cardMgr.pengCellFace[clientOpt][pIndex][4]:loadTexture(optCard..".png")
end
--[[
    button 碰杠听胡过（1- 5）
    #define WIK_PENG                    0x01                                //碰牌类型
    #define WIK_MGANG                   0x02                                //明杠牌类型
    #define WIK_AGANG                   0x04                                //暗杠牌类型
    #define WIK_PGANG                   0x08                                //碰杠牌类型
    #define WIK_LISTEN                  0x10                                //听牌类型
    #define WIK_CHI_HU                  0x20                                /胡类型
    ]]
--只发给自己（其他人打的牌，等待自己操作）
function PlayLayer:waitOption(options, card   )

   -- print("\nWait options  "..options.."    \n")
    local actOption =  girl.getBitTable( options ) 
   
    for i=1,8 do
       -- print(" "..actOption[i])
    end

    self.actCard = card   --操作的牌值
    self.huCard = card     --胡牌的牌值

   -- print("\n################### card  "..card)
    self.gangSaveValue = 0

    if actOption[1] == 1 then   --peng
        self.btnActions[1]:setVisible(true)
        dataMgr.optType = 1   --碰
        print("waitPeng")
    end
    if actOption[2] == 1 then   --mgang
         self.btnActions[2]:setVisible(true)
         self.gangSaveValue = 2
         dataMgr.optType = 2   --杠
         print("waitMgang")
    end

    if actOption[6] == 1 then   --吃胡
        self.btnActions[4]:setVisible(true)
        dataMgr.optType = 4   --胡
        print("waitHu")
    end
    self.btnActions[5]:setVisible(true) 

    dataMgr.status.isMeOption = 1
    --timer
    self:whichTurn(1)
end
--操作返回结果
function PlayLayer:optionResult( optResult)
    local actOption =  girl.getBitTable(optResult.cbOperateCode)  --操作码    0：为过
    local clientOpt = dataMgr.chair[optResult.wOperateUser + 1]  --操作者的客户端椅子Id 
    local clientPro = dataMgr.chair[optResult.wProvideUser + 1]  --提供者的客户端椅子Id 
    local optCard = optResult.cbOperateCard  --操作的牌值

    if clientOpt == 1 then --自己
        --关闭定时器
        self:stopClock()  --close timer

        if actOption[1] == 1 then   --碰
            self:optMePeng(clientOpt, clientPro, optCard)
            actMgr:playAction(2, clientOpt)
        end

        if actOption[2] == 1 then   --明杠
            self:optMeMGang(clientOpt, clientPro, optCard)
            actMgr:playAction(3, clientOpt)
        end

        if actOption[3] == 1 then   --暗杠
            self:optMeAGang(clientOpt, clientPro, optCard)
            actMgr:playAction(3, clientOpt)
        end

        if actOption[4] == 1 then    --碰杠
            self:optMePGang(clientOpt, clientPro, optCard)
            actMgr:playAction(3, clientOpt)
        end

        --自己点击了过，
        if optResult.cbOperateCode == 0 then
            if clientPro == 1   then    --是自己提供的，（自己摸牌后，杠胡点过)
                print(" #<K<K<K<K<K  ")
                --杠胡不点，点过后打开触摸
                cardDataMgr.outType = 0 
                cardMgr:setImgTouchCard(true)
                self:whichTurn(1) 
            else      --其他人打牌，自己点击了过
                 self:stopClock()
            end
        end

        dataMgr.status.isMeOption = 0   --我操作过了
        print("optResult isMeOption")

        --其他人碰杠过操作
    else
        if actOption[1] == 1 then   --peng
            self:optOtherPeng(clientOpt, clientPro, optCard)
            actMgr:playAction(2, clientOpt)
            return

        elseif actOption[2] == 1 then   --mgang
             self:optOtherMGang(clientOpt, clientPro, optCard) 
             actMgr:playAction(3, clientOpt)
             return 

        elseif actOption[3] == 1 then   --agang
            self:optOtherAGang(clientOpt, clientPro, optCard)
            actMgr:playAction(3, clientOpt)
            return

        elseif actOption[4] == 1 then    --pgang
            self:optOtherPGang(clientOpt, clientPro, optCard)
            actMgr:playAction(3, clientOpt)
            return

        elseif actOption[6] == 1 then    --胡    其他人胡了，清托管状态
            dataMgr.status.isMeOption = 0
            dataMgr.status.isMeOut = 0
            return
        end
        --其他人点击了过
        if optResult.cbOperateCode == 0 then
            self:stopClock() --先停掉计时器
            if dataMgr.status.auto and clientId == 1 then
                dataMgr.timeLeft = girl.delayTime.autoThinkTime
            else
                dataMgr.timeLeft = girl.delayTime.thinkTime
            end
            self.txtClock:setString(dataMgr.timeLeft)

            self.deskBgNode:schedule(self.deskBgNode,
                function()
                    self:clockShow()
                end
                ,1.0
                ) 
        end

    end
end
return PlayLayer
