#include "cgpCustom_auto.hpp"
#include "Helpers.h"
#include "ContentManager.h"
#include "MTCustomEventQueue.h"
#include "TTSocketClient.h"
#include "NetData.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"


int lua_cgpCustom_MTCustomEventQueue_pushCustomEvent(lua_State* tolua_S)
{
    int argc = 0;
    MTCustomEventQueue* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MTCustomEventQueue",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MTCustomEventQueue*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_MTCustomEventQueue_pushCustomEvent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        const char* arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "MTCustomEventQueue:pushCustomEvent"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "MTCustomEventQueue:pushCustomEvent"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_MTCustomEventQueue_pushCustomEvent'", nullptr);
            return 0;
        }
        cobj->pushCustomEvent(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MTCustomEventQueue:pushCustomEvent",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_MTCustomEventQueue_pushCustomEvent'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_MTCustomEventQueue_pushCustomEvents(lua_State* tolua_S)
{
    int argc = 0;
    MTCustomEventQueue* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MTCustomEventQueue",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MTCustomEventQueue*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_MTCustomEventQueue_pushCustomEvents'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "MTCustomEventQueue:pushCustomEvents");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_MTCustomEventQueue_pushCustomEvents'", nullptr);
            return 0;
        }
        cobj->pushCustomEvents(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MTCustomEventQueue:pushCustomEvents",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_MTCustomEventQueue_pushCustomEvents'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_MTCustomEventQueue_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MTCustomEventQueue",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_MTCustomEventQueue_getInstance'", nullptr);
            return 0;
        }
        MTCustomEventQueue* ret = MTCustomEventQueue::getInstance();
        object_to_luaval<MTCustomEventQueue>(tolua_S, "MTCustomEventQueue",(MTCustomEventQueue*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MTCustomEventQueue:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_MTCustomEventQueue_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_cgpCustom_MTCustomEventQueue_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MTCustomEventQueue)");
    return 0;
}

int lua_register_cgpCustom_MTCustomEventQueue(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"MTCustomEventQueue");
    tolua_cclass(tolua_S,"MTCustomEventQueue","MTCustomEventQueue","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"MTCustomEventQueue");
        tolua_function(tolua_S,"pushCustomEvent",lua_cgpCustom_MTCustomEventQueue_pushCustomEvent);
        tolua_function(tolua_S,"pushCustomEvents",lua_cgpCustom_MTCustomEventQueue_pushCustomEvents);
        tolua_function(tolua_S,"getInstance", lua_cgpCustom_MTCustomEventQueue_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(MTCustomEventQueue).name();
    g_luaType[typeName] = "MTCustomEventQueue";
    g_typeCast["MTCustomEventQueue"] = "MTCustomEventQueue";
    return 1;
}

int lua_cgpCustom_LifeCircleMutexLocker_constructor(lua_State* tolua_S)
{
    int argc = 0;
    LifeCircleMutexLocker* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::mutex* arg0;

        ok &= luaval_to_object<std::mutex>(tolua_S, 2, "std::mutex*",&arg0, "LifeCircleMutexLocker:LifeCircleMutexLocker");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_LifeCircleMutexLocker_constructor'", nullptr);
            return 0;
        }
        cobj = new LifeCircleMutexLocker(arg0);
        tolua_pushusertype(tolua_S,(void*)cobj,"LifeCircleMutexLocker");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LifeCircleMutexLocker:LifeCircleMutexLocker",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_LifeCircleMutexLocker_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cgpCustom_LifeCircleMutexLocker_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (LifeCircleMutexLocker)");
    return 0;
}

int lua_register_cgpCustom_LifeCircleMutexLocker(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"LifeCircleMutexLocker");
    tolua_cclass(tolua_S,"LifeCircleMutexLocker","LifeCircleMutexLocker","",nullptr);

    tolua_beginmodule(tolua_S,"LifeCircleMutexLocker");
        tolua_function(tolua_S,"new",lua_cgpCustom_LifeCircleMutexLocker_constructor);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(LifeCircleMutexLocker).name();
    g_luaType[typeName] = "LifeCircleMutexLocker";
    g_typeCast["LifeCircleMutexLocker"] = "LifeCircleMutexLocker";
    return 1;
}

