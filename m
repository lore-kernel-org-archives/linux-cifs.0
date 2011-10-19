From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs: allow cifs to do readpages larger and
 asynchronously (try #7)
Date: Wed, 19 Oct 2011 15:33:28 -0400
Message-ID: <20111019153328.4eb81795@corrin.poochiereds.net>
References: <1319030695-4115-1-git-send-email-jlayton@redhat.com>
	<CAKywueTEa-fDK5edm44+OamNMcmyCQWSDNxMWQc_c2Os9-N8UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTEa-fDK5edm44+OamNMcmyCQWSDNxMWQc_c2Os9-N8UA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 19 Oct 2011 23:22:09 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/10/19 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > This patchset is a respin to fix a bug that Pavel identified in the
> > readv error handling, and to also fix up some merge conflicts that =
crept
> > in with some other patches that Steve merged recently. Other than t=
hose
> > changes, this is essentially the same patchset as the earlier versi=
ons
> > in this series.
> >
> > This set is also available via my git tree on samba.org:
> >
> > =C2=A0 =C2=A0http://git.samba.org/?p=3Djlayton/linux.git;a=3Dsummar=
y
> >
> > Jeff Layton (5):
> > =C2=A0cifs: fix protocol definition for READ_RSP
> > =C2=A0cifs: add cifs_async_readv
> > =C2=A0cifs: convert cifs_readpages to use async reads
> > =C2=A0cifs: allow for larger rsize=3D options and change defaults
> > =C2=A0cifs: tune bdi.ra_pages in accordance with the rsize
> >
> > =C2=A0fs/cifs/cifspdu.h =C2=A0 | =C2=A0 =C2=A04 +-
> > =C2=A0fs/cifs/cifsproto.h | =C2=A0 24 ++++
> > =C2=A0fs/cifs/cifssmb.c =C2=A0 | =C2=A0359 ++++++++++++++++++++++++=
+++++++++++++++++++++++++++
> > =C2=A0fs/cifs/connect.c =C2=A0 | =C2=A0167 +++++++++++++++---------
> > =C2=A0fs/cifs/file.c =C2=A0 =C2=A0 =C2=A0| =C2=A0293 ++++++++++++++=
++++------------------------
> > =C2=A05 files changed, 612 insertions(+), 235 deletions(-)
> >
> > --
> > 1.7.6.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
>=20
> Reviewed-and-Tested-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>=20

Thanks for the review and testing, Pavel.

I've gone ahead and added this to the patches in my git repo and
re-pushed it. If Steve pulls from there, it should show up with those
tags in mainline.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
