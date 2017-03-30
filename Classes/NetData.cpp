#include "NetData.h"

DataRcv* DataRcv::create(EventCustom*  pEvent)
{
	DataRcv *pDataRcv = new DataRcv();
	if (pDataRcv)
	{
		pDataRcv->phead = (const char*)pEvent->getUserData();
		//�����ݿ�ʼ��ƫ�ƣ� ������������
		pDataRcv->pNow = (const char*)pEvent->getUserData();
		pDataRcv->autorelease();
		pDataRcv->retain();
	}
	else
	{
		CC_SAFE_DELETE(pDataRcv);
	}
	return pDataRcv;
}

void DataRcv::destroys()
{
	if (phead != NULL)
	{
		delete phead;
		phead = NULL;
		pNow = NULL;
	}
	this->release();
}

char DataRcv::readInt8()
{
    char i[1];
	memcpy(i, pNow, 1);
	pNow++;
	return i[0];
}


short DataRcv::readInt16()
{
	short i[1];
	memcpy(i, pNow, 2);
	pNow += 2;
	return i[0];
}

int DataRcv::readInt32()
{
	int i[1];
	memcpy(i, pNow, 4);
	pNow += 4;
	return i[0];
}


unsigned char DataRcv::readByte()
{
	unsigned char i[1];
	memcpy(i, pNow, 1);
	pNow++;
	return i[0];
}


unsigned short DataRcv::readWORD()
{
	unsigned short i[1];
	memcpy(i, pNow, 2);
	pNow += 2;
	return i[0];
}

unsigned int DataRcv::readDWORD()
{
	unsigned int i[1];
	memcpy(i, pNow, 4);
	pNow += 4;
	return i[0];
}

long long DataRcv::readUInt64()
{
	long long i[1];
	memcpy(i, pNow, 8);
	pNow += 8;
	return i[0];
}

double DataRcv::readDouble()
{
	double i[1];
	memcpy(i, pNow, 8);
	pNow += 8;
	return i[0];
}

std::string DataRcv::readString(int len)
{
	std::string s;
	char i[256];
	memcpy(i, pNow, len);
	s = i;
	pNow += len;
	return s;
}

DataSnd* DataSnd::create(unsigned short wMainCmd, unsigned short wSubCmd)
{
	DataSnd *pDataSnd = new DataSnd();
	if (pDataSnd)
	{
		//log("[LUA-print] sendData  Main %d,  Sub %d", wMainCmd, wSubCmd);
		pDataSnd->pNow = (char*)pDataSnd->pBuf + sizeof(TCP_Info);
		memcpy(pDataSnd->pNow, &wMainCmd, 2);
		pDataSnd->pNow += 2;
		memcpy(pDataSnd->pNow, &wSubCmd, 2);
		pDataSnd->pNow += 2;
		pDataSnd->wDataSize = sizeof(TCP_Head);
		pDataSnd->autorelease();
		pDataSnd->retain();
	}
	else
	{
		CC_SAFE_DELETE(pDataSnd);
	}
	return pDataSnd;
}

void DataSnd::wrInt8(char val)
{
	memcpy(pNow, &val, 1);
	pNow += 1;
	wDataSize += 1;
}

void DataSnd::wrInt16(short val)
{
	memcpy(pNow, &val, 2);
	pNow += 2;
	wDataSize += 2;
}

void DataSnd::wrInt32(int val)
{
	memcpy(pNow, &val, 4);
	pNow += 4;
	wDataSize += 4;
}

void DataSnd::wrInt64(long long val)
{
	memcpy(pNow, &val, 8);
	pNow += 8;
	wDataSize += 8;
}

void DataSnd::wrByte(unsigned char val)
{
	memcpy(pNow, &val, 1);
	pNow += 1;
	wDataSize += 1;
}

void DataSnd::wrWORD(unsigned short val)
{
	memcpy(pNow, &val, 2);
	pNow += 2;
	wDataSize += 2;
}

void DataSnd::wrDWORD(unsigned int val)
{
	memcpy(pNow, &val, 4);
	pNow += 4;
	wDataSize += 4;
}

void DataSnd::wrDouble(double val)
{
	memcpy(pNow, &val, 8);
	pNow += 8;
	wDataSize += 8;
}

void DataSnd::wrString(std::string str, int len)
{
	memcpy(pNow, str.c_str(), len);
	pNow += len;
	wDataSize += len;
}

void  DataSnd::sendData(unsigned char bSocketType)
{
	unsigned short wEncryptSize = wDataSize - sizeof(TCP_Info);
	unsigned short wSnapCount = 0;
	if ((wEncryptSize % sizeof(unsigned int)) != 0)
	{
		wSnapCount = sizeof(unsigned int) - wEncryptSize % sizeof(unsigned int);
		memset(pBuf + sizeof(TCP_Info) + wEncryptSize, 0, wSnapCount);
	}
	//Ч�������ֽ�ӳ�䣬������TCP_Info, ����ͷ4�ֽ�
	unsigned char cbCheckCode = 0;
	unsigned short i = 0;
	for (i = sizeof(TCP_Info); i < wDataSize; i++)
	{
		cbCheckCode += pBuf[i];
		pBuf[i] = g_SendByteMap[(unsigned char)(pBuf[i])];   //ӳ��
	}
	//��д��Ϣͷ
	TCP_Info*  tcpInfo = (TCP_Info *)pBuf;
	tcpInfo->cbCheckCode = ~cbCheckCode + 1;
	tcpInfo->wPacketSize = wDataSize;   //ȫ�����ȣ�����TCP_Head8�ֽ�

	TTSocketClient::getInstance()->Send((char*)pBuf, wDataSize, bSocketType);
}

