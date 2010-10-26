From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] CIFS: Invalidate inode pages on the last close
Date: Tue, 26 Oct 2010 22:00:07 +0400
Message-ID: <AANLkTint5opJs4pg96oBgUvkC3D-DvMQV8WxmrbuFuCh@mail.gmail.com>
References: <AANLkTimEwyZkxat-yq8pg3-MCVsnURowe-di2D2YBZhR@mail.gmail.com>
	<20101026102518.5d6bea89@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101026102518.5d6bea89-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/10/26 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 26 Oct 2010 17:01:26 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> When we close the last file handle of the inode we should invalidate=
 it
>> to prevent data coherency problem when we open it again but it has b=
een
>> modified by other clients.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/file.c | =A0 14 ++++++++++++--
>> =A01 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index d7c212a..02a045e 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -150,8 +150,14 @@ client_can_cache:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D true;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D true;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Exclusive Oplock granted on ino=
de %p", inode);
>> - =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ)
>> + =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Level II Oplock franted on inode =
%p", inode);
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false;
>> + =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D false;
>> + =A0 =A0 }
>>
>
> The oplock handling in cifs is rather ad-hoc. There's a lot of
> cut-and-pasted code that sets that clientCanCache flags. The flags
> themselves are also sort of hard to understand -- i.e. why is is "All=
"
> and not "Write"?
>
> This would be good opportunity to consolidate that code into helper
> functions and just call them from the appropriate places.

Good idea. I will try to do it.

>
> Perhaps a helper function that takes an oplock value and sets the
> clientCanCache flags appropriately? Or...maybe consider doing away wi=
th
> the canCache flags and just store the oplock value in the inode and
> have helper macros or something that read that value and tell you wha=
t
> can be done with it.
>
> =A0 i.e.: CLIENT_CAN_CACHE_READ(inode), CLIENT_CAN_CACHE_WRITE(inode)
>
>
>
>> =A0 =A0 =A0 return rc;
>> =A0}
>> @@ -271,8 +277,10 @@ cifs_new_fileinfo(__u16 fileHandle, struct file=
 *file,
>> =A0 */
>> =A0void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>> =A0{
>> + =A0 =A0 struct inode *inode =3D cifs_file->dentry->d_inode;
>> =A0 =A0 =A0 struct cifsTconInfo *tcon =3D tlink_tcon(cifs_file->tlin=
k);
>> - =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(cifs_file->dentry->=
d_inode);
>> + =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
>> + =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
>> =A0 =A0 =A0 struct cifsLockInfo *li, *tmp;
>>
>> =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
>> @@ -290,6 +298,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_=
file)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_file->dentry->d_ino=
de);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsi->clientCanCacheRead =3D false;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsi->clientCanCacheAll =A0=3D false;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_S=
TRICT_IO)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 invalidate_remote_inode(in=
ode);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^=
^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0I don't think it's safe to call this u=
nder a spinlock.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0It would probably be better instead to=
 flag the inode
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0as needing invalidation by setting the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0invalidate_mapping flag to true.
>

At first I was going not to do it under a spinlock, but Wine
application suddently crashes in this case. So, I didn't understand
the reason of so strange behavior and leave it under the spinlock - it
works well.

>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
>>

--=20
Best regards,
Pavel Shilovsky.
