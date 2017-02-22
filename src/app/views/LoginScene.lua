local CURRENT_MODULE_NAME = ...

local DataMgr     = import(".DataManager"):getInstance()
local NetWorkLogin = import(".NetWorkLogin"):getInstance()
local viewMgr = import(".ViewManager"):getInstance()

local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)
LoginScene.RESOURCE_FILENAME = "LoginScene.csb"


function LoginScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    ContentManager:getInstance():test()
end
  
function LoginScene:onEnter()
    local rootNode = self:getResourceNode()


    viewMgr.loginScene = self

    local txUid = rootNode:getChildByName("TextField_uid")
  --  local self.uid = txUid:getString()

 

    local btnLogin = rootNode:getChildByName("Button_login")

    btnLogin:onClicked(
    function ()
        print("\ntxUid"..txUid:getString())
        print("do not use the chinese in the name and password")
        self:startLogin()
        end
    )

end

function LoginScene:startLogin()
    TTSocketClient:getInstance():startSocket("139.196.237.203",5050, girl.SocketType.Login)

    local snd = DataSnd:create(1, 2)
    --local uid = "1711514028"
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
