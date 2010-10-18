From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 08/13] cifs: convert GlobalSMBSeslock from a rwlock to
 regular spinlock
Date: Sun, 17 Oct 2010 20:34:18 -0500
Message-ID: <AANLkTi=6buvrfN_pnY_JZ6MHLaMqxu3WqBcD9xk9k4n0@mail.gmail.com>
References: <1287171248-464-1-git-send-email-jlayton@redhat.com>
	<1287171248-464-9-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287171248-464-9-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Nice writeup on lwn with the more detailed explanation of the topic of =
rwlocks

http://lwn.net/Articles/364583/

This patch and patch 9 reviewed/merged now as well.

Also FYI - I fixed a checkpatch warning on patch 2

On Fri, Oct 15, 2010 at 2:34 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Convert this lock to a regular spinlock
>
> A rwlock_t offers little value here. It's more expensive than a regul=
ar
> spinlock unless you have a fairly large section of code that runs und=
er
> the read lock and can benefit from the concurrency.
>
> Additionally, we need to ensure that the refcounting for files isn't
> racy and to do that we need to lock areas that can increment it for
> write. That means that the areas that can actually use a read_lock ar=
e
> very few and relatively infrequently used.
>
> While we're at it, change the name to something easier to type, and f=
ix
> a bug in find_writable_file. cifsFileInfo_put can sleep and shouldn't=
 be
