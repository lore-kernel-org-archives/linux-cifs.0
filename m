From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/16] CIFS: Check for SMB2 vs CIFS in find_tcp_session
Date: Mon, 7 May 2012 07:52:03 -0500
Message-ID: <CAH2r5mt7hxvaCzaUU0n96p9SVQ6Sso5p6JaYg0gwm6QA0SgHeg@mail.gmail.com>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
	<1332753703-4315-4-git-send-email-piastry@etersoft.ru>
	<20120506100129.0b2f626b@corrin.poochiereds.net>
	<CAH2r5mvX4pfxR4B9TXYcSDOTn3cY0d+Be50zwZ+NhceDOR6vxQ@mail.gmail.com>
	<20120507073636.1d10a9ae@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120507073636.1d10a9ae-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, May 7, 2012 at 6:36 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Sun, 6 May 2012 22:32:54 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Sun, May 6, 2012 at 9:01 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> > On Mon, 26 Mar 2012 13:21:30 +0400
>> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> >
>> >> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> >> ---
>> >> =A0fs/cifs/cifsglob.h | =A0 =A03 +++
>> >> =A0fs/cifs/connect.c =A0| =A0 16 +++++++++++++++-
>> >> =A02 files changed, 18 insertions(+), 1 deletions(-)
>> >>
>> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> >> index 9e28070..fbee8ef 100644
>> >> --- a/fs/cifs/cifsglob.h
>> >> +++ b/fs/cifs/cifsglob.h
>> >> @@ -267,6 +267,9 @@ struct TCP_Server_Info {
>> >> =A0 =A0 =A0 char server_GUID[16];
>> >> =A0 =A0 =A0 char sec_mode;
>> >> =A0 =A0 =A0 bool session_estab; /* mark when very first sess is e=
stablished */
>> >> +#ifdef CONFIG_CIFS_SMB2
>> >> + =A0 =A0 bool is_smb2; =A0 /* SMB2 not CIFS protocol negotiated =
*/
>> >> +#endif
>> >> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
>> >> =A0 =A0 =A0 enum securityEnum secType;
>> >> =A0 =A0 =A0 bool oplocks:1; /* enable oplocks */
>> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> >> index 955f0a3..1fbc21f 100644
>> >> --- a/fs/cifs/connect.c
>> >> +++ b/fs/cifs/connect.c
>> >> @@ -1,7 +1,7 @@
>> >> =A0/*
>> >> =A0 * =A0 fs/cifs/connect.c
>> >> =A0 *
>> >> - * =A0 Copyright (C) International Business Machines =A0Corp., 2=
002,2009
>> >> + * =A0 Copyright (C) International Business Machines =A0Corp., 2=
002,2011
>> >> =A0 * =A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
>> >> =A0 *
>> >> =A0 * =A0 This library is free software; you can redistribute it =
and/or modify
>> >> @@ -2093,6 +2093,14 @@ static int match_server(struct TCP_Server_=
Info *server, struct sockaddr *addr,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct sockad=
dr *)&vol->srcaddr))
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> >>
>> >> +#ifdef CONFIG_CIFS_SMB2
>> >> + =A0 =A0 if ((server->is_smb2 =3D=3D true) && (vol->use_smb2 =3D=
=3D false))
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> >> +
>> >> + =A0 =A0 if ((server->is_smb2 =3D=3D false) && (vol->use_smb2 =3D=
=3D true))
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> >> +#endif /* CONFIG_CIFS_SMB2 */
>> >> +
>> >
>> > Again, booleans for this seem like a less than ideal solution. Bet=
ter
>> > to have this based on a version number or maybe a protocol version=
 enum?
>> >
>> >> =A0 =A0 =A0 if (!match_port(server, addr))
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> >>
>> >> @@ -2217,6 +2225,7 @@ cifs_get_tcp_session(struct smb_vol *volume=
_info)
>> >>
>> >> =A0 =A0 =A0 tcp_ses->noblocksnd =3D volume_info->noblocksnd;
>> >> =A0 =A0 =A0 tcp_ses->noautotune =3D volume_info->noautotune;
>> >> + =A0 =A0 /* BB should we set this unconditionally now, especiall=
y for SMB2 */
>> >> =A0 =A0 =A0 tcp_ses->tcp_nodelay =3D volume_info->sockopt_tcp_nod=
elay;
>> >
>> > Why is it more important to use TCP_NODELAY for SMB2? The above co=
mment
>> > doesn't really say...
>> >
>> >> =A0 =A0 =A0 tcp_ses->in_flight =3D 0;
>> >> =A0 =A0 =A0 tcp_ses->credits =3D 1;
>> >> @@ -2261,6 +2270,11 @@ cifs_get_tcp_session(struct smb_vol *volum=
e_info)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err_crypto_release;
>> >> =A0 =A0 =A0 }
>> >>
>> >> +#ifdef CONFIG_CIFS_SMB2
>> >> + =A0 =A0 if (volume_info->use_smb2)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 tcp_ses->is_smb2 =3D true;
>> >> +#endif /* CONFIG_CIFS_SMB2 */
>> >> +
>> >
>> > The above should instead set a pointer to a "struct
>> > protocol_operations" or something. That struct could have a versio=
n
>> > field within it and it would give you a mechanism to allow for
>> > protocol-version specific behavior without resorting to sprinkling
>> > "is_smb2" checks all over the code.
>>
>> On the tcp-nodelay question:
>>
>> I think it complicates things to give the user a choice now (it shou=
ld
>> be faster to send with nodelay) - should probably be unconditional
>> (less options for SMB2 is easier since we have a spec, and well
>> behaved servers)
>>
>
> It is more complicated to give a choice, but why should we choose to
> use TCP_NODELAY at all? Do we have any benchmarks or anything that sh=
ow
> that it really helps performance or makes any difference at all?

We did have benchmarks that showed it was faster (it got requests
on the wire faster) but that was years ago.  Generally for request/resp=
onse
protocols why wouldn't you always set TCP_NODELAY?
--=20
Thanks,

Steve
