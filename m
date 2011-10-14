From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [v3 PATCH 1/6] CIFS: Simplify byte range locking code
Date: Fri, 14 Oct 2011 16:14:54 +0400
Message-ID: <CAKywueR_p_Z0ep9No4bLYVkB7ztv9VAQWhdUaZpvyxZegkanrQ@mail.gmail.com>
References: <1318016059-29306-1-git-send-email-piastry@etersoft.ru>
	<1318016059-29306-2-git-send-email-piastry@etersoft.ru>
	<20111014071702.09802e65@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111014071702.09802e65-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/14 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, =A07 Oct 2011 23:34:14 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Split cifs_lock into several functions and let CIFSSMBLock get pid
>> as an argument.
>>
>
> In general, this sort of thing should be 2 patches. One to split up t=
he
> function (with no behavioral changes) and one to add the pid arg.
>
> It's very hard to review this otherwise since the behavioral change i=
s
> commingled with the cleanup.

Sorry, will keep it in mind for the future.

>
> Also, it's not clear to me why you're adding the pid here. What good
> does that do?

We will use pid field with brlock cache to set the owner of the lock
while pushing locks on oplock break. It's a preparation for the
further changes.

>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h =A0| =A0 =A01 +
>> =A0fs/cifs/cifsproto.h | =A0 =A02 +-
>> =A0fs/cifs/cifssmb.c =A0 | =A0 =A04 +-
>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0370 ++++++++++++++++++++++++++++--=
---------------------
>> =A04 files changed, 205 insertions(+), 172 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 95dad9d..84b0dd1 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -487,6 +487,7 @@ struct cifsLockInfo {
>> =A0 =A0 =A0 struct list_head llist; /* pointer to next cifsLockInfo =
*/
>> =A0 =A0 =A0 __u64 offset;
>> =A0 =A0 =A0 __u64 length;
>> + =A0 =A0 __u32 pid;
>> =A0 =A0 =A0 __u8 type;
>> =A0};
>>
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 8df28e9..0d57080 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -360,7 +360,7 @@ extern int CIFSGetSrvInodeNumber(const int xid, =
struct cifs_tcon *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int remap_special_chars)=
;
>>
>> =A0extern int CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u16 netfid, const =
__u64 len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u16 netfid, const =
__u32 netpid, const __u64 len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 offset, cons=
t __u32 numUnlock,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u32 numLock, con=
st __u8 lockType,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const bool waitFlag, con=
st __u8 oplock_level);
>
> That argument list is getting to be very long. Perhaps it's time to
> bundle them up into a struct?

Yes, good idea. Steve has already merged this - so, I think it will be
another patch.

