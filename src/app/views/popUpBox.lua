--  弹出界面--
local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local musicMgr = import(".MusicManager"):getInstance()



local popUpBox = class("popUpBox", display.newLayer)
function popUpBox:ctor()  
--all Node
    local rootNode = cc.CSLoader:createNode("popUpBox.csb"):addTo(self)
    self.rootNode = rootNode
    rootNode:setPosition(display.center)
    layerMgr.LoginScene:addChild(self, 10000)
    self.txtInfo = rootNode:getChildByName("Text_info")
    self.btnCancel = rootNode:getChildByName("Button_cancel")
    self.btnOk = rootNode:getChildByName("Button_Ok")
end

function popUpBox.create()
    return popUpBox.new(types)
end
function popUpBox:getBtns(types)   --1, 只有一个确定    2： 有一个确定和一个取消
    if types == 2 then
        return self.btnOk, self.btnCancel
    elseif types == 1 then
        self.btnCancel:setVisible(false)
        self.btnOk:setPositionX(0)    --居中
        return self.btnOk
    end

    
end
function popUpBox:remove(  )
    self:removeSelf()
end
function popUpBox:setInfo( str )
    self.txtInfo:setString(str)
end

return popUpBox