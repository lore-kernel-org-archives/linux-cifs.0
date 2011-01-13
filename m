From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/2] mount.cifs: clean up handling of uid= and gid=
Date: Wed, 12 Jan 2011 21:13:47 -0500
Message-ID: <20110112211347.33f6b037@corrin.poochiereds.net>
References: <1294863996-7678-1-git-send-email-jlayton@samba.org>
	<AANLkTin6ccN_qBD32eo0dMXCLpEQXscX_sjOzNwvMtRO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org, metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin6ccN_qBD32eo0dMXCLpEQXscX_sjOzNwvMtRO-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 12 Jan 2011 15:42:35 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Jan 12, 2011 at 2:26 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > The handling of these options is quite convoluted. Change it so tha=
t
> > these options are stored as numbers and then appended to the option
> > strings.
> >
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> > =A0mount.cifs.c | =A0 94 +++++++++++++++++++++++++++++-------------=
---------------
> > =A01 files changed, 48 insertions(+), 46 deletions(-)
> >
> > diff --git a/mount.cifs.c b/mount.cifs.c
> > index df92d79..8fccf44 100644
> > --- a/mount.cifs.c
> > +++ b/mount.cifs.c
> > @@ -857,19 +857,24 @@ parse_options(const char *data, struct parsed=
_mount_info *parsed_info)
> > =A0 =A0 =A0 =A0int rc =3D 0;
> > =A0 =A0 =A0 =A0int got_uid =3D 0;
> > =A0 =A0 =A0 =A0int got_gid =3D 0;
> > - =A0 =A0 =A0 char user[32];
> > - =A0 =A0 =A0 char group[32];
> > + =A0 =A0 =A0 uid_t uid;
> > + =A0 =A0 =A0 gid_t gid;
> > + =A0 =A0 =A0 char txtbuf[12];
>=20
> Looks correct except perhaps a comment about the value of 12 would be=
 nice.
>=20
> Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20

Good point. I'll add one before I merge it.

Thanks,
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
