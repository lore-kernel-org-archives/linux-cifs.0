From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v5] CIFS: Separate protocol specific part from getlk
Date: Thu, 17 May 2012 13:13:41 +0400
Message-ID: <CAKywueRyxS8ohjyQroN7Pn5Q1WB=QK4602W5vRFDc6N9TfGEiQ@mail.gmail.com>
References: <1337245754-14796-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337245754-14796-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/17 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h | =A0 =A02 ++
> =A0fs/cifs/file.c =A0 =A0 | =A0 52 ++++++++++++++++++++++++++++++----=
------------------
> =A0fs/cifs/smb1ops.c =A0| =A0 =A07 +++++++
> =A03 files changed, 39 insertions(+), 22 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 6943448..b6e97f8 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -156,10 +156,12 @@ enum smb_version {
>
> =A0struct mid_q_entry;
> =A0struct TCP_Server_Info;
> +struct cifsFileInfo;
>
> =A0struct smb_version_operations {
> =A0 =A0 =A0 =A0int (*send_cancel)(struct TCP_Server_Info *, void *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mid_q_entr=
y *);
> + =A0 =A0 =A0 bool (*compare_fids)(struct cifsFileInfo *, struct cifs=
=46ileInfo *);
> =A0};
>
> =A0struct smb_version_values {
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index ac71f85..9c2d85d 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -671,7 +671,7 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
>
> =A0static bool
> =A0cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offs=
et,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, _=
_u8 type, __u16 netfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, _=
_u8 type, struct cifsFileInfo *cur,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifsLoc=
kInfo **conf_lock)
> =A0{
> =A0 =A0 =A0 =A0struct cifsLockInfo *li;
> @@ -682,8 +682,8 @@ cifs_find_fid_lock_conflict(struct cifsFileInfo *=
cfile, __u64 offset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset >=3D li->offset + li->l=
ength)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if ((type & server->vals->shared_=
lock_type) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((netfid =3D=3D cfil=
e->netfid && current->tgid =3D=3D li->pid)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|| type =3D=3D li->t=
ype))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((server->ops->compa=
re_fids(cur, cfile) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current->tgid =3D=
=3D li->pid) || type =3D=3D li->type))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*conf_lock =3D li;
> @@ -694,17 +694,17 @@ cifs_find_fid_lock_conflict(struct cifsFileInfo=
 *cfile, __u64 offset,
> =A0}
>
> =A0static bool
> -cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u8 type=
, __u16 netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo **c=
onf_lock)
> +cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset, __=
u64 length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u8 type, struct cifsL=
ockInfo **conf_lock)
> =A0{
> =A0 =A0 =A0 =A0bool rc =3D false;
> =A0 =A0 =A0 =A0struct cifsFileInfo *fid, *tmp;
> + =A0 =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->=
d_inode);
>
> =A0 =A0 =A0 =A0spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0list_for_each_entry_safe(fid, tmp, &cinode->openFileLi=
st, flist) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_find_fid_lock_conflict(fid=
, offset, length, type,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0netfid, conf_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0cfile, conf_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0}
> @@ -732,8 +732,8 @@ cifs_lock_test(struct cifsFileInfo *cfile, __u64 =
offset, __u64 length,
>
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
>
> - =A0 =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, offset, lengt=
h, type,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cfile->netfid, &conf_lock);
> + =A0 =A0 =A0 exist =3D cifs_find_lock_conflict(cfile, offset, length=
, type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &conf_lock);
> =A0 =A0 =A0 =A0if (exist) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_start =3D conf_lock->offset;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_end =3D conf_lock->offset + =
conf_lock->length - 1;
> @@ -779,8 +779,8 @@ try_again:
> =A0 =A0 =A0 =A0exist =3D false;
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
>
> - =A0 =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, lock->offset,=
 lock->length,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 lock->type, cfile->netfid, &conf_lock);
> + =A0 =A0 =A0 exist =3D cifs_find_lock_conflict(cfile, lock->offset, =
lock->length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 lock->type, &conf_lock);
> =A0 =A0 =A0 =A0if (!exist && cinode->can_cache_brlcks) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_add_tail(&lock->llist, &cfile->ll=
ist);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> @@ -1117,6 +1117,15 @@ cifs_read_flock(struct file_lock *flock, __u32=
 *type, int *lock, int *unlock,
> =A0}
>
> =A0static int
> +cifs_mandatory_lock(int xid, struct cifsFileInfo *cfile, __u64 offse=
t,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u32 type, int l=
ock, int unlock, bool wait)
> +{
> + =A0 =A0 =A0 return CIFSSMBLock(xid, tlink_tcon(cfile->tlink), cfile=
->netfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current->tgid, l=
ength, offset, unlock, lock,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(__u8)type, wait=
, 0);
> +}
> +
> +static int
> =A0cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
> =A0 =A0 =A0 =A0 =A0 bool wait_flag, bool posix_lck, int xid)
> =A0{
> @@ -1149,12 +1158,11 @@ cifs_getlk(struct file *file, struct file_loc=
k *flock, __u32 type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> =A0 =A0 =A0 =A0/* BB we could chain these into one lock request BB */
> - =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, current->tgid, le=
ngth,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_start, 0, =
1, type, 0, 0);
> + =A0 =A0 =A0 rc =3D cifs_mandatory_lock(xid, cfile, flock->fl_start,=
 length, type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01, 0=
, false);
> =A0 =A0 =A0 =A0if (rc =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, c=
urrent->tgid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0leng=
th, flock->fl_start, 1, 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type=
, 0, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_mandatory_lock(xid, cfile, =
flock->fl_start, length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0type, 0, 1, false);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_type =3D F_UNLCK;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Error unloc=
king previously locked "
> @@ -1167,13 +1175,13 @@ cifs_getlk(struct file *file, struct file_loc=
k *flock, __u32 type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, current->tgid, le=
ngth,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_start, 0, =
1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type | server->vals-=
>shared_lock_type, 0, 0);
> + =A0 =A0 =A0 rc =3D cifs_mandatory_lock(xid, cfile, flock->fl_start,=
 length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type=
 | server->vals->shared_lock_type, 1, 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fals=
e);
> =A0 =A0 =A0 =A0if (rc =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, c=
urrent->tgid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0leng=
th, flock->fl_start, 1, 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type=
 | server->vals->shared_lock_type, 0, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_mandatory_lock(xid, cfile, =
flock->fl_start, length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0type | server->vals->shared_lock_type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A00, 1, false);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_type =3D F_RDLCK;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Error unloc=
king previously locked "
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index af48a8b..ce27f86 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -60,8 +60,15 @@ send_nt_cancel(struct TCP_Server_Info *server, voi=
d *buf,
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +static bool
> +cifs_compare_fids(struct cifsFileInfo *ob1, struct cifsFileInfo *ob2=
)
> +{
> + =A0 =A0 =A0 return ob1->netfid =3D=3D ob2->netfid;
> +}
> +
> =A0struct smb_version_operations smb1_operations =3D {
> =A0 =A0 =A0 =A0.send_cancel =3D send_nt_cancel,
> + =A0 =A0 =A0 .compare_fids =3D cifs_compare_fids,
> =A0};
>
> =A0struct smb_version_values smb1_values =3D {
> --
> 1.7.1
>

Steve, can you replace the patch in your 'for-next' branch with this on=
e?

I have the equivalent of you 'for-next' branch with new version of
this patch here:
http://git.altlinux.org/people/piastry/public/?p=3Dcifs-2.6.git;a=3Dsho=
rtlog;h=3Drefs/heads/cifs-patches-new

--=20
Best regards,
Pavel Shilovsky.
