local CURRENT_MODULE_NAME = ...
require("src/cocos/cocos2d/json")

local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local netLogin = import(".NetWorkLogin"):getInstance()
local netGame = import(".NetWorkGame"):getInstance()
local sdkHelper = import(".SDKHelper"):getInstance()
local musicMgr = import(".MusicManager"):getInstance()

local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)
LoginScene.RESOURCE_FILENAME = "LoginScene.csb"

function LoginScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    --ContentManager:getInstance():test()
end
 
 --定时器管理 
function LoginScene:timerManager(  )

    --loginScene   游戏服务器心跳检测
    self.btnTimers = {}
    for i=1,39 do
        self.btnTimers[i] = self.rootNode:getChildByName("Node_timer_"..i)
    end
    --[[
        1:请求支付
        layerMgr.LoginScene.btnTimers[1]:schedule(layerMgr.LoginScene.btnTimers[1],
            function()
                print("test")
            end
            ,1.0
            ) 

        2：大结算延时
        3：小最后一局小结算延时删除
        4: 聊天界面图片显示3秒后隐藏
        5: 聊天界面文字显示3秒后隐藏

    ]]

        --曹国平21开始
    --[[
        21:有人离开后5秒，断socket, 返回主界面
        22:逃跑
        23:30    playLayer runAction
        31:游戏服务器心跳检测

    ]]

  
end

function LoginScene:onEnter()
    local rootNode = self:getResourceNode()
    self.rootNode = rootNode
    local imgBg = rootNode:getChildByName("background")
    local imgHealth = rootNode:getChildByName("Image_health")

    local seq = cc.Sequence:create(
                --cc.DelayTime:create(1.0),   --广电测试
                cc.FadeOut:create(0.5),
                cc.CallFunc:create(
                function ()
                    imgBg:setVisible(true)
                    imgHealth:setVisible(false)
                end)
                )
    imgHealth:runAction(seq)


    imgBg:setVisible(false)
    layerMgr.LoginScene = self

    self.btnLoginWin = imgBg:getChildByName("Button_WindowsLogin")   --windows登录
    
    self.btnLoginWin:onClicked(
    function ()
        self.btnLoginWin:setTouchEnabled(false)
        musicMgr:playEffect("game_button_click.mp3", false)
            local time1 = os.time()
            local time2 = math.random(1, 100)
            local strUid  = tostring(time1 * 100 + time2)
        dataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end
    )




    local txtUid = imgBg:getChildByName("TextField_uid")
    local txtPassword = imgBg:getChildByName("TextField_password")

    local txtVerMain = rootNode:getChildByName("Text_versionMain")
    local txtVerSub = rootNode:getChildByName("Text_versionSub")
    local txtVerData = rootNode:getChildByName("Text_versionData")

    txtVerMain:setString(netTb.version.main..".")
    txtVerSub :setString(netTb.version.sub..".")
    txtVerData:setString(netTb.version.data)

    --预加载MainLayer
    local mainLayer = layerMgr:getLayer(layerMgr.layIndex.MainLayer)  
    mainLayer:setVisible(false)

    self.btnLogin = imgBg:getChildByName("Button_login")   --微信登录
    self.btnLogin:onClicked(
    function ()
        self.btnLogin:setTouchEnabled(false)
        self:clickLogin()
    end
    )

    self:timerManager()   --定时器管理

    --获取房间号和ip
    local roomNum , ipInt
    if  device.platform == "android" then
        roomNum = Helpers:callGetRoomNum()
        print("getRoomNum in lua")
        ipInt = Helpers:callGetIp()   --ip
        print("getip in lua")

    elseif device.platform == "ios" then
        roomNum = Helpers:getRoomNumber()
        ipInt = Helpers:getIpAddress()
    elseif device.platform == "windows" then
        print("helpers:callGetRoomNum windows!")
    end


    --获取uri读取的房间号，没有的话，默认为0
    if  device.platform ~= "windows" then
        if roomNum ~= 0 then    --被邀请，自动登录  
            dataMgr.roomSet.dwRoomNum = roomNum
            local i1, i2, i3, i4
            i1 = ipInt % 256   --最低位地址
            ipInt = (ipInt - i1) / 256
            i2 = ipInt % 256
            ipInt = (ipInt - i2 ) / 256
            i3 = ipInt % 256
            i4 = (ipInt - i3) / 256
            local ipStr = i4.."."..i3.."."..i2.."."..i1
            dataMgr.weChat.spbill_create_ip = ipStr
            print("ip ")
            print(dataMgr.weChat.spbill_create_ip)
            dataMgr.roomSet.autoJoin = 1
            self.btnLogin:setTouchEnabled(false)   --自动加入房间时禁止自己点击
            print("loginScene,  auto ")    
            self:clickLogin()             --自动启动游戏

        else   
            if cc.UserDefault:getInstance():getBoolForKey("first_time", true) then   --首次登录，
                 return
            else     --没有被邀请，已经登录过，也自动登录
                self:clickLogin()
            end
        end
    end

    -- local delayAction     = cc.DelayTime:create(2.0)
    -- local callFuncAction1 = cc.CallFunc:create(
    --     function()
    --         print("###############")
    --     end)
    -- local sequenceAction  = cc.Sequence:create(delayAction, callFuncAction1)
    -- local repeatAction    = cc.Repeat:create(sequenceAction, 10)
    -- layerMgr.LoginScene.btnTimers[1]:runAction(repeatAction)



