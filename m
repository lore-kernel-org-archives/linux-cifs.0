From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: manpages - Add contents for mount option
 cifsacl (try #2)
Date: Fri, 15 Jul 2011 14:54:05 -0400
Message-ID: <20110715145405.735a612f@tlielax.poochiereds.net>
References: <1310751455-19523-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110715143055.22a44fc5@tlielax.poochiereds.net>
	<CADT32eK49E4HELSa7-vyy4WSjco0-TPSaafem-DRUsO8LsrhaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eK49E4HELSa7-vyy4WSjco0-TPSaafem-DRUsO8LsrhaA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 15 Jul 2011 13:48:04 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Jul 15, 2011 at 1:30 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Fri, 15 Jul 2011 12:37:35 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Manpage contents for cifs mount option =C2=A0cifsacl
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =C2=A0mount.cifs.8 | =C2=A0 33 +++++++++++++++++++++++++++++++++
> >> =C2=A01 files changed, 33 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/mount.cifs.8 b/mount.cifs.8
> >> index 7e0f117..082adcd 100644
> >> --- a/mount.cifs.8
> >> +++ b/mount.cifs.8
> >> @@ -272,6 +272,39 @@ Do not allow POSIX ACL operations even if ser=
ver would support them\&.
> >> =C2=A0The CIFS client can get and set POSIX ACLs (getfacl, setfacl=
) to Samba servers version 3\&.0\&.10 and later\&. Setting POSIX ACLs r=
equires enabling both XATTR and then POSIX support in the CIFS configur=
ation options when building the cifs module\&. POSIX ACL support can be=
 disabled on a per mount basis by specifying "noacl" on mount\&.
> >> =C2=A0.RE
> >> =C2=A0.PP
> >> +cifsacl
> >> +.RS 4
> >> +This option is used to map CIFS/NTFS ACLs to/fro Linux permission=
 bits,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 ^^^^^^
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 to/from ... ditto for the other places in this entry
> >
>=20
> Jeff, not sure I understand this change. Replace map with to/from?
>=20

No, replace "to/fro" with "to/from"...

Another thought occurs to me as well...the ID mapping code is very new,
but the cifsacl option has been around for a while. It would be good to
clarify that here so that someone can have a reasonable expectation of
the behavior they'll see when they enable this on a given kernel
version.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
