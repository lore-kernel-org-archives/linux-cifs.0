From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Does fscache work already??
Date: Sun, 27 Mar 2011 18:14:17 +0200
Message-ID: <AANLkTincNUGiyUmn03n5gPqF-VvUNkMSdjLKCjR++XtR@mail.gmail.com>
References: <AANLkTimQbY+kizqhrV3k5NnCzQMWJRN4XxTWxzB237Ts@mail.gmail.com>
	<4D8F59B2.3070808@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D8F59B2.3070808-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Yes I found out. Thanks anyway.

Stef

2011/3/27 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
> On 03/27/2011 04:35 PM, Stef Bon wrote:
>>
>> Hi,
>>
>> I've just installed cachefilesd from source, got it running,
>> configured the kernel, to make it support fscache,
>> and mounted some shares using cifs.
>>
>> I do not see anything happen. No files in /var/cache/fscache/cache/....
>> It's mounted using autofs.
>>
>> I have cifs-utils 4.8 installed, and latest kernel 2.6.38.1.
>>
>> Is a commandline option required or something?
>>
>
> You'd also need to use the mount option "-o fsc" along with the kernel
> config option CONFIG_CIFS_FSCACHE.
>
>
> --
> Suresh Jayaraman
>