int lua_cgpCustom_TTSocketClient_startSocket(lua_State* tolua_S)
{
    int argc = 0;
    TTSocketClient* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TTSocketClient",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TTSocketClient*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_TTSocketClient_startSocket'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        unsigned short arg1;
        uint16_t arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "TTSocketClient:startSocket"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_ushort(tolua_S, 3, &arg1, "TTSocketClient:startSocket");

        ok &= luaval_to_uint16(tolua_S, 4,&arg2, "TTSocketClient:startSocket");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_TTSocketClient_startSocket'", nullptr);
            return 0;
        }
        cobj->startSocket(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TTSocketClient:startSocket",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_TTSocketClient_startSocket'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_TTSocketClient_MapRecvByte(lua_State* tolua_S)
{
    int argc = 0;
    TTSocketClient* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TTSocketClient",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TTSocketClient*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_TTSocketClient_MapRecvByte'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        uint16_t arg0;

        ok &= luaval_to_uint16(tolua_S, 2,&arg0, "TTSocketClient:MapRecvByte");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_TTSocketClient_MapRecvByte'", nullptr);
            return 0;
        }
        uint16_t ret = cobj->MapRecvByte(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TTSocketClient:MapRecvByte",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_TTSocketClient_MapRecvByte'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_TTSocketClient_ConnectIPv4(lua_State* tolua_S)
{
    int argc = 0;
    TTSocketClient* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TTSocketClient",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TTSocketClient*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_TTSocketClient_ConnectIPv4'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        unsigned short arg1;
        uint16_t arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "TTSocketClient:ConnectIPv4"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_ushort(tolua_S, 3, &arg1, "TTSocketClient:ConnectIPv4");

        ok &= luaval_to_uint16(tolua_S, 4,&arg2, "TTSocketClient:ConnectIPv4");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_TTSocketClient_ConnectIPv4'", nullptr);
            return 0;
        }
        bool ret = cobj->ConnectIPv4(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TTSocketClient:ConnectIPv4",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_TTSocketClient_ConnectIPv4'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_TTSocketClient_Send(lua_State* tolua_S)
{
    int argc = 0;
    TTSocketClient* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TTSocketClient",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TTSocketClient*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_TTSocketClient_Send'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        int arg1;
        uint16_t arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "TTSocketClient:Send"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "TTSocketClient:Send");

        ok &= luaval_to_uint16(tolua_S, 4,&arg2, "TTSocketClient:Send");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_TTSocketClient_Send'", nullptr);
            return 0;
        }
        int ret = cobj->Send(arg0, arg1, arg2);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    if (argc == 4) 
    {
        const char* arg0;
        int arg1;
        uint16_t arg2;
        int arg3;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "TTSocketClient:Send"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "TTSocketClient:Send");

        ok &= luaval_to_uint16(tolua_S, 4,&arg2, "TTSocketClient:Send");

        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "TTSocketClient:Send");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_TTSocketClient_Send'", nullptr);
            return 0;
        }
        int ret = cobj->Send(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TTSocketClient:Send",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_TTSocketClient_Send'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_TTSocketClient_closeMySocket(lua_State* tolua_S)
{
    int argc = 0;
    TTSocketClient* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TTSocketClient",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TTSocketClient*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_TTSocketClient_closeMySocket'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        uint16_t arg0;

        ok &= luaval_to_uint16(tolua_S, 2,&arg0, "TTSocketClient:closeMySocket");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_TTSocketClient_closeMySocket'", nullptr);
            return 0;
        }
        int ret = cobj->closeMySocket(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TTSocketClient:closeMySocket",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_TTSocketClient_closeMySocket'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_TTSocketClient_recvDateLogin(lua_State* tolua_S)
{
    int argc = 0;
    TTSocketClient* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TTSocketClient",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TTSocketClient*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_TTSocketClient_recvDateLogin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_TTSocketClient_recvDateLogin'", nullptr);
            return 0;
        }
        bool ret = cobj->recvDateLogin();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TTSocketClient:recvDateLogin",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_TTSocketClient_recvDateLogin'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_TTSocketClient_recvDateGame(lua_State* tolua_S)
{
    int argc = 0;
    TTSocketClient* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TTSocketClient",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TTSocketClient*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_TTSocketClient_recvDateGame'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_TTSocketClient_recvDateGame'", nullptr);
            return 0;
        }
        bool ret = cobj->recvDateGame();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TTSocketClient:recvDateGame",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_TTSocketClient_recvDateGame'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_TTSocketClient_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"TTSocketClient",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_TTSocketClient_getInstance'", nullptr);
            return 0;
        }
        TTSocketClient* ret = TTSocketClient::getInstance();
        object_to_luaval<TTSocketClient>(tolua_S, "TTSocketClient",(TTSocketClient*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "TTSocketClient:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_TTSocketClient_getInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_cgpCustom_TTSocketClient_constructor(lua_State* tolua_S)
{
    int argc = 0;
    TTSocketClient* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_TTSocketClient_constructor'", nullptr);
            return 0;
        }
        cobj = new TTSocketClient();
        tolua_pushusertype(tolua_S,(void*)cobj,"TTSocketClient");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TTSocketClient:TTSocketClient",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_TTSocketClient_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cgpCustom_TTSocketClient_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (TTSocketClient)");
    return 0;
}