>
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index aac37d9..b79d7fd 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -1965,7 +1965,7 @@ CIFSSMBWrite2(const int xid, struct cifs_io_pa=
rms *io_parms,
>>
>> =A0int
>> =A0CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
>> - =A0 =A0 =A0 =A0 const __u16 smb_file_id, const __u64 len,
>> + =A0 =A0 =A0 =A0 const __u16 smb_file_id, const __u32 netpid, const=
 __u64 len,
>> =A0 =A0 =A0 =A0 =A0 const __u64 offset, const __u32 numUnlock,
>> =A0 =A0 =A0 =A0 =A0 const __u32 numLock, const __u8 lockType,
>> =A0 =A0 =A0 =A0 =A0 const bool waitFlag, const __u8 oplock_level)
>> @@ -2001,7 +2001,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *t=
con,
>> =A0 =A0 =A0 pSMB->Fid =3D smb_file_id; /* netfid stays le */
>>
>> =A0 =A0 =A0 if ((numLock !=3D 0) || (numUnlock !=3D 0)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 pSMB->Locks[0].Pid =3D cpu_to_le16(current=
->tgid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 pSMB->Locks[0].Pid =3D cpu_to_le16(netpid)=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB where to store pid high? */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->Locks[0].LengthLow =3D cpu_to_le32=
((u32)len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->Locks[0].LengthHigh =3D cpu_to_le3=
2((u32)(len>>32));
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 9f41a10..90e1720 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -631,8 +631,8 @@ int cifs_closedir(struct inode *inode, struct fi=
le *file)
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -static int store_file_lock(struct cifsFileInfo *fid, __u64 len,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 offs=
et, __u8 lockType)
>> +static int store_file_lock(struct cifsFileInfo *cfile, __u64 len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u64 offset, __u8 =
type, __u16 netfid)
>> =A0{
>> =A0 =A0 =A0 struct cifsLockInfo *li =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kmalloc(sizeof(struct cifsLockInfo), GFP=
_KERNEL);
>> @@ -640,210 +640,241 @@ static int store_file_lock(struct cifsFileIn=
fo *fid, __u64 len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> =A0 =A0 =A0 li->offset =3D offset;
>> =A0 =A0 =A0 li->length =3D len;
>> - =A0 =A0 li->type =3D lockType;
>> - =A0 =A0 mutex_lock(&fid->lock_mutex);
>> - =A0 =A0 list_add(&li->llist, &fid->llist);
>> - =A0 =A0 mutex_unlock(&fid->lock_mutex);
>> + =A0 =A0 li->type =3D type;
>> + =A0 =A0 li->pid =3D current->tgid;
>> + =A0 =A0 mutex_lock(&cfile->lock_mutex);
>> + =A0 =A0 list_add_tail(&li->llist, &cfile->llist);
>> + =A0 =A0 mutex_unlock(&cfile->lock_mutex);
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> -int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
>> +static void
>> +cifs_read_flock(struct file_lock *flock, __u8 *type, int *lock, int=
 *unlock,
>> + =A0 =A0 =A0 =A0 =A0 =A0 bool *wait_flag)
>> =A0{
>> - =A0 =A0 int rc, xid;
>> - =A0 =A0 __u32 numLock =3D 0;
>> - =A0 =A0 __u32 numUnlock =3D 0;
>> - =A0 =A0 __u64 length;
>> - =A0 =A0 bool wait_flag =3D false;
>> - =A0 =A0 struct cifs_sb_info *cifs_sb;
>> - =A0 =A0 struct cifs_tcon *tcon;
>> - =A0 =A0 __u16 netfid;
>> - =A0 =A0 __u8 lockType =3D LOCKING_ANDX_LARGE_FILES;
>> - =A0 =A0 bool posix_locking =3D 0;
>> -
>> - =A0 =A0 length =3D 1 + pfLock->fl_end - pfLock->fl_start;
>> - =A0 =A0 rc =3D -EACCES;
>> - =A0 =A0 xid =3D GetXid();
>> -
>> - =A0 =A0 cFYI(1, "Lock parm: 0x%x flockflags: "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0"0x%x flocktype: 0x%x start: %lld end: =
%lld",
>> - =A0 =A0 =A0 =A0 =A0 =A0 cmd, pfLock->fl_flags, pfLock->fl_type, pf=
Lock->fl_start,
>> - =A0 =A0 =A0 =A0 =A0 =A0 pfLock->fl_end);
>> -
>> - =A0 =A0 if (pfLock->fl_flags & FL_POSIX)
>> + =A0 =A0 if (flock->fl_flags & FL_POSIX)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Posix");
>> - =A0 =A0 if (pfLock->fl_flags & FL_FLOCK)
>> + =A0 =A0 if (flock->fl_flags & FL_FLOCK)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Flock");
>> - =A0 =A0 if (pfLock->fl_flags & FL_SLEEP) {
>> + =A0 =A0 if (flock->fl_flags & FL_SLEEP) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Blocking lock");
>> - =A0 =A0 =A0 =A0 =A0 =A0 wait_flag =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 *wait_flag =3D true;
>> =A0 =A0 =A0 }
>> - =A0 =A0 if (pfLock->fl_flags & FL_ACCESS)
>> + =A0 =A0 if (flock->fl_flags & FL_ACCESS)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Process suspended by mandatory =
locking - "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"not implemented yet");
>> - =A0 =A0 if (pfLock->fl_flags & FL_LEASE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "not implemented yet");
>> + =A0 =A0 if (flock->fl_flags & FL_LEASE)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Lease on file - not implemented=
 yet");
>> - =A0 =A0 if (pfLock->fl_flags &
>> + =A0 =A0 if (flock->fl_flags &
>> =A0 =A0 =A0 =A0 =A0 (~(FL_POSIX | FL_FLOCK | FL_SLEEP | FL_ACCESS | =
=46L_LEASE)))
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Unknown lock flags 0x%x", pfLock-=
>fl_flags);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Unknown lock flags 0x%x", flock->=
fl_flags);
>>
>> - =A0 =A0 if (pfLock->fl_type =3D=3D F_WRLCK) {
>> + =A0 =A0 *type =3D LOCKING_ANDX_LARGE_FILES;
>> + =A0 =A0 if (flock->fl_type =3D=3D F_WRLCK) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "F_WRLCK ");
>> - =A0 =A0 =A0 =A0 =A0 =A0 numLock =3D 1;
>> - =A0 =A0 } else if (pfLock->fl_type =3D=3D F_UNLCK) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 *lock =3D 1;
>> + =A0 =A0 } else if (flock->fl_type =3D=3D F_UNLCK) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "F_UNLCK");
>> - =A0 =A0 =A0 =A0 =A0 =A0 numUnlock =3D 1;
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* Check if unlock includes more than
>> - =A0 =A0 =A0 =A0 =A0 =A0 one lock range */
>> - =A0 =A0 } else if (pfLock->fl_type =3D=3D F_RDLCK) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 *unlock =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* Check if unlock includes more than one =
lock range */
>> + =A0 =A0 } else if (flock->fl_type =3D=3D F_RDLCK) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "F_RDLCK");
>> - =A0 =A0 =A0 =A0 =A0 =A0 lockType |=3D LOCKING_ANDX_SHARED_LOCK;
>> - =A0 =A0 =A0 =A0 =A0 =A0 numLock =3D 1;
>> - =A0 =A0 } else if (pfLock->fl_type =3D=3D F_EXLCK) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 *type |=3D LOCKING_ANDX_SHARED_LOCK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 *lock =3D 1;
>> + =A0 =A0 } else if (flock->fl_type =3D=3D F_EXLCK) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "F_EXLCK");
>> - =A0 =A0 =A0 =A0 =A0 =A0 numLock =3D 1;
>> - =A0 =A0 } else if (pfLock->fl_type =3D=3D F_SHLCK) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 *lock =3D 1;
>> + =A0 =A0 } else if (flock->fl_type =3D=3D F_SHLCK) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "F_SHLCK");
>> - =A0 =A0 =A0 =A0 =A0 =A0 lockType |=3D LOCKING_ANDX_SHARED_LOCK;
>> - =A0 =A0 =A0 =A0 =A0 =A0 numLock =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 *type |=3D LOCKING_ANDX_SHARED_LOCK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 *lock =3D 1;
>> =A0 =A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Unknown type of lock");
>> +}
>>
>> - =A0 =A0 cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
>> - =A0 =A0 tcon =3D tlink_tcon(((struct cifsFileInfo *)file->private_=
data)->tlink);
>> - =A0 =A0 netfid =3D ((struct cifsFileInfo *)file->private_data)->ne=
tfid;
>> -
>> - =A0 =A0 if ((tcon->ses->capabilities & CAP_UNIX) &&
>> - =A0 =A0 =A0 =A0 (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInf=
o.Capability)) &&
>> - =A0 =A0 =A0 =A0 ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)=
 =3D=3D 0))
