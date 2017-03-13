local CURRENT_MODULE_NAME = ...

local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local netLogin = import(".NetWorkLogin"):getInstance()
local netGame = import(".NetWorkGame"):getInstance()

local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)
LoginScene.RESOURCE_FILENAME = "LoginScene.csb"


function LoginScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    ContentManager:getInstance():test()
end
  
function LoginScene:onEnter()
    local rootNode = self:getResourceNode()


    layerMgr.LoginScene = self

    local txUid = rootNode:getChildByName("TextField_uid")
    local btnLogin = rootNode:getChildByName("Button_login")
    btnLogin:onClicked(
    function ()
        local strUid = txUid:getString()
        if #strUid == 0 then
            strUid = tostring(1711514050 + math.random(1000000, 9000000))

        end
        dataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end
    )

    local btnFast1 = rootNode:getChildByName("Button_1")
    local btnFast2 = rootNode:getChildByName("Button_2")
    local btnFast3 = rootNode:getChildByName("Button_3")
    local btnFast4 = rootNode:getChildByName("Button_4")
    btnFast1:onClicked(function (  )
        local strUid = "1711514028"
        dataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)

    btnFast2:onClicked(function (  )
        local strUid = "1711514029"
        dataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)

    btnFast3:onClicked(function (  )
        local strUid = "1711514030"
        dataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)

    btnFast4:onClicked(function (  )
        local strUid = "1711514031"
        dataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)

    --cgpTest
    local strUid = "1711514028"
    dataMgr.myBaseData.uid = strUid
    print("strUid:"..strUid)
    --self:startLogin(strUid)
    layerMgr:showLayer(layerMgr.layIndex.MainLayer)

end

function LoginScene:startLogin(_uid)
    TTSocketClient:getInstance():startSocket(netTb.ip, netTb.port.login, netTb.SocketType.Login)

    local snd = DataSnd:create(1, 2)
    local uid = _uid
    local dwPlazaVersion = 65536
    local szMachineID = uid
    local szPassword = uid
    local szAccounts = uid
    local cbValidateFlags = 3

    snd:wrDWORD(dwPlazaVersion)
    print("dwPlazaVersion")
    snd:wrString(szMachineID, 66)
    snd:wrString(szPassword, 64)
    snd:wrString(szAccounts, 66)
    snd:wrString(uid, 32)
    snd:wrDWORD(cbValidateFlags)
    snd:sendData(netTb.SocketType.Login)
    snd:release();

end



return LoginScene
