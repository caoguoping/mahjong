local CURRENT_MODULE_NAME = ...

local DataMgr     = import(".DataManager"):getInstance()
local LayerMgr = import(".LayerManager"):getInstance()

local PlayLayer = class("PlayLayer", display.newLayer)

-- fileNode  1:me,   2:left,    3:up,     4:right
local deskBgNode     = nil
local deskUiNode     = nil
local wallNode = {}
local stndNode = {}
local dachNode = {}
local pengNode = {}

local wallCell = {}
local stndCell = {}
local dachCell = {}
local pengCell = {}

function PlayLayer:ctor()
    local rootNode = cc.CSLoader:createNode("playScene.csb"):addTo(self)
    self.rootNode = rootNode
    deskBgNode  = rootNode:getChildByName("FileNode_deskBg")
    deskUiNode  = rootNode:getChildByName("FileNode_deskUi")

    wallNode[1]  = rootNode:getChildByName("FileNode_wallMe")
    wallNode[2]  = rootNode:getChildByName("FileNode_wallLeft")
    wallNode[3]  = rootNode:getChildByName("FileNode_wallUp")
    wallNode[4]  = rootNode:getChildByName("FileNode_wallRight")
    stndNode[1]  = rootNode:getChildByName("FileNode_standMe")
    stndNode[2]  = rootNode:getChildByName("FileNode_standLeft")
    stndNode[3]  = rootNode:getChildByName("FileNode_standUp")
    stndNode[4]  = rootNode:getChildByName("FileNode_standRight")
    dachNode[1]  = rootNode:getChildByName("FileNode_dachuMe")
    dachNode[2]  = rootNode:getChildByName("FileNode_dachuLeft")
    dachNode[3]  = rootNode:getChildByName("FileNode_dachuUp")
    dachNode[4]  = rootNode:getChildByName("FileNode_dachuRight")
    pengNode[1]  = rootNode:getChildByName("FileNode_pengMe")
    pengNode[2]  = rootNode:getChildByName("FileNode_pengLeft")
    pengNode[3]  = rootNode:getChildByName("FileNode_pengUp")
    pengNode[4]  = rootNode:getChildByName("FileNode_pengRight")

    self:resetNodeVisible()
--bg
    

--ui
    local btnClose = deskUiNode:getChildByName("Button_Close")
    btnClose:onClicked(
        function ()
        LayerMgr:showLayer(LayerMgr.Enum.MainLayer, params)
        TTSocketClient:getInstance():closeMySocket(girl.SocketType.Game)
        end)

    for i = 1, 4 do
        wallCell[i] = {}
        stndCell[i] = {}
        dachCell[i] = {}
        pengCell[i] = {}
        for j=1,4 do
            pengCell[i][j] = {}
        end
    end
    --堆牌
    for  i = 1,4 do
        for j = 1,36 do
            local imgName = "Image"..j
            wallCell[i][j] = wallNode[i]:getChildByName(imgName)
        end
    end

    --碰牌  四个一组,pengCell[1][1][1]，共四组，5,6为13,14张
    for  i = 1,4 do
        pengCell[i][5] = pengNode[i]:getChildByName("Image13")
        pengCell[i][6] = pengNode[i]:getChildByName("Image14")
        for j = 1, 4 do
            local nodeName = "Node_"..j
            local nd = pengNode[i]:getChildByName(nodeName)
            for k = 1, 4 do
                local imgName = "Image"..k
                local imgBg = nd:getChildByName(imgName)
                pengCell[i][j][k] = imgBg:getChildByName("Image_face")
            end
        end
    end

    --打出牌
    for i = 1, 4 do
        for j = 1, 24 do
            local imgName = "Image"..j
            local imgBg = dachNode[i]:getChildByName(imgName)
            dachCell[i][j] = imgBg:getChildByName("ImageFace")
        end
    end

    wallCell[1][35]:setVisible(false)
    pengCell[2][3][4]:loadTexture("24.png")
    dachCell[4][14]:loadTexture("17.png")
    -- for i = 1,40000 do
    --     for i=1,14 do
    --         pengMeCell[1]:loadTexture("24.png")
    --     end
    -- end


end
  
function PlayLayer.create()
    return PlayLayer.new()
end

function PlayLayer:resetNodeVisible()
    for i=1,4 do
        wallNode[i]:setVisible(true)
        -- stndNode[i]:setVisible(false)
        -- dachNode[i]:setVisible(false)
        -- pengNode[i]:setVisible(false)
    end
end

function PlayLayer:refresh(params)
    self:resetNodeVisible()


end


return PlayLayer
