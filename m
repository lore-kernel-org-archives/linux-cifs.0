From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: add missing unicode handling routines needed for
 smb2
Date: Mon, 7 Mar 2011 13:35:00 -0500
Message-ID: <20110307133500.5a390371@tlielax.poochiereds.net>
References: <AANLkTinVkEHg-DOp6+0Jq+_vteYaix+nqt=QNFJ7nSML@mail.gmail.com>
	<20110307094123.065e59c6@tlielax.poochiereds.net>
	<AANLkTinnHSpJMMvTVU77fgcgZWum6Ovb5SfOSxPbSfSG@mail.gmail.com>
	<20110307105338.69e862d0@tlielax.poochiereds.net>
	<AANLkTi=GF+b7UaKsC70BuBF7GaDNLJBGA1=2H7y3edcO@mail.gmail.com>
	<20110307132814.4b01df08@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110307132814.4b01df08-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 7 Mar 2011 13:28:14 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, 7 Mar 2011 11:09:06 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> > On Mon, Mar 7, 2011 at 9:53 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > > On Mon, 7 Mar 2011 09:07:52 -0600
> > > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > >> On Mon, Mar 7, 2011 at 8:41 AM, Jeff Layton <jlayton@poochiereds=
=2Enet> wrote:
> > >> > On Sun, 6 Mar 2011 22:17:32 -0600
> > >> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >> >
> > >> > This patch appears to be malformed...
> > >>
> > >> Cut-paste or mailer error.
> > >>
> > >> commit 11471483dbfd2f4235346acf9e181a549b3979a1
> > >> Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > >> Date: =A0 Mon Mar 7 04:15:05 2011 +0000
> > >>
> > >> =A0 =A0 [CIFS] Add missing unicode handling routines needed by s=
mb2
> > >>
> > >> =A0 =A0 Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > >>
> > >
> > > Given that there are no callers of these functions, it's hard to
> > > understand the need for this. These look like cut and paste of th=
e cifs
> > > functions. Why do we need separate routines for this for smb2?
> >=20
> > The caller of these functions will include SMB2 Tree Connect,
> > but the patch for that is not ready since quite a bit of #defines
> > in smb2pdu.c had to be reworked to account for the merge.
> >=20
> > The main two reasons these two routines are needed:
> > 1) we needed a Unicode only string conversion routine
> > (the cifs one takes an ascii parameter which is superflous
> > for the case of SMB2, which only does Unicode
> > and would make the smb2pdu.c code messie).
> > The routine is trivial and uses the existing cifs_unicode worker.
> > 2) similarly with the routine to allocate a unicodestring on
> > the fly  which is needed since we only use iovecs for cifs
> > and similar to the above is only Unicode (no ascii).
> >=20
> > The routines themselves are small.  I doubt that cifs
> > would use a routine that is unicode only but they
> > may be useful in the future so I put them in cifs_unicode.c
> > rather than a new smb2_unicode.c
> >=20
>=20
> I'm sorry, I'm not convinced. These routines do *exactly* the same
> thing as the code that's already there. If the existing code is a
> superset of the functionality needed, then there's really no need to
> add new routines for this. That's just increases the maintenance
> overhead for no value at all.=20
>=20
> Also, you didn't answer my question about the endianness. These
> routines look wrong in that they don't convert the characters to litt=
le
> endian. I think the best thing would be to remove these routines and
> adapt the new code to use the existing infrastructure.
>=20

Please disregard the above. I just looked closer and you're correct
that there is a difference.

This is doing a strndup *to* ucs2, and since the routine I was worried
about is just counting the bytes, endianness doesn't matter.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
