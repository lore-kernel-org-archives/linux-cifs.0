From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 01/11] CIFS: Respect negotiated MaxMpxCount
Date: Sun, 18 Mar 2012 22:23:47 +0400
Message-ID: <CAKywueSrGVvwqHbTK3sNLsHDx3vR6U0Ca712ZXKNTnjnOgPGDA@mail.gmail.com>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-2-git-send-email-piastry@etersoft.ru>
	<20120317071201.7f28683b@tlielax.poochiereds.net>
	<CAKywueTDsGhcHiGM_uX6V0dnY3m_W4kD2qcb+JWRq=UVnBnvPw@mail.gmail.com>
	<CAH2r5msMKiEyS2-ak2+tQoRFommSHRcCNwp-J+XtgovmSae7-A@mail.gmail.com>
	<20120318065059.62592afb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120318065059.62592afb-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

18 =CD=C1=D2=D4=C1 2012=9A=C7. 14:50 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Sat, 17 Mar 2012 10:20:59 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Sat, Mar 17, 2012 at 9:53 AM, Pavel Shilovsky <piastry@etersoft.r=
u> wrote:
>> > 17 =CD=C1=D2=D4=C1 2012=9A=C7. 15:12 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=
=CC=D8 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
>> >> On Fri, 16 Mar 2012 18:09:24 +0300
>> >> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> >>
>> >>> Some servers sets this value less than 50 that was hardcoded and
>> >>> we lost the connection if when we exceed this limit. Fix this by
>> >>> respecting this value - not sending more than the server allows.
>> >>>
>> >>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> >>> ---
>> >>> =9Afs/cifs/cifsfs.c =9A =9A| =9A =9A8 ++++----
>> >>> =9Afs/cifs/cifsglob.h =9A| =9A 10 +++-------
>> >>> =9Afs/cifs/cifssmb.c =9A | =9A =9A9 +++++++--
>> >>> =9Afs/cifs/connect.c =9A | =9A 11 ++++-------
>> >>> =9Afs/cifs/dir.c =9A =9A =9A | =9A =9A6 ++++--
>> >>> =9Afs/cifs/file.c =9A =9A =9A| =9A =9A4 ++--
>> >>> =9Afs/cifs/transport.c | =9A =9A4 ++--
>> >>
>> >> Introducing a behavior change like this at the beginning of the s=
eries
>> >> is probably a mistake. You'll have no reasonable way to bisect do=
wn
>> >> regressions, so you won't know if a problem is due to the change =
to a
>> >> credit-based model or due to changing the client to respect the m=
axmpx.
>> >>
>> >> Instead of doing this, we should instead reorganize the code arou=
nd a
>> >> credit based model first, while attempting to mimic the existing
>> >> behavior as closely as possible. Once that framework is in place,=
 then
>> >> change the behavior and start respecting the maxmpx.
>> >>
>> >> If you do that, then someone can reasonably bisect between those =
two
>> >> changes and we can determine the source of a regression.
>> >> --
>> >> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >
>> > This was done to push this patch to 3.3 and stable tree as well.
>> > That's why it is in the start of series.
>> >
>> > If we decide not to push it for now, I agree that this patch shoul=
d be
>> > in the modified version (according to changes from other patches) =
at
>> > the end of the series.
>> >
>> > Steve, your thoughts?
>> >
>> > --
>> > Best regards,
>> > Pavel Shilovsky.
>>
>> We want to fix the reported (cifs) problem first with a simple patch
>> (that would be suitable for stable too).
>>
>> The most important reported problems are mounts to servers
>> running some versions of Windows Vista and some versions of Windows =
7
>> which set maxmpx below 50 and more importantly have maxworkitems
>> (in the windows registry on the server) set at too small a value to =
handle
>> the 20 or 30 async reads or writes which are now often in flight to =
them.
>>
>> The fix we need first is to honor the maxmpx that the server sets (a=
nd
>> probably remove cifs_max_pending which is obsolete as
>> a global module parm or simply do the minimum of cifs_max_pending
>> and maxmpx as the earlier patch did).
>> If desired (to workaround buggy
>> servers) in a second patch we could add a mount parm if we think the=
re are
>> servers such as windows 7 for which we will need to set the
>> negotiated value lower (due to their maxworkitems registry
>> problem), or Samba for which maxmpx could be ignored
>> (and as JRA and others indicated - we could send
>> a thousand requests in parallel).
>>
>
> By the way...
>
> What's the plan for blocking locks and echoes here? Do you plan to ma=
ke
> them just ignore the maxmpx limit?

I think we shouldn't play with them for stable. We still don't know
what exactly we should do with them - really risky to make experiments
on stable kernels.

So, as we are sure that exceeding negotiated maxmpx value with any
request except blocking lock and echo is wrong, I suggest to fix this
- it is what this patch (#1) does. When we get more information about
blocking locks and echos we can fix this too.

>
> Another important case to consider is the (apparently common) case
> where maxmpx is 1. We don't really want to make things worse against
> such servers...
>

If server negotiates maxmpx=3D1 then we simply disable oplocks for now
(that the patch does) - don't think it makes things worse for those
servers.

--=20
Best regards,
Pavel Shilovsky.
