#include "TTSocketClient.h"

static TTSocketClient* m_instance = NULL;

TTSocketClient::TTSocketClient()
{
	mSocketLogin = 0;
	mSocketGame = 0;
#ifdef WIN32
	unsigned short wVersionRequested;
	wVersionRequested = MAKEWORD(2, 0);
	WSADATA wsaData;
	int nRet = WSAStartup(wVersionRequested, &wsaData);
	if (nRet != 0)
	{
		return;
	}
#endif
}

TTSocketClient::~TTSocketClient()
{
}

TTSocketClient* TTSocketClient::getInstance()
{
	if (m_instance == NULL)
	{
		m_instance = new TTSocketClient;
	}
	return m_instance;
}



//解密数据
unsigned short TTSocketClient::CrevasseBuffer(unsigned char pcbDataBuffer[], unsigned short wDataSize)
{
	if (wDataSize < sizeof(TCP_Command))
	{
		return 0;
	}
	//调整长度
	unsigned short wSnapCount = 0;
	if ((wDataSize % sizeof(unsigned int)) != 0)
	{
		wSnapCount = sizeof(unsigned int)-wDataSize % sizeof(unsigned int);
		memset(pcbDataBuffer + wDataSize, 0, wSnapCount);
	}
	for (int i = 0; i < wDataSize; i++)
	{
		pcbDataBuffer[i] = MapRecvByte(pcbDataBuffer[i]);
	}

	return wDataSize;
}



//映射接收数据
unsigned char TTSocketClient::MapRecvByte(unsigned char const cbData)
{
	unsigned char cbMap = g_RecvByteMap[cbData];
	return cbMap;
}

bool TTSocketClient::recvDateLogin()
{
	int iRetCode = 0;
	bool  isContinune;
	TCP_Info   pInfoHead;
	unsigned short wPacketSize;
	unsigned short wPacketSizeSave;

	while (mSocketLogin != 0)
	{
		//read head
		iRetCode = recv(mSocketLogin, (char*)&pInfoHead, sizeof(TCP_Info), 0);
		isContinune = true;
		if (0 == iRetCode)
		{
			log("cocos2d-x recv 0 header");
			continue;
		}
		else if (iRetCode < 0)
		{
			closeMySocket(0);
			return true;
		}
		else
		{
			wPacketSizeSave = wPacketSize = pInfoHead.wPacketSize - sizeof(TCP_Info);  //去除TCP_info后的长度
			if (wPacketSize > SOCKET_TCP_BUFFER)
			{
				log("TTSocketClient recvDataLogin wPacketSize > 16384, error!");
				continue;
			}
			if (mSocketLogin == 0)
			{
				return true;
			}
			int recv_len = 0;

			//read body
			char*  pRecvBufLogin = new char[SOCKET_TCP_BUFFER];
			while (mSocketLogin != 0)
			{
				iRetCode = recv(mSocketLogin, pRecvBufLogin + recv_len, wPacketSize - recv_len, 0);
				lastRcvTimeLogin = time(NULL);   //更新接收时间
				if (iRetCode == 0)
				{
					isContinune = false;
					continue;
				}
				else if (iRetCode < 0)
				{
					mSocketLogin = 0;
					return true;
				}
				recv_len += iRetCode;
				if (recv_len >= wPacketSize)
				{
					break;
				}
			}
			if (isContinune)
			{
				wPacketSize = wPacketSizeSave;
				unsigned short wRealySize = CrevasseBuffer((unsigned char*)pRecvBufLogin, wPacketSize);
				if (wRealySize < sizeof(TCP_Command))
				{
					continue;
				}
				MTCustomEventQueue::getInstance()->pushCustomEvent("rcvDataLogin", pRecvBufLogin);
			}
		}
	}
	return true;
}

