local CURRENT_MODULE_NAME = ...

local DataMgr     = import(".DataManager"):getInstance()
local NetWorkLogin = import(".NetWorkLogin"):getInstance()
local NetWorkLogin = import(".NetWorkLogin"):getInstance()


local LobbyScene = class("LobbyScene", cc.load("mvc").ViewBase)
LobbyScene.RESOURCE_FILENAME = "NewLobby.csb"

function LobbyScene:onCreate()
    print("resource node = "..tostring(self:getResourceNode()))

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

    local snd = DataSnd:create(1, 1)
    local uid = "1711514028"
    local dwPlazaVersion = 65536
    local dwFrameVersion = 65536
    local dwProcessVersion = 65536
    local szPassword = uid
    local szMachineID = uid
    local wKindID = 2
    local wTable = 65535
    local wChair = 65535

    snd:wrDWORD(dwPlazaVersion)
    snd:wrDWORD(dwFrameVersion)
    snd:wrDWORD(dwProcessVersion)
    snd:wrDWORD(DataMgr.myBaseData.dwUserID)
    snd:wrString(szPassword, 66) 
    snd:wrString(szMachineID, 66) 
    snd:wrWORD(wKindID) 
    snd:wrWORD(wTable)  
    snd:wrWORD(wChair) 
    snd:sendData(girl.SocketType.Game)
    snd:release();
end

return LobbyScene
