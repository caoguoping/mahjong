

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
            --self:loginComplete(rcv)
        end

    else 
    --
    end
end

return NetWorkGame