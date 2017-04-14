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
--数组下标拷贝
    --[[
    [1 ]  = 
    [2 ]  = 
    [3 ]  = 
    [4 ]  = 
    [5 ]  = 
    [6 ]  = 
    [7 ]  = 
    [8 ]  = 
    [9 ]  = 
    [10] = 
    [11] = 
    [12] = 
    [13] = 
    [14] = 
    [15] = 
    [16] = 
    [17] = 
    [18] = 
    [19] = 
    [20] = 
    [21] = 
    ]]

--playerStatus
    --0, 游戏前，   1, 游戏中，    2，   游戏结束
    self.playerStatus = 0
    self.isNormalEnd = true    --true  单局结算   false   总结算

    self.prop = {}    --道具，，下标为道具ID， 值为数量
    self.prop[10] = 0
    --[[
        10:房卡
    ]]

--myBaseData
    self.myBaseData = {}
    self.myBaseData.cbGender = 2    --男，   2，女
    self.myBaseData.young = 1     --1,青年，   2,老年
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
        cbGender  --性别        
        cbMoorMachine     
        szAccounts        
        szNickName        
        szGroupName       
        cbShowServerStatus
        isFirstLogin      
        rmb   
        --
        headimgurl
        city         
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
    --下标为服务器Id, 值为客户端ID  chair下标传入1， 4，即服务器chairId + 1
    --[[
    server
            2
        1        3
            0
    client（固定不变)
            3
        2        4
            1

    direction(每局都变),  --下标为客户端ID ， 值为方位
              1(东)
        2(南)        4
              3

    

    ]]
    self.chair = {}  
    self.direction = {}  --东南西北（1， 2， 3， 4) 东为庄家
--roomSet
    self.roomSet = {} 
     --[[
    比下胡： 连庄(0bit)，包牌，花杠，        对对胡，杠后开花， 黄庄，
            天胡， 地胡， 全求独钓，     对对胡，杠后开花， 黄庄(11bit)
    wScore;                                         //总分数    100， 200， 300
    wJieSuanLimit;                          //单局结算上限      0：无限制，    100 ：100翻
    wBiXiaHu;                                       //比下胡 12bit
    bGangHouKaiHua;                                 //杠后开花  0：翻倍        1：加20花
    bZaEr;                                          //砸二      0：不砸2，     1：砸2
    bFaFeng;                                        //罚分      0：不罚分，    1：罚
    bYaJue;                                         //压绝    3bit  自己对的牌(0bit), 别人对的牌，  已打出的牌(2bit)  
    bJuShu;                                         //局数     1：1圈，   2:2圈，   4:4圈
    bIsJinyunzi                                     //是否进园子 1：进园子   ，   0:敞开头   

    以下不在发送数组里面
    wChair   高位，
    wTable
    bIsCreate     1:创建 0:加入
    dwRoomNum     输入的房间号或算好的房间号
    ]] 
    self.IndexRecords = 0       -----检索一场详细游戏数据的HistroyRecords[i]的i值
    self.ThisTableRecords = 0   -----检索本局的历史数据key值，HistroyRecords最后一行数据,0没有开局,游戏一局结算时插入该值
    self.HistroyRecords = {}    -----游戏历史每场详细数据 ----第一维的数据为登录游戏时，服务器发送的历史数据
    self.HistroyRecords.ItemCount = 0           ----ItemCount记录历史数据的条数
    -- for i=1,20 do                                   ----第三维的数据是该场次四个玩家每一局的数据
    --     self.HistroyRecords[i] = {}
    --     self.HistroyRecords[i].wTable = 0            --未分解的数据，包含日期、时间、桌子号
    --     self.HistroyRecords[i].lScore = 0            --该场次的总积分
    --     self.HistroyRecords[i].dwUserID = 0          --用户账号
    --     self.HistroyRecords[i].cbType = 1            --模式，1、进园子 2、敞开怀
    --  self.HistroyRecords[i].Records = {}
    --  for j=1,16 do
    --      self.HistroyRecords[i].Records[j] = {}
    --         for n=1,4 do             ---该场次一局的结算数据，包含4个玩家
    --             self.HistroyRecords[i].Records[j][n] = {}
    --             self.HistroyRecords[i].Records[j][n].lScore = 0         --该局的结算分
    --             self.HistroyRecords[i].Records[j][n].dwUserID = 0       --用户id
    --             self.HistroyRecords[i].Records[j][n].username = "admin"       --用户名
    --         end
    --     end
        
    -- end


    self.zhangJiData = {}
    self.zhangJiCount = 5
    for i=1,16 do
        self.zhangJiData[i] = {}
        for j=1,4 do
            self.zhangJiData[i][j] = {}
            self.zhangJiData[i][j].name = ""
            self.zhangJiData[i][j].dwUserID = 1
            self.zhangJiData[i][j].lScore = 0
        end
    end


    self.gameEnd = {}
    --[[
    
    ]]
    self.timeLeft = 0     --出牌剩余时间
    self.schedulerID = 0   --出牌剩余时间定时器
    self.fangzhuSvr = 1    --谁是房主[1, 4] svr chairId

    self.isMusicOn = true
    self.isEffectOn = true

end

function DataManager:getServiceChairId( clientId )
    for i=1,4 do
        if self.chair[i] == clientId then
            return i  --服务器为[1, 4]
        end
    end
end

--svrId 1,4    
function DataManager:getSvrIdByUserId( dwUserID )
    for k, v in pairs(self.onDeskData) do
        if v.dwUserID == dwUserID then
            return k
        end
    end


end

return DataManager
