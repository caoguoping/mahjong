

local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()



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

function NetWorkLogin:loginFail( rcv )
    TTSocketClient:getInstance():closeMySocket(netTb.SocketType.Login)
    local popupbox =  import(".popUpBox",CURRENT_MODULE_NAME).create() 
    popupbox:setInfo(Strings.connectLoginFail)
    local btnOk  = popupbox:getBtns(1)
    btnOk:onClicked(function (  )
    popupbox:remove()
    end)

end

function NetWorkLogin:handleEventLogin( event)
    local rcv = DataRcv:create(event)
    local wMainCmd = rcv:readWORD()
    local wSubCmd = rcv:readWORD()
    --print("Login Main "..wMainCmd..", Sub "..wSubCmd)
  
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
        elseif wSubCmd == 101 then
            self:loginFail(rcv)
        elseif wSubCmd == 108 then         ---游戏登录，向服务器获取该玩家的历史记录
            self:HistroyRecordsByLogin(rcv)
        elseif wSubCmd == 107 then
            self:Zhanji(rcv)
        elseif wSubCmd == 106 then
            self:TuiGuang(rcv)
        elseif wSubCmd == 109 then  
            self:checkBind(rcv)  
        end
    elseif wMainCmd == 3 then
            if wSubCmd == 502 then
               self:propChange(rcv)
            --充值返回值  0：成功  ，   其他失败
            elseif wSubCmd == 500 then
                self:getBagInfo(rcv)
            elseif wSubCmd == 506 then
                self:propChange(rcv)   --道具变更

            elseif wSubCmd == 515 then
                self:getShopInfo(rcv)
            --todo
            elseif wSubCmd == 854 then
                self:getChargeResult(rcv)
            end

    else
    -- --
    end
end

function NetWorkLogin:getChargeResult( rcv )
    local result = rcv:readDWORD()
    if result == 0 then
        --成功
        print("charge success!")
    else
        print("charge fail")
    end

end


--背包(3, 500)
function NetWorkLogin:getBagInfo( rcv )
    local bagSize = rcv:readByte()
    print("bagSize "..bagSize)

    for i=1,bagSize do
        local kindId = rcv:readWORD()
        local propCount = rcv:readWORD()
        print("kindId propcount")
        print(kindId)
        print(propCount)
        dataMgr.prop[kindId] = propCount
    end

    layerMgr:getLayer(layerMgr.layIndex.MainLayer, params).txtFangKa:setString(tostring(dataMgr.prop[10]))
end



-- //商城信息
-- struct Shop_Info
-- {
--     WORD       ID         ;                点击了第几个
--     WORD       ProtoID    ;                //商品ID 10
--     WORD       Cnt         ;                        //商品数量
--     WORD       RCnt       ;                   //真实数量
--     WORD       Cost       ;                       //商品价格
--     WORD       RCost       ;                  //实际价格
--     char       ProtoName[32];          //商品名称
-- };

--商店目录
function NetWorkLogin:getShopInfo( rcv )    
    local shopCount = rcv:readWORD()     --商品数量
    if shopCount > 6 then
        shopCount = 6
    end
    print("shopCount ")
    print(shopCount)
    dataMgr.shoppingCount = shopCount
    for i=1,shopCount do
        dataMgr.shoppingData[i] = {}
        dataMgr.shoppingData[i].ID        = rcv:readWORD()
        dataMgr.shoppingData[i].ProtoID   = rcv:readWORD()
        dataMgr.shoppingData[i].Cnt       = rcv:readWORD()
        dataMgr.shoppingData[i].RCnt      = rcv:readWORD()
        dataMgr.shoppingData[i].Cost      = rcv:readWORD()
        dataMgr.shoppingData[i].RCost     = rcv:readWORD()
        dataMgr.shoppingData[i].ProtoName = rcv:readString(64)
        print("protoName")
        print(dataMgr.shoppingData[i].ProtoName)
    end
end
 
