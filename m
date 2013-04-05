From: Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH v2 1/4] dcache: Don't take unnecessary lock in d_count
 update
Date: Fri, 05 Apr 2013 16:26:27 -0400
Message-ID: <515F3373.40302@hp.com>
References: <1365181061-30787-1-git-send-email-Waiman.Long@hp.com> <1365181061-30787-2-git-send-email-Waiman.Long@hp.com> <20130405171220.GD4068@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>,
	Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, autofs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"Chandramouleeswaran, Aswin" <aswin-VXdhtT5mjnY@public.gmane.org>,
	"Norton, Scott J" <scott.norton-VXdhtT5mjnY@public.gmane.org>,
	Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>,
	Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130405171220.GD4068-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On 04/05/2013 01:12 PM, Al Viro wrote:
>> @@ -635,22 +640,14 @@ struct dentry *dget_parent(struct dentry *dentry)
>>   {
>>   	struct dentry *ret;
>>
>> -repeat:
>> -	/*
>> -	 * Don't need rcu_dereference because we re-check it was correct under
>> -	 * the lock.
>> -	 */
>>   	rcu_read_lock();
>> -	ret = dentry->d_parent;
>> -	spin_lock(&ret->d_lock);
>> -	if (unlikely(ret != dentry->d_parent)) {
>> -		spin_unlock(&ret->d_lock);
>> -		rcu_read_unlock();
>> -		goto repeat;
>> -	}
>> +	ret = rcu_dereference(dentry->d_parent);
>>   	rcu_read_unlock();
>> +	if (dcount_inc_cmpxchg(ret))
>> +		return ret;
>> +	spin_lock(&ret->d_lock);
> And WTF is going to protect your "ret" from being freed just as you'd done
> rcu_read_unlock()?

I think I had made a mistake here. I should move the rcu_read_unlock() 
down to before the return statement as well as after the spin_lock(). 
Thank for pointing this out. I will fix that in the next version. 
Anything else that needs to be fixed?

Regards,
Longman
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
