From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 01/11] CIFS: Simplify inFlight logic
Date: Tue, 28 Feb 2012 15:39:27 +0400
Message-ID: <CAKywueQ4S-V13O_gpNAHRpWo6NikQnA1KQYvokrVPRf2vW=xYQ@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-2-git-send-email-piastry@etersoft.ru>
	<CAH2r5msNLEF9qVvKsTVTUnPyUjk+7iYVJTxZgd_uuXLAE0iyRg@mail.gmail.com>
	<CAKywueQNFbwDqwr7adWsUZmaYX28tz3kYnL1=4itBHAFV1aeaA@mail.gmail.com>
	<20120228063120.76265cd9@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120228063120.76265cd9-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/28 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 28 Feb 2012 13:38:46 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2012/2/28 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> > I got a chance to look through this patch set in more detail on th=
e way
>> > to the SMB2.2 test event. =A0I liked many of the patches, but this=
 one
>> > seems to complicate, rather than simplify by adding a spinlock
>> > to what used to be an atomic_inc. =A0There is also a possibility t=
hat this
>> > spinlock will become hot. =A0I don't mind moving the atomic_inc in=
side the
>> > new dec_in_flight macro though to make it easier in the future.
>> >
>>
>> The idea was to simplify the usage of inFlight value. Now it is
>> protected by both spin_lock and atomic mechanism in one case and wit=
h
>> only atomic in another - =A0I think it's rather complicated. The pat=
ch
>> gets rid of one of the protection mechanism (atomic) and use only
>> spin_lock - this spin_lock is used further for protecting oplock and
>> echo specific variables as well.
>>
>
> The problem here is that the locking around this variable is unclear:
>
> If you need a spinlock to access/change it, then why use an atomic? I=
f
> an atomic is sufficient then why use the spinlock at all?
>
> I don't much care what scheme you end up using for this, but if you
> really need a belt-and-suspenders approach (atomic + spinlock), then
> the reasoning for it needs to be clearly documented. We mere mortals
> must understand how it's supposed to work so we don't break it later.

I don't know how the existing approach comes the tree but I guess that
it needs to be atomic to easily decrement and read this variable and
needs to be surrounded by spinlocks in wait_for_free_request to make
sure we are not incrementing the value that is already >=3D
cifs_max_pending.

The whole scheme is rather complicated of course - so, the goal of
this patch is to make it more understandable and simple (only one
protection mechanism - spin_lock).

--=20
Best regards,
Pavel Shilovsky.
