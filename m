From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: document 'fsc' mount option
Date: Tue, 27 Jul 2010 22:03:53 +0530
Message-ID: <4C4F0A71.8020908@suse.de>
References: <4C4EE408.7070109@suse.de>	<20100727103313.4b730ea8@tlielax.poochiereds.net>	<AANLkTina2EyHkrgNAcrY8ZRK=fXQS71dekWc+kOA0+mz@mail.gmail.com>	<20100727111517.4fe0859e@tlielax.poochiereds.net> <AANLkTik9JqtqAtKJQsaQR8aC8s0kwmrcU=_=QQei7U07@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik9JqtqAtKJQsaQR8aC8s0kwmrcU=_=QQei7U07-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/27/2010 08:51 PM, Steve French wrote:
> scripts/extract-ikconfig could be run against the image (or look at
> /proc/config.gz) - but unless there is an easier way to view kernel
> config options on particular distros via distro specific tools -
> probably easier just to note that CONFIG_FSCACHE must be selected in
> the kernel build (since it forces dependencies on the other kernel
> options being set)

Does something like
	$zcat /proc/config.gz | grep CONFIG_CIFS_FSCACHE

might work on all distros?

But, Jeff's idea of having a features file in /proc sounds good. Apart
from using them as a reference to check in documentation, it could be a
useful information while collecting debugging output as well..?


Thanks,

-- 
Suresh Jayaraman
