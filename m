From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: make CIFS depend on CRYPTO_ECB
Date: Fri, 3 Jun 2011 14:02:18 -0400
Message-ID: <20110603140218.02d3315e@tlielax.poochiereds.net>
References: <4DE89FFD.6040006@suse.de>
	<20110603091007.7c7b9910@corrin.poochiereds.net>
	<BANLkTimhjwe1Ry8JR+bTixSRmd86gHADTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimhjwe1Ry8JR+bTixSRmd86gHADTw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 3 Jun 2011 12:39:41 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Merged.  This is a strange dependency - it looks like thee real
> problem is that the two crypto libs we depend on that depend on this
> don't select ECB but it is harmless to add the select.
>=20

Hmm...then maybe the patch should this dependency there so that other
kernel subsystems don't get bitten by the same problem?

> On Fri, Jun 3, 2011 at 8:10 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Fri, 03 Jun 2011 14:19:01 +0530
> > Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> >
> >> When CONFIG_CRYPTO_ECB is not set, trying to mount a CIFS share wi=
th NTLM
> >> security resulted in mount failure with the following error:
> >> =C2=A0 =C2=A0"CIFS VFS: could not allocate des crypto API"
> >>
> >> Seems like a leftover from commit 43988d7.
> >>
> >> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/Kconfig | =C2=A0 =C2=A01 +
> >> =C2=A01 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> >> index 1cd4c3a..66c68ab 100644
> >> --- a/fs/cifs/Kconfig
> >> +++ b/fs/cifs/Kconfig
> >> @@ -7,6 +7,7 @@ config CIFS
> >> =C2=A0 =C2=A0 =C2=A0 select CRYPTO_MD5
> >> =C2=A0 =C2=A0 =C2=A0 select CRYPTO_HMAC
> >> =C2=A0 =C2=A0 =C2=A0 select CRYPTO_ARC4
> >> + =C2=A0 =C2=A0 select CRYPTO_ECB
> >> =C2=A0 =C2=A0 =C2=A0 select CRYPTO_DES
> >> =C2=A0 =C2=A0 =C2=A0 help
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 This is the client VFS module for the =
Common Internet File System
> >
> > Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
