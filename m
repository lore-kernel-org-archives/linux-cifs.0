From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 01/11] CIFS: Respect negotiated MaxMpxCount
Date: Sun, 18 Mar 2012 06:50:59 -0400
Message-ID: <20120318065059.62592afb@tlielax.poochiereds.net>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-2-git-send-email-piastry@etersoft.ru>
	<20120317071201.7f28683b@tlielax.poochiereds.net>
	<CAKywueTDsGhcHiGM_uX6V0dnY3m_W4kD2qcb+JWRq=UVnBnvPw@mail.gmail.com>
	<CAH2r5msMKiEyS2-ak2+tQoRFommSHRcCNwp-J+XtgovmSae7-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msMKiEyS2-ak2+tQoRFommSHRcCNwp-J+XtgovmSae7-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 17 Mar 2012 10:20:59 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sat, Mar 17, 2012 at 9:53 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org=
> wrote:
> > 17 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2012=C2=A0=D0=B3. 15:12 =D0=BF=D0=
=BE=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Jeff La=
yton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> >> On Fri, 16 Mar 2012 18:09:24 +0300
> >> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >>
> >>> Some servers sets this value less than 50 that was hardcoded and
> >>> we lost the connection if when we exceed this limit. Fix this by
> >>> respecting this value - not sending more than the server allows.
> >>>
> >>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >>> ---
> >>> =C2=A0fs/cifs/cifsfs.c =C2=A0 =C2=A0| =C2=A0 =C2=A08 ++++----
> >>> =C2=A0fs/cifs/cifsglob.h =C2=A0| =C2=A0 10 +++-------
> >>> =C2=A0fs/cifs/cifssmb.c =C2=A0 | =C2=A0 =C2=A09 +++++++--
> >>> =C2=A0fs/cifs/connect.c =C2=A0 | =C2=A0 11 ++++-------
> >>> =C2=A0fs/cifs/dir.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A06 ++++--
> >>> =C2=A0fs/cifs/file.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A04 ++--
> >>> =C2=A0fs/cifs/transport.c | =C2=A0 =C2=A04 ++--
> >>
> >> Introducing a behavior change like this at the beginning of the se=
ries
> >> is probably a mistake. You'll have no reasonable way to bisect dow=
n
> >> regressions, so you won't know if a problem is due to the change t=
o a
> >> credit-based model or due to changing the client to respect the ma=
xmpx.
> >>
> >> Instead of doing this, we should instead reorganize the code aroun=
d a
> >> credit based model first, while attempting to mimic the existing
> >> behavior as closely as possible. Once that framework is in place, =
then
> >> change the behavior and start respecting the maxmpx.
> >>
> >> If you do that, then someone can reasonably bisect between those t=
wo
> >> changes and we can determine the source of a regression.
> >> --
> >> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> > This was done to push this patch to 3.3 and stable tree as well.
> > That's why it is in the start of series.
> >
> > If we decide not to push it for now, I agree that this patch should=
 be
> > in the modified version (according to changes from other patches) a=
t
> > the end of the series.
> >
> > Steve, your thoughts?
> >
> > --
> > Best regards,
> > Pavel Shilovsky.
>=20
> We want to fix the reported (cifs) problem first with a simple patch
> (that would be suitable for stable too).
>=20
> The most important reported problems are mounts to servers
> running some versions of Windows Vista and some versions of Windows 7
> which set maxmpx below 50 and more importantly have maxworkitems
> (in the windows registry on the server) set at too small a value to h=
andle
> the 20 or 30 async reads or writes which are now often in flight to t=
hem.
>=20
> The fix we need first is to honor the maxmpx that the server sets (an=
d
> probably remove cifs_max_pending which is obsolete as
> a global module parm or simply do the minimum of cifs_max_pending
> and maxmpx as the earlier patch did).=20
> If desired (to workaround buggy
> servers) in a second patch we could add a mount parm if we think ther=
e are
> servers such as windows 7 for which we will need to set the
> negotiated value lower (due to their maxworkitems registry
> problem), or Samba for which maxmpx could be ignored
> (and as JRA and others indicated - we could send
> a thousand requests in parallel).
>=20

By the way...

What's the plan for blocking locks and echoes here? Do you plan to make
them just ignore the maxmpx limit?

Another important case to consider is the (apparently common) case
where maxmpx is 1. We don't really want to make things worse against
such servers...

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