end

--点击微信登录或自动登录
function LoginScene:clickLogin(  )
    local timeTp = os.time()
    print("LUA-print times0 "..timeTp)
    musicMgr:playEffect("game_button_click.mp3", false)


    if cc.UserDefault:getInstance():getBoolForKey("first_time", true) then   --首次登录
        if  device.platform == "android" then
            Helpers:callJavaLogin()
        elseif device.platform == "ios" then
            Helpers:weichatLogin()
        else
            print("windows...")
        end 
         
    else    --已经登录过, 自动登录
        dataMgr.myBaseData.uid = cc.UserDefault:getInstance():getStringForKey("openid")
        dataMgr.myBaseData.szNickName = cc.UserDefault:getInstance():getStringForKey("nickName")
        dataMgr.myBaseData.cbGender = cc.UserDefault:getInstance():getStringForKey("sex")
        dataMgr.myBaseData.headimgurl = cc.UserDefault:getInstance():getStringForKey("headimgurl")
        dataMgr.myBaseData.unionId = cc.UserDefault:getInstance():getStringForKey("unionId")

        local xmlHttpReq = cc.XMLHttpRequest:new()
        dataMgr:getUrlImgByClientId(xmlHttpReq, 1, dataMgr.myBaseData.headimgurl,
        function ()
            if xmlHttpReq.readyState == 4 and (xmlHttpReq.status >= 200 and xmlHttpReq.status < 207) then
                local fileData = xmlHttpReq.response
                local fullFileName = cc.FileUtils:getInstance():getWritablePath()..xmlHttpReq._urlFileName
                print("LUA-print"..fullFileName)
                local file = io.open(fullFileName,"wb+")
                if file then
                    file:write(fileData)
                    file:close()
                end
                layerMgr.LoginScene:startLogin(dataMgr.myBaseData.uid)
            end
        end
        )
    end
end

function LoginScene:startLogin(_uid)
    print("startLogin openid ".._uid)
    TTSocketClient:getInstance():startSocket(netTb.ip, netTb.port.login, netTb.SocketType.Login)
    local snd = DataSnd:create(1, 2)
    local uid = _uid
    local dwPlazaVersion = 65536
    local szMachineID = uid
    local szPassword = uid
    local szAccounts = uid
    local cbValidateFlags = 3

    snd:wrDWORD(dwPlazaVersion)
    snd:wrString(szMachineID, 66)
    snd:wrString(szPassword, 64)
    snd:wrString(szAccounts, 66)
    snd:wrString(uid, 32)
    snd:wrDWORD(cbValidateFlags)
    snd:sendData(netTb.SocketType.Login)
    snd:release();

end



return LoginScene
