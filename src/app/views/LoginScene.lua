local CURRENT_MODULE_NAME = ...

local DataMgr     = import(".DataManager"):getInstance()
local NetWorkLogin = import(".NetWorkLogin"):getInstance()
local LayerMgr = import(".LayerManager"):getInstance()


local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)
LoginScene.RESOURCE_FILENAME = "LoginScene.csb"


function LoginScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    ContentManager:getInstance():test()
end
  
function LoginScene:onEnter()
    local rootNode = self:getResourceNode()


    LayerMgr.LoginScene = self

    local txUid = rootNode:getChildByName("TextField_uid")
    local btnLogin = rootNode:getChildByName("Button_login")
    btnLogin:onClicked(
    function ()
        local strUid = txUid:getString()
        if #strUid == 0 then
            strUid = tostring(1711514050 + math.random(1000000, 9000000))

        end
        DataMgr.myBaseData.uid = strUid
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
        DataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)

    btnFast2:onClicked(function (  )
        local strUid = "1711514028"
        DataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)

    btnFast3:onClicked(function (  )
        local strUid = "1711514028"
        DataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)

    btnFast4:onClicked(function (  )
        local strUid = "1711514028"
        DataMgr.myBaseData.uid = strUid
        print("strUid:"..strUid)
        self:startLogin(strUid)
    end)



end

function LoginScene:startLogin(_uid)
    TTSocketClient:getInstance():startSocket("139.196.237.203",5050, girl.SocketType.Login)

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
    snd:sendData(girl.SocketType.Login)
    snd:release();

end



return LoginScene
