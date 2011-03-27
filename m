From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Does fscache work already??
Date: Sun, 27 Mar 2011 21:07:22 +0530
Message-ID: <4D8F59B2.3070808@suse.de>
References: <AANLkTimQbY+kizqhrV3k5NnCzQMWJRN4XxTWxzB237Ts@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimQbY+kizqhrV3k5NnCzQMWJRN4XxTWxzB237Ts-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 03/27/2011 04:35 PM, Stef Bon wrote:
> Hi,
>
> I've just installed cachefilesd from source, got it running,
> configured the kernel, to make it support fscache,
> and mounted some shares using cifs.
>
> I do not see anything happen. No files in /var/cache/fscache/cache/....
> It's mounted using autofs.
>
> I have cifs-utils 4.8 installed, and latest kernel 2.6.38.1.
>
> Is a commandline option required or something?
>

You'd also need to use the mount option "-o fsc" along with the kernel
config option CONFIG_CIFS_FSCACHE.


-- 
Suresh Jayaraman
