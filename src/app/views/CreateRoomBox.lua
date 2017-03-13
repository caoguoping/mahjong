--  创建房间弹出界面--
local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()


local createRoomBox = class("createRoomBox", display.newLayer)
function createRoomBox:ctor()
--all Node
    local rootNode = cc.CSLoader:createNode("createRoom.csb"):addTo(self)
    self.rootNode = rootNode
    rootNode:setPosition(display.center)
    local btnCreate = rootNode:getChildByName("Button_create")
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


    local tbBiaxiahu = {}
    tbBiaxiahu[1]  = 1
    tbBiaxiahu[2]  = 1
    tbBiaxiahu[3]  = 1
    tbBiaxiahu[4]  = 1
    tbBiaxiahu[5]  = 1
    tbBiaxiahu[6]  = 1
    tbBiaxiahu[7]  = 1
    tbBiaxiahu[8]  = 1
    tbBiaxiahu[9]  = 1
    tbBiaxiahu[10] = 1
    tbBiaxiahu[11] = 1
    tbBiaxiahu[12] = 1

    local tbYaJue = {}
    tbYaJue[1] = 1
    tbYaJue[2] = 1
    tbYaJue[3] = 1

    dataMgr.roomSet.wScore        = 200
    dataMgr.roomSet.wJieSuanLimit = 0
    dataMgr.roomSet.wBiXiaHu      = girl.getAllBitValue(tbBiaxiahu)
    dataMgr.roomSet.bGangHouKaiHua= 1
    dataMgr.roomSet.bZaEr         = 0
    dataMgr.roomSet.bFaFeng       = 1
    dataMgr.roomSet.bYaJue        = girl.getAllBitValue(tbYaJue)
    dataMgr.roomSet.bJuShu        = 1
    dataMgr.roomSet.bIsJinyunzi   = 1
    layerMgr.LoginScene:addChild(self, 10000)
    btnCreate:onClicked(
        --cgpTest
        function ( )
            layerMgr:removeBoxes(layerMgr.boxIndex.CreateRoomBox)
            layerMgr:showLayer(layerMgr.layIndex.PlayLayer, params) 
        end


        -- function (  )
        --     self:sendCreateRoom()
        -- end
    )
end

function createRoomBox:sendCreateRoom()
    --cgpTest
    print("\ncreateRoomBox")

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

function createRoomBox:init(  )
    -- body
end

function createRoomBox.create(  )
    return createRoomBox.new()
end

return createRoomBox
