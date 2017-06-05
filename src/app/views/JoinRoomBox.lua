--  创建房间弹出界面--
local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local musicMgr = import(".MusicManager"):getInstance()

local roomNumLenth = 6      --输入的房间号的长度，6位

local JoinRoomBox = class("JoinRoomBox", display.newLayer)
function JoinRoomBox:ctor()
--all Node
    dataMgr.roomSet.currentJushu = 0
    local rootNode = cc.CSLoader:createNode("joinRoom.csb"):addTo(self)
    self.rootNode = rootNode
    rootNode:setPosition(display.center)
    layerMgr.LoginScene:addChild(self, 10000)

    local txUid = rootNode:getChildByName("TextField_uid")
    local btnClose = rootNode:getChildByName("Button_close")
    local imgMask = rootNode:getChildByName("Image_mask")
    imgMask:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:removeSelf()
        end
        )
    btnClose:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:removeSelf()
        end)

    self.txts = {}
    self.roomNum = {}  --6位数
    self.nowNum = 0  --已输入的房间位数
    for i=1, roomNumLenth do
        local tmpStr = "Text_"..i
        self.txts[i] = rootNode:getChildByName(tmpStr)
    end

    local btns = {}
    local isCanClick = true    --数字键是否可以点击， 满6个不可点

    --Button_1   上显示的数值是0
    for i=1,10 do
        local tmpStr = "Button_"..i
        btns[i] = rootNode:getChildByName(tmpStr)
        if isCanClick then
            btns[i]:onClicked(
            function (  )
                musicMgr:playEffect("game_button_click.mp3", false)
                self.nowNum = self.nowNum + 1;
                print("self.nowNum"..self.nowNum)
                if self.nowNum < roomNumLenth + 1 then
                    self.txts[self.nowNum]:setString(tostring(i - 1))
                    self.txts[self.nowNum]:setVisible(true)
                    self.roomNum[roomNumLenth + 1 - self.nowNum] = i - 1

                    if self.nowNum == roomNumLenth then
                        dataMgr.roomSet.dwRoomNum = girl.getAllDicimalValue(self.roomNum, roomNumLenth)
                        self:startGame(netTb.ip, netTb.port.game, netTb.SocketType.Game) 
                        print("joinRoom"..dataMgr.roomSet.dwRoomNum) 
                        isCanClick = false
                    end
                else

                end


            end
            )
        end

    end

    local btnReput = rootNode:getChildByName("Button_re")
    btnReput:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            self:reputRoomNum()
        end
        )

    local btnDelete = rootNode:getChildByName("Button_delete")
    btnDelete:onClicked(
        function (  )
            self:deleteRoomNum()
        end
        )

    local btnOk = rootNode:getChildByName("Button_Ok")
    btnOk:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            local strUid = txUid:getString()
            if #strUid < roomNumLenth then
                return
            else
                dataMgr.roomSet.dwRoomNum = tonumber(strUid)
                self:startGame(netTb.ip, netTb.port.game, netTb.SocketType.Game) 
            end
 

        end
        )

        --自动启动游戏
    if dataMgr.roomSet.autoJoin == 1 then
        print("joinRoomBox,  auto startGame")
        self:startGame(netTb.ip, netTb.port.game, netTb.SocketType.Game)
        return
    end

end

function JoinRoomBox:reputRoomNum(  )
    self.roomNum = {}  --7位数
    self.nowNum = 0  --已输入的房间位数
    for i=1,roomNumLenth do
        self.txts[i]:setVisible(false)
    end
end

function JoinRoomBox:deleteRoomNum(  )
    musicMgr:playEffect("game_button_click.mp3", false)    
    if self.nowNum < 1 then
       return
    end
    if self.nowNum >= roomNumLenth + 1 then
        self.nowNum = roomNumLenth
    end
    self.txts[self.nowNum]:setVisible(false)
    self.nowNum = self.nowNum - 1;    
end

function JoinRoomBox:startGame(ip, port)
    TTSocketClient:getInstance():startSocket(ip, port, netTb.SocketType.Game)

    local snd = DataSnd:create(1, 1)
    local dwPlazaVersion = 65536
    local dwFrameVersion = 65536
    local dwProcessVersion = 65536
    local szPassword = uid
    local szMachineID = uid
    local wKindID = 3
    
--关闭点击按钮
    -- local wTable = dataMgr.roomSet.dwRoomNum % 65536
    -- local wChair = (dataMgr.roomSet.dwRoomNum - wTable)/ 65536  
    local wTable = (dataMgr.roomSet.dwRoomNum - 16951) % 65536
    local wChair = (dataMgr.roomSet.dwRoomNum - 16951 - wTable)/ 65536      

    --为密码，实际总的tableId为：wChair * 65536 + wTable + 16951
    --创建房间发满的，加入房间发实际的

    snd:wrDWORD(dwPlazaVersion)
    snd:wrDWORD(dwFrameVersion)
    snd:wrDWORD(dwProcessVersion)
    snd:wrDWORD(dataMgr.myBaseData.dwUserID)
    snd:wrString(szPassword, 66) 
    snd:wrString(szMachineID, 66) 
    snd:wrWORD(wKindID) 
    snd:wrWORD(wTable)  
    snd:wrWORD(wChair) 
    snd:sendData(netTb.SocketType.Game)
    snd:release();
end


function JoinRoomBox.create(  )
    return JoinRoomBox.new()
end

return JoinRoomBox
