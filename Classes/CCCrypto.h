
#ifndef __CC_EXTENSION_CCCRYPTO_H_
#define __CC_EXTENSION_CCCRYPTO_H_
#include "cocos2d.h"
using namespace std;
using namespace cocos2d;
#include "md5.h"
class Crypto
{
public:
	static std::string getMd5String(const char*  input);

};
#endif