bool TTSocketClient::recvDateGame()
{
	int iRetCode = 0;
	bool  isContinune;
	TCP_Info   pInfoHead;
	unsigned short wPacketSize;
	unsigned short wPacketSizeSave;

	while (mSocketGame != 0)
	{
		//read head
		iRetCode = recv(mSocketGame, (char*)&pInfoHead, sizeof(TCP_Info), 0);
		//log("cocos2d-x header %d", iRetCode);
		isContinune = true;
		if (0 == iRetCode)
		{
			log("cocos2d-x game recv 0 header");
			continue;
		}
		else if (iRetCode < 0)
		{
			closeMySocket(1);
			return true;
		}
		else
		{
			wPacketSizeSave = wPacketSize = pInfoHead.wPacketSize - sizeof(TCP_Info);  //去除TCP_info后的长度
			if (wPacketSize > SOCKET_TCP_BUFFER)
			{
				log("TTSocketClient recvDataGame wPacketSize > 16384, error!");
				continue;
			}
			if (mSocketGame == 0)
			{
				return true;
			}
			int recv_len = 0;

			//read body
			char*  pRecvBufGame = new char[SOCKET_TCP_BUFFER];
			while (mSocketGame != 0)
			{
				iRetCode = recv(mSocketGame, pRecvBufGame + recv_len, wPacketSize - recv_len, 0);
				//log("cocos2d-x Body %d", iRetCode);
				lastRcvTimeGame = time(NULL);   //更新接收时间
				if (iRetCode == 0)
				{
					isContinune = false;
					continue;
				}
				else if (iRetCode < 0)
				{
					mSocketGame = 0;
					return true;
				}
				recv_len += iRetCode;
				if (recv_len >= wPacketSize)
				{
					break;
				}
			}
			if (isContinune)
			{
				wPacketSize = wPacketSizeSave;
				unsigned short wRealySize = CrevasseBuffer((unsigned char*)pRecvBufGame, wPacketSize);
				if (wRealySize < sizeof(TCP_Command))
				{
					continue;
				}
				MTCustomEventQueue::getInstance()->pushCustomEvent("rcvDataGame", pRecvBufGame);
			}
		}
	}
	return true;
}

void TTSocketClient::startSocket(const char *ip, unsigned short port, unsigned char bSocketType)
{
	bool isConnect = ConnectIPv4(ip, port, bSocketType);
	if (isConnect)
	{
		if (bSocketType == 0)
		{
			std::thread recvDate(&TTSocketClient::recvDateLogin, this);
			recvDate.detach();
		} 
		else if (bSocketType == 1)
		{
			std::thread recvDate2(&TTSocketClient::recvDateGame, this);
			recvDate2.detach();
		}
	}
}

bool TTSocketClient::ConnectIPv4(const char *ip, unsigned short port, unsigned char bSocketType)
{
	SOCKET socketTmp;
	socketTmp = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	struct sockaddr_in svraddr;
	svraddr.sin_family = AF_INET;
	svraddr.sin_addr.s_addr = inet_addr(ip);
	svraddr.sin_port = htons(port);
	int ret = connect(socketTmp, (const struct sockaddr*)&svraddr, sizeof(svraddr));
	if (ret == SOCKET_ERROR) 
	{
		log("\nconnect error");
		return false;
	}
	if (bSocketType == 0)
	{
		mSocketLogin = socketTmp ;
	}
	else if (bSocketType == 1)
	{
		mSocketGame = socketTmp;
	}
	return true;
}


//加密后的buf
int TTSocketClient::Send(const char* buf, int len, unsigned char bSocketType, int flags)
{
	int bytes;
	int count = 0;

	SOCKET socketTmp;
	if (bSocketType == 0)
	{
		socketTmp = mSocketLogin;
	}
	else if (bSocketType == 1)
	{
		socketTmp = mSocketGame;
	}

	while (count < len) {

		bytes = send(socketTmp, buf + count, len - count, flags);
		if (bytes == -1 || bytes == 0)
			return -1;
		count += bytes;
	}

	return count;
}

// int TTSocketClient::Recv(char* buf, int len, int flags, unsigned char bSocketType)
// {
// 	SOCKET socketTmp;
// 	if (bSocketType == 0)
// 	{
// 		socketTmp = mSocketLogin;
// 	}
// 	else if (bSocketType == 1)
// 	{
// 		socketTmp = mSocketGame;
// 	}
// 	return (recv(socketTmp, buf, len, flags));
// }

int TTSocketClient::closeMySocket(unsigned char bSocketType)
{
	SOCKET socketTmp;
	if (bSocketType == 0)
	{
		socketTmp = mSocketLogin;
		mSocketLogin = 0;
	}
	else if (bSocketType == 1)
	{
		socketTmp = mSocketGame;
		mSocketGame = 0;
	}
//#if (PlatWhich == PlatWin)
#ifdef WIN32
	return (closesocket(socketTmp));
#else
	shutdown(socketTmp,SHUT_RDWR);
	return (close(socketTmp));
#endif
	
}
