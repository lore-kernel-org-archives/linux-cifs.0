From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/16] CIFS: Check for SMB2 vs CIFS in find_tcp_session
Date: Mon, 7 May 2012 08:36:13 -0500
Message-ID: <CAH2r5msOqC=jgX7m6GfKs_S7oMaxzC5rh+0_-ZGLYrVOJri=Vg@mail.gmail.com>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
	<1332753703-4315-4-git-send-email-piastry@etersoft.ru>
	<20120506100129.0b2f626b@corrin.poochiereds.net>
	<CAH2r5mvX4pfxR4B9TXYcSDOTn3cY0d+Be50zwZ+NhceDOR6vxQ@mail.gmail.com>
	<20120507073636.1d10a9ae@corrin.poochiereds.net>
	<CAH2r5mt7hxvaCzaUU0n96p9SVQ6Sso5p6JaYg0gwm6QA0SgHeg@mail.gmail.com>
	<20120507093233.04d13b0d@corrin.poochiereds.net>
	<CAH2r5msg8C8WMk_+4WYss_109EWec8v2R=vcH4BGmsGtb2tUQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msg8C8WMk_+4WYss_109EWec8v2R=vcH4BGmsGtb2tUQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

NODELAY is often set on NFS, FTP and Samba.

On Mon, May 7, 2012 at 8:34 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> It is going to be a small effect normally but should be measurable -
> for all smb requests
> but write we issue them as one tcp send, and in all cases except writ=
e they
> are small so can get delayed.
>
> I remember asking Linux networking guys many years ago and they said
> we should be setting it (unless something strange changed not sure
> why the logic for all but writes would be different on no delay).
>
> On Mon, May 7, 2012 at 8:32 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> On Mon, 7 May 2012 07:52:03 -0500
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> On Mon, May 7, 2012 at 6:36 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>>> > On Sun, 6 May 2012 22:32:54 -0500
>>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> >
>>> >> On Sun, May 6, 2012 at 9:01 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote:
>>> >> > On Mon, 26 Mar 2012 13:21:30 +0400
>>> >> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>> >> >
>>> >> >> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>>> >> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>> >> >> ---
>>> >> >> =A0fs/cifs/cifsglob.h | =A0 =A03 +++
>>> >> >> =A0fs/cifs/connect.c =A0| =A0 16 +++++++++++++++-
>>> >> >> =A02 files changed, 18 insertions(+), 1 deletions(-)
>>> >> >>
>>> >> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>>> >> >> index 9e28070..fbee8ef 100644
>>> >> >> --- a/fs/cifs/cifsglob.h
>>> >> >> +++ b/fs/cifs/cifsglob.h
>>> >> >> @@ -267,6 +267,9 @@ struct TCP_Server_Info {
>>> >> >> =A0 =A0 =A0 char server_GUID[16];
>>> >> >> =A0 =A0 =A0 char sec_mode;
>>> >> >> =A0 =A0 =A0 bool session_estab; /* mark when very first sess =
is established */
>>> >> >> +#ifdef CONFIG_CIFS_SMB2
>>> >> >> + =A0 =A0 bool is_smb2; =A0 /* SMB2 not CIFS protocol negotia=
ted */
>>> >> >> +#endif
>>> >> >> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose *=
/
>>> >> >> =A0 =A0 =A0 enum securityEnum secType;
>>> >> >> =A0 =A0 =A0 bool oplocks:1; /* enable oplocks */
>>> >> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>> >> >> index 955f0a3..1fbc21f 100644
>>> >> >> --- a/fs/cifs/connect.c
>>> >> >> +++ b/fs/cifs/connect.c
>>> >> >> @@ -1,7 +1,7 @@
>>> >> >> =A0/*
>>> >> >> =A0 * =A0 fs/cifs/connect.c
>>> >> >> =A0 *
>>> >> >> - * =A0 Copyright (C) International Business Machines =A0Corp=
=2E, 2002,2009
>>> >> >> + * =A0 Copyright (C) International Business Machines =A0Corp=
=2E, 2002,2011
>>> >> >> =A0 * =A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
>>> >> >> =A0 *
>>> >> >> =A0 * =A0 This library is free software; you can redistribute=
 it and/or modify
>>> >> >> @@ -2093,6 +2093,14 @@ static int match_server(struct TCP_Ser=
ver_Info *server, struct sockaddr *addr,
>>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct so=
ckaddr *)&vol->srcaddr))
>>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>> >> >>
>>> >> >> +#ifdef CONFIG_CIFS_SMB2
>>> >> >> + =A0 =A0 if ((server->is_smb2 =3D=3D true) && (vol->use_smb2=
 =3D=3D false))
>>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>> >> >> +
>>> >> >> + =A0 =A0 if ((server->is_smb2 =3D=3D false) && (vol->use_smb=
2 =3D=3D true))
>>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>> >> >> +#endif /* CONFIG_CIFS_SMB2 */
>>> >> >> +
>>> >> >
>>> >> > Again, booleans for this seem like a less than ideal solution.=
 Better
>>> >> > to have this based on a version number or maybe a protocol ver=
sion enum?
>>> >> >
>>> >> >> =A0 =A0 =A0 if (!match_port(server, addr))
>>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>> >> >>
>>> >> >> @@ -2217,6 +2225,7 @@ cifs_get_tcp_session(struct smb_vol *vo=
lume_info)
>>> >> >>
>>> >> >> =A0 =A0 =A0 tcp_ses->noblocksnd =3D volume_info->noblocksnd;
>>> >> >> =A0 =A0 =A0 tcp_ses->noautotune =3D volume_info->noautotune;
>>> >> >> + =A0 =A0 /* BB should we set this unconditionally now, espec=
ially for SMB2 */
>>> >> >> =A0 =A0 =A0 tcp_ses->tcp_nodelay =3D volume_info->sockopt_tcp=
_nodelay;
>>> >> >
>>> >> > Why is it more important to use TCP_NODELAY for SMB2? The abov=
e comment
>>> >> > doesn't really say...
>>> >> >
>>> >> >> =A0 =A0 =A0 tcp_ses->in_flight =3D 0;
>>> >> >> =A0 =A0 =A0 tcp_ses->credits =3D 1;
>>> >> >> @@ -2261,6 +2270,11 @@ cifs_get_tcp_session(struct smb_vol *v=
olume_info)
>>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err_crypto_release;
>>> >> >> =A0 =A0 =A0 }
>>> >> >>
>>> >> >> +#ifdef CONFIG_CIFS_SMB2
>>> >> >> + =A0 =A0 if (volume_info->use_smb2)
>>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 tcp_ses->is_smb2 =3D true;
>>> >> >> +#endif /* CONFIG_CIFS_SMB2 */
>>> >> >> +
>>> >> >
>>> >> > The above should instead set a pointer to a "struct
>>> >> > protocol_operations" or something. That struct could have a ve=
rsion
>>> >> > field within it and it would give you a mechanism to allow for
>>> >> > protocol-version specific behavior without resorting to sprink=
ling
>>> >> > "is_smb2" checks all over the code.
>>> >>
>>> >> On the tcp-nodelay question:
>>> >>
>>> >> I think it complicates things to give the user a choice now (it =
should
>>> >> be faster to send with nodelay) - should probably be uncondition=
al
>>> >> (less options for SMB2 is easier since we have a spec, and well
>>> >> behaved servers)
>>> >>
>>> >
>>> > It is more complicated to give a choice, but why should we choose=
 to
>>> > use TCP_NODELAY at all? Do we have any benchmarks or anything tha=
t show
>>> > that it really helps performance or makes any difference at all?
>>>
>>> We did have benchmarks that showed it was faster (it got requests
>>> on the wire faster) but that was years ago. =A0Generally for reques=
t/response
>>> protocols why wouldn't you always set TCP_NODELAY?
>>
>> Because it's less efficient to send a request in two frames than one=
?
>> You're basically trading extra bandwidth for lowered latency. That's
>> not necessarily a win...
>>
>> Consider a write request, for instance. If we have to do it in small
>> pieces we could end up sending more TCP frames than necessary which
>> have their own overhead. The data may get to the server faster in so=
me
>> cases, but until the whole request is there it can't really do anyth=
ing
>> with it anyway. You're better off having waited until it was all
>> buffered up.
>>
>> I don't know one way or the other whether using TCP_NODELAY is faste=
r
>> on some workloads. Before we make any assumptions however, we ought =
to
>> come up with a way to test that theory, and to assess its impact on
>> bandwidth utilization.
>>
>> --
>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
