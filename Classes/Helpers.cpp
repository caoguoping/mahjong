#include "Helpers.h"

static Helpers* m_instance = NULL;
Helpers* Helpers::getInstance()
{
	if (m_instance == NULL)
	{
		m_instance = new Helpers;
	}
	return m_instance;
}

#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include "platform/android/jni/JniHelper.h"
#include <jni.h>
#include "org_cocos2dx_lua_SDKPlugin.h"

JNIEXPORT void JNICALL Java_org_cocos2dx_lua_SDKPlugin_LoginCallback(JNIEnv * env, jclass jc, jstring openid, jstring nickname, jstring sex, jstring headimgurl, jstring roomNum, jstring hostIp, jstring unionId, jstring saves)
{
    log("LUA-print jniCall LoginCallback");
    Helpers*  helpers = Helpers::getInstance();
	const char* strOpenid     = helpers->jstringTostring(env, openid);
	const char* strNickName   = helpers->jstringTostring(env, nickname);
	const char* strSex        = helpers->jstringTostring(env, sex);
	const char* strHeadimgurl = helpers->jstringTostring(env, headimgurl);
	const char* strRoomNum       = helpers->jstringTostring(env, roomNum);
	const char* strIp       = helpers->jstringTostring(env, hostIp);
	const char* strUnionId       = helpers->jstringTostring(env, unionId);
	const char* strSaves       = helpers->jstringTostring(env, saves);

	memcpy(helpers->weChatData.openid    , strOpenid    , 32);
	memcpy(helpers->weChatData.nickName  , strNickName  , 32);
	memcpy(helpers->weChatData.sex       , strSex       , 32);
	memcpy(helpers->weChatData.headimgurl, strHeadimgurl, 200);
	memcpy(helpers->weChatData.roomNum  , strRoomNum      , 32);
	memcpy(helpers->weChatData.hostIp      , strIp      , 16);
	memcpy(helpers->weChatData.unionId      , strUnionId      , 64);
	memcpy(helpers->weChatData.saves      , strSaves      , 32);
    helpers->sendLoginData();
}

JNIEXPORT void JNICALL Java_org_cocos2dx_lua_SDKPlugin_payCallback(JNIEnv * env, jclass js, jint jResCode, jstring jsave)
{
	log("LUA-print CPP payCallback");
	Helpers*  helpers = Helpers::getInstance();
	int resCode = jResCode;
	helpers->sendPayData(resCode);
}

char* Helpers::jstringTostring(JNIEnv* env, jstring jstr)
{
	char* rtn = NULL;
	jclass clsstring = env->FindClass("java/lang/String");
	jstring strencode = env->NewStringUTF("utf-8");
	jmethodID mid = env->GetMethodID(clsstring, "getBytes", "(Ljava/lang/String;)[B");
	jbyteArray barr = (jbyteArray)env->CallObjectMethod(jstr, mid, strencode);
	jsize alen = env->GetArrayLength(barr);
	jbyte* ba = env->GetByteArrayElements(barr, JNI_FALSE);
	if (alen > 0)
	{
		rtn = (char*)malloc(alen + 1);
		memcpy(rtn, ba, alen);
		rtn[alen] = 0;
	}
	env->ReleaseByteArrayElements(barr, ba, 0);
	return rtn;
}

void Helpers::callJavaLogin(void)
{
	JniMethodInfo info;
	bool ret = JniHelper::getStaticMethodInfo(info, "org/cocos2dx/lua/AppActivity", "login", "()V");
	if (ret)
	{
		log("LUA-print callJava init success\n");
		info.env->CallStaticVoidMethod(info.classID, info.methodID);
	}
}