int lua_register_cgpCustom_TTSocketClient(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"TTSocketClient");
    tolua_cclass(tolua_S,"TTSocketClient","TTSocketClient","",nullptr);

    tolua_beginmodule(tolua_S,"TTSocketClient");
        tolua_function(tolua_S,"new",lua_cgpCustom_TTSocketClient_constructor);
        tolua_function(tolua_S,"startSocket",lua_cgpCustom_TTSocketClient_startSocket);
        tolua_function(tolua_S,"MapRecvByte",lua_cgpCustom_TTSocketClient_MapRecvByte);
        tolua_function(tolua_S,"ConnectIPv4",lua_cgpCustom_TTSocketClient_ConnectIPv4);
        tolua_function(tolua_S,"Send",lua_cgpCustom_TTSocketClient_Send);
        tolua_function(tolua_S,"closeMySocket",lua_cgpCustom_TTSocketClient_closeMySocket);
        tolua_function(tolua_S,"recvDateLogin",lua_cgpCustom_TTSocketClient_recvDateLogin);
        tolua_function(tolua_S,"recvDateGame",lua_cgpCustom_TTSocketClient_recvDateGame);
        tolua_function(tolua_S,"getInstance", lua_cgpCustom_TTSocketClient_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(TTSocketClient).name();
    g_luaType[typeName] = "TTSocketClient";
    g_typeCast["TTSocketClient"] = "TTSocketClient";
    return 1;
}

