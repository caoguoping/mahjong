

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
          snd:sendData(girl.SocketType.Game)
          snd:release();
        end

    elseif wMainCmd == 1 then
        if wSubCmd == 100 then
            --self:loginComplete(rcv)
        end

    elseif wMainCmd == 3 then
        if wSubCmd == 102 then
            self:sitDown(rcv)
        elseif wSubCmd == 100 then
            
        end
    else 
    --
    end
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
    local wChairID      = rcv:readWORD();
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
    if wChairID > 4 or wChairID < 1 then
        print("error: wChairID out of range !")
        return
    end
--
    DataMgr.onDeskData[wChairID].dwGameID      = dwGameID     
    DataMgr.onDeskData[wChairID].dwUserID      = dwUserID     
    DataMgr.onDeskData[wChairID].dwGroupID     = dwGroupID    
    DataMgr.onDeskData[wChairID].wFaceID       = wFaceID      
    DataMgr.onDeskData[wChairID].dwCustomID    = dwCustomID   
    DataMgr.onDeskData[wChairID].cbGender      = cbGender     
    DataMgr.onDeskData[wChairID].cbMemberOrder = cbMemberOrder
    DataMgr.onDeskData[wChairID].cbMasterOrder = cbMasterOrder
    DataMgr.onDeskData[wChairID].cbUserStatus  = cbUserStatus 
    DataMgr.onDeskData[wChairID].wTableID      = wTableID     
    DataMgr.onDeskData[wChairID].wChairID      = wChairID     
    DataMgr.onDeskData[wChairID].lScore        = lScore       
    DataMgr.onDeskData[wChairID].lGrade        = lGrade       
    DataMgr.onDeskData[wChairID].lInsure       = lInsure      
    DataMgr.onDeskData[wChairID].dwWinCount    = dwWinCount   
    DataMgr.onDeskData[wChairID].dwLostCount   = dwLostCount  
    DataMgr.onDeskData[wChairID].dwDrawCount   = dwDrawCount  
    DataMgr.onDeskData[wChairID].dwFleeCount   = dwFleeCount  
    DataMgr.onDeskData[wChairID].dwUserMedal   = dwUserMedal  
    DataMgr.onDeskData[wChairID].dwExperience  = dwExperience 
    DataMgr.onDeskData[wChairID].lLoveLiness   = lLoveLiness  
    DataMgr.onDeskData[wChairID].nick1         = nick1        
    DataMgr.onDeskData[wChairID].nick2         = nick2        
    DataMgr.onDeskData[wChairID].szNickName    = szNickName   

    if DataMgr.myBaseData.dwUserID == dwUserId then
        local svrChairId = wChairID
        DataMgr.chair[svrChairId] = 1
        local index = svrChairId
        for i=1,3 do
            index = index + 1
            if index > 4 then
                index = 1
            end
            DataMgr.chair[index] = i
        end
    end
        if (DATA->myBaseData.dwUserID == result.dwUserID)
        {
            playerInDeskModel->chair[dwSvChairID] = 0;
            DWORD index = dwSvChairID;

            for (DWORD i = 1; i < 4; i++)
            {
                ++index;
                if (index > 3)
                {
                    index = 0;
                }
                playerInDeskModel->chair[index] = i;
            }
            if (DATA->bGameCate == DataManager::E_GameCateMatch)
            {
                blueSkyDispatchEvent(EventType::SHOW_PLAYER_ON_DESK_DATA, data);
            }
            
        }
end

return NetWorkGame