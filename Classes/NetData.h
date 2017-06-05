#ifndef  _NET_DATA_H_
#define  _NET_DATA_H_

#include "cocos2d.h"
#include "TTSocketClient.h"

USING_NS_CC;


struct stWeChatData
{
	char  openid[32];
	char  nickName[32];
	char  sex[32];
	char  headimgurl[200];
	char  roomNum[32];    //ʵ�����Ƿ����
	char  hostIp[16];   //ip
	char  unionId[64];  //ͳһ��ʶ 
	char  saves[32];
};


class  DataRcv:public Ref
{
public:
	const char*  phead;
	const char*  pNow;
public:
//	static DataRcv * create(void*  pData);  //dataΪ���ݣ�������������
	static DataRcv * create(EventCustom*  pEvent);  //dataΪ���ݣ�������������
	void destroys(void);
	char readInt8();
	short readInt16();
	int readInt32();
	unsigned char readByte();
	unsigned short readWORD();
	unsigned int readDWORD();
	long long readUInt64();     //�з��ţ� �д���
	double readDouble();
	std::string readString(int len);
};

class  DataSnd :public Ref
{
public:
	unsigned char pBuf[16384];
	char*  pNow;
	unsigned short wPos;
	unsigned short wDataSize;   //ȫ������,����TCP_Head 8�ֽ�
	//unsigned char bSocketType;   //0:login,   1:game
public:
	static DataSnd * create(unsigned short wMainSub, unsigned short wSub);
	//void destroys(void);
	//unsigned short getDataSize();
	void sendData(unsigned char bSocketType);
	void wrInt8(char);
	void wrInt16(short);
	void wrInt32(int);
	void wrInt64(long long);
	void wrByte(unsigned char);
	void wrWORD(unsigned short);
	void wrDWORD(unsigned int);
	void wrDouble(double);
	void wrString(std::string str, int len);
};	 


//sdkLoginData
class  SDKLoginData:public Ref
{
public:
	static SDKLoginData * create(EventCustom*  pEvent);
	std::string readOpenid();
	std::string readNickName();
	std::string readSex();
	std::string readHeadimgurl();
	std::string readRoomNum();
	std::string readIp();
	std::string readUnionId();
	std::string readSaves();
public:
	stWeChatData  weChatData;

};

#endif