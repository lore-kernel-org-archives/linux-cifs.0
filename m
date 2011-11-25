From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] resolve_host: silence compiler warning about discarding
 const qualifier
Date: Fri, 25 Nov 2011 09:41:30 -0500
Message-ID: <20111125094130.5ed251e1@corrin.poochiereds.net>
References: <1322051608-18427-1-git-send-email-jlayton@samba.org>
	<CAH2r5mtFrN25ni9jtPy4gSwJpA8419bgaZjanPEE8orEc+-nGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtFrN25ni9jtPy4gSwJpA8419bgaZjanPEE8orEc+-nGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 24 Nov 2011 20:39:31 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Looks fine.
>=20
> Reviewed-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>=20
> Do we care about lines over 80 in length?  (I don't care unless it
> improves readability to fix).
>=20

Thanks...I haven't cared so much about 80 char widths in in cifs-utils.
If someone seriously objects we can do a cleanup on this file later.


> On Wed, Nov 23, 2011 at 6:33 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > ...don't use "ipaddr" here since it's a const pointer.
> >
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> > =C2=A0resolve_host.c | =C2=A0 =C2=A03 +--
> > =C2=A01 files changed, 1 insertions(+), 2 deletions(-)
> >
> > diff --git a/resolve_host.c b/resolve_host.c
> > index 69859a3..17cbd10 100644
> > --- a/resolve_host.c
> > +++ b/resolve_host.c
> > @@ -70,8 +70,7 @@ int resolve_host(const char *host, char *addrstr)
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (sin6->sin6_scope_id) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D strnlen(tmpbuf, sizeo=
f(tmpbuf));
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ipaddr =3D tmpbuf + len;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 snprintf(ipaddr, sizeof(tmpbuf) =
- len, "%%%u",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 snprintf(tmpbuf + len, sizeof(tm=
pbuf) - len, "%%%u",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
sin6->sin6_scope_id);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0}
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> > --
> > 1.7.6.4
> >
>=20
>=20


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
