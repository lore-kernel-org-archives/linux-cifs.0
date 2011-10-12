From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: review of patch "cifs: untangle server->maxBuf and
 CIFSMaxBufSize"
Date: Wed, 12 Oct 2011 15:22:43 -0400
Message-ID: <20111012152243.42356adb@tlielax.poochiereds.net>
References: <CAH2r5mug5PmrbhmAazv62xQGgFmH8TjZEL84WOnbvO59hccPwQ@mail.gmail.com>
	<20111012132510.68c3d986@tlielax.poochiereds.net>
	<CAH2r5mvG_NTvnjAhxZWMnkBbpMXqLoJaBWiyqnA5DOdABCTmkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvG_NTvnjAhxZWMnkBbpMXqLoJaBWiyqnA5DOdABCTmkw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 12 Oct 2011 14:06:13 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Oct 12, 2011 at 12:25 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > On Wed, 12 Oct 2011 12:15:29 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Reviewing changes to fs/cifs/connect.c in
> >> http://git.samba.org/?p=3Djlayton/linux.git;a=3Dcommit;h=3Db82a255=
01cb18b86fd247da15c886762fdc5404c
> >>
> >> It looks like the following logic changes from setting rsize to wh=
at
> >> the server claims it can support (negotiated maxBuf) to what our
> >> maximum buffer size is:
> >>
> >> @@ -3130,8 +3130,7 @@ try_mount_again:
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(DBG2,=
 "no very large read support, rsize now 127K");
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(tcon->ses->capabilities & CAP_LA=
RGE_READ_X))
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =
=3D min(cifs_sb->rsize,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(tcon->ses->server->maxBuf - MAX_=
CIFS_HDR_SIZE));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =
=3D min(cifs_sb->rsize, CIFSMaxBufSize);
> >>
> >>
> >> Is that what we want?
> >>
> >
> > I think so, yes. That's part of untangling the mess.
> >
> > According to the protocol docs, the server should only be bound by =
the
> > client's MaxBufSize for reads. Therefore, the maxBuf advertised by =
the
> > server should have no bearing on the rsize.
>=20
> That may be true, but the following phrase in the description of
> SMB Read (not ReadX) worried me:
>=20
> "If a read requests more data than can be placed in a message of
> MaxBufferSize for the SMB
> connection, the server MUST abort the connection to the client."
>=20

I don't think that cifs.ko ever does old-school SMB Read calls, does
it? We don't seem to even have the command defined in cifspdu.h...

Regardless, that code will go away once you get to this patch:

    cifs: allow for larger rsize=3D options and change defaults

I wouldn't sweat it too much.
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
