--  创建房间弹出界面--
local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()


local joinRoomBox = class("joinRoomBox", display.newLayer)
function joinRoomBox:ctor()
--all Node
    local rootNode = cc.CSLoader:createNode("joinRoom.csb"):addTo(self)
    self.rootNode = rootNode
    rootNode:setPosition(display.center)
    layerMgr.LoginScene:addChild(self, 10000)
    local btnClose = rootNode:getChildByName("Button_close")
    local imgMask = rootNode:getChildByName("Image_mask")
    imgMask:onClicked(
        function (  )
            self:removeSelf()
        end
        )
    btnClose:onClicked(
        function (  )
            self:removeSelf()
        end)

    self.txts = {}
    self.roomNum = {}  --7位数
    self.nowNum = 0  --已输入的房间位数
    for i=1,7 do
        local tmpStr = "Text_"..i
        self.txts[i] = rootNode:getChildByName(tmpStr)
    end

    local btns = {}
    for i=1,10 do
        local tmpStr = "Button_"..i
        btns[i] = rootNode:getChildByName(tmpStr)
        btns[i]:onClicked(
        function (  )
            self.nowNum = self.nowNum + 1;
            self.txts[self.nowNum]:setString(tostring(i - 1))
            self.roomNum[self.nowNum] = i - 1
            if self.nowNum == 7 then
                local readRoomNum = girl.getAllDicimalValue(self.roomNum, 7)
                print("@@@@@@@@@@@@@@@@@@\n "..readRoomNum)
                --self:sendJoinRoom()
                layerMgr:removeBoxes(layerMgr.boxIndex.JoinRoomBox)
                layerMgr:showLayer(layerMgr.layIndex.PlayLayer, params) 

            end
        end
        )
    end

    local btnReput = rootNode:getChildByName("Button_re")
    btnReput:onClicked(
        function (  )
            
        end
        )

    local btnDelete = rootNode:getChildByName("Button_delete")
    btnDelete:onClicked(
        function (  )
            
        end
        )
end

function joinRoomBox:sendJoinRoom()
    --cgpTest
    print("\njoinRoomBox")
    
    local snd = DataSnd:create(1, 4)
    snd:wrWORD(dataMgr.roomSet.wScore        )
    snd:wrWORD(dataMgr.roomSet.wJieSuanLimit )
    snd:wrWORD(dataMgr.roomSet.wBiXiaHu      )
    snd:wrByte(dataMgr.roomSet.bGangHouKaiHua)
    snd:wrByte(dataMgr.roomSet.bZaEr         )
    snd:wrByte(dataMgr.roomSet.bFaFeng       )
    snd:wrByte(dataMgr.roomSet.bYaJue        )
    snd:wrByte(dataMgr.roomSet.bJuShu        )
    snd:wrByte(dataMgr.roomSet.bIsJinyunzi   )
    snd:sendData(netTb.SocketType.Game)
    snd:release();
end


function joinRoomBox.create(  )
    return joinRoomBox.new()
end

return joinRoomBox
