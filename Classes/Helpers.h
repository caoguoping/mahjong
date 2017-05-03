

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

#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID

	void sendLoginData(void);
	//�������
	void callWechatShareJoin(const char* imgPath, const char* url,  int roomNum,  int isToAll);
	//����ս��
	void callWechatShareResult(const char* imgPath, int isToAll);
	//΢��֧��
	void callWeChatPay(const char* prePayId, const char*  saves  );

	char* jstringTostring(JNIEnv* env, jstring jstr);
	void callJavaLogin(void);
#endif

    
};

