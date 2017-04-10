cc.exports.girl            = girl or {}
cc.exports.netTb       = netTb or {}
cc.exports.fxString       = fxString or {}
cc.exports.fxValue       = fxValue or {}

netTb.SocketType = 
{
	Login  = 0,
	Game   = 1,
}
--netTb.ip = "192.168.3.15"
netTb.ip = "101.66.251.195"
netTb.port =
{
    login = 5050,
    game = 5010,
    jinyunzi = 5010,
    changkaihuan = 5011,
}




--未缩小的原始尺寸
girl.cardHeight = 130
girl.cardWidth = 92

girl.posy = 0
girl.posx = {}
	for i=1,13 do
		girl.posx[i] = 640 - 564 + 92 * (i - 1) * 0.93
	end
girl.posx[14] = 564 + 640

--1,wo,  2,左，3， 上
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



fxString[1 ] = "胡牌"
fxString[2 ] = "胡牌"
fxString[3 ] = "包牌"
fxString[4 ] = "对对胡"
fxString[5 ] = "清一色"
fxString[6 ] = "混一色"
fxString[7 ] = "天胡"
fxString[8 ] = "地胡"
fxString[9 ] = "全求独钓"
fxString[10] = "压绝"
fxString[11] = "七对"
fxString[12] = "海底捞月"
fxString[13] = "小杠开花"
fxString[14] = "大杠开花"
fxString[15] = "双七对"
fxString[16] = "无花果"
fxString[17] = "门清"
fxString[18] = "非门清"
fxString[19] = "压档"
fxString[20] = "独占"
fxString[21] = "边枝"
fxString[22] = "缺一"
fxString[23] = "风碰"
fxString[24] = "风杠"
fxString[25] = "风暗杠"

--与上面的翻型一一对应
fxValue[1 ] = 10
fxValue[2 ] = 10
fxValue[3 ] = 0
fxValue[4 ] = 20
fxValue[5 ] = 30
fxValue[6 ] = 20
fxValue[7 ] = 100
fxValue[8 ] = 100
fxValue[9 ] = 40
fxValue[10] = 20
fxValue[11] = 40
fxValue[12] = 20
fxValue[13] = 10
fxValue[14] = 20
fxValue[15] = 80
fxValue[16] = 20
fxValue[17] = 10
fxValue[18] = 0
fxValue[19] = 1
fxValue[20] = 1
fxValue[21] = 1
fxValue[22] = 1
fxValue[23] = 1
fxValue[24] = 2
fxValue[25] = 3


--[[
命名：  nan(nv) + _牌值 + _中年（青年) + _随机.mp3
1：青年， 2：中年

例：nan_9_1_2.mp3     青年男子九万的第二个音效
	nv_11_2_1.mp3     中年女子碰的第一个音效
]]

-- --男声1每种声音的个数
-- NanCnt1 = {}
-- --万
-- NanCnt1[1 ] = 
-- NanCnt1[2 ] = 
-- NanCnt1[3 ] = 
-- NanCnt1[4 ] = 
-- NanCnt1[5 ] = 
-- NanCnt1[6 ] = 
-- NanCnt1[7 ] = 
-- NanCnt1[8 ] = 
-- NanCnt1[9 ] = 
-- --补花(10)， 碰(11)，杠（12），胡（13）， 杠开（14）， 天胡（15）， 地胡（16）
-- NanCnt1[10] = 
-- NanCnt1[11] = 
-- NanCnt1[12] = 
-- NanCnt1[13] = 
-- NanCnt1[14] = 
-- NanCnt1[15] = 
-- NanCnt1[16] = 
-- --条
-- NanCnt1[17] = 
-- NanCnt1[18] = 
-- NanCnt1[19] = 
-- NanCnt1[20] = 
-- NanCnt1[21] = 
-- NanCnt1[22] = 
-- NanCnt1[23] = 
-- NanCnt1[24] = 
-- NanCnt1[25] = 
-- --饼
-- NanCnt1[33] = 
-- NanCnt1[34] = 
-- NanCnt1[35] = 
-- NanCnt1[36] = 
-- NanCnt1[37] = 
-- NanCnt1[38] = 
-- NanCnt1[39] = 
-- NanCnt1[40] = 
-- NanCnt1[41] = 

-- --东南西北
-- NanCnt1[49] = 
-- NanCnt1[50] = 
-- NanCnt1[51] = 
-- NanCnt1[52] = 


