/***********************************************************************************
 *Copyright(C),2010-2011,SAINTGAME Company
 *FileName: MTCustomEventQueue.H
 *Author  : young
 *Version : 1.0
 *Date    : 2015/3/18
 *Description: �̰߳�ȫ����Ϣ�أ������߳�ͬ������
 *Others:
 *History:        //�޸���ʷ��¼�б�ÿ���޸ļ�¼Ӧ�����޸����ڡ��޸��߼��޸����ݼ��
     1.Date:
       Author:
       Modification:
**************************************************************************************/

#ifndef __MTCustomEventQueue_H__
#define __MTCustomEventQueue_H__

#include "cocos2d.h"
#include <mutex>

USING_NS_CC;
using namespace std;

class MTCustomEventQueue : public Ref
{
private:
	/**
	 *@name:��Ϣ����
	 *@obj:���ݶ���
	 */
	typedef struct
	{
		string   name;
		const char*  pData;
	} NotificationArgs;

private:
	MTCustomEventQueue();
	~MTCustomEventQueue();

public:
	static MTCustomEventQueue* getInstance()
	{
		if (mInstance == NULL)
		{
			mInstance = new MTCustomEventQueue;
		}
		return mInstance;
	}

	void pushCustomEvents(float dt);
	void pushCustomEvent(const char* name, const char* pData);

private:
	static MTCustomEventQueue      *mInstance;
	vector<NotificationArgs>    vecNotifications;

};

/************************************
 * ȫ�ֻ�����                                                            
 ************************************/
extern mutex shareNotificationQueueLock;

/************************************
 * ����������������                                                            
 ************************************/
class LifeCircleMutexLocker
{
public:
	LifeCircleMutexLocker(mutex *m) : mt(m)
	{
		mt->lock();
	}

	~LifeCircleMutexLocker()
	{
		mt->unlock();
	}
private:
	mutex *mt;
};

#define LifeCircleMutexLock(_mutex_) LifeCircleMutexLocker __locker__(_mutex_)

#endif //__MTCustomEventQueue_H__
