cc.exports.girl            = girl or {}
cc.exports.netTb       = netTb or {}
cc.exports.fxString       = fxString or {}
cc.exports.fxValue       = fxValue or {}


netTb.SocketType = 
{
	Login  = 0,
	Game   = 1,
}
-- netTb.ip = "192.168.3.15"   --内网
netTb.ip = "101.37.16.227"   --外网
--netTb.ip = "192.168.3.19"
--netTb.ip = "101.37.20.36"  --版署ip

netTb.version = 
{
    main = 1,
    sub = 2,
    data = 27
}


netTb.port =
{
    login = 5050,
    --game = 5010,  --版署
    game = 5011,    --15 或 36
    --game = 5020,      -- 19 
    jinyunzi = 5010,
    changkaihuan = 5011,
}


--未缩小的原始尺寸
girl.cardHeight = 124
girl.cardWidth = 87        --底牌X被缩小为87,原为92   87 * 14 = 1218   left 62    1131 + 20 + 15 =1166
girl.leftWidth = 20   --最左边预留20
girl.GapWidth = 15   --13张与14张之间留15


--动态创建的手牌的位置
girl.posy = 0
girl.posx = {}
	for i=1,13 do
		girl.posx[i] = girl.leftWidth + (i - 0.5) * girl.cardWidth    --左边留空20
	end
girl.posx[14] = girl.leftWidth + 13.5 * girl.cardWidth + girl.GapWidth

--圈数对应的房卡
girl.juToFang = {}
girl.juToFang[1] = 2
girl.juToFang[2] = 4
girl.juToFang[4] = 7


--各种延时
girl.delayTime = {}
girl.delayTime.showHupaiRst = 2.0     --显示胡牌结果前的等待
girl.delayTime.thinkTime  = 15    --出牌思考时间，超过自动出牌
--girl.delayTime.autoThinkTime = 1   --托管状态，出牌思考时间
girl.delayTime.autoThinkTime = 5   --托管状态，出牌思考时间
girl.delayTime.BigJiesuan = 6   --最后一局小结算停留时间，结束后跳出大结算


--1,我,  2,左，3， 上   碰杠胡特效
girl.effPosX = {}
girl.effPosY = {}
girl.effPosX[1] = 641	
girl.effPosY[1] = 150
girl.effPosX[2] = 302	
girl.effPosY[2] = 417
girl.effPosX[3] = 627	
girl.effPosY[3] = 593
girl.effPosX[4] = 955	
girl.effPosY[4] = 428

--当场加减分，位置
girl.scorePosX = {}
girl.scorePosY = {}
girl.scorePosX[1] = 180
girl.scorePosX[2] = 180
girl.scorePosX[3] = 860
girl.scorePosX[4] = 1080
girl.scorePosY[1] = 180
girl.scorePosY[2] = 550
girl.scorePosY[3] = 670
girl.scorePosY[4] = 480


fxString[1 ] = "胡牌     "
fxString[2 ] = "胡牌     "
fxString[3 ] = "包牌     "
fxString[4 ] = "对对胡   "
fxString[5 ] = "清一色   "
fxString[6 ] = "混一色   "
fxString[7 ] = "天胡     "
fxString[8 ] = "地胡     "
fxString[9 ] = "全球独钓 "
fxString[10] = "压绝     "
fxString[11] = "七对     "
fxString[12] = "海底捞月 "
fxString[13] = "小杠开花 "
fxString[14] = "大杠开花 "
fxString[15] = "双七对   "
fxString[16] = "无花果   "
fxString[17] = "门清     "
fxString[18] = "非门清   "
fxString[19] = "压档     "
fxString[20] = "独占     "
fxString[21] = "边枝     "
fxString[22] = "缺一     "
fxString[23] = "风碰     "
fxString[24] = "风杠     "
fxString[25] = "风暗杠   "
fxString[30] = "花牌     "
fxString[31] = "花牌(砸2)"
fxString[32] = "比下胡   "

--与上面的翻型一一对应
fxValue[1 ] = "+ 10"
fxValue[2 ] = "+ 10"
fxValue[3 ] = "+ 0"
fxValue[4 ] = "+ 20"
fxValue[5 ] = "+ 30"
fxValue[6 ] = "+ 20"
fxValue[7 ] = "+ 100"
fxValue[8 ] = "+ 50"
fxValue[9 ] = "+ 40"
fxValue[10] = "+ 20"
fxValue[11] = "+ 40"
fxValue[12] = "+ 20"
fxValue[13] = "+ 10"
fxValue[14] = "+ 20"
fxValue[15] = "+ 80"
fxValue[16] = "+ 20"
fxValue[17] = "+ 10"
fxValue[18] = "+ 0"
fxValue[19] = "+ 1"
fxValue[20] = "+ 1"
fxValue[21] = "+ 1"
fxValue[22] = "+ 1"
fxValue[23] = "+ 1"
fxValue[24] = "+ 2"
fxValue[25] = "+ 3"
fxValue[32] = "x 2"

