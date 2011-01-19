From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: clean up unaligned accesses in cifs_unicode.c
Date: Wed, 19 Jan 2011 11:11:41 -0500
Message-ID: <20110119111141.0567a9e9@tlielax.poochiereds.net>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
	<1295382799-7902-5-git-send-email-jlayton@redhat.com>
	<AANLkTikZYP39UEVGt1Tn1PdYE9RnoBEhOjV+qWfd3oRm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikZYP39UEVGt1Tn1PdYE9RnoBEhOjV+qWfd3oRm-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 19 Jan 2011 09:58:45 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Jan 18, 2011 at 2:33 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > Make sure we use get/put_unaligned routines when accessing wide
> > character strings.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

[...]

> > @@ -60,7 +64,7 @@ cifs_ucs2_bytes(const __le16 *from, int maxbytes,
> > =A0/*
> > =A0* cifs_mapchar - convert a little-endian char to proper char in =
codepage
>=20
> I think this wording is now incorrect since src_char is not le anymor=
e.
>=20

Good catch. I'll fix it.


[...]

> > @@ -158,19 +162,23 @@ cifs_from_ucs2(char *to, const __le16 *from, =
int tolen, int fromlen,
> > =A0 =A0 =A0 =A0 */
> > =A0 =A0 =A0 =A0safelen =3D tolen - (NLS_MAX_CHARSET_SIZE + nullsize=
);
> >
> > - =A0 =A0 =A0 for (i =3D 0; i < fromwords && from[i]; i++) {
> > + =A0 =A0 =A0 for (i =3D 0; i < fromwords; i++) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ftmp =3D get_unaligned_le16(&from[i])=
;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ftmp =3D=3D 0)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> > +
>=20
> Can the contents of from[i] be 0 so ftmp is 0 but we did
> not want to break out until fromwords?
>=20

I don't quite understand what you're asking. The code should be
equivalent to what was there before except that we use
get_unaligned_le16 to get the value and store it in a variable on the
stack. Note that the '&& from[i]' condition was removed from the "for"
statement.


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
