--  商城弹出界面--
local CURRENT_MODULE_NAME = ...
local dataMgr     = import(".DataManager"):getInstance()
local layerMgr = import(".LayerManager"):getInstance()
local musicMgr = import(".MusicManager"):getInstance()




local ShoppingBox = class("ShoppingBox", display.newLayer)
function ShoppingBox:ctor()
--all Node
    local rootNode = cc.CSLoader:createNode("shopping.csb"):addTo(self)
    self.rootNode = rootNode
    rootNode:setPosition(display.center)
    layerMgr.LoginScene:addChild(self, 10000)

    self.txtRoomCard = rootNode:getChildByName("Text_itemsNum")
    self.txtRoomCard:setString(dataMgr.prop[10])

    local btnClose = rootNode:getChildByName("Button_close")
        btnClose:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)
            local mainlayer = layerMgr:getLayer(layerMgr.layIndex.MainLayer)
            mainlayer:refresh()
            self:removeSelf()
        end)

    --测试
    --local cardTable = {3, 5, 15, 50, 100, 520}
    --local moneyTable = {5, 10, 30, 88, 168, 888}  --单位为元
    
    local itemNodes = {}
    local itemNames  = {}
    local itemNums   = {}
    local itemIcons  = {}
    local itemMoneys = {}
    local btns = {}

    for i=1,6 do
        itemNodes[i] =  rootNode:getChildByName("FileNode_"..i)
        itemNodes[i]:setVisible(false)
    end
    local itemCount = dataMgr.shoppingCount
    print("itemCount")
    print(itemCount)
    for i=1, itemCount do
        itemNodes[i]:setVisible(true)
        itemNames [i] = itemNodes[i]:getChildByName("Text_itemName")
        itemNums  [i] = itemNodes[i]:getChildByName("Text_itemNum")
        itemIcons [i] = itemNodes[i]:getChildByName("Image_icon")
        itemMoneys[i] = itemNodes[i]:getChildByName("Text_Money")
        btns[i]    =    itemNodes[i]:getChildByName("Button__buy")
        --itemNames[i]:setString("房卡")
        --itemNums[i]:setString("×"..cardTable[i])
        --itemMoneys[i]:setString(moneyTable[i]..".00")
        itemNames[i]:setString(dataMgr.shoppingData[i].ProtoName)
        itemNums[i]:setString("×"..dataMgr.shoppingData[i].RCnt)
        itemMoneys[i]:setString(dataMgr.shoppingData[i].RCost/100)
        itemIcons[i]:loadTexture("item_"..dataMgr.shoppingData[i].ProtoID..".png")
        btns[i]:onClicked(
        function (  )
            musicMgr:playEffect("game_button_click.mp3", false)

            --调用微信支付
            if  device.platform == "android" then
                self:callPay(dataMgr.shoppingData[i].ID)
            elseif device.platform == "ios" then
                --whj 添加iOS支付
                -- Helpers:createPurchase(i-1)
                local popupbox =  import(".popUpBox",CURRENT_MODULE_NAME).create()
                popupbox:setInfo(Strings.notopen)
                local btnOk = popupbox:getBtns(1)
                btnOk:onClicked(
                    function (  )
                        popupbox:remove()
                    end
                )
            else
                print("windows...")
                self:callPay(dataMgr.shoppingData[i].ID)
            end 
        end
        )
    end
end

--刷新房卡
function ShoppingBox:refresh(  )
    print("shoppingBox , refresh")
    self.txtRoomCard:setString(dataMgr.prop[10])
end

function ShoppingBox:sendCardChange(  )
    local times = os.time()
    print("times afterPay "..times)
    print("ischange ")
    print(dataMgr.buy.isCardChange)
    if dataMgr.buy.isCardChange then   --已经收到变化
        dataMgr.buy.isCardChange = false
        layerMgr.LoginScene.btnTimers[1]:stopAllActions()
        print("stopAllActions")
        local popupbox =  import(".popUpBox",CURRENT_MODULE_NAME).create() 
        popupbox:setInfo(Strings.buyOk)
        local btnOk = popupbox:getBtns(1)
        btnOk:onClicked(function (  )
            self:refresh()
            popupbox:remove()
        end)
        return
    else
        local snd = DataSnd:create(3, 501)
        snd:wrDWORD(dataMgr.myBaseData.dwUserID)
        snd:wrDWORD(10)
        snd:sendData(netTb.SocketType.Login)
        snd:release()
    end
end


