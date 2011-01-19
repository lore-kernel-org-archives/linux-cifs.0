From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: clean up unaligned accesses in cifs_unicode.c
Date: Wed, 19 Jan 2011 11:30:39 -0500
Message-ID: <20110119113039.1dfd3916@tlielax.poochiereds.net>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
	<1295382799-7902-5-git-send-email-jlayton@redhat.com>
	<AANLkTikZYP39UEVGt1Tn1PdYE9RnoBEhOjV+qWfd3oRm@mail.gmail.com>
	<AANLkTikxyAb2GSBxNeWYE6sAp7bSdakjWgp1_si1G7HU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikxyAb2GSBxNeWYE6sAp7bSdakjWgp1_si1G7HU-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 19 Jan 2011 10:08:59 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:


> >> @@ -158,19 +162,23 @@ cifs_from_ucs2(char *to, const __le16 *from,=
 int tolen, int fromlen,
> >> =A0 =A0 =A0 =A0 */
> >> =A0 =A0 =A0 =A0safelen =3D tolen - (NLS_MAX_CHARSET_SIZE + nullsiz=
e);
> >>
> >> - =A0 =A0 =A0 for (i =3D 0; i < fromwords && from[i]; i++) {
> >> + =A0 =A0 =A0 for (i =3D 0; i < fromwords; i++) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ftmp =3D get_unaligned_le16(&from[i]=
);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ftmp =3D=3D 0)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> >> +
> >
> > Can the contents of from[i] be 0 so ftmp is 0 but we did
> > not want to break out until fromwords?
> >
>=20
> Basically, why_does/what_it_means get_unaligned_le16()
> returning 0 warrants breaking out of the loop!
>=20

That means that we hit the NULL terminator in the "from" string (two
adjacent zero bytes). So, we absolutely want to break out there.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
