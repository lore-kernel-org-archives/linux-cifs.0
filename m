From: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Thu, 18 Aug 2011 08:22:44 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1108180821440.7903@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan> <3300.1313637592@jrobl> <alpine.DEB.2.02.1108180632000.10458@p34.internal.lan> <alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. R. Okajima" <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1108180807070.7903-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



On Thu, 18 Aug 2011, Justin Piszcz wrote:

>
>
> On Thu, 18 Aug 2011, Justin Piszcz wrote:
>
>> 
>> 
>> On Thu, 18 Aug 2011, J. R. Okajima wrote:
>> 
>>> 
>>> Justin Piszcz:
>>>> Does anyone know if any kernel supports CIFS w/out crashing? I'd like to
>>>> backup some CIFS shares, thanks.
>>>> 
>>>> 
>>>> mount -t cifs //w2/x /mnt -o user=user,pass=pass
>>>> 
>>>> [  881.388836] CIFS VFS: cifs_mount failed w/return code = -22
>>> 	:::
>>> 
>>> Since it failed mounting, this patch will help you. Although the patch
>>> will fix one bug, there still may exist another problem.
>>> 
>>> http://marc.info/?l=linux-cifs&m=131345112022031&w=2
>> 
>> Hi,
>> 
>> Latest patch (this one) applied to linux-3.1-rc2 works, at least it mounted
>> this time and did not instantly crash the kernel!
>> 
>> I also tried the hostname again (and it did not crash the kernel, but it 
>> failed to mount).
>> 
>> Used the IP and it mounted successfully:
>> //10.0.0.11/x          28T  5.0T   23T  19% /mnt
>> //10.0.0.11/y          19T  1.2T   18T   7% /mnt2
>> 
>> It has not crashed yet (which is good), I'll apply this patch to my
>> production machine and test taking backups of this data and let you know
>> if it crashes again, thanks!
>> 
>> Justin.
>
>
> Hello,
>
> It is working but very slowly:
>
> Device eth6 [10.0.1.2] (1/1):
> ================================================================================
> Incoming:                               Outgoing:
> Curr: 37.60 MByte/s                     Curr: 0.44 MByte/s
> Avg: 4.98 MByte/s                       Avg: 0.09 MByte/s
> Min: 0.00 MByte/s                       Min: 0.00 MByte/s
> Max: 40.79 MByte/s                      Max: 0.48 MByte/s
> Ttl: 1.45 GByte                         Ttl: 26.77 MByte
>
> Over 10GbE the other direction (Linux -> Windows (via Samba)) I get 500MiB/s, 
> is CIFS slow?
>
> I'll look into options to tweak the speed but this is very poor speed when 
> you have to transfer 5-10TB.  However, it is not crashing anymore, so any 
> speed is better than that :)
>
> Justin.

Hi,

Mounting with:
rw,uid=1000,gid=100,mode=0644,rsize=130048,wsize=1048576,credentials=/root/.cifs 
Same speed:
Device eth6 [10.0.1.2] (1/1):
================================================================================
Incoming:                               Outgoing:
Curr: 32.42 MByte/s                     Curr: 0.38 MByte/s
Avg: 30.72 MByte/s                      Avg: 0.39 MByte/s
Min: 0.00 MByte/s                       Min: 0.00 MByte/s
Max: 43.64 MByte/s                      Max: 0.59 MByte/s
Ttl: 20.15 GByte                        Ttl: 261.03 MByte

Thoughts?

Has anyone achieved > 30-40MB/s with CIFS?
This is a 10GbE link (and yes JUMBO frames are enabled on both sides, and 
again, samba from Linux->Windows = 500MB/s)

Justin.