--道具变更 3, 506     
function NetWorkLogin:propChange( rcv )

    local kindId = rcv:readWORD()
    local count = rcv:readWORD()     --总数
    dataMgr.prop[kindId] = count
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  3, 506   propChange,  prop[10]")
    print("kindId "..kindId.."count "..count)
    if dataMgr.prop[10] == dataMgr.buy.cardSave then  --没有变化
        dataMgr.buy.isCardChange = false
    else
        dataMgr.buy.isCardChange = true
    end
    local mainLayer = layerMgr:getLayer(layerMgr.layIndex.MainLayer)
    mainLayer:refresh()
    if layerMgr.boxes[layerMgr.boxIndex.ShoppingBox] then
        print("shoppingBox ############")
        layerMgr.boxes[layerMgr.boxIndex.ShoppingBox]:refresh()
    end
end



--战绩, 1, 107
function NetWorkLogin:Zhanji( rcv )
    local wCount = rcv:readWORD()  -- 战绩总条数
    local wFlag = rcv:readWORD()    -- 分包情况使用 超过50条 0 - 不是最后一条 1 - 最后一条  当前应该不要用
    rcv:readDWORD()
    print("wCount",wCount)
    print("wFlag",wFlag)
    print("IndexRecords"..dataMgr.IndexRecords)
    dataMgr.HistroyRecords[dataMgr.IndexRecords].Records = {} 
    for i = 1, wCount do
        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i] = {}             
        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].username1 = rcv:readString(64)
        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].username2 = rcv:readString(64)
        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].username3 = rcv:readString(64)
        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].username4 = rcv:readString(64)

        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].lScore1 = rcv:readUInt64()
        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].lScore2 = rcv:readUInt64()
        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].lScore3 = rcv:readUInt64()
        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].lScore4 = rcv:readUInt64()

        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].dwUserID1 = rcv:readDWORD()
        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].dwUserID2 = rcv:readDWORD()
        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].dwUserID3 = rcv:readDWORD()
        dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].dwUserID4 = rcv:readDWORD()
       
        print("username1",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].username1)
        print("score1",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].lScore1)
        print("userid1",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].dwUserID1)
                        print("username2",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].username2)
        print("score2",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].lScore2)
        print("userid2",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].dwUserID2)
                        print("username3",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].username3)
        print("score3",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].lScore3)
        print("userid3",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].dwUserID3)
                        print("username4",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].username4)
        print("score4",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].lScore4)
        print("userid4",dataMgr.HistroyRecords[dataMgr.IndexRecords].Records[i].dwUserID4)
       
    end

end   

---推广，1，106
function NetWorkLogin:TuiGuang ( rcv )
    local result = rcv:readDWORD()

    local popupbox =  import(".popUpBox",CURRENT_MODULE_NAME).create() 

    if result == 0 then
        --成功
        print("charge success!")
        dataMgr.myBaseData.isBind = 1
        popupbox:setInfo(Strings.tuiGuangSuccess)
        local btnOk = popupbox:getBtns(1)
        btnOk:onClicked(function (  )
            popupbox:remove()
            layerMgr:showLayer(layerMgr.layIndex.MainLayer, params)
        end)
    elseif result == 1 then
        popupbox:setInfo(Strings.tuiGuangFailOne)
        local btnOk = popupbox:getBtns(1)
        btnOk:onClicked(function (  )
            popupbox:remove()
            -- layerMgr:showLayer(layerMgr.layIndex.MainLayer, params)
        end)
    elseif result == 2 then
        popupbox:setInfo(Strings.tuiGuangFailTwo)
        local btnOk = popupbox:getBtns(1)
        btnOk:onClicked(function (  )
            popupbox:remove()
            -- layerMgr:showLayer(layerMgr.layIndex.MainLayer, params)
        end)
    elseif result == 3 then
        popupbox:setInfo(Strings.tuiGuangFailThree)
        local btnOk = popupbox:getBtns(1)
        btnOk:onClicked(function (  )
            popupbox:remove()
            layerMgr:showLayer(layerMgr.layIndex.MainLayer, params)
        end)
    end 
end

--- 检测是否可以绑定  1, 109
function NetWorkLogin:checkBind( rcv )
    local  isBind = rcv:readWORD()
    dataMgr.myBaseData.isBind = isBind
end

