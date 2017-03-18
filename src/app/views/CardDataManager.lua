local CURRENT_MODULE_NAME = ...


local s_inst = nil
local CardDataManager = class("CardDataManager")

function CardDataManager:getInstance()
    if nil == s_inst then
        s_inst = CardDataManager.new()
        s_inst:init()
    end
    return s_inst
end

function CardDataManager:init()
    self.cardSend = {}
    self.cardSend.cbCardData = {}
    self.cardSend.cbHuaCardData = {}
    --[[
         wBankerUser             
        wCurrentUser
        wReplaceUser
              bSice1
              bSice2
        cbUserAction
        cbCardData[14];    
        cbHuaCardData[14];
        bLianZhuangCount;  
     ]]
    self.bankClient = nil
end

return CardDataManager
