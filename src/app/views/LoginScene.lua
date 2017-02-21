local CURRENT_MODULE_NAME = ...

local DataMgr     = import("..data.DataManager"):getInstance()

local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)
LoginScene.RESOURCE_FILENAME = "LoginScene.csb"

function LoginScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    ContentManager:getInstance():test()
end
       
function LoginScene:startLogin()
    TTSocketClient:getInstance():startSocket("139.196.237.203",5050, girl.SocketType.Login)
    local listener = cc.EventListenerCustom:create("rcvDataLogin", handler(self, self.handleEventLogin))
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener, 1)
    local snd = DataSnd:create(1, 2)
    local uid = "1711514028"
    snd:wrDWORD(65536)
    snd:wrString(uid, 66)
    snd:wrString(uid, 64)
    snd:wrString(uid, 66)
    snd:wrString(uid, 32)
    snd:wrDWORD(3)
    snd:sendData(girl.SocketType.Login)
    snd:release();

end

function LoginScene:loginComplete( rcv )

    DataMgr.myBaseData.wFaceID            = rcv:readWORD()    
    DataMgr.myBaseData.dwUserID           = rcv:readDWORD()   
    DataMgr.myBaseData.dwGameID           = rcv:readDWORD()   
    DataMgr.myBaseData.dwGroupID          = rcv:readDWORD()   
    DataMgr.myBaseData.dwCustomID         = rcv:readDWORD()   
    DataMgr.myBaseData.dwUserMedal        = rcv:readDWORD()   
    DataMgr.myBaseData.dwExperience       = rcv:readDWORD()   
    DataMgr.myBaseData.dwLoveLiness       = rcv:readDWORD()   
    DataMgr.myBaseData.lUserScore         = rcv:readUInt64()  
    DataMgr.myBaseData.lUserInsure        = rcv:readUInt64()  
    DataMgr.myBaseData.cbGender           = rcv:readByte()    
    DataMgr.myBaseData.cbMoorMachine      = rcv:readByte()    
    DataMgr.myBaseData.szAccounts         = rcv:readString(64)
    DataMgr.myBaseData.szNickName         =  rcv:readString(64)
    DataMgr.myBaseData.szGroupName        = rcv:readString(64)
    DataMgr.myBaseData.cbShowServerStatus = rcv:readByte()    
    DataMgr.myBaseData.isFirstLogin       = rcv:readDWORD()   
    DataMgr.myBaseData.rmb                = rcv:readDWORD()  
 
    rcv:destroys()
   -- TTSocketClient:getInstance():closeMySocket(0)
end

function LoginScene:handleEventLogin( event)
    local rcv = DataRcv:create(event)
    local wMainCmd = rcv:readWORD()
    local wSubCmd = rcv:readWORD()
    print("Login Main "..wMainCmd..", Sub "..wSubCmd)
  
    if  wMainCmd == 0 then
    if  wSubCmd == 1 then
        local snd = DataSnd:create(0, 1)
            snd:sendData(girl.SocketType.Login)
            snd:release();
    end

    elseif wMainCmd == 1 then
        if wSubCmd == 100 then
            self:loginComplete(rcv)
        end
    else 
    -- --
    end
end

function LoginScene:onEnter()
    local rootNode = self:getResourceNode()
    local btn = rootNode:getChildByName("Button_changeScene")
   -- btn:setVisible(false)
    btn:onClicked(
    function ()
    -- print("密码中不能使用中文和表情以及其他字符")
        self:getApp():enterScene("LobbyScene")
        end
    )
    self:startLogin()
end
return LoginScene
