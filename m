From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] CIFS: Invalidate inode pages on the last close
Date: Tue, 26 Oct 2010 10:09:24 -0500
Message-ID: <AANLkTi=gt5U7ezhF0-QJpUj-qcq8pK1-z9iVWdf=uDQD@mail.gmail.com>
References: <AANLkTimEwyZkxat-yq8pg3-MCVsnURowe-di2D2YBZhR@mail.gmail.com>
	<20101026102518.5d6bea89@tlielax.poochiereds.net>
	<AANLkTimSEvz71LXn2uBFq2m-LVCE03W6mZqPbcc9AOJ-@mail.gmail.com>
	<20101026105233.3205feeb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101026105233.3205feeb-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 26, 2010 at 9:52 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 26 Oct 2010 09:46:34 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Oct 26, 2010 at 9:25 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > On Tue, 26 Oct 2010 17:01:26 +0400
>> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> When we close the last file handle of the inode we should invalid=
ate it
>> >> to prevent data coherency problem when we open it again but it ha=
s been
>> >> modified by other clients.
>> >>
>> >> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> ---
>> >> =A0fs/cifs/file.c | =A0 14 ++++++++++++--
>> >> =A01 files changed, 12 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> >> index d7c212a..02a045e 100644
>> >> --- a/fs/cifs/file.c
>> >> +++ b/fs/cifs/file.c
>> >> @@ -150,8 +150,14 @@ client_can_cache:
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D tru=
e;
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D tr=
ue;
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Exclusive Oplock granted on =
inode %p", inode);
>> >> - =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ)
>> >> + =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false=
;
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D tr=
ue;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Level II Oplock franted on ino=
de %p", inode);
>> >> + =A0 =A0 } else {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false=
;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D fals=
e;
>> >> + =A0 =A0 }
>> >>
>> >
>> > The oplock handling in cifs is rather ad-hoc. There's a lot of
>> > cut-and-pasted code that sets that clientCanCache flags. The flags
>> > themselves are also sort of hard to understand -- i.e. why is is "=
All"
>> > and not "Write"?
>> >
>> > This would be good opportunity to consolidate that code into helpe=
r
>> > functions and just call them from the appropriate places.
>> >
>> > Perhaps a helper function that takes an oplock value and sets the
>> > clientCanCache flags appropriately? Or...maybe consider doing away=
 with
>> > the canCache flags and just store the oplock value in the inode an=
d
>> > have helper macros or something that read that value and tell you =
what
>> > can be done with it.
>> >
>> > =A0 i.e.: CLIENT_CAN_CACHE_READ(inode), CLIENT_CAN_CACHE_WRITE(ino=
de)
>>
>> Remember that the reason we don't have a can_cache_write is that the=
re
>> is no equivalent smb/cifs protocol concept as "can_cache_write"
>> independent of caching reads - there are basically three types:
>> 1) batch oplocks (read/write and open/close caching) which we don't
>> use (although will in smb2)
>> 2) read/write
>> 3) read
>>
>
> I understand that, but from a coding standpoint I don't care. All I
> care about is: "What can I do with the cached data attached to this
> inode right now?"
>
> That's why I think it might be saner to get rid of the bools
> and keep the oplock flag in the inode and have macros that tell me wh=
at
> I can actually do with it.

Booleans are cheap, probably use less space (depending on compiler and =
arch).
Seems low priority to make that kind of change - lots of more
important functional enhancements, and it might grow the inode.

--=20
Thanks,

Steve
