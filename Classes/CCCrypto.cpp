
#include "CCCrypto.h"

 std::string Crypto::getMd5String(const char*  input)
{
	 MD5 md5;
	 md5.update(input);
	 //return (md5.toString().data());
	 return (md5.toString());
}

