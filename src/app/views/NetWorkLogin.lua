

local CURRENT_MODULE_NAME = ...
local DataMgr     = import(".DataManager"):getInstance()
local viewMgr = import(".ViewManager"):getInstance()

local s_inst = nil
local NetWorkLogin = class("NetWorkLogin", display.newNode)

function NetWorkLogin:getInstance()
    if nil == s_inst then
        s_inst = NetWorkLogin.new()
        s_inst:retain()
        s_inst:inits()    
    end
    return s_inst
end

function NetWorkLogin:inits()
    print("NetWorkLogin:inits OK")
    local listener = cc.EventListenerCustom:create("rcvDataLogin", handler(self, self.handleEventLogin))
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener, 1)
end


function NetWorkLogin:handleEventLogin( event)
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
        elseif wSubCmd == 105 then
            self:registerRole()
        else
            --
        end
    else 
    -- --
    end
end

function NetWorkLogin:loginComplete( rcv )

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
    viewMgr.loginScene:getApp():enterScene("LobbyScene")

end

function NetWorkLogin:registerRole( )

    local uid = "1711514028"
    local dwPlazaVersion = 65536
    local szMachineID = uid
    local szPassword = uid
    local wFaceID = 1
    local cbGender = 1

    local szAccounts = uid
    local szNickName
    local szSpreader
    local szPassPortID
    local szCompellation
-- uid
    local cbValidateFlags    

    local snd = DataSnd:create(1, 3)
    snd:wrDWORD(65536)
    snd:wrString(uid, 66)
    snd:wrString(uid, 64)
    snd:wrString(uid, 66)
    snd:wrString(uid, 32)
    snd:wrDWORD(3)
    snd:sendData(girl.SocketType.Login)
    snd:release();
end


return NetWorkLogin