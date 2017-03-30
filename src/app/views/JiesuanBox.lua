--  结算弹出界面--
local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()


local JiesuanBox = class("JiesuanBox", display.newLayer)
function JiesuanBox:ctor()
    local rootNode = cc.CSLoader:createNode("jiesuan.csb"):addTo(self)
    self.rootNode = rootNode
    rootNode:setPosition(display.center)
    layerMgr.LoginScene:addChild(self, 10000)
  
    --返回按钮、继续游戏按钮、分享按钮
    local btnBack = rootNode:getChildByName("Button_back")
    local btnContiue = rootNode:getChildByName("Button_contiue")
    local btnShare = rootNode:getChildByName("Button_share")

    --返回按钮、继续游戏按钮、分享按钮
    btnBack:onClicked(
    function()
        layerMgr:showLayer(layerMgr.layIndex.MainLayer, params)
        TTSocketClient:getInstance():closeMySocket(netTb.SocketType.Game)
        self:removeSelf()
    end)

    btnContiue:onClicked(
    function()
        local snd = DataSnd:create(100, 2)
        snd:sendData(netTb.SocketType.Game)
        snd:release();
        print("btnContiue") 
        self:removeSelf()
    end)

    btnShare:onClicked(
    function()
        print("btnShare") 
        self:removeSelf()
    end)

    --顶部自摸、流局、点胡()
    local topNode= rootNode:getChildByName("TopNode")
    --本家是赢家显示
    local topImgs = {}   -- 1-5
    topImgs[1]  = topNode:getChildByName("win_dianhu")
    topImgs[2]    = topNode:getChildByName("win_zimo")
    --本家为输家显示
    topImgs[3] = topNode:getChildByName("lost_dianhu") --点胡
    topImgs[4]   = topNode:getChildByName("lost_zimo")   --自摸
    --流局
    topImgs[5]      = topNode:getChildByName("liuju")
    
     --翻型下拉
    self.listFanXing = rootNode:getChildByName("ListView_fanxing")

    --只有我赢了才显示
    local nodeIsMeWin = rootNode:getChildByName("Node_isMeWin")

    local nodeHead = {}   --4家头像节点, win为4， 其他左边开始1， 2， 3
    local imgHead = {} 
    local txtName = {}
    local txtScore = {}
    local imgIsMe = {}
    local imgIsBaopai = {}

    for i=1,3 do
        local tempName = "FileNode_head_"..i
        nodeHead[i] = rootNode:getChildByName(tempName) 
        imgHead[i] = nodeHead[i]:getChildByName("Image_head")
        imgIsMe[i] = nodeHead[i]:getChildByName("img_myself")
        imgIsBaopai[i] = nodeHead[i]:getChildByName("img_baopai")
        txtName[i] = nodeHead[i]:getChildByName("name_Text")
        txtScore[i] = nodeHead[i]:getChildByName("fen_Text")
    end

    nodeHead[4] = rootNode:getChildByName("Node_WinHead") 
    imgHead[4] = nodeHead[4]:getChildByName("Image_head")
    imgIsMe[4] = nodeHead[4]:getChildByName("img_myself")
    --imgIsBaopai[4] = nodeHead[i]:getChildByName("img_baopai")
    txtName[4] = nodeHead[4]:getChildByName("name_Text")
    txtScore[4] = nodeIsMeWin:getChildByName("AtlasLabel_bigScore")   --在Node_isMeWin节点下


    local nodePengMe = rootNode:getChildByName("FileNode_pengMe")
        --碰牌  四个一组,pengCell[1][1][1]，共四组，5,6为13,14张

    self.pengCell = {}
    self.pengCellFace = {}
    self.pengCell[5] =  nodePengMe:getChildByName("Image13")
    self.pengCell[6] =  nodePengMe:getChildByName("Image14")
    self.pengCellFace[5] =  self.pengCell[5]:getChildByName("Image_face")
    self.pengCellFace[6] =  self.pengCell[6]:getChildByName("Image_face")
    for j = 1, 4 do
        local nodeName = "Node_"..j
        local nd =  nodePengMe:getChildByName(nodeName)
        self.pengCell[j] = {}
        self.pengCellFace[j] = {}

        for k = 1, 4 do
            local imgName = "Image"..k
            self.pengCell[j][k] = nd:getChildByName(imgName)
            self.pengCellFace[j][k] = self.pengCell[j][k]:getChildByName("Image_face")
            --self.pengCell[i][j][k]:setVisible(false)
        end
    end



    --self:initData(gameEndData)
end

function JiesuanBox:initData( gameEndData )
    --self.listFanXing
    local itemHeigth = 50
    local itemWidth = 663

    for i=1,5 do
        local oneNode = cc.CSLoader:createNode("jiesuanFanxing.csb")
        local oneLayout = ccui.Layout:create()
        oneLayout:addChild(oneNode)
        oneNode:setPosition(cc.p(itemWidth * 0.5, -itemHeigth * 0.5))
        self.listFanXing:setItemsMargin(itemHeigth + 6)
        self.listFanXing:pushBackCustomItem(oneLayout)
    end


    self.listFanXing:pushBackCustomItem(ccui.Layout:create())


end

function JiesuanBox.create(  )
    return JiesuanBox.new()
end

return JiesuanBox
