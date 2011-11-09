From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: lower default wsize when unix extensions are not
 used
Date: Wed, 9 Nov 2011 18:57:51 -0500
Message-ID: <20111109185751.030239d4@corrin.poochiereds.net>
References: <1320863843-29406-1-git-send-email-jlayton@redhat.com>
	<CADT32eLBeJoeiJUHM5OvK=7vGG1Z5X2NUVh6Hnkfp89u1yySww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLBeJoeiJUHM5OvK=7vGG1Z5X2NUVh6Hnkfp89u1yySww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 9 Nov 2011 17:10:48 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Nov 9, 2011 at 12:37 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > We've had some reports of servers (namely, the Solaris in-kernel CI=
=46S
> > server) that don't deal properly with writes that are "too large" e=
ven
> > though they set CAP_LARGE_WRITE_ANDX. Change the default to better
> > mirror what windows clients do.
> >
> > Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> > Reported-by: Nick Davis <phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/connect.c | =C2=A0 23 +++++++++++++++++++----
> > =C2=A01 files changed, 19 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index d6a972d..bf82f88 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -2912,18 +2912,33 @@ void cifs_setup_cifs_sb(struct smb_vol *pvo=
lume_info,
> > =C2=A0#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
> >
> > =C2=A0/*
> > - * Windows only supports a max of 60k reads. Default to that when =
posix
> > - * extensions aren't in force.
> > + * Windows only supports a max of 60kb reads and 65535 byte writes=
=2E Default to
> > + * those values when posix extensions aren't in force. In actualit=
y here, we
> > + * use 65536 to allow for a write that is a multiple of 4k. Most s=
ervers seem
> > + * to be ok with the extra byte even though Windows doesn't send w=
rites that
> > + * are that large.
> > + *
> > + * Citation:
> > + *
> > + * http://blogs.msdn.com/b/openspecification/archive/2009/04/10/sm=
b-maximum-transmit-buffer-size-and-performance-tuning.aspx
> > =C2=A0*/
> > =C2=A0#define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
> > +#define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
> >
> > =C2=A0static unsigned int
> > =C2=A0cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *=
pvolume_info)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 unix_cap =3D le64_to_cpu(tcon->fsU=
nixInfo.Capability);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct TCP_Server_Info *server =3D tcon-=
>ses->server;
> > - =C2=A0 =C2=A0 =C2=A0 unsigned int wsize =3D pvolume_info->wsize ?=
 pvolume_info->wsize :
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFS_DEFAULT_IOSIZE;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int wsize;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* start with specified wsize, or default */
> > + =C2=A0 =C2=A0 =C2=A0 if (pvolume_info->wsize)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wsize =3D pvolum=
e_info->wsize;
> > + =C2=A0 =C2=A0 =C2=A0 else if (tcon->unix_ext && (unix_cap & CIFS_=
UNIX_LARGE_WRITE_CAP))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wsize =3D CIFS_D=
EFAULT_IOSIZE;
> > + =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wsize =3D CIFS_D=
EFAULT_NON_POSIX_WSIZE;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* can server support 24-bit write sizes=
? (via UNIX extensions) */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!tcon->unix_ext || !(unix_cap & CIFS=
_UNIX_LARGE_WRITE_CAP))
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
> Does this change warrant any change to mount.cifs man page as well?

Yes, it does. I want to confirm that Steve plans to merge it first, but
I plan to do a manpage update to document it.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
