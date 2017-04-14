--大厅界面

local CURRENT_MODULE_NAME = ...

local dataMgr     = import(".DataManager"):getInstance()
local layerMgr= import(".LayerManager"):getInstance()
local musicMgr = import(".MusicManager"):getInstance()
local actMgr = import(".ActionManager"):getInstance()
    
local MainLayer = class("MainLayer", display.newLayer)

function MainLayer:ctor()
    --musicMgr:FullMusicVolume()

    local rootNode = cc.CSLoader:createNode("NewLobby.csb"):addTo(self)
    self.rootNode = rootNode

    self.txtName = rootNode:getChildByName("Text_name")
    self.txtFangKa = rootNode:getChildByName("Text_fangKa")


    self.btnCreate = rootNode:getChildByName("Button_create")
    self.btnJoin = rootNode:getChildByName("Button_join")
    self.btncreateAlready = rootNode:getChildByName("Button_createAlready")
    --------------  
    self.btnRecord = rootNode:getChildByName("Button_record")
    self.btnRules = rootNode:getChildByName("Button_rules")
    self.btnCardAdd = rootNode:getChildByName("Button_cardAdd")
    self.btnSetting = rootNode:getChildByName("Button_setting")

    self.btnSetting:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            layerMgr.boxes[layerMgr.boxIndex.SettingBox] = import(".SettingBox",CURRENT_MODULE_NAME).create()
        end

        )


    self.btnCreate:onClicked(
    function ()
    --cgpTest
    --[[
        startGame (1,1),连接游戏服务器成功(1,100)后弹出设置界面,(1,4)创建房间，1,104成功后显示房间

        改：
        先显示界面，点创建界面的创建按钮，连网络(startGame)，连接成功时， 发创建参数
    ]]
        musicMgr:playEffect("game_button_click.mp3", false)     
        dataMgr.roomSet.bIsCreate = 1
        dataMgr.joinPeople = 0
        dataMgr.playerStatus = 0


        layerMgr.boxes[layerMgr.boxIndex.CreateRoomBox] = import(".CreateRoomBox",CURRENT_MODULE_NAME).create()
        --self:startGame(netTb.ip, netTb.port.game, netTb.SocketType.Game)  
        local playLayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer, params)
        playLayer:createRefresh()
        playLayer:setVisible(false)
        --layerMgr:showLayer(layerMgr.layIndex.PlayLayer, params)
        --self:showCreateRoom()
        --dataMgr.roomSet.bIsCreate = 1
        --layerMgr.boxes[layerMgr.boxIndex.CreateRoomBox] = import(".CreateRoomBox",CURRENT_MODULE_NAME).create()
        --layerMgr:showLayer(layerMgr.layIndex.PlayLayer, params)
    end
    ) 

    self.btnJoin:onClicked(
    function ()
--cgpTest
    --[[
        弹出界面，写完直接发(1, 1)
    ]]
        musicMgr:playEffect("game_button_click.mp3", false)
        dataMgr.roomSet.bIsCreate = 0
        dataMgr.joinPeople = 0
        dataMgr.playerStatus = 0

        --test
        --layerMgr.boxes[layerMgr.boxIndex.JiesuanBox] = import(".JiesuanBox",CURRENT_MODULE_NAME).create()
        layerMgr.boxes[layerMgr.boxIndex.JoinRoomBox] = import(".JoinRoomBox",CURRENT_MODULE_NAME).create()

        local playLayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer, params)
        playLayer:createRefresh()
        playLayer:setVisible(false)
    end
    )  

    --返回房间
    self.btncreateAlready:onClicked(
    function (  )
        musicMgr:playEffect("game_button_click.mp3", false)
        local snd = DataSnd:create(3, 13)
        snd:wrByte(2)   --坐下
        snd:sendData(netTb.SocketType.Game)
        snd:release()
--        musicMgr:playMusic("bgMusic.mp3", true)
        layerMgr:showLayer(layerMgr.layIndex.PlayLayer, params)

    end
    )  
    -------------------
    --打开游戏记录
    self.btnRecord:onClicked(
    function (  )
        musicMgr:playEffect("game_button_click.mp3", false)
        layerMgr.boxes[layerMgr.boxIndex.ZhanJiListBox] = import(".ZhanJiListBox",CURRENT_MODULE_NAME).create()
    end
    )
    -- --打开玩法规则
    self.btnRules:onClicked(
    function (  )
        musicMgr:playEffect("game_button_click.mp3", false)
        layerMgr.boxes[layerMgr.boxIndex.RulesBox] = import(".RulesBox",CURRENT_MODULE_NAME).create()
    end
    )
    self.btnCardAdd:onClicked(
    function (  )
        musicMgr:playEffect("game_button_click.mp3", false)
        layerMgr.boxes[layerMgr.boxIndex.TuiGuangBox] = import(".TuiGuangBox",CURRENT_MODULE_NAME).create()
    end
    )
    --------------

    self:btnCreateOrBack(true)
    --musicMgr:halfMusicVolume()
    --cc.SimpleAudioEngine:getInstance():playMusic("bgMusic.mp3", true)
   -- cc.SimpleAudioEngine:getInstance():setMusicVolume(0.2)
    --print("Music half")
    --local volume = cc.SimpleAudioEngine:getInstance():getMusicVolume()
    --print(volume)
    musicMgr:playMusic("bgMusic.mp3", true)
    --预加载playLayer
    local playLayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer)  
    playLayer:setVisible(false)
end

--创建房间按钮还是返回按钮   true ,创建房间，   false  返回房间
function MainLayer:btnCreateOrBack( isCreate )    
    if isCreate then      --显示创建房间按钮
        self.btnCreate:setVisible(true)
        self.btncreateAlready:setVisible(false)
        self.btnJoin:setTouchEnabled(true)
    else
        self.btncreateAlready:setVisible(true)
        self.btnCreate:setVisible(false)
        self.btnJoin:setTouchEnabled(false)
    end
end

function MainLayer:refresh()
    print("refresh ")
    print(dataMgr.myBaseData.szNickName)
    print(tostring(dataMgr.prop[10]))
    self.txtName:setString(dataMgr.myBaseData.szNickName)
    self.txtFangKa:setString(tostring(dataMgr.prop[10]))  
end

function MainLayer:showCreateRoom(  )
    --local  createRoomBox = import(".CreateRoomBox",CURRENT_MODULE_NAME).create()

end

function MainLayer.creator( )
   return MainLayer.new()
end

-- function MainLayer:refresh(params)
--     -- body
-- end

function MainLayer:startGame(ip, port)
    TTSocketClient:getInstance():startSocket(ip, port, netTb.SocketType.Game)

    local snd = DataSnd:create(1, 1)
    local uid = dataMgr.myBaseData.uid
    local dwPlazaVersion = 65536
    local dwFrameVersion = 65536
    local dwProcessVersion = 65536
    local szPassword = uid
    local szMachineID = uid
    local wKindID = 3
    local wTable = 65535
    local wChair = 65535       
    --为密码，实际总的tableId为：wChair * 65536 + wTable
    --创建房间发满的，加入房间发实际的

    snd:wrDWORD(dwPlazaVersion)
    snd:wrDWORD(dwFrameVersion)
    snd:wrDWORD(dwProcessVersion)
    snd:wrDWORD(dataMgr.myBaseData.dwUserID)
    snd:wrString(szPassword, 66) 
    snd:wrString(szMachineID, 66) 
    snd:wrWORD(wKindID) 

    snd:wrWORD(wTable)  
    snd:wrWORD(wChair) 
    snd:sendData(netTb.SocketType.Game)
    snd:release();
end

return MainLayer
