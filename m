From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] CIFS: Invalidate inode pages on the last close
Date: Tue, 26 Oct 2010 10:52:33 -0400
Message-ID: <20101026105233.3205feeb@tlielax.poochiereds.net>
References: <AANLkTimEwyZkxat-yq8pg3-MCVsnURowe-di2D2YBZhR@mail.gmail.com>
	<20101026102518.5d6bea89@tlielax.poochiereds.net>
	<AANLkTimSEvz71LXn2uBFq2m-LVCE03W6mZqPbcc9AOJ-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimSEvz71LXn2uBFq2m-LVCE03W6mZqPbcc9AOJ--JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 26 Oct 2010 09:46:34 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Oct 26, 2010 at 9:25 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Tue, 26 Oct 2010 17:01:26 +0400
> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> When we close the last file handle of the inode we should invalida=
te it
> >> to prevent data coherency problem when we open it again but it has=
 been
> >> modified by other clients.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/file.c | =A0 14 ++++++++++++--
> >> =A01 files changed, 12 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index d7c212a..02a045e 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -150,8 +150,14 @@ client_can_cache:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D true=
;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D tru=
e;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Exclusive Oplock granted on i=
node %p", inode);
> >> - =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ)
> >> + =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D tru=
e;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Level II Oplock franted on inod=
e %p", inode);
> >> + =A0 =A0 } else {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D false=
;
> >> + =A0 =A0 }
> >>
> >
> > The oplock handling in cifs is rather ad-hoc. There's a lot of
> > cut-and-pasted code that sets that clientCanCache flags. The flags
> > themselves are also sort of hard to understand -- i.e. why is is "A=
ll"
> > and not "Write"?
> >
> > This would be good opportunity to consolidate that code into helper
> > functions and just call them from the appropriate places.
> >
> > Perhaps a helper function that takes an oplock value and sets the
> > clientCanCache flags appropriately? Or...maybe consider doing away =
with
> > the canCache flags and just store the oplock value in the inode and
> > have helper macros or something that read that value and tell you w=
hat
> > can be done with it.
> >
> > =A0 i.e.: CLIENT_CAN_CACHE_READ(inode), CLIENT_CAN_CACHE_WRITE(inod=
e)
>=20
> Remember that the reason we don't have a can_cache_write is that ther=
e
> is no equivalent smb/cifs protocol concept as "can_cache_write"
> independent of caching reads - there are basically three types:
> 1) batch oplocks (read/write and open/close caching) which we don't
> use (although will in smb2)
> 2) read/write
> 3) read
>=20

I understand that, but from a coding standpoint I don't care. All I
care about is: "What can I do with the cached data attached to this
inode right now?"

That's why I think it might be saner to get rid of the bools
and keep the oplock flag in the inode and have macros that tell me what
I can actually do with it.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
