
#include "cocos2d.h"
using namespace cocos2d;
#include "MTCustomEventQueue.h"
#include "NetData.h"

class Helpers
{
public:
	static Helpers* getInstance();

	stWeChatData  weChatData;



#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID

	void sendLoginData(void);
	void callWechatShare(const char* imgPath);
	char* jstringTostring(JNIEnv* env, jstring jstr);
	void callJavaLogin(void);
#endif

    
};