// ÑûÇëÎ¢ÐÅºÃÓÑ path Í¼Æ¬Â·¾¶  url ÍøÖ·  £¬  isToAll  1:·ÖÏíµ½ÅóÓÑÈ¦£¬ 0  ·ÖÏí¸øºÃÓÑ  
void Helpers::callWechatShareJoin(const char* imgPath, const char* url,  int roomNum,  int isToAll)
{
	JniMethodInfo info;
	bool ret = JniHelper::getStaticMethodInfo(info, "org/cocos2dx/lua/AppActivity", "WechatShareJoin", "(Ljava/lang/String;Ljava/lang/String;II)V");
	if (ret)
	{
		log("LUA-print callWechatShare success\n");
		jstring jimgPath = info.env->NewStringUTF(imgPath); 
		jstring jurl = info.env->NewStringUTF(url); 
		info.env->CallStaticVoidMethod(info.classID, info.methodID, jimgPath, jurl, roomNum, isToAll);
		info.env->DeleteLocalRef(jimgPath);
		info.env->DeleteLocalRef(jurl);
	}
}

//Î¢ÐÅÖ§¸¶
void Helpers::callWeChatPay(const char* prePayId, const char*  saves  )
{
	JniMethodInfo info;
	bool ret = JniHelper::getStaticMethodInfo(info, "org/cocos2dx/lua/AppActivity", "callWeChatPay", "(Ljava/lang/String;Ljava/lang/String;)V");
	if (ret)
	{
		log("LUA-print callWeChatPay success\n");
		jstring jPrePayId = info.env->NewStringUTF(prePayId); 
		jstring jSaves = info.env->NewStringUTF(saves); 
		info.env->CallStaticVoidMethod(info.classID, info.methodID, jPrePayId, jSaves);
		info.env->DeleteLocalRef(jPrePayId);
		info.env->DeleteLocalRef(jSaves);
	}
}

//·ÖÏíÕ½¼¨  //path Í¼Æ¬Â·¾¶    isToAllFriends  1:·ÖÏíµ½ÅóÓÑÈ¦£¬ 0  ·ÖÏí¸øºÃÓÑ  
void Helpers::callWechatShareResult(const char* imgPath, int isToAll)
{
	JniMethodInfo info;
	bool ret = JniHelper::getStaticMethodInfo(info, "org/cocos2dx/lua/AppActivity", "weChatShareResult", "(Ljava/lang/String;I)V");
	if (ret)
	{
		log("LUA-print callWechatShareResult success\n");
		jstring jMsg = info.env->NewStringUTF(imgPath); 
		info.env->CallStaticVoidMethod(info.classID, info.methodID, jMsg, isToAll);
		info.env->DeleteLocalRef(jMsg);
	}
}

void Helpers::sendLoginData(void)
{
	log("LUA-print cpp sendLoginData");
	auto dispatcher = Director::getInstance()->getEventDispatcher();
	EventCustom event("rcvSDKLogin");
	event.setUserData((void*)&weChatData);
	dispatcher->dispatchEvent(&event);
}

void Helpers::sendPayData(int resCode)
{
	payResCode = resCode;
	log("LUA-print cpp sendPayData %d ", resCode);
	auto dispatcher = Director::getInstance()->getEventDispatcher();
	EventCustom event("rcvSDKPay");
	dispatcher->dispatchEvent(&event);

}

int Helpers::getPayResCode()
{
	return payResCode;
}


int Helpers::callGetRoomNum(void)
{
	JniMethodInfo info;
	bool ret = JniHelper::getStaticMethodInfo(info, "org/cocos2dx/lua/AppActivity", "getRoomNum", "()I");
	if (ret)
	{
		
		int roomNum = info.env->CallStaticIntMethod(info.classID, info.methodID);
		log("LUA-print callGetRoomNum roomNum %d\n", roomNum);
		return roomNum;
	}
}

int Helpers::callGetIp(void)
{
	JniMethodInfo info;
	bool ret = JniHelper::getStaticMethodInfo(info, "org/cocos2dx/lua/AppActivity", "getHostIp", "()I");
	if (ret)
	{

		int hostIP = info.env->CallStaticIntMethod(info.classID, info.methodID);
		log("LUA-print callGetIp  %d\n", hostIP);

		//return ((ip & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF));
		return hostIP;
	}
}
#endif

