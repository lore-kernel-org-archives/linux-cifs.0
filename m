From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/16] CIFS: Check for SMB2 vs CIFS in find_tcp_session
Date: Mon, 7 May 2012 09:51:08 -0400
Message-ID: <20120507095108.5b8df49f@corrin.poochiereds.net>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
	<1332753703-4315-4-git-send-email-piastry@etersoft.ru>
	<20120506100129.0b2f626b@corrin.poochiereds.net>
	<CAH2r5mvX4pfxR4B9TXYcSDOTn3cY0d+Be50zwZ+NhceDOR6vxQ@mail.gmail.com>
	<20120507073636.1d10a9ae@corrin.poochiereds.net>
	<CAH2r5mt7hxvaCzaUU0n96p9SVQ6Sso5p6JaYg0gwm6QA0SgHeg@mail.gmail.com>
	<20120507093233.04d13b0d@corrin.poochiereds.net>
	<CAH2r5msg8C8WMk_+4WYss_109EWec8v2R=vcH4BGmsGtb2tUQw@mail.gmail.com>
	<CAH2r5msOqC=jgX7m6GfKs_S7oMaxzC5rh+0_-ZGLYrVOJri=Vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msOqC=jgX7m6GfKs_S7oMaxzC5rh+0_-ZGLYrVOJri=Vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 7 May 2012 08:36:13 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> NODELAY is often set on NFS, FTP and Samba.
>=20

I don't see where the Linux NFS client sets TCP_NODELAY. I've also
never noticed the client delaying small requests, but I haven't really
looked for it either...
=20
You may be correct here and it is beneficial, but I think we ought to
have some way to measure that gain and the impact on the overall
bandwidth utilization. After all, you don't get any speedup from this
"for free". It costs you in overall network utilization. That cost may
be marginal, but it won't be zero.

> On Mon, May 7, 2012 at 8:34 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> > It is going to be a small effect normally but should be measurable =
-
> > for all smb requests
> > but write we issue them as one tcp send, and in all cases except wr=
ite they
> > are small so can get delayed.
> >


