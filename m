From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [patch] cifs: integer overflow in parse_dacl()
Date: Wed, 11 Jan 2012 13:20:53 -0500
Message-ID: <20120111132053.467e8cae@tlielax.poochiereds.net>
References: <20120111074627.GA4519@elgon.mountain>
	<CADT32eLVwQT9V67BX8TkjVHDnQoYS7OqA_-xbnjY57ZXO3EfsA@mail.gmail.com>
	<CAH2r5muDQUL=0HcoFHH3QvP7C2pyy0=S9ESFBcm=qOYg3ESdxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muDQUL=0HcoFHH3QvP7C2pyy0=S9ESFBcm=qOYg3ESdxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 11 Jan 2012 11:24:03 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Jan 11, 2012 at 9:50 AM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Wed, Jan 11, 2012 at 1:46 AM, Dan Carpenter <dan.carpenter@oracl=
e.com> wrote:
> >> On 32 bit systems num_aces * sizeof(struct cifs_ace *) could overf=
low
> >> leading to a smaller ppace buffer than we expected.
> >>
> >> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >>
> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> >> index 72ddf23..c1b2544 100644
> >> --- a/fs/cifs/cifsacl.c
> >> +++ b/fs/cifs/cifsacl.c
> >> @@ -909,6 +909,8 @@ static void parse_dacl(struct cifs_acl *pdacl,=
 char *end_of_acl,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0umode_t gro=
up_mask =3D S_IRWXG;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0umode_t oth=
er_mask =3D S_IRWXU | S_IRWXG | S_IRWXO;
> >>
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (num_aces > =
ULONG_MAX / sizeof(struct cifs_ace *))
> >
> > Should an error/warning (like cifs client can't handle these many a=
ces or
> > possible erroneous number of aces sent by server etc.) be logged be=
fore
> > returning?
> >
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ppace =3D k=
malloc(num_aces * sizeof(struct cifs_ace *),
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0GFP_KERNEL);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ppace)=
 {
>=20
> Perhaps.   Also note that you would overflow maximum smb size if num
> aces is huge
> so would you have even gotten this far?
>=20

Only if the smb frame is properly formed. It's possible that it's
corrupt in such a way that the num_aces field is much larger than it
should be, but the rest of the frame looks OK.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
