local CURRENT_MODULE_NAME = ...

local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local cardNode		= import(".CardNode", CURRENT_MODULE_NAME)
local s_inst = nil
local cardDataMgr = import(".CardDataManager"):getInstance()
local CardManager = class("CardManager")


function CardManager:getInstance()
	if not s_inst then
		s_inst = CardManager.new()
		s_inst:inits()
	end
	return s_inst
end

function CardManager:inits( )
	self.cardCreate = {}
	self.whichTouch = nil
	self.stndMeCnt = nil

end

function CardManager:hideAllCards(  )
    for i=1,4 do
        self.wallNode[i]:setVisible(false)
        self.stndNode[i]:setVisible(false)
        self.outNode[i]:setVisible(true)
        self.pengNode[i]:setVisible(false)
    end

    --打出牌
    for i = 1, 4 do
        for j = 1, 24 do
            self.outCell[i][j]:setVisible(false)
        end
    end
    self.stndNodeMeBei:setVisible(false)
end

function CardManager:initAllNodes( param )
	local rootNode = param.rootNode
	self.wallNode = {}
    self.stndNode = {}
    self.outNode = {}
    self.pengNode = {}
    self.wallCell = {}  --1, 144 已按抓牌顺序排好序
    self.stndCell = {}
    self.outCell = {}
    self.pengCell = {}

    self.nodeDachu = {}  --打出牌节点
    self.imgBigDachu = {} --打出牌
    self.deskUiNode  = rootNode:getChildByName("FileNode_deskUi")
    for i=1,4 do
        local strName = "FileNode_dachuBig_"..i
        self.nodeDachu[i] = self.deskUiNode:getChildByName(strName)
        self.nodeDachu[i]:setVisible(false)
        self.imgBigDachu[i] = self.nodeDachu[i]:getChildByName("Image_paiMian")
    end
    self.imgTouchCard = self.deskUiNode:getChildByName("Image_touchCard")
    self.imgTouchOther = self.deskUiNode:getChildByName("Image_touchOther")
    self.touchSn = 0   --点击第几张牌