-- --女声1每种声音的个数
-- NvCnt1 = {}
-- --万
-- NvCnt1[1 ] = 
-- NvCnt1[2 ] = 
-- NvCnt1[3 ] = 
-- NvCnt1[4 ] = 
-- NvCnt1[5 ] = 
-- NvCnt1[6 ] = 
-- NvCnt1[7 ] = 
-- NvCnt1[8 ] = 
-- NvCnt1[9 ] = 
-- --补花， 碰，杠，胡， 杠开， 天胡， 地胡
-- NvCnt1[10] = 
-- NvCnt1[11] = 
-- NvCnt1[12] = 
-- NvCnt1[13] = 
-- NvCnt1[14] = 
-- NvCnt1[15] = 
-- NvCnt1[16] = 
-- --条
-- NvCnt1[17] = 
-- NvCnt1[18] = 
-- NvCnt1[19] = 
-- NvCnt1[20] = 
-- NvCnt1[21] = 
-- NvCnt1[22] = 
-- NvCnt1[23] = 
-- NvCnt1[24] = 
-- NvCnt1[25] = 
-- --饼
-- NvCnt1[33] = 
-- NvCnt1[34] = 
-- NvCnt1[35] = 
-- NvCnt1[36] = 
-- NvCnt1[37] = 
-- NvCnt1[38] = 
-- NvCnt1[39] = 
-- NvCnt1[40] = 
-- NvCnt1[41] = 

-- --东南西北
-- NvCnt1[49] = 
-- NvCnt1[50] = 
-- NvCnt1[51] = 
-- NvCnt1[52] = 






-- --男声2每种声音的个数
-- NanCnt2 = {}
-- --万
-- NanCnt2[1 ] = 
-- NanCnt2[2 ] = 
-- NanCnt2[3 ] = 
-- NanCnt2[4 ] = 
-- NanCnt2[5 ] = 
-- NanCnt2[6 ] = 
-- NanCnt2[7 ] = 
-- NanCnt2[8 ] = 
-- NanCnt2[9 ] = 
-- --补花， 碰，杠，胡， 杠开， 天胡， 地胡
-- NanCnt2[10] = 
-- NanCnt2[11] = 
-- NanCnt2[12] = 
-- NanCnt2[13] = 
-- NanCnt2[14] = 
-- NanCnt2[15] = 
-- NanCnt2[16] = 
-- --条
-- NanCnt2[17] = 
-- NanCnt2[18] = 
-- NanCnt2[19] = 
-- NanCnt2[20] = 
-- NanCnt2[21] = 
-- NanCnt2[22] = 
-- NanCnt2[23] = 
-- NanCnt2[24] = 
-- NanCnt2[25] = 
-- --饼
-- NanCnt2[33] = 
-- NanCnt2[34] = 
-- NanCnt2[35] = 
-- NanCnt2[36] = 
-- NanCnt2[37] = 
-- NanCnt2[38] = 
-- NanCnt2[39] = 
-- NanCnt2[40] = 
-- NanCnt2[41] = 

-- --东南西北
-- NanCnt2[49] = 
-- NanCnt2[50] = 
-- NanCnt2[51] = 
-- NanCnt2[52] = 


-- --女声2每种声音的个数
-- NvCnt2 = {}
-- --万
-- NvCnt2[1 ] = 
-- NvCnt2[2 ] = 
-- NvCnt2[3 ] = 
-- NvCnt2[4 ] = 
-- NvCnt2[5 ] = 
-- NvCnt2[6 ] = 
-- NvCnt2[7 ] = 
-- NvCnt2[8 ] = 
-- NvCnt2[9 ] = 
-- --补花， 碰，杠，胡， 杠开， 天胡， 地胡
-- NvCnt2[10] = 
-- NvCnt2[11] = 
-- NvCnt2[12] = 
-- NvCnt2[13] = 
-- NvCnt2[14] = 
-- NvCnt2[15] = 
-- NvCnt2[16] = 
-- --条
-- NvCnt2[17] = 
-- NvCnt2[18] = 
-- NvCnt2[19] = 
-- NvCnt2[20] = 
-- NvCnt2[21] = 
-- NvCnt2[22] = 
-- NvCnt2[23] = 
-- NvCnt2[24] = 
-- NvCnt2[25] = 
-- --饼
-- NvCnt2[33] = 
-- NvCnt2[34] = 
-- NvCnt2[35] = 
-- NvCnt2[36] = 
-- NvCnt2[37] = 
-- NvCnt2[38] = 
-- NvCnt2[39] = 
-- NvCnt2[40] = 
-- NvCnt2[41] = 

-- --东南西北
-- NvCnt2[49] = 
-- NvCnt2[50] = 
-- NvCnt2[51] = 
-- NvCnt2[52] = 



