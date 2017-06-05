

local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()



local s_inst = nil
local SDKHelper = class("SDKHelper", display.newNode)

function SDKHelper:getInstance()
    if nil == s_inst then
        s_inst = SDKHelper.new()
        s_inst:retain()
        s_inst:inits()    
    end
    return s_inst
end

function SDKHelper:inits()
    print("SDKHelper:inits OK")
    self.listenerLogin = cc.EventListenerCustom:create("rcvSDKLogin", handler(self, self.handleSDKLogin))
    self.listenerPay = cc.EventListenerCustom:create("rcvSDKPay", handler(self, self.handleSDKPay))
    self.eventDispatcher = self:getEventDispatcher()
    self.eventDispatcher:addEventListenerWithFixedPriority(self.listenerLogin, 1)
    self.eventDispatcher:addEventListenerWithFixedPriority(self.listenerPay, 1)

end

function SDKHelper:handleSDKLogin( event)
    print("handleSDKLogin")
    self.eventDispatcher:removeEventListener(self.listenerLogin)
    local sdkData = SDKLoginData:create(event)
    local openid = sdkData:readOpenid()
    local nickName = sdkData:readNickName()
    local sex = sdkData:readSex()
    local headimgurl = sdkData:readHeadimgurl()
    local strRoomNum = sdkData:readRoomNum()  --房间号
    local hostip = sdkData:readIp()   --手机IP
    local unionId = sdkData:readUnionId()
    local saves = sdkData:readSaves()
    dataMgr.weChat.spbill_create_ip = hostip

    cc.UserDefault:getInstance():setBoolForKey("first_time", false)
    cc.UserDefault:getInstance():setStringForKey("openid", openid)
    cc.UserDefault:getInstance():setStringForKey("nickName", nickName)
    cc.UserDefault:getInstance():setStringForKey("sex", sex)
    cc.UserDefault:getInstance():setStringForKey("headimgurl", headimgurl)
    cc.UserDefault:getInstance():setStringForKey("unionId", unionId)
    cc.UserDefault:getInstance():flush()

    local roomNum = tonumber(strRoomNum)
    print("roomNum   in SDKHelper "..roomNum)
    if roomNum == 0 then   --非自动启动
        dataMgr.roomSet.autoJoin = 0
    else
        dataMgr.roomSet.autoJoin = 1  --自动启动
        dataMgr.roomSet.dwRoomNum = roomNum
    end

    dataMgr.myBaseData.uid = openid
    dataMgr.myBaseData.szNickName = nickName
    dataMgr.myBaseData.unionId = unionId
    if sex == 0 then
        sex = math.random(2)   --随机性别
    end
    dataMgr.myBaseData.cbGender = sex


    dataMgr.myBaseData.headimgurl = headimgurl
    --dataMgr.myBaseData.roomNum = roomNum

        local xmlHttpReq = cc.XMLHttpRequest:new()
        dataMgr:getUrlImgByClientId(xmlHttpReq, 1, dataMgr.myBaseData.headimgurl,
        function ()
            if xmlHttpReq.readyState == 4 and (xmlHttpReq.status >= 200 and xmlHttpReq.status < 207) then
                local fileData = xmlHttpReq.response
                local fullFileName = cc.FileUtils:getInstance():getWritablePath()..xmlHttpReq._urlFileName
                print("LUA-print"..fullFileName)
                local file = io.open(fullFileName,"wb+")
                file:write(fileData)
                file:close()
                layerMgr.LoginScene:startLogin(openid)
            end
        end
        )
    --dataMgr:getUrlImgByClientId(1, dataMgr.myBaseData.headimgurl)

    print("openid "..openid.."  nickName "..nickName.." sex "..sex.." headimgurl "..headimgurl.." roomNum "..roomNum.." cbGender "..dataMgr.myBaseData.cbGender)
end

function SDKHelper:handleSDKPay( event)
    print("handleSDKPay")
    self.eventDispatcher:removeEventListener(self.listenerPay)
    local resCode = Helpers:getPayResCode()
    print("resCode in lua ")
    print(resCode)
    if resCode == 0 then   --购买成功

        local delayAction     = cc.DelayTime:create(2.0)
        local callFuncAction1 = cc.CallFunc:create(
            function()
                local snd = DataSnd:create(3, 501)
                snd:wrDWORD(dataMgr.myBaseData.dwUserID)
                snd:wrDWORD(10)
                snd:sendData(netTb.SocketType.Login)
                snd:release()
            end)
        local sequenceAction  = cc.Sequence:create(delayAction, callFuncAction1)
        local repeatAction    = cc.Repeat:create(sequenceAction, 5)
        layerMgr.LoginScene.btnTimers[1]:runAction(repeatAction)

        local popupbox =  import(".popUpBox",CURRENT_MODULE_NAME).create() 
        popupbox:setInfo(Strings.buyOk)
        local btnOk = popupbox:getBtns(1)
        btnOk:onClicked(function (  )
            popupbox:remove()
            
        end)
    else   --购买失败
        local popupbox =  import(".popUpBox",CURRENT_MODULE_NAME).create() 
        popupbox:setInfo(Strings.buyFail)
        local btnOk = popupbox:getBtns(1)
        btnOk:onClicked(function (  )
            popupbox:remove()
            
        end)
    end


end



return SDKHelper