> > I remember asking Linux networking guys many years ago and they sai=
d
> > we should be setting it (unless something strange changed not sure
> > why the logic for all but writes would be different on no delay).
> >
> > On Mon, May 7, 2012 at 8:32 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> >> On Mon, 7 May 2012 07:52:03 -0500
> >> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >>> On Mon, May 7, 2012 at 6:36 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> >>> > On Sun, 6 May 2012 22:32:54 -0500
> >>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>> >
> >>> >> On Sun, May 6, 2012 at 9:01 AM, Jeff Layton <jlayton-H+wXaHxf7aJhl2p70BpVqQ@public.gmane.org=
m> wrote:
> >>> >> > On Mon, 26 Mar 2012 13:21:30 +0400
> >>> >> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >>> >> >
> >>> >> >> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >>> >> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >>> >> >> ---
> >>> >> >> =C2=A0fs/cifs/cifsglob.h | =C2=A0 =C2=A03 +++
> >>> >> >> =C2=A0fs/cifs/connect.c =C2=A0| =C2=A0 16 +++++++++++++++-
> >>> >> >> =C2=A02 files changed, 18 insertions(+), 1 deletions(-)
> >>> >> >>
> >>> >> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >>> >> >> index 9e28070..fbee8ef 100644
> >>> >> >> --- a/fs/cifs/cifsglob.h
> >>> >> >> +++ b/fs/cifs/cifsglob.h
> >>> >> >> @@ -267,6 +267,9 @@ struct TCP_Server_Info {
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 char server_GUID[16];
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 char sec_mode;
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 bool session_estab; /* mark when very =
first sess is established */
> >>> >> >> +#ifdef CONFIG_CIFS_SMB2
> >>> >> >> + =C2=A0 =C2=A0 bool is_smb2; =C2=A0 /* SMB2 not CIFS proto=
col negotiated */
> >>> >> >> +#endif
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 u16 dialect; /* dialect index that ser=
ver chose */
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 enum securityEnum secType;
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 bool oplocks:1; /* enable oplocks */
> >>> >> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >>> >> >> index 955f0a3..1fbc21f 100644
> >>> >> >> --- a/fs/cifs/connect.c
> >>> >> >> +++ b/fs/cifs/connect.c
> >>> >> >> @@ -1,7 +1,7 @@
> >>> >> >> =C2=A0/*
> >>> >> >> =C2=A0 * =C2=A0 fs/cifs/connect.c
> >>> >> >> =C2=A0 *
> >>> >> >> - * =C2=A0 Copyright (C) International Business Machines =C2=
=A0Corp., 2002,2009
> >>> >> >> + * =C2=A0 Copyright (C) International Business Machines =C2=
=A0Corp., 2002,2011
> >>> >> >> =C2=A0 * =C2=A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org=
)
> >>> >> >> =C2=A0 *
> >>> >> >> =C2=A0 * =C2=A0 This library is free software; you can redi=
stribute it and/or modify
> >>> >> >> @@ -2093,6 +2093,14 @@ static int match_server(struct TCP_S=
erver_Info *server, struct sockaddr *addr,
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(struct sockaddr *)&vol->srcaddr))
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >>> >> >>
> >>> >> >> +#ifdef CONFIG_CIFS_SMB2
> >>> >> >> + =C2=A0 =C2=A0 if ((server->is_smb2 =3D=3D true) && (vol->=
use_smb2 =3D=3D false))
> >>> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >>> >> >> +
> >>> >> >> + =C2=A0 =C2=A0 if ((server->is_smb2 =3D=3D false) && (vol-=
>use_smb2 =3D=3D true))
> >>> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >>> >> >> +#endif /* CONFIG_CIFS_SMB2 */
> >>> >> >> +
> >>> >> >
> >>> >> > Again, booleans for this seem like a less than ideal solutio=
n. Better
> >>> >> > to have this based on a version number or maybe a protocol v=
ersion enum?
> >>> >> >
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 if (!match_port(server, addr))
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >>> >> >>
> >>> >> >> @@ -2217,6 +2225,7 @@ cifs_get_tcp_session(struct smb_vol *=
volume_info)
> >>> >> >>
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->noblocksnd =3D volume_info->n=
oblocksnd;
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->noautotune =3D volume_info->n=
oautotune;
> >>> >> >> + =C2=A0 =C2=A0 /* BB should we set this unconditionally no=
w, especially for SMB2 */
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->tcp_nodelay =3D volume_info->=
sockopt_tcp_nodelay;
> >>> >> >
> >>> >> > Why is it more important to use TCP_NODELAY for SMB2? The ab=
ove comment
> >>> >> > doesn't really say...
> >>> >> >
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->in_flight =3D 0;
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 tcp_ses->credits =3D 1;
> >>> >> >> @@ -2261,6 +2270,11 @@ cifs_get_tcp_session(struct smb_vol =
*volume_info)
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_e=
rr_crypto_release;
> >>> >> >> =C2=A0 =C2=A0 =C2=A0 }
> >>> >> >>
> >>> >> >> +#ifdef CONFIG_CIFS_SMB2
> >>> >> >> + =C2=A0 =C2=A0 if (volume_info->use_smb2)
> >>> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tcp_ses->is_smb=
2 =3D true;
> >>> >> >> +#endif /* CONFIG_CIFS_SMB2 */
> >>> >> >> +
> >>> >> >
> >>> >> > The above should instead set a pointer to a "struct
> >>> >> > protocol_operations" or something. That struct could have a =
version
> >>> >> > field within it and it would give you a mechanism to allow f=
or
> >>> >> > protocol-version specific behavior without resorting to spri=
nkling
> >>> >> > "is_smb2" checks all over the code.
> >>> >>
> >>> >> On the tcp-nodelay question:
> >>> >>
> >>> >> I think it complicates things to give the user a choice now (i=
t should
> >>> >> be faster to send with nodelay) - should probably be unconditi=
onal
> >>> >> (less options for SMB2 is easier since we have a spec, and wel=
l
> >>> >> behaved servers)
> >>> >>
> >>> >
> >>> > It is more complicated to give a choice, but why should we choo=
se to
> >>> > use TCP_NODELAY at all? Do we have any benchmarks or anything t=
hat show
> >>> > that it really helps performance or makes any difference at all=
?
> >>>
> >>> We did have benchmarks that showed it was faster (it got requests
> >>> on the wire faster) but that was years ago. =C2=A0Generally for r=
equest/response
> >>> protocols why wouldn't you always set TCP_NODELAY?
> >>
> >> Because it's less efficient to send a request in two frames than o=
ne?
> >> You're basically trading extra bandwidth for lowered latency. That=
's
> >> not necessarily a win...
> >>
> >> Consider a write request, for instance. If we have to do it in sma=
ll
> >> pieces we could end up sending more TCP frames than necessary whic=
h
> >> have their own overhead. The data may get to the server faster in =
some
> >> cases, but until the whole request is there it can't really do any=
thing
> >> with it anyway. You're better off having waited until it was all
> >> buffered up.
> >>
> >> I don't know one way or the other whether using TCP_NODELAY is fas=
ter
> >> on some workloads. Before we make any assumptions however, we ough=
t to
> >> come up with a way to test that theory, and to assess its impact o=
n
> >> bandwidth utilization.
> >>
> >> --
> >> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