>> - =A0 =A0 =A0 =A0 =A0 =A0 posix_locking =3D 1;
>> - =A0 =A0 /* BB add code here to normalize offset and length to
>> - =A0 =A0 account for negative length which we can not accept over t=
he
>> - =A0 =A0 wire */
>> - =A0 =A0 if (IS_GETLK(cmd)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (posix_locking) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int posix_lock_type;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (lockType & LOCKING_AND=
X_SHARED_LOCK)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_lock=
_type =3D CIFS_RDLCK;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_lock=
_type =3D CIFS_WRLCK;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBPosixLock(xi=
d, tcon, netfid, 1 /* get */,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 length, pfLock, posix_lock_type,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 wait_flag);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* BB we could chain these into one lock r=
equest BB */
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, leng=
th, pfLock->fl_start,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00, 1, l=
ockType, 0 /* wait flag */, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tc=
on, netfid, length,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0pfLock->fl_start, 1 /* numUnlock */ ,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00 /* numLock */ , lockType,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00 /* wait flag */, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pfLock->fl_type =3D F_UNLC=
K;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, =
"Error unlocking previously locked "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0"range %d during test of lock", rc);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if rc =3D=3D ERR_SHARIN=
G_VIOLATION ? */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> +static int
>> +cifs_getlk(struct cifsFileInfo *cfile, struct file_lock *flock, __u=
8 type,
>> + =A0 =A0 =A0 =A0bool wait_flag, bool posix_lck, int xid)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 __u64 length =3D 1 + flock->fl_end - flock->fl_start;
>> + =A0 =A0 __u16 netfid =3D cfile->netfid;
>> + =A0 =A0 struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (lockType & LOCKING_AND=
X_SHARED_LOCK) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pfLock->fl=
_type =3D F_WRLCK;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIF=
SSMBLock(xid, tcon, netfid, length,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 pfLock->fl_start, 0, 1,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 lockType | LOCKING_ANDX_SHARED_LOCK,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 0 /* wait flag */, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=
=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 length, pfLock->fl_start, 1, 0,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 lockType |
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 LOCKING_ANDX_SHARED_LOCK,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 0 /* wait flag */, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 pfLock->fl_type =3D F_RDLCK;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (rc !=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error unlocking "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 "previously locked range %d "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 "during test of lock", rc);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 pfLock->fl_type =3D F_WRLCK;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 if (posix_lck) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 int posix_lock_type;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (type & LOCKING_ANDX_SHARED_LOCK)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_lock_type =3D CIFS_R=
DLCK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_lock_type =3D CIFS_W=
RLCK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBPosixLock(xid, tcon, netfid,=
 1 /* get */,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 length, flock, posix_lock_type,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 wait_flag);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> + =A0 =A0 /* BB we could chain these into one lock request BB */
>> + =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, current->tgid, lengt=
h,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_start, 0, 1, =
type, 0, 0);
>> + =A0 =A0 if (rc =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, curr=
ent->tgid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length,=
 flock->fl_start, 1, 0,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type, 0=
, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_type =3D F_UNLCK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error unlocking=
 previously locked "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"ra=
nge %d during test of lock", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 if (!numLock && !numUnlock) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* if no lock or unlock then nothing
>> - =A0 =A0 =A0 =A0 =A0 =A0 to do since we do not know what it is */
>> - =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
>> + =A0 =A0 if (type & LOCKING_ANDX_SHARED_LOCK) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_type =3D F_WRLCK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 if (posix_locking) {
>> + =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, current->tgid, lengt=
h,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_start, 0, 1,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type | LOCKING_ANDX_SHA=
RED_LOCK, 0, 0);
>> + =A0 =A0 if (rc =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, curr=
ent->tgid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length,=
 flock->fl_start, 1, 0,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type | =
LOCKING_ANDX_SHARED_LOCK,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_type =3D F_RDLCK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error unlocking=
 previously locked "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "range=
 %d during test of lock", rc);
>> + =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_type =3D F_WRLCK;
>> +
>> + =A0 =A0 rc =3D 0;
>> + =A0 =A0 return rc;
>> +}
>> +
>> +static int
>> +cifs_setlk(struct file *file, =A0struct file_lock *flock, __u8 type=
,
>> + =A0 =A0 =A0 =A0bool wait_flag, bool posix_lck, int lock, int unloc=
k, int xid)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 __u64 length =3D 1 + flock->fl_end - flock->fl_start;
>> + =A0 =A0 struct cifsFileInfo *cfile =3D (struct cifsFileInfo *)file=
->private_data;
>> + =A0 =A0 struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
>> + =A0 =A0 __u16 netfid =3D cfile->netfid;
>> +
>> + =A0 =A0 if (posix_lck) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int posix_lock_type;
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (lockType & LOCKING_ANDX_SHARED_LOCK)
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (type & LOCKING_ANDX_SHARED_LOCK)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_lock_type =3D CIFS=
_RDLCK;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_lock_type =3D CIFS=
_WRLCK;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (numUnlock =3D=3D 1)
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (unlock =3D=3D 1)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_lock_type =3D CIFS=
_UNLCK;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBPosixLock(xid, tcon, netfid,=
 0 /* set */,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 length, pfLock, posix_lock_type,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 wait_flag);
>> - =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 struct cifsFileInfo *fid =3D file->private=
_data;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (numLock) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tc=
on, netfid, length,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0pfLock->fl_start, 0, numLock, lockType,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0wait_flag, 0);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* For Win=
dows locks we must store them. */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D sto=
re_file_lock(fid, length,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 pfLock->fl_start, lockType);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else if (numUnlock) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* For each stored lock th=
at this unlock overlaps
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0completely, unlock =
it. */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int stored_rc =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo *li, *=
tmp;
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBPosixLock(xid, tcon, netfid,=
 0 /* set */, length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 flock, posix_lock_type, wait_flag);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&fid->lock_mute=
x);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(l=
i, tmp, &fid->llist, llist) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pfLock=
->fl_start <=3D li->offset &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 (pfLock->fl_start + length) >=3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 (li->offset + li->length)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 stored_rc =3D CIFSSMBLock(xid, tcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 netfid, li->length,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 li->offset, 1, 0,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 li->type, false, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (stored_rc)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 rc =3D stored_rc;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 list_del(&li->llist);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 kfree(li);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 if (lock) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, curr=
ent->tgid, length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->=
fl_start, 0, lock, type, wait_flag, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* For Windows locks we mu=
st store them. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D store_file_lock(cfi=
le, length, flock->fl_start,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0type, netfid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 } else if (unlock) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* For each stored lock that this unlock=
 overlaps completely,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* unlock it.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 int stored_rc =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo *li, *tmp;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&cfile->lock_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(li, tmp, &cfile->=
llist, llist) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flock->fl_start > li->=
offset ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (flock->fl_start +=
 length) <
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (li->offset + li->=
length))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (current->tgid !=3D li-=
>pid)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stored_rc =3D CIFSSMBLock(=
xid, tcon, netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 current->tgid, li->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 li->offset, 1, 0, li->type,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 0, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (stored_rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D sto=
red_rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&=
li->llist);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(li);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&fid->lock_mu=
tex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&cfile->lock_mutex);
>> + =A0 =A0 }
>> +out:
>> + =A0 =A0 if (flock->fl_flags & FL_POSIX)
>> + =A0 =A0 =A0 =A0 =A0 =A0 posix_lock_file_wait(file, flock);
>> + =A0 =A0 return rc;
>> +}
>> +
>> +int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
>> +{
>> + =A0 =A0 int rc, xid;
>> + =A0 =A0 int lock =3D 0, unlock =3D 0;
>> + =A0 =A0 bool wait_flag =3D false;
>> + =A0 =A0 bool posix_lck =3D false;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> + =A0 =A0 struct cifs_tcon *tcon;
>> + =A0 =A0 struct cifsInodeInfo *cinode;
>> + =A0 =A0 struct cifsFileInfo *cfile;
>> + =A0 =A0 __u16 netfid;
>> + =A0 =A0 __u8 type;
>> +
>> + =A0 =A0 rc =3D -EACCES;
>> + =A0 =A0 xid =3D GetXid();
>> +
>> + =A0 =A0 cFYI(1, "Lock parm: 0x%x flockflags: 0x%x flocktype: 0x%x =
start: %lld "
>> + =A0 =A0 =A0 =A0 =A0 =A0 "end: %lld", cmd, flock->fl_flags, flock->=
fl_type,
>> + =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_start, flock->fl_end);
>> +
>> + =A0 =A0 cifs_read_flock(flock, &type, &lock, &unlock, &wait_flag);
>> +
>> + =A0 =A0 cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
>> + =A0 =A0 cfile =3D (struct cifsFileInfo *)file->private_data;
>> + =A0 =A0 tcon =3D tlink_tcon(cfile->tlink);
>> + =A0 =A0 netfid =3D cfile->netfid;
>> + =A0 =A0 cinode =3D CIFS_I(file->f_path.dentry->d_inode);
>> +
>> + =A0 =A0 if ((tcon->ses->capabilities & CAP_UNIX) &&
>> + =A0 =A0 =A0 =A0 (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInf=
o.Capability)) &&
>> + =A0 =A0 =A0 =A0 ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)=
 =3D=3D 0))
