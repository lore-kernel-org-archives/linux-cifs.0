From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: RFC: Attach locks to cifsFileInfo instead of cifsInodeInfo
Date: Thu, 1 Dec 2011 16:36:39 +0400
Message-ID: <CAKywueRy6t3Znn3__=OvY-meagLJ3sHft++Uzk6KiyEgC=+gug@mail.gmail.com>
References: <1320696342.1690.19.camel@sprabhu.fab.redhat.com>
	<CAKywueTSqckM1iVsrEu47RwBA3GnpfZU17QrrNineJBVOcZdvQ@mail.gmail.com>
	<1320751612.2941.10.camel@localhost>
	<CAKywueQ65EgLz9iDd2exq85jBMGrBFLiq=mq2dOY9poy3_1h0g@mail.gmail.com>
	<1320773203.1690.35.camel@sprabhu.fab.redhat.com>
	<CAKywueSRYxizd+mKw8p93Os0Aqij+R2Dh=2hu6JuJ+bv7S+uWw@mail.gmail.com>
	<1321020680.1690.57.camel@sprabhu.fab.redhat.com>
	<CAKywueQwM49dfne1L_d4WVa3zENdshbuuiZ9tVzv=BiF171_8w@mail.gmail.com>
	<1321276715.1690.78.camel@sprabhu.fab.redhat.com>
	<1321547488.1690.122.camel@sprabhu.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321547488.1690.122.camel-yuq4rhG59MBosH8Q1Ye95IGKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/11/17 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Pavel,
>
> I've made some changes to the locking code which makes it easier to
> unlock all locks on an inode. This fixes the earlier problem where
> unlock =A0requests would only process the locks for that open file
> instance while ignoring the locks on other open file instances for th=
at
> inode.
>
> However we still have one major issue. In case of unlocks, the curren=
t
> code will only return locks which are completely within the range
> specified by the unlock command. If we get an unlock request which
> divides a =A0brlock into 2, we ignore the unlock request for that brl=
ock.
> This will result in a situation where the application finds a lock on=
 a
> part of the file it expected to be unlocked. Should we check for thes=
e
> cases and return an EFAULT in cases where the unlock request will not
> completely unlock the entire range?

Yes, I think that we should report to the userspace to let the
application know about the failure. I found this on fcntl man page:

ENOLCK
Too many segment locks open, lock table is full, or a remote locking
protocol failed (e.g., locking over NFS).

I think this fits our scenario.

