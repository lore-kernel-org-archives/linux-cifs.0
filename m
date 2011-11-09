From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: lower default wsize when unix extensions are not
 used
Date: Wed, 9 Nov 2011 16:04:08 -0500
Message-ID: <20111109160408.44947815@corrin.poochiereds.net>
References: <1320863843-29406-1-git-send-email-jlayton@redhat.com>
	<20111109134140.2105ed9e@corrin.poochiereds.net>
	<CAH2r5mtmboSEMHbj6ixh6UGSgiTFz1Mn=ZU6fkQaCSu7n6h=EQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org,
	piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtmboSEMHbj6ixh6UGSgiTFz1Mn=ZU6fkQaCSu7n6h=EQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 9 Nov 2011 14:55:36 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> How much of a performance hit does this make?  I would expect that
> dropping the writesize by more than 50% to most non-Samba servers to
> work around a bug in Solaris seems extreme.  If this hurts our
> performance measurably, it may be more pragmatic to limit the wsize
> change to a subset of these (e.g. based on server type) - seems more
> fair to not punish other servers for a Solaris bug.
>=20

I'm not sure how big a hit it will be, but it won't be 0. As always, it
depends on workload. The problem is, I'm not sure we can reliably
detect when the server can't handle larger writes like this.

Most servers are fine with larger writes, but when it's not then the
result is failed writeback. Given that a lot of userspace code doesn't
check the return code on close(), then this manifests itself as
"silent" data corruption.

So, while I don't like it, I think we're basically of constrained by
Windows' behavior here. We really have to ensure that the defaults work
for everyone, even if they're not what we'd consider ideal.

Note too that this just sets the default wsize to 65536 in this
situation. There's nothing that prevents someone from setting it higher
if they have a server that can handle larger writes.

> On Wed, Nov 9, 2011 at 12:41 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Wed, =C2=A09 Nov 2011 13:37:23 -0500
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> >> We've had some reports of servers (namely, the Solaris in-kernel C=
IFS
> >> server) that don't deal properly with writes that are "too large" =
even
> >> though they set CAP_LARGE_WRITE_ANDX. Change the default to better
> >> mirror what windows clients do.
> >>
> >> Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> Reported-by: Nick Davis <phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> >> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/connect.c | =C2=A0 23 +++++++++++++++++++----
> >> =C2=A01 files changed, 19 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index d6a972d..bf82f88 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -2912,18 +2912,33 @@ void cifs_setup_cifs_sb(struct smb_vol *pv=
olume_info,
> >> =C2=A0#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
> >>
> >> =C2=A0/*
> >> - * Windows only supports a max of 60k reads. Default to that when=
 posix
> >> - * extensions aren't in force.
> >> + * Windows only supports a max of 60kb reads and 65535 byte write=
s. Default to
> >> + * those values when posix extensions aren't in force. In actuali=
ty here, we
> >> + * use 65536 to allow for a write that is a multiple of 4k. Most =
servers seem
> >> + * to be ok with the extra byte even though Windows doesn't send =
writes that
> >> + * are that large.
> >> + *
> >> + * Citation:
> >> + *
> >> + * http://blogs.msdn.com/b/openspecification/archive/2009/04/10/s=
mb-maximum-transmit-buffer-size-and-performance-tuning.aspx
> >> =C2=A0 */
> >> =C2=A0#define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
> >> +#define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
> >>
> >> =C2=A0static unsigned int
> >> =C2=A0cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol =
*pvolume_info)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 __u64 unix_cap =3D le64_to_cpu(tcon->fsUnixIn=
fo.Capability);
> >> =C2=A0 =C2=A0 =C2=A0 struct TCP_Server_Info *server =3D tcon->ses-=
>server;
> >> - =C2=A0 =C2=A0 unsigned int wsize =3D pvolume_info->wsize ? pvolu=
me_info->wsize :
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFS_DEFAULT_IOSIZE;
> >> + =C2=A0 =C2=A0 unsigned int wsize;
> >> +
> >> + =C2=A0 =C2=A0 /* start with specified wsize, or default */
> >> + =C2=A0 =C2=A0 if (pvolume_info->wsize)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wsize =3D pvolume_info=
->wsize;
> >> + =C2=A0 =C2=A0 else if (tcon->unix_ext && (unix_cap & CIFS_UNIX_L=
ARGE_WRITE_CAP))
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wsize =3D CIFS_DEFAULT=
_IOSIZE;
> >> + =C2=A0 =C2=A0 else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wsize =3D CIFS_DEFAULT=
_NON_POSIX_WSIZE;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 /* can server support 24-bit write sizes? (vi=
a UNIX extensions) */
> >> =C2=A0 =C2=A0 =C2=A0 if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX=
_LARGE_WRITE_CAP))
> >
> >
> > I should also mention that I suspect that this will fix this bug
> > without needing extra options:
> >
> > =C2=A0 =C2=A0https://bugzilla.samba.org/show_bug.cgi?id=3D8559
> >
> > If it looks acceptable, this might be suitable for stable too.
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
