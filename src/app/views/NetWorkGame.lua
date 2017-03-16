

local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local cardDataMgr     = import(".CardDataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()

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
            if dataMgr.roomSet.bIsCreate == 1 then
                self:connectSuccessCreate(rcv)
            elseif dataMgr.roomSet.bIsCreate == 0 then
                self:connectSuccessJoin(rcv)
            end
            
        elseif wSubCmd == 104 then
            self:createSuccess(rcv) 
        end
    elseif wMainCmd == 3 then
        if wSubCmd == 102 then
            self:sitDown(rcv)
        elseif wSubCmd == 100 then
            self:playerCome(rcv) 
        end

        --200,1 出牌，一个byte
    elseif wMainCmd == 200 then
            if wSubCmd == 100 then --发牌
                self:sendCard(rcv)
            elseif wSubCmd == 101 then --出牌
                self:rcvOutCard(rcv)
    else 
            end    
    --
    end
end

--发牌
function NetWorkGame:sendCard( rcv )
    cardDataMgr.cardSend.wBankerUser    = rcv:readWORD()               --庄家用户
    cardDataMgr.cardSend.wCurrentUser   = rcv:readWORD()               --当前用户
    cardDataMgr.cardSend.wReplaceUser   = rcv:readWORD()               --补牌用户
    cardDataMgr.cardSend.bSice1         = rcv:readByte()   
    cardDataMgr.cardSend.bSice2         = rcv:readByte()
    cardDataMgr.cardSend.cbUserAction   = rcv:readByte()               --用户动作
    for i=1,14 do
        cardDataMgr.cardSend.cbCardData[i] = rcv:readByte()
    end
    for i=1,14 do
        cardDataMgr.cardSend.cbHuaCardData[i] = rcv:readByte()
    end
    cardDataMgr.cardSend.bLianZhuangCount = rcv:readByte()                        --连庄计数
    layerMgr:getLayer(layerMgr.layIndex.PlayLayer):sendCard()
    rcv:destroys()
end

--收到用户出牌
function NetWorkGame:rcvOutCard( rcv )
    local outCard = {}
    outCard.wOutCardUser = rcv:readWORD()
    outCard.bOutCardData = rcv:readByte()
    rcv:destroys()
    layerMgr:getLayer(layerMgr.layIndex.PlayLayer):rcvOutCard(outCard)
end

--创建房间连接成功
function NetWorkGame:connectSuccessCreate( rcv )
    -- local mainLayer = layerMgr:getLayer(layerMgr.layIndex.MainLayer)
    -- mainLayer:showCreateRoom()
    layerMgr.boxes[1] = import(".CreateRoomBox",CURRENT_MODULE_NAME).create()

end

--加入房间连接成功
function NetWorkGame:connectSuccessJoin( rcv )
    rcv:destroys()
    local delay = cc.DelayTime:create(1.0)
    local action = cc.Sequence:create(delay, cc.CallFunc:create(
        function (  )
            layerMgr:removeBoxes(layerMgr.boxIndex.JoinRoomBox)
            layerMgr:showLayer(layerMgr.layIndex.PlayLayer, params)  
        end))
    self:runAction(action)

end

--创建房间成功
function NetWorkGame:createSuccess( rcv )
    local wTableId = rcv:readWORD()
    local wChairId = rcv:readWORD()
    rcv:destroys()
    dataMgr.roomSet.wChair = wChairId
    dataMgr.roomSet.wTable = wTableId
    layerMgr:removeBoxes(layerMgr.boxIndex.CreateRoomBox)
    layerMgr:showLayer(layerMgr.layIndex.PlayLayer, params)
    layerMgr:getLayer(layerMgr.layIndex.PlayLayer, params):waitJoin()

end

function NetWorkGame:sitDown( rcv )
    local dwUserId = rcv:readDWORD()
    local wTableId = rcv:readWORD()
    local wChairId = rcv:readWORD()
    local cbUserStatus = rcv:readByte()
    rcv:destroys()
    if dataMgr.myBaseData.dwUserID == dwUserId and cbUserStatus == 2 then
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
    dataMgr.onDeskData[svrChair].dwGameID      = dwGameID     
    dataMgr.onDeskData[svrChair].dwUserID      = dwUserID     
    dataMgr.onDeskData[svrChair].dwGroupID     = dwGroupID    
    dataMgr.onDeskData[svrChair].wFaceID       = wFaceID      
    dataMgr.onDeskData[svrChair].dwCustomID    = dwCustomID   
    dataMgr.onDeskData[svrChair].cbGender      = cbGender     
    dataMgr.onDeskData[svrChair].cbMemberOrder = cbMemberOrder
    dataMgr.onDeskData[svrChair].cbMasterOrder = cbMasterOrder
    dataMgr.onDeskData[svrChair].cbUserStatus  = cbUserStatus 
    dataMgr.onDeskData[svrChair].wTableID      = wTableID     
    dataMgr.onDeskData[svrChair].wChairID      = wChairID     
    dataMgr.onDeskData[svrChair].lScore        = lScore       
    dataMgr.onDeskData[svrChair].lGrade        = lGrade       
    dataMgr.onDeskData[svrChair].lInsure       = lInsure      
    dataMgr.onDeskData[svrChair].dwWinCount    = dwWinCount   
    dataMgr.onDeskData[svrChair].dwLostCount   = dwLostCount  
    dataMgr.onDeskData[svrChair].dwDrawCount   = dwDrawCount  
    dataMgr.onDeskData[svrChair].dwFleeCount   = dwFleeCount  
    dataMgr.onDeskData[svrChair].dwUserMedal   = dwUserMedal  
    dataMgr.onDeskData[svrChair].dwExperience  = dwExperience 
    dataMgr.onDeskData[svrChair].lLoveLiness   = lLoveLiness  
    dataMgr.onDeskData[svrChair].nick1         = nick1        
    dataMgr.onDeskData[svrChair].nick2         = nick2        
    dataMgr.onDeskData[svrChair].szNickName    = szNickName   
--客户端chairId赋值
    if dataMgr.myBaseData.dwUserID == dwUserId then
        local svrChairId = wChairID + 1    --从1开始, 1, 4
        dataMgr.chair[svrChairId] = 1
        local index = svrChairId
        for i=2,4 do
            index = index + 1
            if index > 4 then
                index = 1
            end
            dataMgr.chair[index] = i
        end
    end
end

return NetWorkGame