From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Simplify invalidate part (try #5)
Date: Sat, 23 Apr 2011 17:31:28 -0500
Message-ID: <BANLkTinqaNMQGGSqQ5v4o14degrTBpL1Zw@mail.gmail.com>
References: <1303565417-3653-1-git-send-email-piastry@etersoft.ru>
	<BANLkTi=J7oNsf=Yixzhp1eU7+=WRW=wB=A@mail.gmail.com>
	<BANLkTinoBtt0UfXOHt2SamjX__30YeagsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinoBtt0UfXOHt2SamjX__30YeagsQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Apr 23, 2011 at 1:49 PM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> 2011/4/23 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> With this patch do you still measure a slight performance degradation
>> (e.g. with dbench) and how much?
>>
>
> I tested it several times and didn't notice any difference between
> this version and try #4 (without filemap_fdatawait calls) in dbench
> (dbench -D dir 1). But, anyway, this patch brings ~5% performance
> itself (in comparison with current state of for-next branch).

Can you clarify what you mean by ~5%?  Did it fix a perf problem?



-- 
Thanks,

Steve
