local CURRENT_MODULE_NAME = ...

local DataMgr     = import(".DataManager"):getInstance()
local LayerMgr = import(".LayerManager"):getInstance()
local cardNode		= import(".CardNode", CURRENT_MODULE_NAME)
local playLayer = LayerMgr:getLayer(LayerMgr.Enum.PlayLayer)
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
	self.posx = {}
	self.posy = nil
	self.cardNodes = {}
end

function CardManager:initCardNodes( cardValues )
	for i=1,#cardValues do
		--self.cardNodes[i] = import(".CardNode", CURRENT_MODULE_NAME).create(cardValues[i])
		self.cardNodes[i] = cardNode.create(cardValues[i])
		playLayer.stndNode[1]:addChild(self.cardNodes[i])
	end
end


return CardManager
