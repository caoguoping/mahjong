local CURRENT_MODULE_NAME = ...
-- classes
--local HeroData      = import(".information.HeroData", CURRENT_MODULE_NAME)

local s_inst = nil
local DataManager = class("DataManager")

function DataManager:getInstance()
    if nil == s_inst then
        s_inst = DataManager.new()
        s_inst:init()
    end
    return s_inst
end

function DataManager:init()
--myBaseData
    self.myBaseData = {}
    --[[
        uid
        wFaceID           
        dwUserID          
        dwGameID          
        dwGroupID         
        dwCustomID        
        dwUserMedal       
        dwExperience      
        dwLoveLiness      
        lUserScore        
        lUserInsure       
        cbGender          
        cbMoorMachine     
        szAccounts        
        szNickName        
        szGroupName       
        cbShowServerStatus
        isFirstLogin      
        rmb               
    ]]
--onDeskData
    --下标为serverChairId
    self.onDeskData = {}
    for i=1,4 do
        self.onDeskData[i] = {}
    end
    --[[
        dwGameID     
        dwUserID     
        dwGroupID    
        wFaceID      
        dwCustomID   
        cbGender     
        cbMemberOrder
        cbMasterOrder
        cbUserStatus 
        wTableID             
        wChairID     
        lScore       
        lGrade       
        lInsure      
        dwWinCount   
        dwLostCount  
        dwDrawCount  
        dwFleeCount  
        dwUserMedal  
        dwExperience 
        lLoveLiness  
        nick1        
        nick2        
        szNickName
        -- szGroupName;szUnderWrite; isClear; 暂时不用
    ]]
--chair  
    --下标为服务器Id, 值为客户端ID  
    --[[
    server
            2
        1        3
            0
    client
            3
        2        4
            1    
    ]]
    self.chair = {}    
end

function DataManager:getServiceChairId( clientId )
    for i=1,4 do
        if self.chair[i] == clientId then
            return i - 1  --服务器为0, 3
        end
    end
end

return DataManager
