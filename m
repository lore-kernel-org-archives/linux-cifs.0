From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Simplify setlk error handling for mandatory locking
Date: Sat, 29 Oct 2011 17:23:44 +0400
Message-ID: <CAKywueSNod2Oajt52nS5B0H_aVb1EXoJgXCiw=DeM7QbXhx2CA@mail.gmail.com>
References: <1319657208-15659-1-git-send-email-piastry@etersoft.ru>
	<1319657208-15659-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319657208-15659-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/26 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> and do a trivial cleanup for getlk.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 99 +++++++++++++++++++++++++++---------------=
--------------
> =A01 files changed, 48 insertions(+), 51 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 6bf14ed..3ad89ec 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -771,20 +771,20 @@ int cifs_setlease(struct file *file, long arg, =
struct file_lock **lease)
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
> @@ -798,7 +798,7 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
> =A0}
>
> =A0static bool
> -cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
> +__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u64 length, __u8 typ=
e, __u16 netfid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifsLockInfo **=
conf_lock)
> =A0{
> @@ -820,6 +820,14 @@ cifs_find_lock_conflict(struct cifsInodeInfo *ci=
node, __u64 offset,
> =A0 =A0 =A0 =A0return false;
> =A0}
>
> +static bool
> +cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsLoc=
kInfo *lock,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo **c=
onf_lock)
> +{
> + =A0 =A0 =A0 return __cifs_find_lock_conflict(cinode, lock->offset, =
lock->length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0lock->type, lock->netfid, conf_lock);
> +}
> +
> =A0static int
> =A0cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 l=
ength,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u8 type, __u16 netfid, struct file_lock=
 *flock)
> @@ -830,8 +838,8 @@ cifs_lock_test(struct cifsInodeInfo *cinode, __u6=
4 offset, __u64 length,
>
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
>
> - =A0 =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, offset, lengt=
h, type, netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &conf_lock);
> + =A0 =A0 =A0 exist =3D __cifs_find_lock_conflict(cinode, offset, len=
gth, type, netfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 &conf_lock);
> =A0 =A0 =A0 =A0if (exist) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_start =3D conf_lock->offset;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_end =3D conf_lock->offset + =
conf_lock->length - 1;
> @@ -849,40 +857,27 @@ cifs_lock_test(struct cifsInodeInfo *cinode, __=
u64 offset, __u64 length,
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -static int
> -cifs_lock_add(struct cifsInodeInfo *cinode, __u64 len, __u64 offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 __u8 type, __u16 netfid)
> +static void
> +cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *loc=
k)
> =A0{
> - =A0 =A0 =A0 struct cifsLockInfo *li;
> -
> - =A0 =A0 =A0 li =3D cifs_lock_init(len, offset, type, netfid);
> - =A0 =A0 =A0 if (!li)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> -
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
> - =A0 =A0 =A0 list_add_tail(&li->llist, &cinode->llist);
> + =A0 =A0 =A0 list_add_tail(&lock->llist, &cinode->llist);
> =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> - =A0 =A0 =A0 return 0;
> =A0}
>
> =A0static int
> -cifs_lock_add_if(struct cifsInodeInfo *cinode, __u64 offset, __u64 l=
ength,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u8 type, __u16 netfid, bool wait)
> +cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo *=
lock,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool wait)
> =A0{
> - =A0 =A0 =A0 struct cifsLockInfo *lock, *conf_lock;
> + =A0 =A0 =A0 struct cifsLockInfo *conf_lock;
> =A0 =A0 =A0 =A0bool exist;
> =A0 =A0 =A0 =A0int rc =3D 0;
>
> - =A0 =A0 =A0 lock =3D cifs_lock_init(length, offset, type, netfid);
> - =A0 =A0 =A0 if (!lock)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> -
> =A0try_again:
> =A0 =A0 =A0 =A0exist =3D false;
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
>
> - =A0 =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, offset, lengt=
h, type, netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &conf_lock);
> + =A0 =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, lock, &conf_l=
ock);
> =A0 =A0 =A0 =A0if (!exist && cinode->can_cache_brlcks) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_add_tail(&lock->llist, &cinode->l=
list);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> @@ -908,7 +903,6 @@ try_again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 kfree(lock);
> =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -1060,7 +1054,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfil=
e)
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
> @@ -1197,14 +1191,12 @@ cifs_getlk(struct file *file, struct file_loc=
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
> @@ -1222,8 +1214,7 @@ cifs_getlk(struct file *file, struct file_lock =
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
> @@ -1392,20 +1383,26 @@ cifs_setlk(struct file *file, =A0struct file_=
lock *flock, __u8 type,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (lock) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add_if(cinode, flock->=
fl_start, length,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 type, netfid, wait_flag);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo *lock;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock =3D cifs_lock_init(flock->fl_start=
, length, type, netfid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!lock)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add_if(cinode, lock, w=
ait_flag);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc < 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (!rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc <=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBLock(xid, tcon, netfid, =
current->tgid, length,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock=
->fl_start, 0, 1, type, wait_flag, 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* For Windows locks we=
 must store them. */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add(ci=
node, length, flock->fl_start,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0type, netfid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_lock_add(cinode, lock);
> =A0 =A0 =A0 =A0} else if (unlock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_unlock_range(cfile, flock,=
 xid);
>
> --
> 1.7.1
>
>

Split it into two and posted to the list.

--=20
Best regards,
Pavel Shilovsky.
