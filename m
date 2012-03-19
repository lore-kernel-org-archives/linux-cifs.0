From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 01/11] CIFS: Respect negotiated MaxMpxCount
Date: Mon, 19 Mar 2012 23:04:37 +0400
Message-ID: <CAKywueR2mWNKxNDhhj_0i0TfiPz3nmvVBXbxGMZ+Lrbgts3cDQ@mail.gmail.com>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-2-git-send-email-piastry@etersoft.ru>
	<20120317071201.7f28683b@tlielax.poochiereds.net>
	<CAKywueTDsGhcHiGM_uX6V0dnY3m_W4kD2qcb+JWRq=UVnBnvPw@mail.gmail.com>
	<CAH2r5msMKiEyS2-ak2+tQoRFommSHRcCNwp-J+XtgovmSae7-A@mail.gmail.com>
	<20120318065059.62592afb@tlielax.poochiereds.net>
	<CAKywueSrGVvwqHbTK3sNLsHDx3vR6U0Ca712ZXKNTnjnOgPGDA@mail.gmail.com>
	<20120319110437.635ea546@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120319110437.635ea546-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

19 =CD=C1=D2=D4=C1 2012=9A=C7. 19:04 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Sun, 18 Mar 2012 22:23:47 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 18 =CD=C1=D2=D4=C1 2012=9A=C7. 14:50 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=
=D8 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
>> > On Sat, 17 Mar 2012 10:20:59 -0500
>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Sat, Mar 17, 2012 at 9:53 AM, Pavel Shilovsky <piastry@etersof=
t.ru> wrote:
>> >> > 17 =CD=C1=D2=D4=C1 2012=9A=C7. 15:12 =D0=CF=CC=D8=DA=CF=D7=C1=D4=
=C5=CC=D8 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
>> >> >> On Fri, 16 Mar 2012 18:09:24 +0300
>> >> >> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> >> >>
>> >> >>> Some servers sets this value less than 50 that was hardcoded =
and
>> >> >>> we lost the connection if when we exceed this limit. Fix this=
 by
>> >> >>> respecting this value - not sending more than the server allo=
ws.
>> >> >>>
>> >> >>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> >> >>> ---
>> >> >>> =9Afs/cifs/cifsfs.c =9A =9A| =9A =9A8 ++++----
>> >> >>> =9Afs/cifs/cifsglob.h =9A| =9A 10 +++-------
>> >> >>> =9Afs/cifs/cifssmb.c =9A | =9A =9A9 +++++++--
>> >> >>> =9Afs/cifs/connect.c =9A | =9A 11 ++++-------
>> >> >>> =9Afs/cifs/dir.c =9A =9A =9A | =9A =9A6 ++++--
>> >> >>> =9Afs/cifs/file.c =9A =9A =9A| =9A =9A4 ++--
>> >> >>> =9Afs/cifs/transport.c | =9A =9A4 ++--
>> >> >>
>> >> >> Introducing a behavior change like this at the beginning of th=
e series
>> >> >> is probably a mistake. You'll have no reasonable way to bisect=
 down
>> >> >> regressions, so you won't know if a problem is due to the chan=
ge to a
>> >> >> credit-based model or due to changing the client to respect th=
e maxmpx.
>> >> >>
>> >> >> Instead of doing this, we should instead reorganize the code a=
round a
>> >> >> credit based model first, while attempting to mimic the existi=
ng
>> >> >> behavior as closely as possible. Once that framework is in pla=
ce, then
>> >> >> change the behavior and start respecting the maxmpx.
>> >> >>
>> >> >> If you do that, then someone can reasonably bisect between tho=
se two
>> >> >> changes and we can determine the source of a regression.
>> >> >> --
>> >> >> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> >
>> >> > This was done to push this patch to 3.3 and stable tree as well=
=2E
>> >> > That's why it is in the start of series.
>> >> >
>> >> > If we decide not to push it for now, I agree that this patch sh=
ould be
>> >> > in the modified version (according to changes from other patche=
s) at
>> >> > the end of the series.
>> >> >
>> >> > Steve, your thoughts?
>> >> >
>> >> > --
>> >> > Best regards,
>> >> > Pavel Shilovsky.
>> >>
>> >> We want to fix the reported (cifs) problem first with a simple pa=
tch
>> >> (that would be suitable for stable too).
>> >>
>> >> The most important reported problems are mounts to servers
>> >> running some versions of Windows Vista and some versions of Windo=
ws 7
>> >> which set maxmpx below 50 and more importantly have maxworkitems
>> >> (in the windows registry on the server) set at too small a value =
to handle
>> >> the 20 or 30 async reads or writes which are now often in flight =
to them.
>> >>
>> >> The fix we need first is to honor the maxmpx that the server sets=
 (and
>> >> probably remove cifs_max_pending which is obsolete as
>> >> a global module parm or simply do the minimum of cifs_max_pending
>> >> and maxmpx as the earlier patch did).
>> >> If desired (to workaround buggy
>> >> servers) in a second patch we could add a mount parm if we think =
there are
>> >> servers such as windows 7 for which we will need to set the
>> >> negotiated value lower (due to their maxworkitems registry
>> >> problem), or Samba for which maxmpx could be ignored
>> >> (and as JRA and others indicated - we could send
>> >> a thousand requests in parallel).
>> >>
>> >
>> > By the way...
>> >
>> > What's the plan for blocking locks and echoes here? Do you plan to=
 make
>> > them just ignore the maxmpx limit?
>>
>> I think we shouldn't play with them for stable. We still don't know
>> what exactly we should do with them - really risky to make experimen=
ts
>> on stable kernels.
>>
>
> Then I'm confused, since you said this in your earlier email:
>
>> This was done to push this patch to 3.3 and stable tree as well.
>> That's why it is in the start of series.
>>
>
> If you're not worrying about stable (and I agree that it's premature =
to
> do that here), then you should focus on converting everything to use
> the new credit-based scheme first and only then introduce the behavio=
r
> change of respecting maxmpx.
>
>> So, as we are sure that exceeding negotiated maxmpx value with any
>> request except blocking lock and echo is wrong, I suggest to fix thi=
s
>> - it is what this patch (#1) does. When we get more information abou=
t
>> blocking locks and echos we can fix this too.
>>
>
> Well, according to what MS wrote back to Steve when he asked, exceedi=
ng
> the maxmpx is wrong _period_, regardless of the call. Echoes are fair=
ly
> easy to deal with, but blocking locks are another matter entirely. I
> believe we need a fundamental rethink there.

I meant that playing with things like blocking locks and echos is too
risky for stable. But if we can fix the existing stable problem (not
respecting MaxMpxCount value by other commands) with a strait-forward
patch like this - we should do it.

>
> I think we need to change blocking lock calls to respect the maxmpx,
> use a small timeout (3-5s or so) and call it in a loop. That would
> allow other calls to "slip in", though it will suck for lock
> "fairness".
>
> That's a separate problem though. For the initial pass here, I think =
we
> should just continue to ignore the limit for blocking locks.

Yes, I agree this is another separate problem.

--=20
Best regards,
Pavel Shilovsky.
