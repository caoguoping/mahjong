local CURRENT_MODULE_NAME = ...

local DataMgr     = import("..data.DataManager"):getInstance()


local LobbyScene = class("LobbyScene", cc.load("mvc").ViewBase)
LobbyScene.RESOURCE_FILENAME = "NewLobby.csb"

function LobbyScene:onCreate()
    print("resource node = "..tostring(self:getResourceNode()))
   
    --[[ you can create scene with following comment code instead of using csb file.
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)
    ]]
end

function LobbyScene:onEnter()
    local rootNode = self:getResourceNode()
   -- print("helo helo heolo######"..DataMgr.myBaseData.dwUserID)
        local scroll = rootNode:getChildByName("ScrollView_button")
        local btnPlayGold = scroll:getChildByName("Button_playGold")
        btnPlayGold:onClicked(
        function ()
            self:startGame("139.196.237.203",5010)
        end
        )   
end

function LobbyScene:startGame(ip, port)
    TTSocketClient:getInstance():startSocket(ip, port, girl.SocketType.Game)
    local listener = cc.EventListenerCustom:create("rcvDataGame", handler(self, self.handleEventGame))
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener, 1)
    local snd = DataSnd:create(1, 1)
    local uid = "1711514028"
    snd:wrDWORD(65536)
    snd:wrDWORD(65536)
    snd:wrDWORD(65536)
    print("dwUserID  "..DataMgr.myBaseData.dwUserID)
    snd:wrDWORD(DataMgr.myBaseData.dwUserID)
    snd:wrString(uid, 66)  --password
    snd:wrString(uid, 66)  --machineId
    snd:wrWORD(2) --kindId
    snd:wrWORD(65535)  --wTableId
    snd:wrWORD(65535)  --wChairId
    snd:sendData(girl.SocketType.Game)
    snd:release();
end

function LobbyScene:handleEventGame( event)
    local rcv = DataRcv:create(event)
    local wMainCmd = rcv:readWORD()
    local wSubCmd = rcv:readWORD()
    print("Game:Main "..wMainCmd..", Sub "..wSubCmd)
    
    if wMainCmd == 0 then
    --心跳
        if wSubCmd == 1 then
        local snd = DataSnd:create(0, 1)
          snd:sendData(girl.SocketType.Game)
          snd:release();
        end

    elseif wMainCmd == 1 then
        if wSubCmd == 100 then
            self:loginComplete(rcv)
        end

    else 
    --
    end
end


return LobbyScene
