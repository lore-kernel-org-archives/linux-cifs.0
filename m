From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 01/11] CIFS: Respect negotiated MaxMpxCount
Date: Mon, 19 Mar 2012 11:04:37 -0400
Message-ID: <20120319110437.635ea546@tlielax.poochiereds.net>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-2-git-send-email-piastry@etersoft.ru>
	<20120317071201.7f28683b@tlielax.poochiereds.net>
	<CAKywueTDsGhcHiGM_uX6V0dnY3m_W4kD2qcb+JWRq=UVnBnvPw@mail.gmail.com>
	<CAH2r5msMKiEyS2-ak2+tQoRFommSHRcCNwp-J+XtgovmSae7-A@mail.gmail.com>
	<20120318065059.62592afb@tlielax.poochiereds.net>
	<CAKywueSrGVvwqHbTK3sNLsHDx3vR6U0Ca712ZXKNTnjnOgPGDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSrGVvwqHbTK3sNLsHDx3vR6U0Ca712ZXKNTnjnOgPGDA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 18 Mar 2012 22:23:47 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 18 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2012=C2=A0=D0=B3. 14:50 =D0=BF=D0=BE=
=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Jeff Layto=
n <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> > On Sat, 17 Mar 2012 10:20:59 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Sat, Mar 17, 2012 at 9:53 AM, Pavel Shilovsky <piastry@etersoft=
=2Eru> wrote:
> >> > 17 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2012=C2=A0=D0=B3. 15:12 =D0=BF=
=D0=BE=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Jeff=
 Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB=
:
> >> >> On Fri, 16 Mar 2012 18:09:24 +0300
> >> >> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >> >>
> >> >>> Some servers sets this value less than 50 that was hardcoded a=
nd
> >> >>> we lost the connection if when we exceed this limit. Fix this =
by
> >> >>> respecting this value - not sending more than the server allow=
s.
> >> >>>
> >> >>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> >>> ---
> >> >>> =C2=A0fs/cifs/cifsfs.c =C2=A0 =C2=A0| =C2=A0 =C2=A08 ++++----
> >> >>> =C2=A0fs/cifs/cifsglob.h =C2=A0| =C2=A0 10 +++-------
> >> >>> =C2=A0fs/cifs/cifssmb.c =C2=A0 | =C2=A0 =C2=A09 +++++++--
> >> >>> =C2=A0fs/cifs/connect.c =C2=A0 | =C2=A0 11 ++++-------
> >> >>> =C2=A0fs/cifs/dir.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A06 ++++=
--
> >> >>> =C2=A0fs/cifs/file.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A04 ++--
> >> >>> =C2=A0fs/cifs/transport.c | =C2=A0 =C2=A04 ++--
> >> >>
> >> >> Introducing a behavior change like this at the beginning of the=
 series
> >> >> is probably a mistake. You'll have no reasonable way to bisect =
down
> >> >> regressions, so you won't know if a problem is due to the chang=
e to a
> >> >> credit-based model or due to changing the client to respect the=
 maxmpx.
> >> >>
> >> >> Instead of doing this, we should instead reorganize the code ar=
ound a
> >> >> credit based model first, while attempting to mimic the existin=
g
> >> >> behavior as closely as possible. Once that framework is in plac=
e, then
> >> >> change the behavior and start respecting the maxmpx.
> >> >>
> >> >> If you do that, then someone can reasonably bisect between thos=
e two
> >> >> changes and we can determine the source of a regression.
> >> >> --
> >> >> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> >
> >> > This was done to push this patch to 3.3 and stable tree as well.
> >> > That's why it is in the start of series.
> >> >
> >> > If we decide not to push it for now, I agree that this patch sho=
uld be
> >> > in the modified version (according to changes from other patches=
) at
> >> > the end of the series.
> >> >
> >> > Steve, your thoughts?
> >> >
> >> > --
> >> > Best regards,
> >> > Pavel Shilovsky.
> >>
> >> We want to fix the reported (cifs) problem first with a simple pat=
ch
> >> (that would be suitable for stable too).
> >>
> >> The most important reported problems are mounts to servers
> >> running some versions of Windows Vista and some versions of Window=
s 7
> >> which set maxmpx below 50 and more importantly have maxworkitems
> >> (in the windows registry on the server) set at too small a value t=
o handle
> >> the 20 or 30 async reads or writes which are now often in flight t=
o them.
> >>
> >> The fix we need first is to honor the maxmpx that the server sets =
(and
> >> probably remove cifs_max_pending which is obsolete as
> >> a global module parm or simply do the minimum of cifs_max_pending
> >> and maxmpx as the earlier patch did).
> >> If desired (to workaround buggy
> >> servers) in a second patch we could add a mount parm if we think t=
here are
> >> servers such as windows 7 for which we will need to set the
> >> negotiated value lower (due to their maxworkitems registry
> >> problem), or Samba for which maxmpx could be ignored
> >> (and as JRA and others indicated - we could send
> >> a thousand requests in parallel).
> >>
> >
> > By the way...
> >
> > What's the plan for blocking locks and echoes here? Do you plan to =
make
> > them just ignore the maxmpx limit?
>=20
> I think we shouldn't play with them for stable. We still don't know
> what exactly we should do with them - really risky to make experiment=
s
> on stable kernels.
>=20

Then I'm confused, since you said this in your earlier email:

> This was done to push this patch to 3.3 and stable tree as well.
> That's why it is in the start of series.
>=20

If you're not worrying about stable (and I agree that it's premature to
do that here), then you should focus on converting everything to use
the new credit-based scheme first and only then introduce the behavior
change of respecting maxmpx.

> So, as we are sure that exceeding negotiated maxmpx value with any
> request except blocking lock and echo is wrong, I suggest to fix this
> - it is what this patch (#1) does. When we get more information about
> blocking locks and echos we can fix this too.
>=20

Well, according to what MS wrote back to Steve when he asked, exceeding
the maxmpx is wrong _period_, regardless of the call. Echoes are fairly
easy to deal with, but blocking locks are another matter entirely. I
believe we need a fundamental rethink there.

I think we need to change blocking lock calls to respect the maxmpx,
use a small timeout (3-5s or so) and call it in a loop. That would
allow other calls to "slip in", though it will suck for lock
"fairness".

That's a separate problem though. For the initial pass here, I think we
should just continue to ignore the limit for blocking locks.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
