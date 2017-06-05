//平台相关

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
	//邀请好友
	void callWechatShareJoin(const char* imgPath, const char* url,  int roomNum,  int isToAll);
	//分享战绩
	void callWechatShareResult(const char* imgPath, int isToAll);
	//微信支付
	void callWeChatPay(const char* prePayId, const char*  saves  );

	char* jstringTostring(JNIEnv* env, jstring jstr);
	void callJavaLogin(void);

	//获取房间号
	int callGetRoomNum(void);
	//获取ip
	int callGetIp(void);
#endif

    
};