---游戏登录，向服务器获取该玩家的历史记录 1, 108
function NetWorkLogin:HistroyRecordsByLogin( rcv )
    local wCount = rcv:readWORD()  -- 战绩总条数
    local wFlag = rcv:readWORD()    -- 分包情况使用 超过50条 0 - 不是最后一条 1 - 最后一条       
    --2个空字节
    print("wCount",wCount)
    rcv:readDWORD()
    local data = dataMgr.HistroyRecords
    if wFlag == 0 then
        for i= data.ItemCount+1, data.ItemCount+50 do 
            data[i] = {}
            --data[i].wTable = rcv:readUInt64()
            data[i].lScore = rcv:readUInt64()
            data[i].wTableID = rcv:readDWORD()
            data[i].wData = rcv:readDWORD()
            data[i].cbType = rcv:readByte()

            -- 7个空字节
             rcv:readDWORD()
             rcv:readWORD()
             rcv:readByte()
        end
        data.ItemCount = data.ItemCount + 50
    elseif wFlag == 1 then
        for i = 1, wCount do 
            data[i] = {}
            data[i].lScore = rcv:readUInt64()
            data[i].wTableID = rcv:readDWORD()
            data[i].wData = rcv:readDWORD()
            data[i].cbType = rcv:readByte() 
            -- 7个空字节
            rcv:readDWORD()
            rcv:readWORD()
            rcv:readByte()
            print(data[i].wTableID)
        end 
        data.ItemCount = wCount
        print(wCount)
    end 
end


function NetWorkLogin:loginComplete( rcv )

    dataMgr.myBaseData.wFaceID            = rcv:readWORD()    
    dataMgr.myBaseData.dwUserID           = rcv:readDWORD()   
    dataMgr.myBaseData.dwGameID           = rcv:readDWORD()   
    dataMgr.myBaseData.dwGroupID          = rcv:readDWORD()   
    dataMgr.myBaseData.dwCustomID         = rcv:readDWORD()   
    dataMgr.myBaseData.dwUserMedal        = rcv:readDWORD()   
    dataMgr.myBaseData.dwExperience       = rcv:readDWORD()   
    dataMgr.myBaseData.dwLoveLiness       = rcv:readDWORD()   
    dataMgr.myBaseData.lUserScore         = rcv:readUInt64()  
    dataMgr.myBaseData.lUserInsure        = rcv:readUInt64()  
    dataMgr.myBaseData.cbGender           = rcv:readByte()    
    dataMgr.myBaseData.cbMoorMachine      = rcv:readByte()    
    dataMgr.myBaseData.szAccounts         = rcv:readString(64)
    --dataMgr.myBaseData.szNickName         = rcv:readString(64)
    rcv:readString(64)
    dataMgr.myBaseData.szGroupName        = rcv:readString(64)
    dataMgr.myBaseData.cbShowServerStatus = rcv:readByte()    
    dataMgr.myBaseData.isFirstLogin       = rcv:readDWORD()   
    dataMgr.myBaseData.rmb                = rcv:readDWORD()  
    rcv:destroys()

    layerMgr:showLayer(layerMgr.layIndex.MainLayer)
    --musicMgr:playMusic("bg.mp3", true)
    local mainLayer = layerMgr:getLayer(layerMgr.layIndex.MainLayer)

    --显示mainLayer的剪切头像
    mainLayer:cutHeadImg()

    mainLayer:refresh()

    --自动启动房间
    if dataMgr.roomSet.autoJoin == 1 then
        mainLayer:btnJoinRoom()
    end

end

function NetWorkLogin:registerRole( rcv)
    local uid = dataMgr.myBaseData.uid
    local dwPlazaVersion = 65536
    local szMachineID = "aaaaaa"
    local szLogonPass = uid
    local szInsurePass = uid
    local wFaceID = 1
    local cbGender = dataMgr.myBaseData.cbGender
    local szAccounts = uid
    local szNickName = dataMgr.myBaseData.szNickName
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
    if  device.platform == "android" then

    else
        
    end
    snd:wrString(dataMgr.myBaseData.headimgurl, 200)
    snd:wrString(dataMgr.myBaseData.unionId, 64)
    print("unionId ")
    print(dataMgr.myBaseData.unionId)
    snd:wrByte(3)

    snd:sendData(netTb.SocketType.Login)
    snd:release();
    rcv:destroys()
end


return NetWorkLogin