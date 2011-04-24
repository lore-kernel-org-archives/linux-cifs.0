From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Simplify invalidate part (try #5)
Date: Sun, 24 Apr 2011 11:22:27 +0400
Message-ID: <BANLkTimD+x+rMSMwP409iJ-F5=XiCf_PYw@mail.gmail.com>
References: <1303565417-3653-1-git-send-email-piastry@etersoft.ru>
	<BANLkTi=J7oNsf=Yixzhp1eU7+=WRW=wB=A@mail.gmail.com>
	<BANLkTinoBtt0UfXOHt2SamjX__30YeagsQ@mail.gmail.com>
	<BANLkTinqaNMQGGSqQ5v4o14degrTBpL1Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinqaNMQGGSqQ5v4o14degrTBpL1Zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/24 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Sat, Apr 23, 2011 at 1:49 PM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org=
> wrote:
>> 2011/4/23 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> With this patch do you still measure a slight performance degradati=
on
>>> (e.g. with dbench) and how much?
>>>
>>
>> I tested it several times and didn't notice any difference between
>> this version and try #4 (without filemap_fdatawait calls) in dbench
>> (dbench -D dir 1). But, anyway, this patch brings ~5% performance
>> itself (in comparison with current state of for-next branch).
>
> Can you clarify what you mean by ~5%? =A0Did it fix a perf problem?
>

Sorry for wasn't clear. I mean when I tested it more carefully (with
several runs) I got the following results against Windows 7 on LAN
(throughput):
1) for-next + try #4 and for-next + try #5 ~ 2.59 MB/sec;
2) for-next ~ 2.48 MB/sec.

So, this patch increases performance by 5%.

--=20
Best regards,
Pavel Shilovsky.