--订单号生成后的响应, 再请求prepayId
function ShoppingBox:responceOrder(tradeID, TotalFee  )
    --  请求prepayId
    print("tradeID")    --订单号
    print(tradeID)
    print("TotalFee")
    print(TotalFee * 100)    --价格

    local xmlHttpReq = cc.XMLHttpRequest:new()
    xmlHttpReq.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    xmlHttpReq:open("POST", "http://gamecrm.nettl.cn/rest/get-pre")

    xmlHttpReq:setRequestHeader("Content-Type","application/x-www-data-urlencoded")

    local testTable =  {["appid"]=dataMgr.weChat.appid, ["mch_id"]=dataMgr.weChat.mch_id, ["nonce_str"]=dataMgr.weChat.nonce_str,
        ["body"]=dataMgr.weChat.body, ["out_trade_no"]=tradeID, ["total_fee"]=TotalFee*100,
        ["spbill_create_ip"]= dataMgr.weChat.spbill_create_ip, ["trade_type"]=dataMgr.weChat.trade_type
    }
    -- encode
    local jsonData = json.encode(testTable)

    local function onRespons(  )
        print("xmlHttpReq.readyState "..xmlHttpReq.readyState.." xmlHttpReq.status "..xmlHttpReq.status)
        if xmlHttpReq.readyState == 4 and (xmlHttpReq.status >= 200 and xmlHttpReq.status < 207) then
            local response   = xmlHttpReq.response
            local output = json.decode(response,1)
            print("xmlHttpRespons weChat Buy \n")
            print(output.prepay_id)
            if output.prepay_id ~= nil then
                local times = os.time()
                dataMgr.buy.cardSave = dataMgr.prop[10]
                print("times before pay "..times.."  prop10 "..dataMgr.buy.cardSave)
                Helpers:callWeChatPay(output.prepay_id, tostring(time10))  --启动支付
                local delayAction     = cc.DelayTime:create(2.0)
                local callFuncAction1 = cc.CallFunc:create(
                    function()
                        self:sendCardChange()
                    end)
                local sequenceAction  = cc.Sequence:create(delayAction, callFuncAction1)
                local repeatAction    = cc.Repeat:create(sequenceAction, 5)
                layerMgr.LoginScene.btnTimers[1]:runAction(repeatAction)
            end
        end
    end

    xmlHttpReq:registerScriptHandler(onRespons)
    xmlHttpReq:send(jsonData)    
end


function ShoppingBox:callPay(indexs )
    --随机数
    local time10 = os.time()
    local time20 = math.random(1, 1000)
    local strNonce_str  = tostring(time10 * 1000 + time20)
    dataMgr.weChat.nonce_str = strNonce_str
    --请求订单号与价格
    local orderUrl = "http://order.nettl.cn/GenerateOrderID/TLMahjong?sign="
    local actionKay = "TLMahjongvPMEVd?]h,@wqSepmnNk=!12"
    local strMd5First = Crypto:getMd5String(actionKay)
    local strMiddle = string.sub(strMd5First, 9, 24)
    local strLast = strMiddle..time10
    local strSign = Crypto:getMd5String(strLast)
    orderUrl = orderUrl..strSign.."&t="..time10

    local xmlHttpReq1 = cc.XMLHttpRequest:new()
    xmlHttpReq1.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    xmlHttpReq1:open("POST", orderUrl)
    xmlHttpReq1:setRequestHeader("Content-Type","application/x-www-data-urlencoded")

    local testTable =  {["UserID"]=dataMgr.myBaseData.dwUserID, ["ProtoID"]=indexs, ["Type"]=2
    }

    -- encode
    local jsonData = json.encode(testTable)
    local function onRespons(  )
        print("xmlHttpReq.readyState in first "..xmlHttpReq1.readyState.." xmlHttpReq.status "..xmlHttpReq1.status)
        if xmlHttpReq1.readyState == 4 and (xmlHttpReq1.status >= 200 and xmlHttpReq1.status < 207) then
            local response   = xmlHttpReq1.response
                print("response\n\n")
                print(response)

                local a1, a2, a3, a4, a5, a6
                a1, a2 = string.find(response, "TradeID")
                a3, a4 = string.find(response, "TotalFee")
                a5, a6 = string.find(response, "Proto")
                print("666666666")
                print(a1, a2, a3, a4, a5, a6)
                a2 = a2 + 4
                a3 = a3 - 4
                a4 = a4 + 4
                a5 = a5 - 4

                local tradeId = string.sub(response, a2, a3)
                local totalFee = string.sub(response, a4, a5)
                --local output = json.decode(response,1)
                self:responceOrder(tradeId, totalFee)
        end
    end

    xmlHttpReq1:registerScriptHandler(onRespons)
    xmlHttpReq1:send(jsonData)
end



function ShoppingBox.create(  )
    return ShoppingBox.new()
end

return ShoppingBox