--getTouchSn
    self.imgTouchCard:addTouchEventListener(
	--[14]多15
	function (sender, state )
		local sn = 0
    	if state == 2 then
    		local touchEndPosX = sender:getTouchEndPosition().x
    		if touchEndPosX < 1247 and touchEndPosX > 1161 then
    			sn = 14
    		else 
    			sn = math.modf((touchEndPosX - 30) / 86) + 1
    		end
    		self.touchSn = sn
    		if sn <= cardDataMgr.pengNum[1] * 3 then
    			return
    		end

			print("\nimgTouchCard posx end"..touchEndPosX.."  sn "..self.touchSn)
			--[[
			local snd = DataSnd:create(200, 1)
			snd:wrByte(cardValues[i])
            snd:sendData(netTb.SocketType.Game)
            snd:release();
			--]]
			local handvalueIndex = sn - cardDataMgr.pengNum[1] * 3   
			self.nodeDachu[1]:setVisible(true)
			self.imgBigDachu[1]:loadTexture(cardDataMgr.handCardValue[handvalueIndex]..".png")

            local delay = cc.DelayTime:create(0.8)
            local action = cc.Sequence:create(delay, cc.CallFunc:create(
                function ()
                	self.nodeDachu[1]:setVisible(false)
                	cardDataMgr.outNum[1] = cardDataMgr.outNum[1] + 1
                	self.outCell[1][cardDataMgr.outNum[1]]:setVisible(true)
                	self.outCellFace[1][cardDataMgr.outNum[1]]:loadTexture(cardDataMgr.handCardValue[handvalueIndex]..".png")
       			end))

			self.nodeDachu[1]:runAction(action)
			self.cardCreate[handvalueIndex]:removeFromParent()
			table.remove(self.cardCreate, handvalueIndex)
			table.remove(cardDataMgr.handCardValue,  handvalueIndex)
			print("\n\ntable size "..#self.cardCreate)
    	end
    end)



    self.wallNode[1]  = rootNode:getChildByName("FileNode_wallMe")
    self.wallNode[4]  = rootNode:getChildByName("FileNode_wallRight")
    self.wallNode[3]  = rootNode:getChildByName("FileNode_wallUp")
    self.wallNode[2]  = rootNode:getChildByName("FileNode_wallLeft")
    self.stndNode[1]  = rootNode:getChildByName("FileNode_standMe")
--test
    --self.stndNode[1]:setVisible(true)
    self.stndNode[4]  = rootNode:getChildByName("FileNode_standRight")
    self.stndNode[3]  = rootNode:getChildByName("FileNode_standUp")
    self.stndNode[2]  = rootNode:getChildByName("FileNode_standLeft")
    self.outNode[1]  = rootNode:getChildByName("FileNode_dachuMe")
    self.outNode[4]  = rootNode:getChildByName("FileNode_dachuRight")
    self.outNode[3]  = rootNode:getChildByName("FileNode_dachuUp")
    self.outNode[2]  = rootNode:getChildByName("FileNode_dachuLeft")
    self.pengNode[1]  = rootNode:getChildByName("FileNode_pengMe")
    self.pengNode[4]  = rootNode:getChildByName("FileNode_pengRight")
    self.pengNode[3]  = rootNode:getChildByName("FileNode_pengUp")
    self.pengNode[2]  = rootNode:getChildByName("FileNode_pengLeft")
    self.stndNodeMeBei = rootNode:getChildByName("FileNode_standMeBei")


    --pai
    self.outCellFace = {}
    self.outCell = {}
    for i = 1, 4 do
        --self.wallCell[i] = {}
        self.stndCell[i] = {}
        self.outCell[i] = {} --打出牌的底
        self.outCellFace[i] = {}  --打出牌的底的牌面
        self.pengCell[i] = {}
        for j=1,4 do
            self.pengCell[i][j] = {}
        end
    end
-- --堆牌
    -- for  i = 1,4 do
    --     for j = 1,36 do
    --         local imgName = "Image"..j
    --         self.wallCell[i][j] =  self.wallNode[i]:getChildByName(imgName)
    --     end
    -- end
    --堆牌
    local sice1 = cardDataMgr.cardSend.bSice1
    local sice2 = cardDataMgr.cardSend.bSice2
	--cgpTest
    sice1 = 3
    sice2 = 4
    local startDir = math.min(sice1, sice2)
    local theSum = sice1 + sice2
    local startIndex = (startDir - 1) * 36 + (theSum - 1) * 2  --相当于0
    for  i = 1,4 do
        for j = 1,36 do
            local imgName = "Image"..j
            local realPos = ((i - 1) * 36 + j - startIndex + 144) % 144
            self.wallCell[realPos] =  self.wallNode[i]:getChildByName(imgName)


            --print(realPos.." ")
        end
    end

    --碰牌  四个一组,pengCell[1][1][1]，共四组，5,6为13,14张
    for  i = 1,4 do
        self.pengCell[i][5] =  self.pengNode[i]:getChildByName("Image13")
        self.pengCell[i][6] =  self.pengNode[i]:getChildByName("Image14")
        for j = 1, 4 do
            local nodeName = "Node_"..j
            local nd =  self.pengNode[i]:getChildByName(nodeName)
            for k = 1, 4 do
                local imgName = "Image"..k
                local imgBg = nd:getChildByName(imgName)
                self.pengCell[i][j][k] = imgBg:getChildByName("Image_face")
            end
        end
    end

    --打出牌
    for i = 1, 4 do
        for j = 1, 24 do
            local imgName = "Image"..j
            self.outCell[i][j] =  self.outNode[i]:getChildByName(imgName) 
            self.outCellFace [i][j] = self.outCell[i][j]:getChildByName("ImageFace")
        end
    end

    --站着的牌, 自己的站牌动态创建，在CardManager CardNodes
    for i=2,4 do
        for j=1,14 do
            local imgName = "Image"..j
            self.stndCell[i][j] = self.stndNode[i]:getChildByName(imgName)
        end
    end
    --自己的盖下去的牌
    for i=1,14 do
        local imgName = "Image"..i
        self.stndCell[1][i] = self.stndNodeMeBei:getChildByName(imgName)
    end
end


--抓一张牌
function CardManager:drawCard( )
	
end

--收到其他玩家出牌
function CardManager:rcvOutCard(outCard )
 --   
end

function CardManager:initcardCreate(cardValues, drawCardValue)
	self.cardCreate = {}    --创建的节点，打出去和碰出去的不算
	--local cardValues = {25, 18, 1, 2, 3, 8, 5, 5, 7, 9, 40, 41, 52, 74}
	table.sort(cardValues)

	for i=1,13 do
		self.cardCreate[i] = cardNode.create(cardValues[i])
		cardDataMgr.handCardValue[i] = cardValues[i]
		self.cardCreate[i]:setPositionX(girl.posx[i])

		self.stndNode[1]:addChild(self.cardCreate[i])
		self.cardCreate[i].sn = i
		self.cardCreate[i].clickTimes = 0

		-- self.cardCreate[i].btnBg:onClicked(
		-- 	function ()
		-- 		-- self.cardCreate[i].clickTimes = self.cardCreate[i].clickTimes + 1
		-- 		-- if self.cardCreate[i].clickTimes == 1 then
		-- 		-- 	self.cardCreate[i]:setPositionY(30)
		-- 		-- elseif self.cardCreate[i].clickTimes == 2 then
		-- 		-- 	--self.cardCreate[i].clickTimes == 0

		-- 			--[[
		-- 			local snd = DataSnd:create(200, 1)
		-- 			snd:wrByte(cardValues[i])
		--             snd:sendData(netTb.SocketType.Game)
		--             snd:release();
		-- 			--]]
		-- 			self.nodeDachu[1]:setVisible(true)
		-- 			self.imgBigDachu[1]:loadTexture(cardValues[i]..".png")


		--             local delay = cc.DelayTime:create(0.8)
		--             local action = cc.Sequence:create(delay, cc.CallFunc:create(
		--                 function ()
		--                 	self.nodeDachu[1]:setVisible(false)
		--                 	cardDataMgr.outNum[1] = cardDataMgr.outNum[1] + 1
		--                 	self.outCell[1][cardDataMgr.outNum[1]]:setVisible(true)
		--                 	self.outCellFace[1][cardDataMgr.outNum[1]]:loadTexture(cardValues[i]..".png")
  --              			end))


		-- 			self.nodeDachu[1]:runAction(action)
		-- 			self.cardCreate[i]:removeFromParent()
		-- 			table.remove(self.cardCreate, i)
		-- 			print("\n\ntable size "..#self.cardCreate)
		-- 		--end
		-- 	end

		-- 	)

	end

	if drawCardValue ~= 0 then
		self.cardCreate[14] = cardNode.create(drawCardValue)
		cardDataMgr.handCardValue[14] = drawCardValue
		self.cardCreate[14]:setPositionX(girl.posx[14])
		self.stndNode[1]:addChild(self.cardCreate[14])
		self.cardCreate[14].sn = 14
		self.cardCreate[14].clickTimes = 0

		self.cardCreate[14].btnBg:onClicked(
			function ()
					self.nodeDachu[1]:setVisible(true)
					self.imgBigDachu[1]:loadTexture(drawCardValue..".png")
		            local delay = cc.DelayTime:create(1.0)
		            local action = cc.Sequence:create(delay, cc.CallFunc:create(
		                function ()
		                	self.nodeDachu[1]:setVisible(false)
		                	cardDataMgr.outNum[1] = cardDataMgr.outNum[1] + 1
		                	self.outCell[1][cardDataMgr.outNum[1]]:setVisible(true)
		                	self.outCellFace[1][cardDataMgr.outNum[1]]:loadTexture(drawCardValue..".png")
               			end))

					self.nodeDachu[1]:runAction(action)
					self.cardCreate[14]:removeFromParent()
				--end
			end

			)
	end

end


return CardManager
