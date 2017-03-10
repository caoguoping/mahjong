

local CURRENT_MODULE_NAME = ...
local DataMgr     = import(".DataManager"):getInstance()

local s_inst = nil
local NetWorkGame = class("NetWorkGame", display.newNode)

function NetWorkGame:getInstance()
    if nil == s_inst then
        s_inst = NetWorkGame.new()
        s_inst:retain()
        s_inst:inits()    
    end
    return s_inst
end

function NetWorkGame:inits()
    print("NetWorkGame:inits OK")
    local listener = cc.EventListenerCustom:create("rcvDataGame", handler(self, self.handleEventGame))
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener, 1)
end

function NetWorkGame:handleEventGame( event)
    local rcv = DataRcv:create(event)
    local wMainCmd = rcv:readWORD()
    local wSubCmd = rcv:readWORD()
    print("Game:Main "..wMainCmd..", Sub "..wSubCmd)
    
    if wMainCmd == 0 then
    --心跳
        if wSubCmd == 1 then
        local snd = DataSnd:create(0, 1)
          snd:sendData(netTb.SocketType.Game)
          snd:release();
        end

    elseif wMainCmd == 1 then
        if wSubCmd == 100 then
            self:connectSuccess(rcv)
        end

    elseif wMainCmd == 3 then
        if wSubCmd == 102 then
            self:sitDown(rcv)
        elseif wSubCmd == 100 then
            self:playerCome(rcv) 
        end
    else 
    --
    end
end

function NetWorkGame:connectSuccess( rcv )
                  local snd = DataSnd:create(1, 4)
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

dataMgr.roomSet.wScore        
dataMgr.roomSet.wJieSuanLimit 
dataMgr.roomSet.wBiXiaHu      
dataMgr.roomSet.bGangHouKaiHua
dataMgr.roomSet.bZaEr         
dataMgr.roomSet.bFaFeng       
dataMgr.roomSet.bYaJue        
dataMgr.roomSet.bJuShu        
dataMgr.roomSet.bIsJinyunzi   


end

function NetWorkGame:sitDown( rcv )
    local dwUserId = rcv:readDWORD()
    local wTableId = rcv:readWORD()
    local wChairId = rcv:readWORD()
    local cbUserStatus = rcv:readByte()
    if DataMgr.myBaseData.dwUserID == dwUserId and cbUserStatus == 2 then
        --me sitdown ,fresh data
    end
end

function NetWorkGame:playerCome( rcv )
--readData and 赋值
    local dwGameID      = rcv:readDWORD();
    local dwUserID      = rcv:readDWORD();
    local dwGroupID     = rcv:readDWORD();
    local wFaceID       = rcv:readWORD();
    local dwCustomID    = rcv:readDWORD();
    local cbGender      = rcv:readByte();
    local cbMemberOrder = rcv:readByte();
    local cbMasterOrder = rcv:readByte();
    local cbUserStatus  = rcv:readByte();
    local wTableID      = rcv:readWORD();
    local wChairID      = rcv:readWORD();         --0,3
    local lScore        = rcv:readUInt64();
    local lGrade        = rcv:readUInt64();
    local lInsure       = rcv:readUInt64();
    local dwWinCount    = rcv:readDWORD();
    local dwLostCount   = rcv:readDWORD();
    local dwDrawCount   = rcv:readDWORD();
    local dwFleeCount   = rcv:readDWORD();
    local dwUserMedal   = rcv:readDWORD();
    local dwExperience  = rcv:readDWORD();
    local lLoveLiness   = rcv:readDWORD();
    local nick1         = rcv:readWORD();  
    local nick2         = rcv:readWORD();
    local szNickName    = rcv:readString(nick1);
    rcv:destroys()

    local svrChair = wChairID + 1
    if svrChair > 4 or svrChair < 1 then
        print("error: wChairID out of range !")
        return
    end
    print(svrChair)
    DataMgr.onDeskData[svrChair].dwGameID      = dwGameID     
    DataMgr.onDeskData[svrChair].dwUserID      = dwUserID     
    DataMgr.onDeskData[svrChair].dwGroupID     = dwGroupID    
    DataMgr.onDeskData[svrChair].wFaceID       = wFaceID      
    DataMgr.onDeskData[svrChair].dwCustomID    = dwCustomID   
    DataMgr.onDeskData[svrChair].cbGender      = cbGender     
    DataMgr.onDeskData[svrChair].cbMemberOrder = cbMemberOrder
    DataMgr.onDeskData[svrChair].cbMasterOrder = cbMasterOrder
    DataMgr.onDeskData[svrChair].cbUserStatus  = cbUserStatus 
    DataMgr.onDeskData[svrChair].wTableID      = wTableID     
    DataMgr.onDeskData[svrChair].wChairID      = wChairID     
    DataMgr.onDeskData[svrChair].lScore        = lScore       
    DataMgr.onDeskData[svrChair].lGrade        = lGrade       
    DataMgr.onDeskData[svrChair].lInsure       = lInsure      
    DataMgr.onDeskData[svrChair].dwWinCount    = dwWinCount   
    DataMgr.onDeskData[svrChair].dwLostCount   = dwLostCount  
    DataMgr.onDeskData[svrChair].dwDrawCount   = dwDrawCount  
    DataMgr.onDeskData[svrChair].dwFleeCount   = dwFleeCount  
    DataMgr.onDeskData[svrChair].dwUserMedal   = dwUserMedal  
    DataMgr.onDeskData[svrChair].dwExperience  = dwExperience 
    DataMgr.onDeskData[svrChair].lLoveLiness   = lLoveLiness  
    DataMgr.onDeskData[svrChair].nick1         = nick1        
    DataMgr.onDeskData[svrChair].nick2         = nick2        
    DataMgr.onDeskData[svrChair].szNickName    = szNickName   
--客户端chairId赋值
    if DataMgr.myBaseData.dwUserID == dwUserId then
        local svrChairId = wChairID + 1    --从1开始, 1, 4
        DataMgr.chair[svrChairId] = 1
        local index = svrChairId
        for i=2,4 do
            index = index + 1
            if index > 4 then
                index = 1
            end
            DataMgr.chair[index] = i
        end
    end
end

return NetWorkGame