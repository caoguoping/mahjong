--  创建房间弹出界面--
local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()


local JiesuanBox = class("JiesuanBox", display.newLayer)
function JiesuanBox:ctor()
--all Node
    local rootNode = cc.CSLoader:createNode("jiesuan.csb"):addTo(self)
    self.rootNode = rootNode
    rootNode:setPosition(display.center)
    layerMgr.LoginScene:addChild(self, 10000)
  
--赋值
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

    end)


    --顶部自摸、流局、点胡
    local topNode= rootNode:getChildByName("TopNode")
    --本家是赢家显示
    local winDianhu  = topNode:getChildByName("win_dianhu")
    local winZimo    = topNode:getChildByName("win_zimo")
    --本家为输家显示
    local lostDianhu = topNode:getChildByName("lost_dianhu") --点胡
    local lostZimo   = topNode:getChildByName("lost_zimo")   --自摸
    --流局
    local liuju      = topNode:getChildByName("liuju")
    --胡家翻型的具体数据流
    --翻型
    local fanxingNode = rootNode:getChildByName("Node_hupaidata_1")
    local fanxingName = fanxingNode:getChildByName("Text_string") 
    local fanxingNum = fanxingNode:getChildByName("Text_num")
    --具体数据
    local dataNode = rootNode:getChildByName("ListView_hupaidata")
    local listData_1 = dataNode:getChildByName("Button_1")
    -----local listData_1_name = listData_1:getChildByName("Text_string")
    -----local listData_1_num = listData_1:getChildByName("Text_num")
    local listData_2 = dataNode:getChildByName("Button_1_0")
    local listData_3 = dataNode:getChildByName("Button_1_1")
    local listData_4 = dataNode:getChildByName("Button_1_2")
    local listData_5 = dataNode:getChildByName("Button_1_3")
    local listData_6 = dataNode:getChildByName("Button_1_4")
    local listData_7 = dataNode:getChildByName("Button_1_5")
    local listData_8 = dataNode:getChildByName("Button_1_6")
    local listData_9 = dataNode:getChildByName("Button_1_7")
    --赢家头像
    local winheadNode = rootNode:getChildByName("Node_WinHead")

    local winheadPic  = winheadNode:getChildByName("headshot_example_27")
    local winIsbenjia = winheadNode:getChildByName("img_myself_1")

    --输家头像1
    local lostheadNode1= rootNode:getChildByName("Node_WinHead_0")

    local lostheadPic1  = lostheadNode1:getChildByName("headshot_example_27")
    local lostIsbenjia = lostheadNode1:getChildByName("img_myself_1")
    local lostheadIsbaopai1 = lostheadNode1:getChildByName("img_baopai_18")
    --输家头像2
    local lostheadNode2= rootNode:getChildByName("Node_WinHead_1")
    local lostheadPic2  = lostheadNode1:getChildByName("headshot_example_27")
    local lostheadIsbaopai2 = lostheadNode1:getChildByName("img_baopai_18_0")
    --输家头像3
    local lostheadNode3= rootNode:getChildByName("Node_WinHead_2")
    local lostheadPic3  = lostheadNode1:getChildByName("headshot_example_27")
    local lostheadIsbaopai3 = lostheadNode1:getChildByName("img_baopai_18_1")

    --赢家  总分值
    local wintxt = rootNode:getChildByName("   ")
    --输家1 总分值
    local losttxt1= rootNode:getChildByName("fen_Text_1")
    --输家2 总分值
    local losttxt2= rootNode:getChildByName("fen_Text_2")
    --输家3 总分值
    local losttxt3= rootNode:getChildByName("fen_Text_3")

    --赢家  名字
    local winname= rootNode:getChildByName("name_Text_4")
    --输家1 名字
    local lostname1= rootNode:getChildByName("name_Text_1")
    --输家2 名字
    local lostname2= rootNode:getChildByName("name_Text_2")
    --输家3 名字
    local lostname3= rootNode:getChildByName("name_Text_3")

    ---**************服务端数据的解析****
    --
    local c_topPic ---顶部显示输赢自摸\点胡、流局判断


end

function JiesuanBox:initData( gameEndData )
    
end


---****显示逻辑***
---顶部显示输赢自摸\点胡、流局判断
function JiesuanBox:SelectTopPic()
    -- if c_topPic== then
    --  --本家点胡
    --      winDianhu:setVisible(true)
    --      winZimo:setVisible(false)
    --      lostDianhu:setVisible(false)
    --      lostZimo:setVisible(false)
    --      liuju:setVisible(false)
    -- elseif c_topPic == then
    -- --本家自摸
    --  winDianhu:setVisible(false)
    --  winZimo:setVisible(true)
    --  lostDianhu:setVisible(false)
    --  lostZimo:setVisible(false)
    --  liuju:setVisible(false)
    -- elseif c_topPic == then
    -- --非本家点胡
    --  winDianhu:setVisible(false)
    --  winZimo:setVisible(false)
    --  lostDianhu:setVisible(true)
    --  lostZimo:setVisible(false)
    --  liuju:setVisible(false)
    -- elseif c_topPic ==  then
    -- --非本家自摸
    --  winDianhu:setVisible(false)
    --  winZimo:setVisible(false)
    --  lostDianhu:setVisible(false)
    --  lostZimo:setVisible(true)
    --  liuju:setVisible(false)
    -- elseif c_topPic ==  then
    -- --流局
    --  winDianhu:setVisible(false)
    --  winZimo:setVisible(false)
    --  lostDianhu:setVisible(false)
    --  lostZimo:setVisible(false)
    --  liuju:setVisible(true)
    -- end  
end   

function JiesuanBox.create(  )
    return JiesuanBox.new()
end

return JiesuanBox