int lua_cgpCustom_DataRcv_readUInt64(lua_State* tolua_S)
{
    int argc = 0;
    DataRcv* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataRcv",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataRcv*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataRcv_readUInt64'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataRcv_readUInt64'", nullptr);
            return 0;
        }
        long long ret = cobj->readUInt64();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataRcv:readUInt64",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataRcv_readUInt64'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataRcv_destroys(lua_State* tolua_S)
{
    int argc = 0;
    DataRcv* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataRcv",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataRcv*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataRcv_destroys'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataRcv_destroys'", nullptr);
            return 0;
        }
        cobj->destroys();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataRcv:destroys",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataRcv_destroys'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataRcv_readInt32(lua_State* tolua_S)
{
    int argc = 0;
    DataRcv* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataRcv",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataRcv*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataRcv_readInt32'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataRcv_readInt32'", nullptr);
            return 0;
        }
        int ret = cobj->readInt32();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataRcv:readInt32",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataRcv_readInt32'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataRcv_readDWORD(lua_State* tolua_S)
{
    int argc = 0;
    DataRcv* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataRcv",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataRcv*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataRcv_readDWORD'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataRcv_readDWORD'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->readDWORD();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataRcv:readDWORD",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataRcv_readDWORD'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataRcv_readInt16(lua_State* tolua_S)
{
    int argc = 0;
    DataRcv* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataRcv",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataRcv*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataRcv_readInt16'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataRcv_readInt16'", nullptr);
            return 0;
        }
        int32_t ret = cobj->readInt16();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataRcv:readInt16",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataRcv_readInt16'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataRcv_readString(lua_State* tolua_S)
{
    int argc = 0;
    DataRcv* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataRcv",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataRcv*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataRcv_readString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "DataRcv:readString");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataRcv_readString'", nullptr);
            return 0;
        }
        std::string ret = cobj->readString(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataRcv:readString",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataRcv_readString'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataRcv_readByte(lua_State* tolua_S)
{
    int argc = 0;
    DataRcv* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataRcv",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataRcv*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataRcv_readByte'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataRcv_readByte'", nullptr);
            return 0;
        }
        uint16_t ret = cobj->readByte();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataRcv:readByte",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataRcv_readByte'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataRcv_readDouble(lua_State* tolua_S)
{
    int argc = 0;
    DataRcv* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataRcv",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataRcv*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataRcv_readDouble'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataRcv_readDouble'", nullptr);
            return 0;
        }
        double ret = cobj->readDouble();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataRcv:readDouble",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataRcv_readDouble'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataRcv_readWORD(lua_State* tolua_S)
{
    int argc = 0;
    DataRcv* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataRcv",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataRcv*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataRcv_readWORD'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataRcv_readWORD'", nullptr);
            return 0;
        }
        unsigned short ret = cobj->readWORD();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataRcv:readWORD",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataRcv_readWORD'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataRcv_readInt8(lua_State* tolua_S)
{
    int argc = 0;
    DataRcv* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataRcv",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataRcv*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataRcv_readInt8'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataRcv_readInt8'", nullptr);
            return 0;
        }
        int32_t ret = cobj->readInt8();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataRcv:readInt8",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataRcv_readInt8'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataRcv_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"DataRcv",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        cocos2d::EventCustom* arg0;
        ok &= luaval_to_object<cocos2d::EventCustom>(tolua_S, 2, "cc.EventCustom",&arg0, "DataRcv:create");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataRcv_create'", nullptr);
            return 0;
        }
        DataRcv* ret = DataRcv::create(arg0);
        object_to_luaval<DataRcv>(tolua_S, "DataRcv",(DataRcv*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "DataRcv:create",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataRcv_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_cgpCustom_DataRcv_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (DataRcv)");
    return 0;
}

int lua_register_cgpCustom_DataRcv(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"DataRcv");
    tolua_cclass(tolua_S,"DataRcv","DataRcv","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"DataRcv");
        tolua_function(tolua_S,"readUInt64",lua_cgpCustom_DataRcv_readUInt64);
        tolua_function(tolua_S,"destroys",lua_cgpCustom_DataRcv_destroys);
        tolua_function(tolua_S,"readInt32",lua_cgpCustom_DataRcv_readInt32);
        tolua_function(tolua_S,"readDWORD",lua_cgpCustom_DataRcv_readDWORD);
        tolua_function(tolua_S,"readInt16",lua_cgpCustom_DataRcv_readInt16);
        tolua_function(tolua_S,"readString",lua_cgpCustom_DataRcv_readString);
        tolua_function(tolua_S,"readByte",lua_cgpCustom_DataRcv_readByte);
        tolua_function(tolua_S,"readDouble",lua_cgpCustom_DataRcv_readDouble);
        tolua_function(tolua_S,"readWORD",lua_cgpCustom_DataRcv_readWORD);
        tolua_function(tolua_S,"readInt8",lua_cgpCustom_DataRcv_readInt8);
        tolua_function(tolua_S,"create", lua_cgpCustom_DataRcv_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(DataRcv).name();
    g_luaType[typeName] = "DataRcv";
    g_typeCast["DataRcv"] = "DataRcv";
    return 1;
}

int lua_cgpCustom_DataSnd_wrInt8(lua_State* tolua_S)
{
    int argc = 0;
    DataSnd* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataSnd",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataSnd*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataSnd_wrInt8'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int32_t arg0;

        ok &= luaval_to_int32(tolua_S, 2,&arg0, "DataSnd:wrInt8");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataSnd_wrInt8'", nullptr);
            return 0;
        }
        cobj->wrInt8(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataSnd:wrInt8",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataSnd_wrInt8'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataSnd_wrString(lua_State* tolua_S)
{
    int argc = 0;
    DataSnd* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataSnd",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataSnd*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataSnd_wrString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        int arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "DataSnd:wrString");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "DataSnd:wrString");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataSnd_wrString'", nullptr);
            return 0;
        }
        cobj->wrString(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataSnd:wrString",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataSnd_wrString'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataSnd_sendData(lua_State* tolua_S)
{
    int argc = 0;
    DataSnd* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataSnd",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataSnd*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataSnd_sendData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        uint16_t arg0;

        ok &= luaval_to_uint16(tolua_S, 2,&arg0, "DataSnd:sendData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataSnd_sendData'", nullptr);
            return 0;
        }
        cobj->sendData(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataSnd:sendData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataSnd_sendData'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataSnd_wrWORD(lua_State* tolua_S)
{
    int argc = 0;
    DataSnd* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataSnd",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataSnd*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataSnd_wrWORD'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned short arg0;

        ok &= luaval_to_ushort(tolua_S, 2, &arg0, "DataSnd:wrWORD");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataSnd_wrWORD'", nullptr);
            return 0;
        }
        cobj->wrWORD(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataSnd:wrWORD",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataSnd_wrWORD'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataSnd_wrInt64(lua_State* tolua_S)
{
    int argc = 0;
    DataSnd* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataSnd",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataSnd*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataSnd_wrInt64'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        long long arg0;

        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "DataSnd:wrInt64");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataSnd_wrInt64'", nullptr);
            return 0;
        }
        cobj->wrInt64(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataSnd:wrInt64",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataSnd_wrInt64'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataSnd_wrDWORD(lua_State* tolua_S)
{
    int argc = 0;
    DataSnd* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataSnd",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataSnd*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataSnd_wrDWORD'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "DataSnd:wrDWORD");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataSnd_wrDWORD'", nullptr);
            return 0;
        }
        cobj->wrDWORD(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataSnd:wrDWORD",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataSnd_wrDWORD'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataSnd_wrDouble(lua_State* tolua_S)
{
    int argc = 0;
    DataSnd* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataSnd",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataSnd*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataSnd_wrDouble'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "DataSnd:wrDouble");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataSnd_wrDouble'", nullptr);
            return 0;
        }
        cobj->wrDouble(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataSnd:wrDouble",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataSnd_wrDouble'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataSnd_wrInt32(lua_State* tolua_S)
{
    int argc = 0;
    DataSnd* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataSnd",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataSnd*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataSnd_wrInt32'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "DataSnd:wrInt32");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataSnd_wrInt32'", nullptr);
            return 0;
        }
        cobj->wrInt32(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataSnd:wrInt32",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataSnd_wrInt32'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataSnd_wrByte(lua_State* tolua_S)
{
    int argc = 0;
    DataSnd* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataSnd",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataSnd*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataSnd_wrByte'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        uint16_t arg0;

        ok &= luaval_to_uint16(tolua_S, 2,&arg0, "DataSnd:wrByte");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataSnd_wrByte'", nullptr);
            return 0;
        }
        cobj->wrByte(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataSnd:wrByte",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataSnd_wrByte'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataSnd_wrInt16(lua_State* tolua_S)
{
    int argc = 0;
    DataSnd* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"DataSnd",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (DataSnd*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_DataSnd_wrInt16'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int32_t arg0;

        ok &= luaval_to_int32(tolua_S, 2,&arg0, "DataSnd:wrInt16");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataSnd_wrInt16'", nullptr);
            return 0;
        }
        cobj->wrInt16(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "DataSnd:wrInt16",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataSnd_wrInt16'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_DataSnd_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"DataSnd",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        unsigned short arg0;
        unsigned short arg1;
        ok &= luaval_to_ushort(tolua_S, 2, &arg0, "DataSnd:create");
        ok &= luaval_to_ushort(tolua_S, 3, &arg1, "DataSnd:create");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_DataSnd_create'", nullptr);
            return 0;
        }
        DataSnd* ret = DataSnd::create(arg0, arg1);
        object_to_luaval<DataSnd>(tolua_S, "DataSnd",(DataSnd*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "DataSnd:create",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_DataSnd_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_cgpCustom_DataSnd_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (DataSnd)");
    return 0;
}

int lua_register_cgpCustom_DataSnd(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"DataSnd");
    tolua_cclass(tolua_S,"DataSnd","DataSnd","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"DataSnd");
        tolua_function(tolua_S,"wrInt8",lua_cgpCustom_DataSnd_wrInt8);
        tolua_function(tolua_S,"wrString",lua_cgpCustom_DataSnd_wrString);
        tolua_function(tolua_S,"sendData",lua_cgpCustom_DataSnd_sendData);
        tolua_function(tolua_S,"wrWORD",lua_cgpCustom_DataSnd_wrWORD);
        tolua_function(tolua_S,"wrInt64",lua_cgpCustom_DataSnd_wrInt64);
        tolua_function(tolua_S,"wrDWORD",lua_cgpCustom_DataSnd_wrDWORD);
        tolua_function(tolua_S,"wrDouble",lua_cgpCustom_DataSnd_wrDouble);
        tolua_function(tolua_S,"wrInt32",lua_cgpCustom_DataSnd_wrInt32);
        tolua_function(tolua_S,"wrByte",lua_cgpCustom_DataSnd_wrByte);
        tolua_function(tolua_S,"wrInt16",lua_cgpCustom_DataSnd_wrInt16);
        tolua_function(tolua_S,"create", lua_cgpCustom_DataSnd_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(DataSnd).name();
    g_luaType[typeName] = "DataSnd";
    g_typeCast["DataSnd"] = "DataSnd";
    return 1;
}

int lua_cgpCustom_SDKLoginData_readOpenid(lua_State* tolua_S)
{
    int argc = 0;
    SDKLoginData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SDKLoginData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SDKLoginData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_SDKLoginData_readOpenid'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_SDKLoginData_readOpenid'", nullptr);
            return 0;
        }
        std::string ret = cobj->readOpenid();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SDKLoginData:readOpenid",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_SDKLoginData_readOpenid'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_SDKLoginData_readCity(lua_State* tolua_S)
{
    int argc = 0;
    SDKLoginData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SDKLoginData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SDKLoginData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_SDKLoginData_readCity'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_SDKLoginData_readCity'", nullptr);
            return 0;
        }
        std::string ret = cobj->readCity();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SDKLoginData:readCity",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_SDKLoginData_readCity'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_SDKLoginData_readNickName(lua_State* tolua_S)
{
    int argc = 0;
    SDKLoginData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SDKLoginData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SDKLoginData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_SDKLoginData_readNickName'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_SDKLoginData_readNickName'", nullptr);
            return 0;
        }
        std::string ret = cobj->readNickName();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SDKLoginData:readNickName",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_SDKLoginData_readNickName'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_SDKLoginData_readHeadimgurl(lua_State* tolua_S)
{
    int argc = 0;
    SDKLoginData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SDKLoginData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SDKLoginData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_SDKLoginData_readHeadimgurl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_SDKLoginData_readHeadimgurl'", nullptr);
            return 0;
        }
        std::string ret = cobj->readHeadimgurl();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SDKLoginData:readHeadimgurl",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_SDKLoginData_readHeadimgurl'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_SDKLoginData_readSex(lua_State* tolua_S)
{
    int argc = 0;
    SDKLoginData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SDKLoginData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SDKLoginData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_SDKLoginData_readSex'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_SDKLoginData_readSex'", nullptr);
            return 0;
        }
        std::string ret = cobj->readSex();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SDKLoginData:readSex",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_SDKLoginData_readSex'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_SDKLoginData_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"SDKLoginData",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        cocos2d::EventCustom* arg0;
        ok &= luaval_to_object<cocos2d::EventCustom>(tolua_S, 2, "cc.EventCustom",&arg0, "SDKLoginData:create");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_SDKLoginData_create'", nullptr);
            return 0;
        }
        SDKLoginData* ret = SDKLoginData::create(arg0);
        object_to_luaval<SDKLoginData>(tolua_S, "SDKLoginData",(SDKLoginData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "SDKLoginData:create",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_SDKLoginData_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_cgpCustom_SDKLoginData_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (SDKLoginData)");
    return 0;
}

int lua_register_cgpCustom_SDKLoginData(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"SDKLoginData");
    tolua_cclass(tolua_S,"SDKLoginData","SDKLoginData","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"SDKLoginData");
        tolua_function(tolua_S,"readOpenid",lua_cgpCustom_SDKLoginData_readOpenid);
        tolua_function(tolua_S,"readCity",lua_cgpCustom_SDKLoginData_readCity);
        tolua_function(tolua_S,"readNickName",lua_cgpCustom_SDKLoginData_readNickName);
        tolua_function(tolua_S,"readHeadimgurl",lua_cgpCustom_SDKLoginData_readHeadimgurl);
        tolua_function(tolua_S,"readSex",lua_cgpCustom_SDKLoginData_readSex);
        tolua_function(tolua_S,"create", lua_cgpCustom_SDKLoginData_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(SDKLoginData).name();
    g_luaType[typeName] = "SDKLoginData";
    g_typeCast["SDKLoginData"] = "SDKLoginData";
    return 1;
}

int lua_cgpCustom_Helpers_callWechatShare(lua_State* tolua_S)
{
    int argc = 0;
    Helpers* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Helpers",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Helpers*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_Helpers_callWechatShare'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "Helpers:callWechatShare"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_Helpers_callWechatShare'", nullptr);
            return 0;
        }
        cobj->callWechatShare(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Helpers:callWechatShare",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_Helpers_callWechatShare'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_Helpers_callJavaLogin(lua_State* tolua_S)
{
    int argc = 0;
    Helpers* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Helpers",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Helpers*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_Helpers_callJavaLogin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_Helpers_callJavaLogin'", nullptr);
            return 0;
        }
        cobj->callJavaLogin();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Helpers:callJavaLogin",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_Helpers_callJavaLogin'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_Helpers_sendLoginData(lua_State* tolua_S)
{
    int argc = 0;
    Helpers* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Helpers",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Helpers*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_Helpers_sendLoginData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_Helpers_sendLoginData'", nullptr);
            return 0;
        }
        cobj->sendLoginData();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Helpers:sendLoginData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_Helpers_sendLoginData'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_Helpers_jstringTostring(lua_State* tolua_S)
{
    int argc = 0;
    Helpers* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Helpers",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Helpers*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_Helpers_jstringTostring'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        _JNIEnv* arg0;
        _jstring* arg1;

        #pragma warning NO CONVERSION TO NATIVE FOR _JNIEnv*
		ok = false;

        ok &= luaval_to_object<_jstring>(tolua_S, 3, "_jstring",&arg1, "Helpers:jstringTostring");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_Helpers_jstringTostring'", nullptr);
            return 0;
        }
        char* ret = cobj->jstringTostring(arg0, arg1);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Helpers:jstringTostring",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_Helpers_jstringTostring'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_Helpers_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Helpers",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_Helpers_getInstance'", nullptr);
            return 0;
        }
        Helpers* ret = Helpers::getInstance();
        object_to_luaval<Helpers>(tolua_S, "Helpers",(Helpers*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Helpers:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_Helpers_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_cgpCustom_Helpers_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Helpers)");
    return 0;
}

int lua_register_cgpCustom_Helpers(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"Helpers");
    tolua_cclass(tolua_S,"Helpers","Helpers","",nullptr);

    tolua_beginmodule(tolua_S,"Helpers");
        tolua_function(tolua_S,"callWechatShare",lua_cgpCustom_Helpers_callWechatShare);
        tolua_function(tolua_S,"callJavaLogin",lua_cgpCustom_Helpers_callJavaLogin);
        tolua_function(tolua_S,"sendLoginData",lua_cgpCustom_Helpers_sendLoginData);
        tolua_function(tolua_S,"jstringTostring",lua_cgpCustom_Helpers_jstringTostring);
        tolua_function(tolua_S,"getInstance", lua_cgpCustom_Helpers_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(Helpers).name();
    g_luaType[typeName] = "Helpers";
    g_typeCast["Helpers"] = "Helpers";
    return 1;
}

int lua_cgpCustom_ContentManager_test(lua_State* tolua_S)
{
    int argc = 0;
    ContentManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ContentManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ContentManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cgpCustom_ContentManager_test'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_ContentManager_test'", nullptr);
            return 0;
        }
        cobj->test();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ContentManager:test",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_ContentManager_test'.",&tolua_err);
#endif

    return 0;
}
int lua_cgpCustom_ContentManager_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ContentManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_ContentManager_getInstance'", nullptr);
            return 0;
        }
        ContentManager* ret = ContentManager::getInstance();
        object_to_luaval<ContentManager>(tolua_S, "ContentManager",(ContentManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ContentManager:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_ContentManager_getInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_cgpCustom_ContentManager_constructor(lua_State* tolua_S)
{
    int argc = 0;
    ContentManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cgpCustom_ContentManager_constructor'", nullptr);
            return 0;
        }
        cobj = new ContentManager();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"ContentManager");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ContentManager:ContentManager",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cgpCustom_ContentManager_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cgpCustom_ContentManager_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (ContentManager)");
    return 0;
}

int lua_register_cgpCustom_ContentManager(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ContentManager");
    tolua_cclass(tolua_S,"ContentManager","ContentManager","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"ContentManager");
        tolua_function(tolua_S,"new",lua_cgpCustom_ContentManager_constructor);
        tolua_function(tolua_S,"test",lua_cgpCustom_ContentManager_test);
        tolua_function(tolua_S,"getInstance", lua_cgpCustom_ContentManager_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(ContentManager).name();
    g_luaType[typeName] = "ContentManager";
    g_typeCast["ContentManager"] = "ContentManager";
    return 1;
}
TOLUA_API int register_all_cgpCustom(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_cgpCustom_LifeCircleMutexLocker(tolua_S);
	lua_register_cgpCustom_SDKLoginData(tolua_S);
	lua_register_cgpCustom_TTSocketClient(tolua_S);
	lua_register_cgpCustom_MTCustomEventQueue(tolua_S);
	lua_register_cgpCustom_Helpers(tolua_S);
	lua_register_cgpCustom_DataRcv(tolua_S);
	lua_register_cgpCustom_ContentManager(tolua_S);
	lua_register_cgpCustom_DataSnd(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

