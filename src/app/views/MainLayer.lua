--大厅界面

local CURRENT_MODULE_NAME = ...

local DataMgr     = import(".DataManager"):getInstance()
local LayerMgr= import(".LayerManager"):getInstance()

local MainLayer = class("MainLayer", display.newLayer)

function MainLayer:ctor()
    local rootNode = cc.CSLoader:createNode("NewLobby.csb"):addTo(self)
    self.rootNode = rootNode
    local btnCreate = rootNode:getChildByName("Button_create")
    local btnJoin = rootNode:getChildByName("Button_join")
    btnCreate:onClicked(
    function ()
        self:startGame("139.196.237.203",5010)
        LayerMgr:showLayer(LayerMgr.Enum.PlayLayer, params)
    end
    ) 
    btnJoin:onClicked(
    function ()
        self:startGame("139.196.237.203",5010)
        LayerMgr:showLayer(LayerMgr.Enum.PlayLayer, params)
    end
    )    

end

function MainLayer:createRoom(  )
    
end

function MainLayer.creator( )
   return MainLayer.new()
end

function MainLayer:refresh(params)
    -- body
end

function MainLayer:startGame(ip, port)
    TTSocketClient:getInstance():startSocket(ip, port, netTb.SocketType.Game)

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
    snd:sendData(netTb.SocketType.Game)
    snd:release();
end

return MainLayer
