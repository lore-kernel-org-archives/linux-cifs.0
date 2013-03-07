From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: 3.7.10+:  BUG Dentry still in use [unmount of cifs cifs]
Date: Thu, 07 Mar 2013 14:18:13 -0800
Message-ID: <51391225.1020403@candelatech.com>
References: <51363F80.8070609@candelatech.com> <20130307191914.GA1652@mguzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130307191914.GA1652-v5fTkemuj/HkZJWtSm8s3NvLeJWuRmrY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 03/07/2013 11:19 AM, Mateusz Guzik wrote:
> On Tue, Mar 05, 2013 at 10:54:56AM -0800, Ben Greear wrote:
>> In doing some CIFS testing (utilizing it's feature to bind to local
>> address..but not sure that matters), we saw this error when trying
>> to un-mount.
>>
>> Our kernel is patched (nfs, some networking related patches), but there
>> are no out-of-kernel patches to CIFS, so I don't *think* this is anything
>> we could have caused.
>>
>> This problem appears to be easily reproducible, so we will be happy
>> to test patches if anyone has any suggestions.
>>
>> BUG: Dentry ffff8800c07e43c0{i=45762,n=cifs2-01.7.lf-data} still in use (1) [unmount of cifs cifs]
>
> We encountered similar panic, but it was related to writes. In our case
> the problem was that some cifsInodeInfo holding dentry references were
> still around (in slow-work queue) during superblock destruction in unmount.
>
> I reproduced the problem on 3.8 kernel (sorry, no 3.7 handy) with reads
> as well, which should match your scenario.
>
> I attached a patch that deals with this problem by grabbing refcounts to
> cifs superblock on cifsInodeInfo creation. This delays sb destruction
> until all cifsInodeInfos are gone. I didn't test it on 3.7.10 kernel but
> it should work fine.

The 3.7.10 patch applied cleanly and appears to fix our problem.

Thanks so much for the patch!

Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
