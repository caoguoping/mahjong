cc.exports.girl            = girl or {}
cc.exports.netTb       = netTb or {}
cc.exports.fxString       = fxString or {}
cc.exports.fxValue       = fxValue or {}
cc.exports.soundCnt      = SoundCnt or {}

netTb.SocketType = 
{
	Login  = 0,
	Game   = 1,
}
--netTb.ip = "192.168.3.15"
netTb.ip = "101.37.20.36"
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

--[性别][青年][牌值]
soundCnt = {}
soundCnt[1] = {} --男
soundCnt[2] = {} --女
soundCnt[1][1] = {}   --男 青年
soundCnt[1][2] = {}   --男 中年
soundCnt[2][1] = {}   --女 青年
soundCnt[2][2] = {}   --女 中年
--男声1每种声音的个数
--万
soundCnt[1][1][1 ] = 2
soundCnt[1][1][2 ] = 4
soundCnt[1][1][3 ] = 1
soundCnt[1][1][4 ] = 1
soundCnt[1][1][5 ] = 1
soundCnt[1][1][6 ] = 2
soundCnt[1][1][7 ] = 1
soundCnt[1][1][8 ] = 3
soundCnt[1][1][9 ] = 1
--补花(10)， 碰(11)，杠(12），胡（13）， 杠开（14）， 天胡（15）， 地胡（16）
soundCnt[1][1][10] =4
soundCnt[1][1][11] =4 
soundCnt[1][1][12] =0
soundCnt[1][1][13] =1
soundCnt[1][1][14] =1 
soundCnt[1][1][15] =1 
soundCnt[1][1][16] =1 
--条
soundCnt[1][1][17] =3 
soundCnt[1][1][18] =2 
soundCnt[1][1][19] =2 
soundCnt[1][1][20] =2 
soundCnt[1][1][21] =3 
soundCnt[1][1][22] =2 
soundCnt[1][1][23] =2 
soundCnt[1][1][24] =2 
soundCnt[1][1][25] =1 
--饼
soundCnt[1][1][33] =2 
soundCnt[1][1][34] =3 
soundCnt[1][1][35] =2 
soundCnt[1][1][36] =3 
soundCnt[1][1][37] =2 
soundCnt[1][1][38] =1 
soundCnt[1][1][39] =2 
soundCnt[1][1][40] =4 
soundCnt[1][1][41] =2 
--东南西北
soundCnt[1][1][49] =2 
soundCnt[1][1][51] =3 
soundCnt[1][1][53] =4 
soundCnt[1][1][55] =2 
--女声1每种声音的个数
--万
soundCnt[2][1][1 ] =2 
soundCnt[2][1][2 ] =3 
soundCnt[2][1][3 ] =1 
soundCnt[2][1][4 ] =1 
soundCnt[2][1][5 ] =1
soundCnt[2][1][6 ] =2 
soundCnt[2][1][7 ] =1 
soundCnt[2][1][8 ] =3 
soundCnt[2][1][9 ] =1 
--补花， 碰，杠，胡， 杠开， 天胡， 地胡
soundCnt[2][1][10] =4 
soundCnt[2][1][11] =3 
soundCnt[2][1][12] =0 
soundCnt[2][1][13] =1 
soundCnt[2][1][14] =1 
soundCnt[2][1][15] =1 
soundCnt[2][1][16] =1 
--条
soundCnt[2][1][17] =3 
soundCnt[2][1][18] =2 
soundCnt[2][1][19] =2 
soundCnt[2][1][20] =2 
soundCnt[2][1][21] =3 
soundCnt[2][1][22] =2 
soundCnt[2][1][23] =2 
soundCnt[2][1][24] =2 
soundCnt[2][1][25] =1 
--饼
soundCnt[2][1][33] =2 
soundCnt[2][1][34] =3 
soundCnt[2][1][35] =2 
soundCnt[2][1][36] =3 
soundCnt[2][1][37] =2 
soundCnt[2][1][38] =1 
soundCnt[2][1][39] =2 
soundCnt[2][1][40] =4 
soundCnt[2][1][41] =2 
--东南西北
soundCnt[2][1][49] =3 
soundCnt[2][1][51] =3 
soundCnt[2][1][53] =4 
soundCnt[2][1][55] =2 

--男声2每种声音的个数
--万
soundCnt[1][2][1 ] =2 
soundCnt[1][2][2 ] =3 
soundCnt[1][2][3 ] =1 
soundCnt[1][2][4 ] =1 
soundCnt[1][2][5 ] =1 
soundCnt[1][2][6 ] =2 
soundCnt[1][2][7 ] =1 
soundCnt[1][2][8 ] =3 
soundCnt[1][2][9 ] =1 
--补花， 碰，杠，胡， 杠开， 天胡， 地胡
soundCnt[1][2][10] =4 
soundCnt[1][2][11] =3 
soundCnt[1][2][12] =0 
soundCnt[1][2][13] =1 
soundCnt[1][2][14] =1 
soundCnt[1][2][15] =1 
soundCnt[1][2][16] =1 
--条
soundCnt[1][2][17] =3 
soundCnt[1][2][18] =2 
soundCnt[1][2][19] =2 
soundCnt[1][2][20] =2 
soundCnt[1][2][21] =3 
soundCnt[1][2][22] =2 
soundCnt[1][2][23] =2 
soundCnt[1][2][24] =2 
soundCnt[1][2][25] =1 
--饼
soundCnt[1][2][33] =2 
soundCnt[1][2][34] =3 
soundCnt[1][2][35] =2 
soundCnt[1][2][36] =3 
soundCnt[1][2][37] =2 
soundCnt[1][2][38] =1 
soundCnt[1][2][39] =2 
soundCnt[1][2][40] =4 
soundCnt[1][2][41] =2 
--东南西北
soundCnt[1][2][49] =2 
soundCnt[1][2][51] =3 
soundCnt[1][2][53] =3 
soundCnt[1][2][55] =2 

--女声2每种声音的个数
--万
soundCnt[2][2][1 ] =2 
soundCnt[2][2][2 ] =3 
soundCnt[2][2][3 ] =1 
soundCnt[2][2][4 ] =1 
soundCnt[2][2][5 ] =1 
soundCnt[2][2][6 ] =2 
soundCnt[2][2][7 ] =1 
soundCnt[2][2][8 ] =3 
soundCnt[2][2][9 ] =1 
--补花， 碰，杠，胡， 杠开， 天胡， 地胡
soundCnt[2][2][10] =4 
soundCnt[2][2][11] =3 
soundCnt[2][2][12] =1 
soundCnt[2][2][13] =1 
soundCnt[2][2][14] =0
soundCnt[2][2][15] =1 
soundCnt[2][2][16] =1 
--条
soundCnt[2][2][17] =3 
soundCnt[2][2][18] =2 
soundCnt[2][2][19] =2 
soundCnt[2][2][20] =2 
soundCnt[2][2][21] =3 
soundCnt[2][2][22] =2 
soundCnt[2][2][23] =2 
soundCnt[2][2][24] =2 
soundCnt[2][2][25] =1 
--饼
soundCnt[2][2][33] =2 
soundCnt[2][2][34] =3 
soundCnt[2][2][35] =2 
soundCnt[2][2][36] =3 
soundCnt[2][2][37] =2 
soundCnt[2][2][38] =1 
soundCnt[2][2][39] =2 
soundCnt[2][2][40] =4 
soundCnt[2][2][41] =2 
--东南西北
soundCnt[2][2][49] =2 
soundCnt[2][2][50] =3 
soundCnt[2][2][51] =4 
soundCnt[2][2][52] =2 


