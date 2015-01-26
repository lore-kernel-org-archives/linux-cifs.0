From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How to do nonblocking writes to CIFS networkshares?
Date: Sun, 25 Jan 2015 21:13:36 -0600
Message-ID: <CADT32eKo6zgS1oVxd6pSRRch5swnD1Y-_Oa_2z85+_nOJ3AODQ@mail.gmail.com>
References: <54BFBCBC.9030706@axis.com>
	<CADT32e+doVOzxo941dBx=mDftcMoFPow24fhMj=pP8gOtgcrFw@mail.gmail.com>
	<54C54132.2010304@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sebastian Rasmussen <sebastian.rasmussen-VrBV9hrLPhE@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C54132.2010304-VrBV9hrLPhE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

You can use man crash command. I use command  sudo crash vmlinux to analyze
a live system.

On Sun, Jan 25, 2015 at 1:17 PM, Sebastian Rasmussen
<sebastian.rasmussen-VrBV9hrLPhE@public.gmane.org> wrote:
>> Not sure why your writes should be blocking, they should return as soon as
>> they
>> write data to page-cache.
>
>
> I haven't checked, but I assume that my backed up writes have filled the
> page cache (it is a pretty memory constrained embedded Linux system).
>
>> Can you run crash on this live system and see where this write
>> call/process is blocked?
>
> I can try, but I don't know this tool. And "crash" was not most search
> friendly term. ;) Do you mind helping out with a URL?
>
>  / Sebastian
>
