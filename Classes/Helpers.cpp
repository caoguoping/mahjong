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

JNIEXPORT void JNICALL Java_org_cocos2dx_lua_SDKPlugin_LoginCallback(JNIEnv * env, jclass jc, jstring openid, jstring nickname, jstring sex, jstring headimgurl, jstring city)
{
    log("LUA-print jniCall LoginCallback");
    Helpers*  helpers = Helpers::getInstance();
	//const char* strUid = helpers->jstringTostring(env, uid);
	const char* strOpenid     = helpers->jstringTostring(env, openid);
	const char* strNickName   = helpers->jstringTostring(env, nickname);
	const char* strSex        = helpers->jstringTostring(env, sex);
	const char* strHeadimgurl = helpers->jstringTostring(env, headimgurl);
	const char* strCity       = helpers->jstringTostring(env, city);

	strncpy(helpers->weChatData.openid    , strOpenid    , 32);
	strncpy(helpers->weChatData.nickName  , strNickName  , 32);
	strncpy(helpers->weChatData.sex       , strSex       , 32);
	strncpy(helpers->weChatData.headimgurl, strHeadimgurl, 256);
	strncpy(helpers->weChatData.city      , strCity      , 32);

    helpers->sendLoginData();
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

void Helpers::callWechatShare(const char* imgPath)
{
	JniMethodInfo info;
	bool ret = JniHelper::getStaticMethodInfo(info, "org/cocos2dx/lua/AppActivity", "weChatShare", "(Ljava/lang/String;)V");
	if (ret)
	{
		log("LUA-print callWechatShare success\n");
		jstring jMsg = info.env->NewStringUTF(imgPath); 
		info.env->CallStaticVoidMethod(info.classID, info.methodID, jMsg);
		info.env->DeleteLocalRef(jMsg);
	}
}

// void showExitPt(const char *title, const char *msg) {  　　
// 	JniMethodInfo t;  　　
// 	//getStaticMethodInfo判断是否在java中实现了名字showTipDialog的方法 　　
// 	//"(Ljava/lang/String;Ljava/lang/String;)V" 对该方法的一个描述，详见说明 　　
// 	if(JniHelper::getStaticMethodInfo(t, CLASS_NAME, "showTipDialog", "(Ljava/lang/String;Ljava/lang/String;)V")) 　　{  　　　　
// 		jstring jTitle = t.env->NewStringUTF(title); 　　　　
// 		jstring jMsg = t.env->NewStringUTF(msg); 　　　　//根据该方法的返回值调用对应的CallStaticxxxMethod方法，如CallStaticIntMethod 　　　　
// 		t.env->CallStaticVoidMethod(t.classID, t.methodID, jTitle, jMsg); 　　　　
// 		t.env->DeleteLocalRef(jTitle); 　　　　
// 		t.env->DeleteLocalRef(jMsg); 　　
// 	}
// }



void Helpers::sendLoginData(void)
{
	log("LUA-print cpp sendLoginData");
	auto dispatcher = Director::getInstance()->getEventDispatcher();
	EventCustom event("rcvSDKLogin");
	event.setUserData((void*)&weChatData);
	dispatcher->dispatchEvent(&event);
}

#endif

