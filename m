From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Upgrading security default
Date: Sat, 24 Nov 2012 23:57:44 -0600
Message-ID: <CAH2r5msXYgqN6ZdyS+mcTtupBk3=dwOh1qrZo4fY5KMOMB58Xg@mail.gmail.com>
References: <CAH2r5mtPAwURZxTeRBfn+c=hNyeaDbmKbYXt=w3VkUu5i1cxNQ@mail.gmail.com>
	<20121123204136.5466f0e9@corrin.poochiereds.net>
	<CAH2r5msv_gp8Vpx82zA084awe++kFd5S3X7==6K2g6c7jBhCOg@mail.gmail.com>
	<20121124061135.317ea3e8@tlielax.poochiereds.net>
	<CAH2r5muU+mK13D-u6ca4sWfvpeP1EdMaxoeX0+5g-v6gu4+_Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muU+mK13D-u6ca4sWfvpeP1EdMaxoeX0+5g-v6gu4+_Mw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Nov 24, 2012 at 10:55 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sat, Nov 24, 2012 at 5:11 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On Fri, 23 Nov 2012 20:48:40 -0600
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> it doesn't change security flags - but it seemed the smallest and
>>> safest since it basically says:
>>> 1) if you pass in "sec=" then use that
>>> 2) otherwise use ntlmssp (with ntlmv2)
>>>
>>> so shouldn't have any unintended consequences (and the sign mount
>>> option should work as expected as well)
>>>
>>
>> Umm...I think it would. The story for people who need to mount using
>> cleartext passwords has always been "Set SecurityFlags to a magic value
>> and mount without a sec= option". With your original patch, that would
>> have broken them, AFAICT.

you are probably right (sec=none was obviously for null user not plain
text password)


-- 
Thanks,

Steve
