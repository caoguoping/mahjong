//ƽ̨���

#include "cocos2d.h"
#include "network/HttpClient.h"


#include "NetData.h"
#include "MTCustomEventQueue.h"
using namespace cocos2d;
using namespace cocos2d::network;


class Helpers
{
public:
	static Helpers* getInstance();

	stWeChatData  weChatData;
	int payResCode = -1;

#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID

	void sendLoginData(void);
	void sendPayData(int);
	
	int getPayResCode();
	//�������
	void callWechatShareJoin(const char* imgPath, const char* url,  int roomNum,  int isToAll);
	//����ս��
	void callWechatShareResult(const char* imgPath, int isToAll);
	//΢��֧��
	void callWeChatPay(const char* prePayId, const char*  saves  );

	char* jstringTostring(JNIEnv* env, jstring jstr);
	void callJavaLogin(void);

	//��ȡ�����
	int callGetRoomNum(void);
	//��ȡip
	int callGetIp(void);
#endif

    
};

