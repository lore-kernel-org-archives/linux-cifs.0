From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/16] CIFS: Check for SMB2 vs CIFS in find_tcp_session
Date: Mon, 7 May 2012 09:32:33 -0400
Message-ID: <20120507093233.04d13b0d@corrin.poochiereds.net>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
	<1332753703-4315-4-git-send-email-piastry@etersoft.ru>
	<20120506100129.0b2f626b@corrin.poochiereds.net>
	<CAH2r5mvX4pfxR4B9TXYcSDOTn3cY0d+Be50zwZ+NhceDOR6vxQ@mail.gmail.com>
	<20120507073636.1d10a9ae@corrin.poochiereds.net>
	<CAH2r5mt7hxvaCzaUU0n96p9SVQ6Sso5p6JaYg0gwm6QA0SgHeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt7hxvaCzaUU0n96p9SVQ6Sso5p6JaYg0gwm6QA0SgHeg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 7 May 2012 07:52:03 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, May 7, 2012 at 6:36 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Sun, 6 May 2012 22:32:54 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Sun, May 6, 2012 at 9:01 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
> >> > On Mon, 26 Mar 2012 13:21:30 +0400
> >> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >> >
> >> >> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> >> ---
> >> >> =C2=A0fs/cifs/cifsglob.h | =C2=A0 =C2=A03 +++
> >> >> =C2=A0fs/cifs/connect.c =C2=A0| =C2=A0 16 +++++++++++++++-
> >> >> =C2=A02 files changed, 18 insertions(+), 1 deletions(-)
> >> >>
> >> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> >> index 9e28070..fbee8ef 100644
> >> >> --- a/fs/cifs/cifsglob.h
> >> >> +++ b/fs/cifs/cifsglob.h
> >> >> @@ -267,6 +267,9 @@ struct TCP_Server_Info {
> >> >> =C2=A0 =C2=A0 =C2=A0 char server_GUID[16];
> >> >> =C2=A0 =C2=A0 =C2=A0 char sec_mode;
> >> >> =C2=A0 =C2=A0 =C2=A0 bool session_estab; /* mark when very firs=
t sess is established */
> >> >> +#ifdef CONFIG_CIFS_SMB2
> >> >> + =C2=A0 =C2=A0 bool is_smb2; =C2=A0 /* SMB2 not CIFS protocol =
negotiated */
> >> >> +#endif
> >> >> =C2=A0 =C2=A0 =C2=A0 u16 dialect; /* dialect index that server =
chose */
> >> >> =C2=A0 =C2=A0 =C2=A0 enum securityEnum secType;
> >> >> =C2=A0 =C2=A0 =C2=A0 bool oplocks:1; /* enable oplocks */
> >> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> >> index 955f0a3..1fbc21f 100644
> >> >> --- a/fs/cifs/connect.c
> >> >> +++ b/fs/cifs/connect.c
> >> >> @@ -1,7 +1,7 @@
> >> >> =C2=A0/*
> >> >> =C2=A0 * =C2=A0 fs/cifs/connect.c
> >> >> =C2=A0 *
> >> >> - * =C2=A0 Copyright (C) International Business Machines =C2=A0=
Corp., 2002,2009
> >> >> + * =C2=A0 Copyright (C) International Business Machines =C2=A0=
Corp., 2002,2011
> >> >> =C2=A0 * =C2=A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
> >> >> =C2=A0 *
> >> >> =C2=A0 * =C2=A0 This library is free software; you can redistri=
bute it and/or modify
> >> >> @@ -2093,6 +2093,14 @@ static int match_server(struct TCP_Serve=
r_Info *server, struct sockaddr *addr,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0(struct sockaddr *)&vol->srcaddr))
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> >>
> >> >> +#ifdef CONFIG_CIFS_SMB2
> >> >> + =C2=A0 =C2=A0 if ((server->is_smb2 =3D=3D true) && (vol->use_=
smb2 =3D=3D false))
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> >> +
> >> >> + =C2=A0 =C2=A0 if ((server->is_smb2 =3D=3D false) && (vol->use=
_smb2 =3D=3D true))
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> >> +#endif /* CONFIG_CIFS_SMB2 */
> >> >> +
> >> >
> >> > Again, booleans for this seem like a less than ideal solution. B=
etter
> >> > to have this based on a version number or maybe a protocol versi=
on enum?
> >> >
> >> >> =C2=A0 =C2=A0 =C2=A0 if (!match_port(server, addr))
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> >>
> >> >> @@ -2217,6 +2225,7 @@ cifs_get_tcp_session(struct smb_vol *volu=
me_info)
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->noblocksnd =3D volume_info->noblo=
cksnd;
> >> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->noautotune =3D volume_info->noaut=
otune;
> >> >> + =C2=A0 =C2=A0 /* BB should we set this unconditionally now, e=
specially for SMB2 */
> >> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->tcp_nodelay =3D volume_info->sock=
opt_tcp_nodelay;
> >> >
> >> > Why is it more important to use TCP_NODELAY for SMB2? The above =
comment
> >> > doesn't really say...
> >> >
> >> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->in_flight =3D 0;
> >> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->credits =3D 1;
> >> >> @@ -2261,6 +2270,11 @@ cifs_get_tcp_session(struct smb_vol *vol=
ume_info)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_err_c=
rypto_release;
> >> >> =C2=A0 =C2=A0 =C2=A0 }
> >> >>
> >> >> +#ifdef CONFIG_CIFS_SMB2
> >> >> + =C2=A0 =C2=A0 if (volume_info->use_smb2)
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tcp_ses->is_smb2 =3D=
 true;
> >> >> +#endif /* CONFIG_CIFS_SMB2 */
> >> >> +
> >> >
> >> > The above should instead set a pointer to a "struct
> >> > protocol_operations" or something. That struct could have a vers=
ion
> >> > field within it and it would give you a mechanism to allow for
> >> > protocol-version specific behavior without resorting to sprinkli=
ng
> >> > "is_smb2" checks all over the code.
> >>
> >> On the tcp-nodelay question:
> >>
> >> I think it complicates things to give the user a choice now (it sh=
ould
> >> be faster to send with nodelay) - should probably be unconditional
> >> (less options for SMB2 is easier since we have a spec, and well
> >> behaved servers)
> >>
> >
> > It is more complicated to give a choice, but why should we choose t=
o
> > use TCP_NODELAY at all? Do we have any benchmarks or anything that =
show
> > that it really helps performance or makes any difference at all?
>=20
> We did have benchmarks that showed it was faster (it got requests
> on the wire faster) but that was years ago.  Generally for request/re=
sponse
> protocols why wouldn't you always set TCP_NODELAY?

Because it's less efficient to send a request in two frames than one?
You're basically trading extra bandwidth for lowered latency. That's
not necessarily a win...

Consider a write request, for instance. If we have to do it in small
pieces we could end up sending more TCP frames than necessary which
have their own overhead. The data may get to the server faster in some
cases, but until the whole request is there it can't really do anything
with it anyway. You're better off having waited until it was all
buffered up.

I don't know one way or the other whether using TCP_NODELAY is faster
on some workloads. Before we make any assumptions however, we ought to
come up with a way to test that theory, and to assess its impact on
bandwidth utilization.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