>
> Sachin Prabhu
>
> ----
>
> Attach locks to cifsFileInfo instead of cifsInodeInfo
>
> Locks in CIFS are attached to an open file instances ie. all
> lock/unlock requests made to the file server should contain the filei=
d
> which represents the open file instance. Grouping all brlocks accordi=
ng
> to the fileid therefore makes it easier to process especially when
> multiple lock or unlock requests for a file are to be made.
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 8f1fe32..8a71b0d 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -949,7 +949,6 @@ cifs_init_once(void *inode)
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cifsi =3D inode;
>
> =A0 =A0 =A0 =A0inode_init_once(&cifsi->vfs_inode);
> - =A0 =A0 =A0 INIT_LIST_HEAD(&cifsi->llist);
> =A0 =A0 =A0 =A0mutex_init(&cifsi->lock_mutex);
> =A0}
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 8238aa1..409d932 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -527,6 +527,7 @@ struct cifs_search_info {
> =A0struct cifsFileInfo {
> =A0 =A0 =A0 =A0struct list_head tlist; /* pointer to next fid owned b=
y tcon */
> =A0 =A0 =A0 =A0struct list_head flist; /* next fid (file instance) fo=
r this inode */
> + =A0 =A0 =A0 struct list_head llist; /* brlocks for this file */
> =A0 =A0 =A0 =A0unsigned int uid; =A0 =A0 =A0 /* allows finding which =
=46ileInfo structure */
> =A0 =A0 =A0 =A0__u32 pid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* process id wh=
o opened file */
> =A0 =A0 =A0 =A0__u16 netfid; =A0 =A0 =A0 =A0 =A0 /* file id from remo=
te */
> @@ -567,9 +568,9 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_f=
ile);
> =A0*/
>
> =A0struct cifsInodeInfo {
> - =A0 =A0 =A0 struct list_head llist; =A0 =A0 =A0 =A0 /* brlocks for =
this inode */
> =A0 =A0 =A0 =A0bool can_cache_brlcks;
> - =A0 =A0 =A0 struct mutex lock_mutex; =A0 =A0 =A0 =A0/* protect two =
fields above */
> + =A0 =A0 =A0 struct mutex lock_mutex; =A0 =A0 =A0 =A0/* protect cifs=
=46ileInfo->llist
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0& cifsInodeInfo->can_cache_brlcks */
> =A0 =A0 =A0 =A0/* BB add in lists for dirty pages i.e. write caching =
info for oplock */
> =A0 =A0 =A0 =A0struct list_head openFileList;
> =A0 =A0 =A0 =A0__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, comp=
ressed, system */
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index cf0b153..3f6b169 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -264,6 +264,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *=
file,
> =A0 =A0 =A0 =A0pCifsFile->tlink =3D cifs_get_tlink(tlink);
> =A0 =A0 =A0 =A0mutex_init(&pCifsFile->fh_mutex);
> =A0 =A0 =A0 =A0INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break)=
;
> + =A0 =A0 =A0 INIT_LIST_HEAD(&pCifsFile->llist);
>
> =A0 =A0 =A0 =A0spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openF=
ileList));
> @@ -333,15 +334,11 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs=
_file)
> =A0 =A0 =A0 =A0/* Delete any outstanding lock records. We'll lose the=
m when the file
> =A0 =A0 =A0 =A0 * is closed anyway.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 mutex_lock(&cifsi->lock_mutex);
> - =A0 =A0 =A0 list_for_each_entry_safe(li, tmp, &cifsi->llist, llist)=
 {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (li->netfid !=3D cifs_file->netfid)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 list_for_each_entry_safe(li, tmp, &cifs_file->llist, ll=
ist) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del(&li->llist);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_del_lock_waiters(li);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(li);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 mutex_unlock(&cifsi->lock_mutex);
>
> =A0 =A0 =A0 =A0cifs_put_tlink(cifs_file->tlink);
> =A0 =A0 =A0 =A0dput(cifs_file->dentry);
> @@ -672,47 +669,82 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock=
)
> =A0}
>
> =A0static bool
> -__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset=
,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u8 type=
, __u16 netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo **c=
onf_lock)
> +__cifs_find_lock_conflict_file(struct cifsFileInfo *cifs_file, __u64=
 offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u64 le=
ngth, __u8 type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct c=
ifsLockInfo **conf_lock)
> =A0{
> - =A0 =A0 =A0 struct cifsLockInfo *li, *tmp;
> + =A0 =A0 =A0 struct cifsLockInfo *li;
>
> - =A0 =A0 =A0 list_for_each_entry_safe(li, tmp, &cinode->llist, llist=
) {
> + =A0 =A0 =A0 list_for_each_entry(li, &cifs_file->llist, llist) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Check if range matches */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (offset + length <=3D li->offset ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset >=3D li->offset + li->l=
ength)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if ((type & LOCKING_ANDX_SHARED_LO=
CK) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((netfid =3D=3D li->=
netfid && current->tgid =3D=3D li->pid) ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 type =3D=3D li->typ=
e))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *conf_lock =3D li;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Is the request for a shared lock */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D LOCKING_ANDX_SHARED_LOC=
K) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Does this process al=
ready posses a lock? */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (current->tgid =3D=3D=
 li->pid)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
false;
You should check if netfids match too, because it is not allowed to
set a shared lock by one handle to an exclusive lock by another.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Is the existing lock=
 a shared lock too? */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (li->type =3D=3D LOC=
KING_ANDX_SHARED_LOCK)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
false;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We have found a conflicting lock */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *conf_lock =3D li;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return false;
> +}
> +
> +static bool
> +__cifs_find_lock_conflict(struct cifsFileInfo *cifs_file, __u64 offs=
et,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u8 =
type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo=
 **conf_lock)
