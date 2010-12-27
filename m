From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/6] CIFS: Implement cifs_strict_writev (try #3)
Date: Mon, 27 Dec 2010 11:35:56 -0500
Message-ID: <20101227113556.56f1b3e8@tlielax.poochiereds.net>
References: <1293357858-10006-1-git-send-email-piastryyy@gmail.com>
	<1293357858-10006-2-git-send-email-piastryyy@gmail.com>
	<20101227110538.48b150c7@tlielax.poochiereds.net>
	<AANLkTi=+Nw+Spp6pmDJbqn5sBt0TKp8g=wr2BTHHdSYu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=+Nw+Spp6pmDJbqn5sBt0TKp8g=wr2BTHHdSYu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 27 Dec 2010 19:20:05 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/12/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Sun, 26 Dec 2010 13:04:18 +0300
> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> If we don't have Exclusive oplock we write a data to the server.
> >> Also set invalidate_mapping flag on the inode if we wrote somethin=
g
> >> to the server. Add cifs_iovec_write to let the client write iovec
> >> buffers through CIFSSMBWrite2.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 15 +++-
> >> =A0fs/cifs/cifsfs.h =A0 =A0| =A0 =A06 ++-
> >> =A0fs/cifs/cifsproto.h | =A0 =A02 +
> >> =A0fs/cifs/file.c =A0 =A0 =A0| =A0193 ++++++++++++++++++++++++++++=
++++++++++++++++++++++-
> >> =A04 files changed, 210 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> index 0d6b005..76ba04e 100644

[...]

> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 do {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid=
, pTcon, open_file->netfid,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0cur_len, *poffset, &written,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0to_send, npages, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 } while (rc =3D=3D -EAGAIN);
> >> +
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^
> > I think the above loop needs to be able to reclaim the filehandle i=
f
> > there was a reconnect event.
>=20
> May I should add both checks: file->private_data =3D=3D NULL and
> open_file->invalidHandle like we have them here
> -http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/fs/cifs/file.c#L963 =
?
>=20

A private_data of NULL on an open file is now a bug. Directories can
currently have a NULL private_data, but that shouldn't be a problem
here. I'd just check for invalidHandle. CIFS also has a ton of unneeded
NULL pointer checks so it's not always worthwhile to use existing code
as a guideline.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
