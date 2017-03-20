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
	self.cardHeight = 130
	self.cardWidth = 92
	self.posx = {}
	for i=1,13 do
		self.posx[i] = -586 + 92 * (i - 1) * 0.93
	end
	self.posx[14] = 564
	self.posy = 0
	self.cardCreate = {}
	self.whichTouch = nil
	self.stndMeCnt = nil

end

function CardManager:hideAllCards(  )
    for i=1,4 do
        self.wallNode[i]:setVisible(false)
        self.stndNode[i]:setVisible(false)
        self.dachNode[i]:setVisible(false)
        self.pengNode[i]:setVisible(false)
    end
    self.stndNodeMeBei:setVisible(false)
end

function CardManager:initAllNodes( param )
	local rootNode = param.rootNode
	self.wallNode = {}
    self.stndNode = {}
    self.dachNode = {}
    self.pengNode = {}
    self.wallCell = {}  --1, 144 已按抓牌顺序排好序
    self.stndCell = {}
    self.dachCell = {}
    self.pengCell = {}

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
    self.dachNode[1]  = rootNode:getChildByName("FileNode_dachuMe")
    self.dachNode[4]  = rootNode:getChildByName("FileNode_dachuRight")
    self.dachNode[3]  = rootNode:getChildByName("FileNode_dachuUp")
    self.dachNode[2]  = rootNode:getChildByName("FileNode_dachuLeft")
    self.pengNode[1]  = rootNode:getChildByName("FileNode_pengMe")
    self.pengNode[4]  = rootNode:getChildByName("FileNode_pengRight")
    self.pengNode[3]  = rootNode:getChildByName("FileNode_pengUp")
    self.pengNode[2]  = rootNode:getChildByName("FileNode_pengLeft")
    self.stndNodeMeBei = rootNode:getChildByName("FileNode_standMeBei")

    -- print("node  "..self.wallNode[1]  )
    -- print("node  "..self.wallNode[4]  )
    -- print("node  "..self.wallNode[3]  )
    -- print("node  "..self.wallNode[2]  )
    -- print("node  "..self.stndNode[1]  )
    -- print("node  "..self.stndNode[4]  )
    -- print("node  "..self.stndNode[3]  )
    -- print("node  "..self.stndNode[2]  )
    -- print("node  "..self.dachNode[1]  )
    -- print("node  "..self.dachNode[4]  )
    -- print("node  "..self.dachNode[3]  )
    -- print("node  "..self.dachNode[2]  )
    -- print("node  "..self.pengNode[1]  )
    -- print("node  "..self.pengNode[4]  )
    -- print("node  "..self.pengNode[3]  )
    -- print("node  "..self.pengNode[2]  )
    -- print("node  "..self.stndNodeMeBei)

    --pai
    for i = 1, 4 do
        --self.wallCell[i] = {}
        self.stndCell[i] = {}
        self.dachCell[i] = {}
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
            local imgBg =  self.dachNode[i]:getChildByName(imgName) 
            self.dachCell[i][j] = imgBg:getChildByName("ImageFace")
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

function CardManager:initcardCreate(cardValues)
	self.cardCreate = {}
	--local cardValues = {25, 18, 1, 2, 3, 8, 5, 5, 7, 9, 40, 41, 52, 74}
	table.sort(cardValues)

	for i=1,#cardValues do
		self.cardCreate[i] = cardNode.create(cardValues[i])
		cardDataMgr.handCard[i] = cardValues[i]
		self.cardCreate[i]:setPositionX(girl.posx[i])

		self.stndNode[1]:addChild(self.cardCreate[i])
		self.cardCreate[i].sn = i
		self.cardCreate[i].clickTimes = 0

		self.cardCreate[i].btnBg:onClicked(
			function ()
				-- self.cardCreate[i].clickTimes = self.cardCreate[i].clickTimes + 1
				-- if self.cardCreate[i].clickTimes == 1 then
				-- 	self.cardCreate[i]:setPositionY(30)
				-- elseif self.cardCreate[i].clickTimes == 2 then
				-- 	--self.cardCreate[i].clickTimes == 0

					--[[
					local snd = DataSnd:create(200, 1)
					snd:wrByte(cardValues[i])
		            snd:sendData(netTb.SocketType.Game)
		            snd:release();
					--]]
					local playLayer = layerMgr:getLayer(layerMgr.layIndex.PlayLayer)
					playLayer.nodeDachu[1]:setVisible(true)
					playLayer.imgBigDachu[1]:loadTexture(cardValues[i]..".png")
		            local delay = cc.DelayTime:create(1.0)
		            local action = cc.Sequence:create(delay, cc.CallFunc:create(
		                function ()
		                	playLayer.nodeDachu[1]:setVisible(false)
		                	cardDataMgr.dachuNum[1] = cardDataMgr.dachuNum[1] + 1
		                	self.dachCell[1][cardDataMgr.dachuNum[1]]:setVisible(true)
		                	self.dachCell[1][cardDataMgr.dachuNum[1]]:loadTexture(cardValues[i]..".png")
               			end))

					playLayer.nodeDachu[1]:runAction(action)
					self.cardCreate[i]:removeFromParent()
				--end
			end

			)

	end
end


return CardManager