> +{
> + =A0 =A0 =A0 struct cifsFileInfo *file, *tmp;
> + =A0 =A0 =A0 bool rc;
> + =A0 =A0 =A0 struct cifsInodeInfo *cifs_inode =3D CIFS_I(cifs_file->=
dentry->d_inode);
> +
> + =A0 =A0 =A0 /* We need to check across every open instance of the i=
node */
> + =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> + =A0 =A0 =A0 list_for_each_entry_safe(file, tmp, &cifs_inode->openFi=
leList, flist) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_get(file);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D __cifs_find_lock_conflict_file(f=
ile, offset, length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 type, conf_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_put(file);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> +
> =A0 =A0 =A0 =A0return false;
> =A0}
>
> =A0static bool
> -cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsLoc=
kInfo *lock,
> +cifs_find_lock_conflict(struct cifsFileInfo *cifs_file,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo *lo=
ck,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifsLockInfo **=
conf_lock)
> =A0{
> - =A0 =A0 =A0 return __cifs_find_lock_conflict(cinode, lock->offset, =
lock->length,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0lock->type, lock->netfid, conf_lock);
> + =A0 =A0 =A0 return __cifs_find_lock_conflict(cifs_file, lock->offse=
t, lock->length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0lock->type, conf_lock);
> =A0}
>
> =A0static int
> -cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 len=
gth,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0__u8 type, __u16 netfid, struct file_loc=
k *flock)
> +cifs_lock_test(struct cifsFileInfo *cifs_file, __u64 offset, __u64 l=
ength,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0__u8 type, struct file_lock *flock)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0struct cifsLockInfo *conf_lock;
> =A0 =A0 =A0 =A0bool exist;
> + =A0 =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(cifs_file->dent=
ry->d_inode);
>
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
>
> - =A0 =A0 =A0 exist =3D __cifs_find_lock_conflict(cinode, offset, len=
gth, type, netfid,
> + =A0 =A0 =A0 exist =3D __cifs_find_lock_conflict(cifs_file, offset, =
length, type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&conf_lock);
> =A0 =A0 =A0 =A0if (exist) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_start =3D conf_lock->offset;
> @@ -732,18 +764,21 @@ cifs_lock_test(struct cifsInodeInfo *cinode, __=
u64 offset, __u64 length,
> =A0}
>
> =A0static void
> -cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *loc=
k)
> +cifs_lock_add(struct cifsFileInfo *cifs_file, struct cifsLockInfo *l=
ock)
> =A0{
> + =A0 =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(cifs_file->dent=
ry->d_inode);
> +
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
> - =A0 =A0 =A0 list_add_tail(&lock->llist, &cinode->llist);
> + =A0 =A0 =A0 list_add_tail(&lock->llist, &cifs_file->llist);
> =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> =A0}
>
> =A0static int
> -cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo *=
lock,
> +cifs_lock_add_if(struct cifsFileInfo *cifs_file, struct cifsLockInfo=
 *lock,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool wait)
