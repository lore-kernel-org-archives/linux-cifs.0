From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 3/3] CIFS: Cleanup byte-range locking code style
Date: Tue, 1 Nov 2011 21:19:46 +0300
Message-ID: <CAKywueQxU87umPDQeyV38kqEs5pQGqC02wFWXsNACENM4-a2Cw@mail.gmail.com>
References: <1319894279-7723-1-git-send-email-piastry@etersoft.ru>
	<1319894279-7723-3-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319894279-7723-3-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/29 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> Reorder parms of cifs_lock_init, trivially simplify getlk code and
> remove extra {} in cifs_lock_add_if.
>
> Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 43 +++++++++++++++++++-----------------------=
-
> =A01 files changed, 19 insertions(+), 24 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index d9cc07f..cf0b153 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -645,20 +645,20 @@ int cifs_closedir(struct inode *inode, struct f=
ile *file)
> =A0}
>
> =A0static struct cifsLockInfo *
> -cifs_lock_init(__u64 len, __u64 offset, __u8 type, __u16 netfid)
> +cifs_lock_init(__u64 offset, __u64 length, __u8 type, __u16 netfid)
> =A0{
> - =A0 =A0 =A0 struct cifsLockInfo *li =3D
> + =A0 =A0 =A0 struct cifsLockInfo *lock =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kmalloc(sizeof(struct cifsLockInfo), G=
=46P_KERNEL);
> - =A0 =A0 =A0 if (!li)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return li;
> - =A0 =A0 =A0 li->netfid =3D netfid;
> - =A0 =A0 =A0 li->offset =3D offset;
> - =A0 =A0 =A0 li->length =3D len;
> - =A0 =A0 =A0 li->type =3D type;
> - =A0 =A0 =A0 li->pid =3D current->tgid;
> - =A0 =A0 =A0 INIT_LIST_HEAD(&li->blist);
> - =A0 =A0 =A0 init_waitqueue_head(&li->block_q);
> - =A0 =A0 =A0 return li;
> + =A0 =A0 =A0 if (!lock)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return lock;
> + =A0 =A0 =A0 lock->offset =3D offset;
> + =A0 =A0 =A0 lock->length =3D length;
> + =A0 =A0 =A0 lock->type =3D type;
> + =A0 =A0 =A0 lock->netfid =3D netfid;
> + =A0 =A0 =A0 lock->pid =3D current->tgid;
> + =A0 =A0 =A0 INIT_LIST_HEAD(&lock->blist);
> + =A0 =A0 =A0 init_waitqueue_head(&lock->block_q);
> + =A0 =A0 =A0 return lock;
> =A0}
>
> =A0static void
> @@ -770,10 +770,8 @@ try_again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0(lock->blist.next =3D=3D &lock->blist));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto try_again;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&cinode->loc=
k_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&lock->bl=
ist);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&lock->blist);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> @@ -927,7 +925,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type =3D CIFS_WRLCK;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck =3D cifs_lock_init(length, flock->f=
l_start, type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck =3D cifs_lock_init(flock->fl_start,=
 length, type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 cfile->netfid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!lck) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> @@ -1064,14 +1062,12 @@ cifs_getlk(struct file *file, struct file_loc=
k *flock, __u8 type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Error unloc=
king previously locked "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
range %d during test of lock", rc);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (type & LOCKING_ANDX_SHARED_LOCK) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_type =3D F_WRLCK;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0rc =3D CIFSSMBLock(xid, tcon, netfid, current->tgid, l=
ength,
> @@ -1089,8 +1085,7 @@ cifs_getlk(struct file *file, struct file_lock =
*flock, __u8 type,
> =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_type =3D F_WRLCK;
>
> - =A0 =A0 =A0 rc =3D 0;
> - =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 return 0;
> =A0}
>
> =A0static void
> @@ -1250,7 +1245,7 @@ cifs_setlk(struct file *file, =A0struct file_lo=
ck *flock, __u8 type,
> =A0 =A0 =A0 =A0if (lock) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifsLockInfo *lock;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock =3D cifs_lock_init(length, flock->=
fl_start, type, netfid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock =3D cifs_lock_init(flock->fl_start=
, length, type, netfid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!lock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
>
> --
> 1.7.1
>
>

Steve, Jeff,

Since #1 and #2 of this series of three are reviewed and ok could you
look at this one, please? It's rather simple, I think.

--=20
Best regards,
Pavel Shilovsky.