> called while holding the lock.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 | =A0 =A02 +-
> =A0fs/cifs/cifsglob.h | =A0 =A02 +-
> =A0fs/cifs/cifssmb.c =A0| =A0 =A04 +-
> =A0fs/cifs/file.c =A0 =A0 | =A0 54 ++++++++++++++++++++++++++--------=
------------------
> =A0fs/cifs/misc.c =A0 =A0 | =A0 =A08 +++---
> =A0fs/cifs/readdir.c =A0| =A0 =A06 ++--
> =A06 files changed, 38 insertions(+), 38 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 3facf25..c25e928 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -942,8 +942,8 @@ init_cifs(void)
> =A0 =A0 =A0 =A0GlobalTotalActiveXid =3D 0;
> =A0 =A0 =A0 =A0GlobalMaxActiveXid =3D 0;
> =A0 =A0 =A0 =A0memset(Local_System_Name, 0, 15);
> - =A0 =A0 =A0 rwlock_init(&GlobalSMBSeslock);
> =A0 =A0 =A0 =A0rwlock_init(&cifs_tcp_ses_lock);
> + =A0 =A0 =A0 spin_lock_init(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0spin_lock_init(&GlobalMid_Lock);
>
> =A0 =A0 =A0 =A0if (cifs_max_pending < 2) {
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 2ecf675..087bc4b 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -722,7 +722,7 @@ GLOBAL_EXTERN rwlock_t =A0 =A0 =A0 =A0 =A0 =A0 =A0=
cifs_tcp_ses_lock;
> =A0* If cifs_tcp_ses_lock and the lock below are both needed to be he=
ld, then
> =A0* the cifs_tcp_ses_lock must be grabbed first and released last.
> =A0*/
> -GLOBAL_EXTERN rwlock_t GlobalSMBSeslock;
> +GLOBAL_EXTERN spinlock_t =A0 =A0 =A0 cifs_file_list_lock;
>
> =A0/* Outstanding dir notify requests */
> =A0GLOBAL_EXTERN struct list_head GlobalDnotifyReqList;
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index a420c7b..bfb59a6 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -91,13 +91,13 @@ static void mark_open_files_invalid(struct cifsTc=
onInfo *pTcon)
> =A0 =A0 =A0 =A0struct list_head *tmp1;
>
> =A0/* list all files open on tree connection and mark them invalid */
> - =A0 =A0 =A0 write_lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0list_for_each_safe(tmp, tmp1, &pTcon->openFileList) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0open_file =3D list_entry(tmp, struct c=
ifsFileInfo, tlist);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0open_file->invalidHandle =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0open_file->oplock_break_cancelled =3D =
true;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 write_unlock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0/* BB Add call to invalidate_inodes(sb) for all superb=
locks mounted
> =A0 =A0 =A0 =A0 =A0 to this tcon */
> =A0}
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 293e9b7..26048dc 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -246,14 +246,14 @@ cifs_new_fileinfo(__u16 fileHandle, struct file=
 *file,
> =A0 =A0 =A0 =A0atomic_set(&pCifsFile->count, 1);
> =A0 =A0 =A0 =A0INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break)=
;
>
> - =A0 =A0 =A0 write_lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openF=
ileList));
> =A0 =A0 =A0 =A0/* if readable file instance put first in list*/
> =A0 =A0 =A0 =A0if (file->f_mode & FMODE_READ)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_add(&pCifsFile->flist, &pCifsInod=
e->openFileList);
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_add_tail(&pCifsFile->flist, &pCif=
sInode->openFileList);
> - =A0 =A0 =A0 write_unlock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
>
> =A0 =A0 =A0 =A0if ((oplock & 0xF) =3D=3D OPLOCK_EXCLUSIVE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCifsInode->clientCanCacheAll =3D true=
;
> @@ -607,13 +607,13 @@ int cifs_close(struct inode *inode, struct file=
 *file)
> =A0 =A0 =A0 =A0pTcon =3D tlink_tcon(pSMBFile->tlink);
> =A0 =A0 =A0 =A0if (pSMBFile) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifsLockInfo *li, *tmp;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMBFile->closePend =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (pTcon) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* no sense reconnecti=
ng to close a file that is
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 already closed */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!pTcon->need_recon=
nect) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_u=
nlock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0timeou=
t =3D 2;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0while =
((atomic_read(&pSMBFile->count) !=3D 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&& (timeout <=3D 2048)) {
> @@ -633,9 +633,9 @@ int cifs_close(struct inode *inode, struct file *=
file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0rc =3D CIFSSMBClose(xid, pTcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMBFile->netfid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_u=
nlock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_unlock(&GlobalSMB=
Seslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_=
list_lock);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Delete any outstanding lock records=
=2E
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 We'll lose them when the file is =
closed anyway. */
> @@ -646,16 +646,16 @@ int cifs_close(struct inode *inode, struct file=
 *file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&pSMBFile->lock_mutex);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del(&pSMBFile->flist);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del(&pSMBFile->tlist);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_unlock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsFileInfo_put(file->private_data);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0file->private_data =3D NULL;
> =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EBADF;
>
> - =A0 =A0 =A0 read_lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0if (list_empty(&(CIFS_I(inode)->openFileList))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "closing last open instance fo=
r inode %p", inode);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* if the file is not open we do not k=
now if we can cache info
> @@ -663,7 +663,7 @@ int cifs_close(struct inode *inode, struct file *=
file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_I(inode)->clientCanCacheRead =3D =
false;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_I(inode)->clientCanCacheAll =A0=3D=
 false;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 read_unlock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0if ((rc =3D=3D 0) && CIFS_I(inode)->write_behind_rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFS_I(inode)->write_behind_rc;
> =A0 =A0 =A0 =A0FreeXid(xid);
> @@ -685,18 +685,18 @@ int cifs_closedir(struct inode *inode, struct f=
ile *file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifsTconInfo *pTcon =3D tlink_t=
con(pCFileStruct->tlink);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Freeing private data in close=
 dir");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!pCFileStruct->srch_inf.endOfSearc=
h &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!pCFileStruct->invalidHandle) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCFileStruct->invalidH=
andle =3D true;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_unlock(&GlobalSMB=
Seslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_=
list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSFindClose(x=
id, pTcon, pCFileStruct->netfid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Closing uncom=
pleted readdir with rc %d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* not much we can do =
if it fails anyway, ignore rc */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_unlock(&GlobalSMB=
Seslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_=
list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ptmp =3D pCFileStruct->srch_inf.ntwrk_=
buf_start;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ptmp) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "closedir free=
 smb buf in srch struct");
> @@ -1182,7 +1182,7 @@ struct cifsFileInfo *find_readable_file(struct =
cifsInodeInfo *cifs_inode,
> =A0 =A0 =A0 =A0if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fsuid_only =3D false;
>
> - =A0 =A0 =A0 read_lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0/* we could simply get the first_list_entry since writ=
e-only entries
> =A0 =A0 =A0 =A0 =A0 are always at the end of the list but since the f=
irst entry might
> =A0 =A0 =A0 =A0 =A0 have a close pending, we go through the whole lis=
t */
> @@ -1196,7 +1196,7 @@ struct cifsFileInfo *find_readable_file(struct =
cifsInodeInfo *cifs_inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* fou=
nd a good file */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* loc=
k it so it will not be closed on us */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsFi=
leInfo_get(open_file);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_un=
lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 open_file;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} /* else might as wel=
l continue, and look for
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 another, or s=
imply have the caller reopen it
> @@ -1204,7 +1204,7 @@ struct cifsFileInfo *find_readable_file(struct =
cifsInodeInfo *cifs_inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else /* write only file */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break; /* write only f=
iles are last so must be done */
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 read_unlock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0return NULL;
> =A0}
> =A0#endif
> @@ -1231,7 +1231,7 @@ struct cifsFileInfo *find_writable_file(struct =
cifsInodeInfo *cifs_inode,
> =A0 =A0 =A0 =A0if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fsuid_only =3D false;
>
> - =A0 =A0 =A0 read_lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0refind_writable:
> =A0 =A0 =A0 =A0list_for_each_entry(open_file, &cifs_inode->openFileLi=
st, flist) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (open_file->closePend)
> @@ -1245,11 +1245,11 @@ refind_writable:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!open_file->invali=
dHandle) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* fou=
nd a good writable file */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_un=
lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 open_file;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_unlock(&GlobalSMBS=
eslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_=
list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Had to unlock since=
 following call can block */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_reopen_fil=
e(open_file, false);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!rc) {
> @@ -1257,7 +1257,7 @@ refind_writable:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0return open_file;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else {=
 /* start over in case this was deleted */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 /* since the list could be modified */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 read_lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cifsFileInfo_put(open_file);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0goto refind_writable;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -1271,7 +1271,7 @@ refind_writable:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0to hold up writepages =
here (rather than
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0in caller) with contin=
uous retries */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "wp failed on =
reopen file");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_lock(&GlobalSMBSes=
lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_li=
st_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* can not use this ha=
ndle, no write
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pending on this o=
ne after all */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsFileInfo_put(open_=
file);
> @@ -1292,7 +1292,7 @@ refind_writable:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0any_available =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto refind_writable;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 read_unlock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0return NULL;
> =A0}
>
> @@ -2200,16 +2200,16 @@ static int is_inode_writable(struct cifsInode=
Info *cifs_inode)
> =A0{
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file;
>
> - =A0 =A0 =A0 read_lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0list_for_each_entry(open_file, &cifs_inode->openFileLi=
st, flist) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (open_file->closePend)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (OPEN_FMODE(open_file->f_flags) & F=
MODE_WRITE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_unlock(&GlobalSMBS=
eslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_=
list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 read_unlock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> @@ -2373,8 +2373,8 @@ void cifs_oplock_break(struct work_struct *work=
)
> =A0 =A0 =A0 =A0 * finished grabbing reference for us. =A0Make sure it=
's done by
> =A0 =A0 =A0 =A0 * waiting for GlobalSMSSeslock.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 write_lock(&GlobalSMBSeslock);
> - =A0 =A0 =A0 write_unlock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> + =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
>
> =A0 =A0 =A0 =A0cifs_oplock_break_put(cfile);
> =A0}
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 9bac3e7..de6073c 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -560,7 +560,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct=
 TCP_Server_Info *srv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0contin=
ue;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->=
num_oplock_brks);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_lock(&GlobalSMBSes=
lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_li=
st_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each(tmp2, &t=
con->openFileList) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0netfil=
e =3D list_entry(tmp2, struct cifsFileInfo,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tlist);
> @@ -572,7 +572,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct=
 TCP_Server_Info *srv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * clo=
sed anyway.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ne=
tfile->closePend) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 read_unlock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0read_unlock(&cifs_tcp_ses_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0return true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -594,11 +594,11 @@ is_valid_oplock_break(struct smb_hdr *buf, stru=
ct TCP_Server_Info *srv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cifs_oplock_break_get(netfile);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0netfil=
e->oplock_break_cancelled =3D false;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_un=
lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read_u=
nlock(&cifs_tcp_ses_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_unlock(&GlobalSMBS=
eslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_=
list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read_unlock(&cifs_tcp_=
ses_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "No matching f=
ile for oplock break");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return true;
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 7bdcb35..c8961c5 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -529,14 +529,14 @@ static int find_cifs_entry(const int xid, struc=
t cifsTconInfo *pTcon,
> =A0 =A0 =A0 =A0 =A0 (index_to_find < first_entry_in_buffer)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* close and restart search */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "search backing up - close and=
 restart search");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_lock(&GlobalSMBSeslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!cifsFile->srch_inf.endOfSearch &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!cifsFile->invalidHandle) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsFile->invalidHandl=
e =3D true;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_unlock(&GlobalSMB=
Seslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_=
list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFSFindClose(xid, pTc=
on, cifsFile->netfid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_unlock(&GlobalSMB=
Seslock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_=
list_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifsFile->srch_inf.ntwrk_buf_start=
) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "freeing SMB f=
f cache buf on search rewind");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifsFile->srch_inf=
=2EsmallBuf)
> --
> 1.7.2.3
>
>



--=20
Thanks,

Steve
