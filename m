From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/16] CIFS: Check for SMB2 vs CIFS in find_tcp_session
Date: Mon, 7 May 2012 07:36:36 -0400
Message-ID: <20120507073636.1d10a9ae@corrin.poochiereds.net>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
	<1332753703-4315-4-git-send-email-piastry@etersoft.ru>
	<20120506100129.0b2f626b@corrin.poochiereds.net>
	<CAH2r5mvX4pfxR4B9TXYcSDOTn3cY0d+Be50zwZ+NhceDOR6vxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvX4pfxR4B9TXYcSDOTn3cY0d+Be50zwZ+NhceDOR6vxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 6 May 2012 22:32:54 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sun, May 6, 2012 at 9:01 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Mon, 26 Mar 2012 13:21:30 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsglob.h | =C2=A0 =C2=A03 +++
> >> =C2=A0fs/cifs/connect.c =C2=A0| =C2=A0 16 +++++++++++++++-
> >> =C2=A02 files changed, 18 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 9e28070..fbee8ef 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -267,6 +267,9 @@ struct TCP_Server_Info {
> >> =C2=A0 =C2=A0 =C2=A0 char server_GUID[16];
> >> =C2=A0 =C2=A0 =C2=A0 char sec_mode;
> >> =C2=A0 =C2=A0 =C2=A0 bool session_estab; /* mark when very first s=
ess is established */
> >> +#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 bool is_smb2; =C2=A0 /* SMB2 not CIFS protocol neg=
otiated */
> >> +#endif
> >> =C2=A0 =C2=A0 =C2=A0 u16 dialect; /* dialect index that server cho=
se */
> >> =C2=A0 =C2=A0 =C2=A0 enum securityEnum secType;
> >> =C2=A0 =C2=A0 =C2=A0 bool oplocks:1; /* enable oplocks */
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 955f0a3..1fbc21f 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -1,7 +1,7 @@
> >> =C2=A0/*
> >> =C2=A0 * =C2=A0 fs/cifs/connect.c
> >> =C2=A0 *
> >> - * =C2=A0 Copyright (C) International Business Machines =C2=A0Cor=
p., 2002,2009
> >> + * =C2=A0 Copyright (C) International Business Machines =C2=A0Cor=
p., 2002,2011
> >> =C2=A0 * =C2=A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
> >> =C2=A0 *
> >> =C2=A0 * =C2=A0 This library is free software; you can redistribut=
e it and/or modify
> >> @@ -2093,6 +2093,14 @@ static int match_server(struct TCP_Server_I=
nfo *server, struct sockaddr *addr,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0(struct sockaddr *)&vol->srcaddr))
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >>
> >> +#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 if ((server->is_smb2 =3D=3D true) && (vol->use_smb=
2 =3D=3D false))
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> +
> >> + =C2=A0 =C2=A0 if ((server->is_smb2 =3D=3D false) && (vol->use_sm=
b2 =3D=3D true))
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> +#endif /* CONFIG_CIFS_SMB2 */
> >> +
> >
> > Again, booleans for this seem like a less than ideal solution. Bett=
er
> > to have this based on a version number or maybe a protocol version =
enum?
> >
> >> =C2=A0 =C2=A0 =C2=A0 if (!match_port(server, addr))
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >>
> >> @@ -2217,6 +2225,7 @@ cifs_get_tcp_session(struct smb_vol *volume_=
info)
> >>
> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->noblocksnd =3D volume_info->noblocks=
nd;
> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->noautotune =3D volume_info->noautotu=
ne;
> >> + =C2=A0 =C2=A0 /* BB should we set this unconditionally now, espe=
cially for SMB2 */
> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->tcp_nodelay =3D volume_info->sockopt=
_tcp_nodelay;
> >
> > Why is it more important to use TCP_NODELAY for SMB2? The above com=
ment
> > doesn't really say...
> >
> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->in_flight =3D 0;
> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->credits =3D 1;
> >> @@ -2261,6 +2270,11 @@ cifs_get_tcp_session(struct smb_vol *volume=
_info)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_err_cryp=
to_release;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> +#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 if (volume_info->use_smb2)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tcp_ses->is_smb2 =3D t=
rue;
> >> +#endif /* CONFIG_CIFS_SMB2 */
> >> +
> >
> > The above should instead set a pointer to a "struct
> > protocol_operations" or something. That struct could have a version
> > field within it and it would give you a mechanism to allow for
> > protocol-version specific behavior without resorting to sprinkling
> > "is_smb2" checks all over the code.
>=20
> On the tcp-nodelay question:
>=20
> I think it complicates things to give the user a choice now (it shoul=
d
> be faster to send with nodelay) - should probably be unconditional
> (less options for SMB2 is easier since we have a spec, and well
> behaved servers)
>=20

It is more complicated to give a choice, but why should we choose to
use TCP_NODELAY at all? Do we have any benchmarks or anything that show
that it really helps performance or makes any difference at all?

> On the "is_smb2" - mostly it just matters whether it is smb2 - but I
> have no problem with a sub-version within smb2, but lets limit this a=
s
> much as is reasonably possible now (most servers support cifs - so
> lets focus as narrowly as we can to accelerate development safely) I
> really don't want to worry about testing smb2.0 vs. 2.1 vs. 2.2 (aka3=
)
> - can't we simply offer smb2.1 and smb3 (if they need to talk to
> Windows Vista they can use cifs) and choose between smb2.1 and smb3
> via a sub-version field (remember these are MUCH easier in smb2 since
> they are just a number not a string).
>=20

My point on the "is_smb2" mechanism is that you're enshrining a boolean
decision into code that will need more subtle decision making later.

Eventually we want to support at least one flavor of smb2 as well as
smb3. At that point, your boolean checks above become a real mess.

Really, it just comes down to planning ahead for support for other
dialects. Since we're restructuring the code now, let's do it in such a
way that we can add support for later dialects with less hassle in the
future.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
