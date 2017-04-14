local CURRENT_MODULE_NAME = ...

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
  
function LoginScene:onEnter()
    local rootNode = self:getResourceNode()


    layerMgr.LoginScene = self

    local txUid = rootNode:getChildByName("TextField_uid")
    self.btnLoginWin = rootNode:getChildByName("Button_WindowsLogin")   --windows登录
    
    self.btnLoginWin:onClicked(
    function ()
        self:disableAllButtons()
        musicMgr:playEffect("game_button_click.mp3", false)
            local time1 = os.time()
            local time2 = math.random(1, 100)
            local strUid  = tostring(time1 * 100 + time2)
        dataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end
    )

    local btnLogin = rootNode:getChildByName("Button_login")   --微信登录
    btnLogin:onClicked(
    function ()
        musicMgr:playEffect("game_button_click.mp3", false)
        self:disableAllButtons()
        Helpers:callJavaLogin() 


    end
    )

    local btnFast1 = rootNode:getChildByName("Button_1")
    local btnFast2 = rootNode:getChildByName("Button_2")
    local btnFast3 = rootNode:getChildByName("Button_3")
    local btnFast4 = rootNode:getChildByName("Button_4")
    btnFast1:onClicked(
     function (  )
        self:disableAllButtons()

        local strUid = "149198809352"
        dataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)

    btnFast2:onClicked(
    function (  )
        self:disableAllButtons()

        local strUid = "1819514032"
        -- local strUid = "1811514032"
        dataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)

    btnFast3:onClicked(
    function (  )
        self:disableAllButtons()

        local strUid = "1811514033"
        dataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)

    btnFast4:onClicked(
    function (  )
        self:disableAllButtons()
        
        local strUid = "1811514034"
        dataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)

    self.btnLogin = btnLogin
    self.btnFast1 = btnFast1
    self.btnFast2 = btnFast2
    self.btnFast3 = btnFast3
    self.btnFast4 = btnFast4


    --预加载MainLayer
    local mainLayer = layerMgr:getLayer(layerMgr.layIndex.MainLayer)  
    mainLayer:setVisible(false)

end


function LoginScene:startLogin(_uid)

    print("openid ".._uid)
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

function LoginScene:disableAllButtons(  )
    self.btnLoginWin:setTouchEnabled(false)
    self.btnLogin:setTouchEnabled(false)
    self.btnFast1:setTouchEnabled(false)
    self.btnFast2:setTouchEnabled(false)
    self.btnFast3:setTouchEnabled(false)
    self.btnFast4:setTouchEnabled(false)
end


return LoginScene