>> + =A0 =A0 =A0 =A0 =A0 =A0 posix_lck =3D true;
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* BB add code here to normalize offset and length to ac=
count for
>> + =A0 =A0 =A0* negative length which we can not accept over the wire=
=2E
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (IS_GETLK(cmd)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_getlk(cfile, flock, type, wait=
_flag, posix_lck, xid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (!lock && !unlock) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* if no lock or unlock then nothing to =
do since we do not
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* know what it is
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 if (pfLock->fl_flags & FL_POSIX)
>> - =A0 =A0 =A0 =A0 =A0 =A0 posix_lock_file_wait(file, pfLock);
>> + =A0 =A0 rc =3D cifs_setlk(file, flock, type, wait_flag, posix_lck,=
 lock, unlock,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xid);
>> =A0 =A0 =A0 FreeXid(xid);
>> =A0 =A0 =A0 return rc;
>> =A0}
>> @@ -2415,8 +2446,9 @@ void cifs_oplock_break(struct work_struct *wor=
k)
>> =A0 =A0 =A0 =A0* disconnected since oplock already released by the s=
erver
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 if (!cfile->oplock_break_cancelled) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(0, tlink_tcon(cfile->tl=
ink), cfile->netfid, 0,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00, 0, 0=
, LOCKING_ANDX_OPLOCK_RELEASE, false,
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(0, tlink_tcon(cfile->tl=
ink), cfile->netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current=
->tgid, 0, 0, 0, 0,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0LOCKING=
_ANDX_OPLOCK_RELEASE, false,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cinod=
e->clientCanCacheRead ? 1 : 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Oplock release rc =3D %d", rc);
>> =A0 =A0 =A0 }
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Best regards,
Pavel Shilovsky.
