--  设置弹出界面--
local CURRENT_MODULE_NAME = ...
local layerMgr = import(".LayerManager"):getInstance()
local musicMgr = import(".MusicManager"):getInstance()

local ChatUIBox = class("ChatUIBox", display.newLayer)
function ChatUIBox:ctor()
    self.chatUINode = cc.CSLoader:createNode("chatUI.csb"):addTo(self)
    local size = cc.Director:getInstance():getVisibleSize()
    local itemWidth = 432
    --self.chatUINode:setPosition(cc.p(size.width-itemWidth/2, display.center.y))
    self.chatUINode:setPosition(display.center)
    layerMgr.LoginScene:addChild(self, 10000)


    self.checkBox = {}
    self.imageNode = {}
	self.textBg = {}
	self.text = {}

	local bgImage = self.chatUINode:getChildByName("Image_mask")
	bgImage:setTouchEnabled(true)
	bgImage:addTouchEventListener(
	    function (sender, state )
	        if state == 2 then
	        	self.chatUINode:removeSelf()
	        end
	    end
	)

	self.imagePanel = self.chatUINode:getChildByName("Panel_1")
	self.scrollView = self.chatUINode:getChildByName("ScrollView_1")
	self.imagePanel:setVisible(false)
	self.scrollView:setVisible(true)

	for i=1,2 do
        local checkBoxName = "CheckBox_"..i
        self.checkBox[i] = self.chatUINode:getChildByName(checkBoxName)
    end

    for i=1,7 do
        local bgName = "Image_"..i
        local textName = "Text_"..i
        self.textBg[i] = self.scrollView:getChildByName(bgName)
        self.textBg[i]:setVisible(false)

        self.text[i] = self.scrollView:getChildByName(textName)
        self.text[i]:setTouchEnabled(true)
        self.text[i]:addTouchEventListener(
			    function (sender, state )
			        if state == 0 then
			        	musicMgr:playEffect("game_button_click.mp3", false)
				        self.textBg[i]:setVisible(true)
			        elseif state == 1 then
				        self.textBg[i]:setVisible(false)
			        elseif state == 2 then
			        	self.chatUINode:removeSelf()
			        	local chatId = 10000+i
						local snd = DataSnd:create(200, 7)
						snd:wrWORD(chatId)
			    		snd:sendData(netTb.SocketType.Game)
			    		snd:release()
			        end
			    end
		    )
    end

    for i=1,12 do
        local imageName = "Image_"..i
        self.imageNode[i] = self.imagePanel:getChildByName(imageName)

        if i<=6 then
        	self.imageNode[i]:setVisible(false)
    	else
    		self.imageNode[i]:setTouchEnabled(true)
    		self.imageNode[i]:addTouchEventListener(
			    function (sender, state )
			        if state == 0 then
			        	musicMgr:playEffect("game_button_click.mp3", false)
				        self.imageNode[i-6]:setVisible(true)
			        elseif state == 1 then
				        self.imageNode[i-6]:setVisible(false)
			        elseif state == 2 then
			        	self.chatUINode:removeSelf()
			        	local chatId = 10100+i-6
						local snd = DataSnd:create(200, 7)
						snd:wrWORD(chatId)
			    		snd:sendData(netTb.SocketType.Game)
			    		snd:release()
			        end
			    end
		    )
    	end
    end

    self.checkBox[1]:setSelected(true)
    self.checkBox[2]:setSelected(false)

    self.checkBox[1]:onClicked(
    	function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            self.checkBox[1]:setSelected(true)
            self.checkBox[2]:setSelected(false) 
            self.scrollView:setVisible(true)
            self.imagePanel:setVisible(false)
        end
    )

    self.checkBox[2]:onClicked(
    	function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            self.checkBox[1]:setSelected(false)
            self.checkBox[2]:setSelected(true)
            self.scrollView:setVisible(false)
            self.imagePanel:setVisible(true)
        end
    )

 --  	self.checkBox = {}
	-- self.textCheckBox = self.chatUINode:getChildByName("CheckBox_1")
	-- self.emojiCheckBox = self.chatUINode:getChildByName("CheckBox_2")
	-- local node1 = self.chatUINode:getChildByName("Node_1")
	-- local node2 = self.chatUINode:getChildByName("Node_2")
 --    local btnMusic = self.chatUINode:getChildByName("Button_music")
 --    local imgMusicOn = self.chatUINode:getChildByName("Image_on")
 --    local imgMusicOff = self.chatUINode:getChildByName("Image_off")

	-- btnMusic:onClicked(
	-- function()
	-- 	musicMgr:playEffect("game_button_click.mp3", false)
	-- 	if musicMgr.isMusicOn == true then
	-- 		imgMusicOn:setVisible(false)
	-- 		imgMusicOff:setVisible(true)
	-- 		musicMgr.isMusicOn = false
	-- 		musicMgr:stopMusic()
	-- 		print("MOn to Off")
	-- 	else
	-- 		imgMusicOn:setVisible(true)
	-- 		imgMusicOff:setVisible(false)
	-- 		musicMgr.isMusicOn = true
 --    		musicMgr:playMusic("bg.mp3", true)
	-- 		print("Off to on")
	-- 	end
	-- end)

	-- btnEffect:onClicked(
	-- function()
	-- 	musicMgr:playEffect("game_button_click.mp3", false)
	-- 	if musicMgr.isEffectOn == true then
	-- 		imgEffectOn:setVisible(false)
	-- 		imgEffectOff:setVisible(true)
	-- 		musicMgr.isEffectOn = false
	-- 		print("E On to Off")
	-- 	else
	-- 		imgEffectOn:setVisible(true)
	-- 		imgEffectOff:setVisible(false)
	-- 		musicMgr.isEffectOn = true
	-- 		print("E Off to on")
	-- 	end
	-- end)

	-- btnclose:onClicked(
 --    function (  )
 --    	musicMgr:playEffect("game_button_click.mp3", false)
 --        self:removeSelf()
 --    end)

	-- imgMusicOn:setVisible(musicMgr.isMusicOn)
	-- imgMusicOff:setVisible(not musicMgr.isMusicOn)
	-- imgEffectOn:setVisible(musicMgr.isEffectOn)
	-- imgEffectOff:setVisible(not musicMgr.isEffectOn)



end



function ChatUIBox:init(  )
    
end

function ChatUIBox.create(  )
    return ChatUIBox.new()
end
return ChatUIBox
