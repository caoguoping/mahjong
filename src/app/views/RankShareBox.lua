--  创建房间弹出界面--
local CURRENT_MODULE_NAME = ...
local dataMgr = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local musicMgr = import(".MusicManager"):getInstance()

local RankShareBox = class("RankShareBox", display.newLayer)
function RankShareBox:ctor()
    local rootNode = cc.CSLoader:createNode("RankShare.csb"):addTo(self)
    self.rootNode = rootNode
    rootNode:setPosition(display.center)
    layerMgr.LoginScene:addChild(self, 10000)
  
    --流水按钮、总分按钮、规则按钮、分享按钮、关闭按钮
	local btnclose = rootNode:getChildByName("Button_close")
	local btnShareFriend = rootNode:getChildByName("Button_friend")
	local btnShareMoments = rootNode:getChildByName("Button_moments")

	---一场总数据的排名  所有控件按从上到下的顺序  剩余钱从大到小
    local changNode = rootNode:getChildByName("Node_chang")
    local headNodes = {}
    local txtUserNames = {}   --名称
    local txtShengju = {}  --胜局数
    local txtFengshu = {}  --分数

    for i=1,4 do
    	headNodes[i] = changNode:getChildByName("FileNode_"..i)
    	txtUserNames[i] = headNodes[i]:getChildByName("name_Text")
    	txtShengju[i] = changNode:getChildByName("Text_dj_"..i)
    	txtFengshu[i] = changNode:getChildByName("Text_"..i)
    end
	local cangkaihuai = changNode:getChildByName("Image_5_ckh")
	local jinyuanzi = changNode:getChildByName("Image_5_jyz")

	local myTables = {}
    for i=1,4 do
        myTables[i] = {}
        myTables[i].money = dataMgr.onDeskData[i].LeftMoney - dataMgr.roomSet.wScore  --总的输赢钱
        myTables[i].index = i       --服务器ID
    end

    --myTables 已按钱进行大小排序
    table.sort( myTables, function (a, b )
    	return a.money > b.money
    end )

	--头像   added by caoguoping
	self.imgHead = {}  --按从上到下的顺序，1,2,3,4
	for i=1,4 do
		self.imgHead[i] = changNode:getChildByName("FileNode_"..i):getChildByName("Image_head")
		local svrId = myTables[i].index
		local clientId = dataMgr.chair[svrId]
		local HeadPath =  cc.FileUtils:getInstance():getWritablePath().."headImage_"..clientId..".png"
        local headSize = self.imgHead[i]:getContentSize()
        local sp2 = display.createCircleSprite(HeadPath, "headshot_example.png"):addTo(self.imgHead[i])
        sp2:setPosition(headSize.width * 0.5, headSize.height * 0.5)
        txtUserNames[i]:setString(dataMgr.onDeskData[svrId].szNickName)
        txtFengshu[i]:setString(myTables[i].money)
        txtShengju[i]:setString(1)
	end
	if dataMgr.roomSet.bIsJinyunzi == 1 then
		jinyuanzi:setVisible(true)
		cangkaihuai:setVisible(false)
	elseif dataMgr.roomSet.bIsJinyunzi == 2 then
		jinyuanzi:setVisible(false)
		cangkaihuai:setVisible(true)
	end
-------
	btnShareMoments:onClicked(
	function()
		musicMgr:playEffect("game_button_click.mp3", false)
        local fileName = "printScreen.png"
        -- 移除纹理缓存
        cc.Director:getInstance():getTextureCache():removeTextureForKey(fileName)
        self:removeChildByTag(1000)
        -- 截屏
        cc.utils:captureScreen(
            function(succeed, outputFile)
                if succeed then
                    print("outputFile ")
                    print(outputFile)
                    if  device.platform == "android" then
           				 Helpers:callWechatShareResult(outputFile, 1)
        			elseif device.platform == "ios" then
            			--whj 添加iOS微信分享
            			Helpers:weichatShareResult(1)
        			else
            			print("windows...")
        			end 
                else
                    print("captureScreen failed !")
                end
            end, 
            fileName)
	end)

	btnShareFriend:onClicked(
	function()
		musicMgr:playEffect("game_button_click.mp3", false)
	    local fileName = "printScreen.png"
	    -- 移除纹理缓存
	    cc.Director:getInstance():getTextureCache():removeTextureForKey(fileName)
	    self:removeChildByTag(1000)
	    -- 截屏
	    cc.utils:captureScreen(
	        function(succeed, outputFile)
	            if succeed then
	                print("outputFile ")
	                print(outputFile)
	                if  device.platform == "android" then
           				Helpers:callWechatShareResult(outputFile, 0)
        			elseif device.platform == "ios" then
            			--whj 添加iOS微信分享
            			Helpers:weichatShareResult(0)
        			else
            			print("windows...")
        			end 
	            else
	                print("captureScreen failed !")
	            end
	        end, 
	        fileName)
	end)


	btnclose:onClicked(
	function (  )
		musicMgr:playEffect("game_button_click.mp3", false)
		TTSocketClient:getInstance():closeMySocket(netTb.SocketType.Game)
		layerMgr.LoginScene.btnTimers[31]:stopAllActions()
		self:removeSelf()
		 --清理手牌
		local playLayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer, params)
        playLayer:refresh()
        layerMgr:showLayer(layerMgr.layIndex.MainLayer, params)

	end)
end



function RankShareBox:init(  )
    -- body
end

function RankShareBox.create(  )
    return RankShareBox.new()
end
return RankShareBox