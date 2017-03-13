local CURRENT_MODULE_NAME = ...

local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local cardNode		= import(".CardNode", CURRENT_MODULE_NAME)
local s_inst = nil
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
	self.cardNodes = {}
	self.whichTouch = nil
	self.stndMeCnt = nil

end

function CardManager:initCardNodes( cardValues ,playLayer)
	--table.sort(cardValues)
	for i=1,#cardValues do
		--self.cardNodes[i] = import(".CardNode", CURRENT_MODULE_NAME).create(cardValues[i])
		self.cardNodes[i] = cardNode.create(cardValues[i])
		self.cardNodes[i]:setPositionX(self.posx[i])
		playLayer.stndNode[1]:addChild(self.cardNodes[i])
		self.cardNodes[i].sn = i
		self.cardNodes[i].clickTimes = 0

		self.cardNodes[i].btnBg:onClicked(
			function ()
				self.cardNodes[i].clickTimes = self.cardNodes[i].clickTimes + 1
				if self.cardNodes[i].clickTimes == 1 then
					self.cardNodes[i]:setPositionY(30)
				elseif self.cardNodes[i].clickTimes == 2 then
					--self.cardNodes[i].clickTimes == 0
					self.cardNodes[i]:removeFromParent()
				end
			end

			)

	end
end


return CardManager