> =A0{
> =A0 =A0 =A0 =A0struct cifsLockInfo *conf_lock;
> + =A0 =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(cifs_file->dent=
ry->d_inode);
> =A0 =A0 =A0 =A0bool exist;
> =A0 =A0 =A0 =A0int rc =3D 0;
>
> @@ -751,9 +786,9 @@ try_again:
> =A0 =A0 =A0 =A0exist =3D false;
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
>
> - =A0 =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, lock, &conf_l=
ock);
> + =A0 =A0 =A0 exist =3D cifs_find_lock_conflict(cifs_file, lock, &con=
f_lock);
> =A0 =A0 =A0 =A0if (!exist && cinode->can_cache_brlcks) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&lock->llist, &cinode->ll=
ist);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&lock->llist, &cifs_file-=
>llist);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -823,7 +858,7 @@ static int
> =A0cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
> =A0{
> =A0 =A0 =A0 =A0int xid, rc =3D 0, stored_rc;
> - =A0 =A0 =A0 struct cifsLockInfo *li, *tmp;
> + =A0 =A0 =A0 struct cifsLockInfo *li;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon;
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry-=
>d_inode);
> =A0 =A0 =A0 =A0unsigned int num, max_num;
> @@ -854,7 +889,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cf=
ile)
> =A0 =A0 =A0 =A0for (i =3D 0; i < 2; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur =3D buf;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(li, tmp, &cino=
de->llist, llist) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry(li, &cfile->llist, =
llist) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (li->type !=3D type=
s[i])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0contin=
ue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur->Pid =3D cpu_to_le=
16(li->pid);
> @@ -865,8 +900,10 @@ cifs_push_mandatory_locks(struct cifsFileInfo *c=
file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (++num =3D=3D max_n=
um) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stored=
_rc =3D cifs_lockv(xid, tcon, cfile->netfid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 li->type, 0, num, buf);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sto=
red_rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sto=
red_rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cERROR(1, "Error while syncing locks");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0rc =3D stored_rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur =3D=
 buf;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num =3D=
 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> @@ -876,8 +913,10 @@ cifs_push_mandatory_locks(struct cifsFileInfo *c=
file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (num) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stored_rc =3D cifs_loc=
kv(xid, tcon, cfile->netfid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 types[i], 0, num, buf);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (stored_rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (stored_rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "Error while syncing locks");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 stored_rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> @@ -1026,7 +1065,6 @@ cifs_getlk(struct file *file, struct file_lock =
*flock, __u8 type,
> =A0 =A0 =A0 =A0__u64 length =3D 1 + flock->fl_end - flock->fl_start;
> =A0 =A0 =A0 =A0struct cifsFileInfo *cfile =3D (struct cifsFileInfo *)=
file->private_data;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
> - =A0 =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->=
d_inode);
> =A0 =A0 =A0 =A0__u16 netfid =3D cfile->netfid;
>
> =A0 =A0 =A0 =A0if (posix_lck) {
> @@ -1046,8 +1084,7 @@ cifs_getlk(struct file *file, struct file_lock =
*flock, __u8 type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D cifs_lock_test(cinode, flock->fl_start, length, =
type, netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock);
> + =A0 =A0 =A0 rc =3D cifs_lock_test(cfile, flock->fl_start, length, t=
ype, flock);
> =A0 =A0 =A0 =A0if (!rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> @@ -1108,7 +1145,8 @@ cifs_free_llist(struct list_head *llist)
> =A0}
>
> =A0static int
> -cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *floc=
k, int xid)
> +cifs_unlock_range_file(struct cifsFileInfo *cfile, struct file_lock =
*flock,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int xid)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0, stored_rc;
> =A0 =A0 =A0 =A0int types[] =3D {LOCKING_ANDX_LARGE_FILES,
> @@ -1134,15 +1172,11 @@ cifs_unlock_range(struct cifsFileInfo *cfile,=
 struct file_lock *flock, int xid)
> =A0 =A0 =A0 =A0for (i =3D 0; i < 2; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur =3D buf;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(li, tmp, &cino=
de->llist, llist) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(li, tmp, &cfil=
e->llist, llist) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (flock->fl_start > =
li->offset ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(flock->fl_sta=
rt + length) <
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(li->offset + =
li->length))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0contin=
ue;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (current->tgid !=3D =
li->pid)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continu=
e;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cfile->netfid !=3D =
li->netfid)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continu=
e;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (types[i] !=3D li->=
type)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0contin=
ue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!cinode->can_cache=
_brlcks) {
> @@ -1172,7 +1206,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, s=
truct file_lock *flock, int xid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 * the inode list.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0cifs_move_llist(&tmp_llist,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &cinode->llist=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &cfile->llist)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0rc =3D stored_rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0/*
> @@ -1198,7 +1232,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, s=
truct file_lock *flock, int xid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stored_rc =3D cifs_loc=
kv(xid, tcon, cfile->netfid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 types[i], num, 0, buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (stored_rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_mo=
ve_llist(&tmp_llist, &cinode->llist);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_mo=
ve_llist(&tmp_llist, &cfile->llist);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 stored_rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_f=
ree_llist(&tmp_llist);
> @@ -1211,6 +1245,30 @@ cifs_unlock_range(struct cifsFileInfo *cfile, =
struct file_lock *flock, int xid)
> =A0}
>
> =A0static int
> +cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *floc=
k, int xid)
> +{
> + =A0 =A0 =A0 struct cifsFileInfo *file, *tmp;
> + =A0 =A0 =A0 struct cifsInodeInfo *cifs_inode =3D CIFS_I(cfile->dent=
ry->d_inode);
> + =A0 =A0 =A0 int rc =3D 0;
> +
> + =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> + =A0 =A0 =A0 list_for_each_entry_safe(file, tmp, &cifs_inode->openFi=
leList, flist) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (file->pid !=3D current->pid)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
The same cifsFileInfo structure can be shared between several
processes and every can set a brlock on it. But file->pid still has
the pid only of the process who opened the file. So, such a check
should be done in cifs_unlock_range_file with lock->pid.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_get(file);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_unlock_range_file(file, flo=
ck, xid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "VFS is out of =
sync with lock on server!");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_put(file);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> +
> + =A0 =A0 =A0 return rc;
> +}
> +
> +static int
> =A0cifs_setlk(struct file *file, =A0struct file_lock *flock, __u8 typ=
e,
> =A0 =A0 =A0 =A0 =A0 bool wait_flag, bool posix_lck, int lock, int unl=
ock, int xid)
> =A0{
> @@ -1218,7 +1276,6 @@ cifs_setlk(struct file *file, =A0struct file_lo=
ck *flock, __u8 type,
> =A0 =A0 =A0 =A0__u64 length =3D 1 + flock->fl_end - flock->fl_start;
> =A0 =A0 =A0 =A0struct cifsFileInfo *cfile =3D (struct cifsFileInfo *)=
file->private_data;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
> - =A0 =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.de=
ntry->d_inode);
> =A0 =A0 =A0 =A0__u16 netfid =3D cfile->netfid;
>
> =A0 =A0 =A0 =A0if (posix_lck) {
> @@ -1249,7 +1306,7 @@ cifs_setlk(struct file *file, =A0struct file_lo=
ck *flock, __u8 type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!lock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add_if(cinode, lock, w=
ait_flag);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add_if(cfile, lock, wa=
it_flag);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc <=3D 0)
> @@ -1262,7 +1319,7 @@ cifs_setlk(struct file *file, =A0struct file_lo=
ck *flock, __u8 type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_lock_add(cinode, lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_lock_add(cfile, lock);
> =A0 =A0 =A0 =A0} else if (unlock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_unlock_range(cfile, flock,=
 xid);
>
>
>

In general, I like your idea to group brlocks to the file structure
(that reverts my previous change) but this should be done in two steps
to make the history bisectable:
1) move locks to cifsFileInfo,
2) change cifs_unlock_range to unlock all process locks that are in
the requested unlock range.

--=20
Best regards,
Pavel Shilovsky.
