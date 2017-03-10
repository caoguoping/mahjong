

local CURRENT_MODULE_NAME = ...
local DataMgr     = import(".DataManager"):getInstance()
local LayerMgr = import(".LayerManager"):getInstance()

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
                snd:sendData(netTb.SocketType.Login)
                snd:release();
        end

    elseif wMainCmd == 1 then
        if wSubCmd == 100 then
            self:loginComplete(rcv)
        elseif wSubCmd == 105 then
            self:registerRole(rcv)
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
    DataMgr.myBaseData.szNickName         = rcv:readString(64)
    DataMgr.myBaseData.szGroupName        = rcv:readString(64)
    DataMgr.myBaseData.cbShowServerStatus = rcv:readByte()    
    DataMgr.myBaseData.isFirstLogin       = rcv:readDWORD()   
    DataMgr.myBaseData.rmb                = rcv:readDWORD()  
    rcv:destroys()

    LayerMgr:showLayer(LayerMgr.Enum.MainLayer)

end

function NetWorkLogin:registerRole( rcv)
    local uid = DataMgr.myBaseData.uid
    local dwPlazaVersion = 65536
    local szMachineID = "aaaaaa"
    local szLogonPass = uid
    local szInsurePass = uid
    local wFaceID = 1
    local cbGender = 1
    local szAccounts = uid
    local szNickName = uid
    local szSpreader = ""
    local szPassPortID = ""
    local szCompellation = ""
    local cbValidateFlags    
    local snd = DataSnd:create(1, 3)
    snd:wrDWORD(dwPlazaVersion)
    snd:wrString(szMachineID, 66)
    snd:wrString(szLogonPass, 66)
    snd:wrString(szInsurePass, 66)
    snd:wrWORD(wFaceID)
    snd:wrByte(cbGender)
    snd:wrString(szAccounts, 64)
    snd:wrString(szNickName, 64)
    snd:wrString(szSpreader, 64)
    snd:wrString(szPassPortID, 38)
    snd:wrString(szCompellation, 32)
    snd:wrString(uid, 32)
    snd:wrByte(3)
    snd:sendData(netTb.SocketType.Login)
    snd:release();
    rcv:destroys()
end


return NetWorkLogin