From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v4 4/5] CIFS: Separate protocol specific part from getlk
Date: Thu, 17 May 2012 13:06:20 +0400
Message-ID: <CAKywueR90VQ03OwKsq=iKBsEFvCXp1m-EYM5uVCH5Hz8=J+U1A@mail.gmail.com>
References: <1337162254-13121-1-git-send-email-piastry@etersoft.ru>
	<1337162254-13121-5-git-send-email-piastry@etersoft.ru>
	<20120516142901.559ac0c6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120516142901.559ac0c6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/16 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, 16 May 2012 13:57:33 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h | =A0 =A02 ++
>> =A0fs/cifs/file.c =A0 =A0 | =A0 52 ++++++++++++++++++++++++++++++---=
-------------------
>> =A0fs/cifs/smb1ops.c =A0| =A0 =A07 +++++++
>> =A03 files changed, 39 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 6943448..b6e97f8 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -156,10 +156,12 @@ enum smb_version {
>>
>> =A0struct mid_q_entry;
>> =A0struct TCP_Server_Info;
>> +struct cifsFileInfo;
>>
>> =A0struct smb_version_operations {
>> =A0 =A0 =A0 int (*send_cancel)(struct TCP_Server_Info *, void *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct mid_q_entr=
y *);
>> + =A0 =A0 bool (*compare_fids)(struct cifsFileInfo *, struct cifsFil=
eInfo *);
>> =A0};
>>
>> =A0struct smb_version_values {
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index ac71f85..9c2d85d 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -671,7 +671,7 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
>>
>> =A0static bool
>> =A0cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 off=
set,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u8=
 type, __u16 netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u8=
 type, struct cifsFileInfo *cur,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockI=
nfo **conf_lock)
>> =A0{
>> =A0 =A0 =A0 struct cifsLockInfo *li;
>> @@ -682,8 +682,8 @@ cifs_find_fid_lock_conflict(struct cifsFileInfo =
*cfile, __u64 offset,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset >=3D li->offset + li->len=
gth)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if ((type & server->vals->shared_lo=
ck_type) &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((netfid =3D=3D cfile->=
netfid && current->tgid =3D=3D li->pid)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|| type =3D=3D li->type=
))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((server->ops->compare_=
fids(cur, cfile) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current->tgid =3D=3D=
 li->pid) || type =3D=3D li->type))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *conf_lock =3D li;
>> @@ -694,17 +694,17 @@ cifs_find_fid_lock_conflict(struct cifsFileInf=
o *cfile, __u64 offset,
>> =A0}
>>
>> =A0static bool
>> -cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u8 type, _=
_u16 netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo **conf=
_lock)
>> +cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset, _=
_u64 length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u8 type, struct cifsLock=
Info **conf_lock)
>> =A0{
>> =A0 =A0 =A0 bool rc =3D false;
>> =A0 =A0 =A0 struct cifsFileInfo *fid, *tmp;
>> + =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->d_i=
node);
>>
>> =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
>> =A0 =A0 =A0 list_for_each_entry_safe(fid, tmp, &cinode->openFileList=
, flist) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_find_fid_lock_conflict(fid, =
offset, length, type,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0netfid, conf_lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0cfile, conf_lock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 }
>> @@ -732,8 +732,8 @@ cifs_lock_test(struct cifsFileInfo *cfile, __u64=
 offset, __u64 length,
>>
>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>>
>> - =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, offset, length, =
type,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cfile->netfid, &conf_lock);
>> + =A0 =A0 exist =3D cifs_find_lock_conflict(cfile, offset, length, t=
ype,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &conf_lock);
>> =A0 =A0 =A0 if (exist) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_start =3D conf_lock->offset;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_end =3D conf_lock->offset + co=
nf_lock->length - 1;
>> @@ -779,8 +779,8 @@ try_again:
>> =A0 =A0 =A0 exist =3D false;
>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>>
>> - =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, lock->offset, lo=
ck->length,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 lock->type, cfile->netfid, &conf_lock);
>> + =A0 =A0 exist =3D cifs_find_lock_conflict(cfile, lock->offset, loc=
k->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 lock->type, &conf_lock);
>> =A0 =A0 =A0 if (!exist && cinode->can_cache_brlcks) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&lock->llist, &cfile->llis=
t);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&cinode->lock_mutex);
>> @@ -1117,6 +1117,15 @@ cifs_read_flock(struct file_lock *flock, __u3=
2 *type, int *lock, int *unlock,
>> =A0}
>>
>> =A0static int
>> +cifs_mandatory_lock(int xid, struct cifsFileInfo *cfile, __u64 offs=
et,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u32 type, int lock=
, int unlock, bool wait)
>> +{
>> + =A0 =A0 return CIFSSMBLock(xid, tlink_tcon(cfile->tlink), cfile->n=
etfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current->tgid, leng=
th, offset, unlock, lock,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(__u8)type, wait, 0=
);
>> +}
>> +
>> +static int
>> =A0cifs_getlk(struct file *file, struct file_lock *flock, __u32 type=
,
>> =A0 =A0 =A0 =A0 =A0bool wait_flag, bool posix_lck, int xid)
>> =A0{
>> @@ -1149,12 +1158,11 @@ cifs_getlk(struct file *file, struct file_lo=
ck *flock, __u32 type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> =A0 =A0 =A0 /* BB we could chain these into one lock request BB */
>> - =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, current->tgid, lengt=
h,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_start, 0, 1, =
type, 0, 0);
>> + =A0 =A0 rc =3D cifs_mandatory_lock(xid, cfile, flock->fl_start, le=
ngth, type,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01, 0, f=
alse);
>> =A0 =A0 =A0 if (rc =3D=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, curr=
ent->tgid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length,=
 flock->fl_start, 1, 0,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type, 0=
, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_mandatory_lock(xid, cfile, flo=
ck->fl_start, length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0type, 0, 1, false);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_type =3D F_UNLCK;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error unlocki=
ng previously locked "
>> @@ -1167,13 +1175,13 @@ cifs_getlk(struct file *file, struct file_lo=
ck *flock, __u32 type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, current->tgid, lengt=
h,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_start, 0, 1,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type | server->vals->sh=
ared_lock_type, 0, 0);
>> + =A0 =A0 rc =3D cifs_mandatory_lock(xid, cfile, flock->fl_start, le=
ngth,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type | =
server->vals->shared_lock_type, 1, 0,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0false);
>> =A0 =A0 =A0 if (rc =3D=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, curr=
ent->tgid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length,=
 flock->fl_start, 1, 0,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type | =
server->vals->shared_lock_type, 0, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_mandatory_lock(xid, cfile, flo=
ck->fl_start, length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0type | server->vals->shared_lock_type,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00, 1, false);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_type =3D F_RDLCK;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error unlocki=
ng previously locked "
>> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
>> index af48a8b..7565587 100644
>> --- a/fs/cifs/smb1ops.c
>> +++ b/fs/cifs/smb1ops.c
>> @@ -60,8 +60,15 @@ send_nt_cancel(struct TCP_Server_Info *server, vo=
id *buf,
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> +static inline bool
>> +cifs_compare_fids(struct cifsFileInfo *ob1, struct cifsFileInfo *ob=
2)
>> +{
>> + =A0 =A0 return ob1->netfid =3D=3D ob2->netfid;
>> +}
>> +
>> =A0struct smb_version_operations smb1_operations =3D {
>> =A0 =A0 =A0 .send_cancel =3D send_nt_cancel,
>> + =A0 =A0 .compare_fids =3D cifs_compare_fids,
>> =A0};
>>
>
> I don't think this will work. You can't get a pointer to a static
> inline, can you? Did this actually build?
>

But you are right - the compiler will just drop 'inline' in this case
- while we don't get this patch in the mainline I think it should be
respin.

--=20
Best regards,
Pavel Shilovsky.
