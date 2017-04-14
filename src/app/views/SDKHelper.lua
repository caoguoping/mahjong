

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
    local listener = cc.EventListenerCustom:create("rcvSDKLogin", handler(self, self.handleSDKLogin))
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener, 1)
end


function SDKHelper:handleSDKLogin( event)
    local sdkData = SDKLoginData:create(event)
    local openid = sdkData:readOpenid()
    local nickName = sdkData:readNickName()
    local sex = sdkData:readSex()
    local headimgurl = sdkData:readHeadimgurl()
    local city = sdkData:readCity()

    dataMgr.myBaseData.uid = openid
    dataMgr.myBaseData.szNickName = nickName
    dataMgr.myBaseData.cbGender = sex
    dataMgr.myBaseData.headimgurl = headimgurl
    dataMgr.myBaseData.city = city

    print("openid "..openid.."  nickName "..nickName.." sex "..sex.." headimgurl "..headimgurl.." city "..city)
    layerMgr.LoginScene:startLogin(openid)

end





return SDKHelper