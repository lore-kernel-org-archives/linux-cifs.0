From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v3 1/5] CIFS: Move locks to cifsFileInfo structure
Date: Fri, 30 Mar 2012 16:03:03 +0400
Message-ID: <CAKywueR96=jtjbSUM5BFZY56egFqCxZNCEY9Uc06C1FzUpszWw@mail.gmail.com>
References: <1332848319-6483-1-git-send-email-piastry@etersoft.ru>
	<1332848319-6483-2-git-send-email-piastry@etersoft.ru>
	<20120329151345.1c66f659@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120329151345.1c66f659-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

29 =CD=C1=D2=D4=C1 2012=9A=C7. 23:13 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Tue, 27 Mar 2012 15:38:35 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> CIFS brlock cache can be used by several file handles if we have a
>> write-caching lease on the file that is supported by SMB2 protocol.
>> Prepate the code to handle this situation correctly by sorting brloc=
ks
>> by a fid to easily push them in portions when lease break comes.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>
> I'm not sure I understand this. It seems like keeping them all as par=
t
> of the inode would be simpler. How does it simplify things to put the=
m
> in separate per-FID buckets?
>
> I suppose one argument is that you could open the file twice and get =
2
> separate FIDs and 2 separate leases, and have different locks against
> each. Then the server might recall one lease but not the other. In th=
at
> case, you'd want to push out only the locks associated with that FID?
>
> Is that the main concern, or am I missing the point here?

Two FIDS will have the same lease and when lease break comes they have
to push their locks to the server. To make this process faster we can
send a chunk of locks in one request, as we already do for cifs
mandatory locks. If we have all FID's lock in one place we don't need
to tun over the whole inode lock list to create groups when oplock
break comes.

The only difference between CIFS and SMB2 is that in SMB2 lock_element
structure in lock request doesn't contain pid element (that exists for
CIFS), assuming that all locks from the request associated with pid
from the header. So to handle this right we need further to replace
cifsFileInfo lock list (introduced by this patch) with "pid_lock" list

struct pid_lock {
  struct list_head lock_list;
  pid_t pid;
}

that group FID's locks by pid.

>
>> ---
>> =9Afs/cifs/cifsfs.c =9A | =9A =9A1 -
>> =9Afs/cifs/cifsglob.h | =9A =9A3 +-
>> =9Afs/cifs/file.c =9A =9A | =9A 98 ++++++++++++++++++++++++++++++++-=
-------------------
>> =9A3 files changed, 61 insertions(+), 41 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index eee522c..3ac61a7 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -939,7 +939,6 @@ cifs_init_once(void *inode)
>> =9A =9A =9A struct cifsInodeInfo *cifsi =3D inode;
>>
>> =9A =9A =9A inode_init_once(&cifsi->vfs_inode);
>> - =9A =9A INIT_LIST_HEAD(&cifsi->llist);
>> =9A =9A =9A mutex_init(&cifsi->lock_mutex);
>> =9A}
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index d5ccd46..4e095ae 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -548,7 +548,6 @@ struct cifsLockInfo {
>> =9A =9A =9A __u64 length;
>> =9A =9A =9A __u32 pid;
>> =9A =9A =9A __u8 type;
>> - =9A =9A __u16 netfid;
>> =9A};
>>
>> =9A/*
>> @@ -573,6 +572,7 @@ struct cifs_search_info {
>> =9Astruct cifsFileInfo {
>> =9A =9A =9A struct list_head tlist; /* pointer to next fid owned by =
tcon */
>> =9A =9A =9A struct list_head flist; /* next fid (file instance) for =
this inode */
>> + =9A =9A struct list_head llist; /* brlocks held by this fid */
>
> It would be nice to comment that the above list is intended to be
> protected by the lock_mutex (right?)
>
>> =9A =9A =9A unsigned int uid; =9A =9A =9A /* allows finding which Fi=
leInfo structure */
>> =9A =9A =9A __u32 pid; =9A =9A =9A =9A =9A =9A =9A/* process id who =
opened file */
>> =9A =9A =9A __u16 netfid; =9A =9A =9A =9A =9A /* file id from remote=
 */
>> @@ -613,7 +613,6 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_=
file);
>> =9A */
>>
>> =9Astruct cifsInodeInfo {
>> - =9A =9A struct list_head llist; =9A =9A =9A =9A /* brlocks for thi=
s inode */
>> =9A =9A =9A bool can_cache_brlcks;
>> =9A =9A =9A struct mutex lock_mutex; =9A =9A =9A =9A/* protect two f=
ields above */
>> =9A =9A =9A /* BB add in lists for dirty pages i.e. write caching in=
fo for oplock */
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 2bf04e9..cc54033 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -264,6 +264,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file =
*file,
>> =9A =9A =9A pCifsFile->tlink =3D cifs_get_tlink(tlink);
>> =9A =9A =9A mutex_init(&pCifsFile->fh_mutex);
>> =9A =9A =9A INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
>> + =9A =9A INIT_LIST_HEAD(&pCifsFile->llist);
>>
>> =9A =9A =9A spin_lock(&cifs_file_list_lock);
>> =9A =9A =9A list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFil=
eList));
>> @@ -334,9 +335,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_=
file)
>> =9A =9A =9A =9A* is closed anyway.
>> =9A =9A =9A =9A*/
>> =9A =9A =9A mutex_lock(&cifsi->lock_mutex);
>> - =9A =9A list_for_each_entry_safe(li, tmp, &cifsi->llist, llist) {
>> - =9A =9A =9A =9A =9A =9A if (li->netfid !=3D cifs_file->netfid)
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue;
>> + =9A =9A list_for_each_entry_safe(li, tmp, &cifs_file->llist, llist=
) {
>> =9A =9A =9A =9A =9A =9A =9A list_del(&li->llist);
>> =9A =9A =9A =9A =9A =9A =9A cifs_del_lock_waiters(li);
>> =9A =9A =9A =9A =9A =9A =9A kfree(li);
>> @@ -645,7 +644,7 @@ int cifs_closedir(struct inode *inode, struct fi=
le *file)
>> =9A}
>>
>> =9Astatic struct cifsLockInfo *
>> -cifs_lock_init(__u64 offset, __u64 length, __u8 type, __u16 netfid)
>> +cifs_lock_init(__u64 offset, __u64 length, __u8 type)
>> =9A{
>> =9A =9A =9A struct cifsLockInfo *lock =3D
>> =9A =9A =9A =9A =9A =9A =9A kmalloc(sizeof(struct cifsLockInfo), GFP=
_KERNEL);
>> @@ -654,7 +653,6 @@ cifs_lock_init(__u64 offset, __u64 length, __u8 =
type, __u16 netfid)
>> =9A =9A =9A lock->offset =3D offset;
>> =9A =9A =9A lock->length =3D length;
>> =9A =9A =9A lock->type =3D type;
>> - =9A =9A lock->netfid =3D netfid;
>> =9A =9A =9A lock->pid =3D current->tgid;
>> =9A =9A =9A INIT_LIST_HEAD(&lock->blist);
>> =9A =9A =9A init_waitqueue_head(&lock->block_q);
>> @@ -687,19 +685,19 @@ cifs_locks_delete_block(struct file_lock *wait=
er)
>> =9A}
>>
>> =9Astatic bool
>> -__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offse=
t,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A __u64 length, __u8 type, _=
_u16 netfid,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A struct cifsLockInfo **conf=
_lock)
>> +__cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 off=
set,
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A __u64 length, =
__u8 type, __u16 netfid,
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A struct cifsLoc=
kInfo **conf_lock)
>> =9A{
>> =9A =9A =9A struct cifsLockInfo *li, *tmp;
>>
>> - =9A =9A list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
>> + =9A =9A list_for_each_entry_safe(li, tmp, &cfile->llist, llist) {
>
> list_for_each_entry should be fine here since you're not doing
> gets/puts on these entries as you go.
>
>> =9A =9A =9A =9A =9A =9A =9A if (offset + length <=3D li->offset ||
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A offset >=3D li->offset + li->len=
gth)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue;
>> =9A =9A =9A =9A =9A =9A =9A else if ((type & LOCKING_ANDX_SHARED_LOC=
K) &&
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A((netfid =3D=3D li->net=
fid && current->tgid =3D=3D li->pid) ||
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A type =3D=3D li->type))
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A((netfid =3D=3D cfile->=
netfid && current->tgid =3D=3D li->pid)
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A|| type =3D=3D li->type=
))
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue;
>> =9A =9A =9A =9A =9A =9A =9A else {
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A *conf_lock =3D li;
>> @@ -710,11 +708,36 @@ __cifs_find_lock_conflict(struct cifsInodeInfo=
 *cinode, __u64 offset,
>> =9A}
>>
>> =9Astatic bool
>> +__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offse=
t,
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A __u64 length, __u8 typ=
e, __u16 netfid,
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A struct cifsLockInfo **=
conf_lock)
>> +{
>> + =9A =9A bool rc;
>> + =9A =9A struct cifsFileInfo *fid, *tmp;
>> +
>> + =9A =9A spin_lock(&cifs_file_list_lock);
>> + =9A =9A list_for_each_entry_safe(fid, tmp, &cinode->openFileList, =
flist) {
>> + =9A =9A =9A =9A =9A =9A cifsFileInfo_get(fid);
>> + =9A =9A =9A =9A =9A =9A spin_unlock(&cifs_file_list_lock);
>
> NAK. list_for_each_entry_safe only protects you from removing the
> current entry of the list by preloading the next entry into "tmp". It=
's
> possible (even likely) that while this code is running, another threa=
d
> could do the final cifsFileInfo_put on the entry that has already bee=
n
> preloaded into "tmp" and cause an oops or worse.

Yes, makes sense. Thanks!

>
>> + =9A =9A =9A =9A =9A =9A rc =3D __cifs_find_fid_lock_conflict(fid, =
offset, length, type,
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9A =9A =9A =9A =9A =9Anetfid, conf_lock);
>> + =9A =9A =9A =9A =9A =9A cifsFileInfo_put(fid);
>> + =9A =9A =9A =9A =9A =9A if (rc)
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A return rc;
>> + =9A =9A =9A =9A =9A =9A spin_lock(&cifs_file_list_lock);
>> + =9A =9A }
>> + =9A =9A spin_unlock(&cifs_file_list_lock);
>> +
>> + =9A =9A return false;
>> +}
>> +
>> +static bool
>> =9Acifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifs=
LockInfo *lock,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A struct cifsLockInfo **conf=
_lock)
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A __u16 netfid, struct cifsL=
ockInfo **conf_lock)
>
> Do we really need this wrapper? There's only one caller of
> cifs_find_lock_conflict, AFAICT.

This makes a caller code smarter, I think.

>
>> =9A{
>> +
>> =9A =9A =9A return __cifs_find_lock_conflict(cinode, lock->offset, l=
ock->length,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9Alock->type, lock->netfid, conf_lock);
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9Alock->type, netfid, conf_lock);
>> =9A}
>>
>> =9A/*
>> @@ -725,17 +748,18 @@ cifs_find_lock_conflict(struct cifsInodeInfo *=
cinode, struct cifsLockInfo *lock,
>> =9A * the server or 1 otherwise.
>> =9A */
>> =9Astatic int
>> -cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 le=
ngth,
>> - =9A =9A =9A =9A =9A =9A__u8 type, __u16 netfid, struct file_lock *=
flock)
>> +cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 leng=
th,
>> + =9A =9A =9A =9A =9A =9A__u8 type, struct file_lock *flock)
>> =9A{
>> =9A =9A =9A int rc =3D 0;
>> =9A =9A =9A struct cifsLockInfo *conf_lock;
>> + =9A =9A struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->d_i=
node);
>> =9A =9A =9A bool exist;
>>
>> =9A =9A =9A mutex_lock(&cinode->lock_mutex);
>>
>> - =9A =9A exist =3D __cifs_find_lock_conflict(cinode, offset, length=
, type, netfid,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9A &conf_lock);
>> + =9A =9A exist =3D __cifs_find_lock_conflict(cinode, offset, length=
, type,
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9A cfile->netfid, &conf_lock);
>> =9A =9A =9A if (exist) {
>> =9A =9A =9A =9A =9A =9A =9A flock->fl_start =3D conf_lock->offset;
>> =9A =9A =9A =9A =9A =9A =9A flock->fl_end =3D conf_lock->offset + co=
nf_lock->length - 1;
>> @@ -754,10 +778,11 @@ cifs_lock_test(struct cifsInodeInfo *cinode, _=
_u64 offset, __u64 length,
>> =9A}
>>
>> =9Astatic void
>> -cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *lo=
ck)
>> +cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock=
)
>> =9A{
>> + =9A =9A struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->d_i=
node);
>> =9A =9A =9A mutex_lock(&cinode->lock_mutex);
>> - =9A =9A list_add_tail(&lock->llist, &cinode->llist);
>> + =9A =9A list_add_tail(&lock->llist, &cfile->llist);
>> =9A =9A =9A mutex_unlock(&cinode->lock_mutex);
>> =9A}
>>
>> @@ -768,10 +793,11 @@ cifs_lock_add(struct cifsInodeInfo *cinode, st=
ruct cifsLockInfo *lock)
>> =9A * 3) -EACCESS, if there is a lock that prevents us and wait is f=
alse.
>> =9A */
>> =9Astatic int
>> -cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo =
*lock,
>> +cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *l=
ock,
>> =9A =9A =9A =9A =9A =9A =9A =9Abool wait)
>> =9A{
>> =9A =9A =9A struct cifsLockInfo *conf_lock;
>> + =9A =9A struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->d_i=
node);
>> =9A =9A =9A bool exist;
>> =9A =9A =9A int rc =3D 0;
>>
>> @@ -779,9 +805,10 @@ try_again:
>> =9A =9A =9A exist =3D false;
>> =9A =9A =9A mutex_lock(&cinode->lock_mutex);
>>
>> - =9A =9A exist =3D cifs_find_lock_conflict(cinode, lock, &conf_lock=
);
>> + =9A =9A exist =3D cifs_find_lock_conflict(cinode, lock, cfile->net=
fid,
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A &conf_lock);
>> =9A =9A =9A if (!exist && cinode->can_cache_brlcks) {
>> - =9A =9A =9A =9A =9A =9A list_add_tail(&lock->llist, &cinode->llist=
);
>> + =9A =9A =9A =9A =9A =9A list_add_tail(&lock->llist, &cfile->llist)=
;
>> =9A =9A =9A =9A =9A =9A =9A mutex_unlock(&cinode->lock_mutex);
>> =9A =9A =9A =9A =9A =9A =9A return rc;
>> =9A =9A =9A }
>> @@ -928,7 +955,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *c=
file)
>> =9A =9A =9A for (i =3D 0; i < 2; i++) {
>> =9A =9A =9A =9A =9A =9A =9A cur =3D buf;
>> =9A =9A =9A =9A =9A =9A =9A num =3D 0;
>> - =9A =9A =9A =9A =9A =9A list_for_each_entry_safe(li, tmp, &cinode-=
>llist, llist) {
>> + =9A =9A =9A =9A =9A =9A list_for_each_entry_safe(li, tmp, &cfile->=
llist, llist) {
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (li->type !=3D types[=
i])
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue=
;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cur->Pid =3D cpu_to_le16=
(li->pid);
>> @@ -1144,7 +1171,6 @@ cifs_getlk(struct file *file, struct file_lock=
 *flock, __u8 type,
>> =9A =9A =9A __u64 length =3D 1 + flock->fl_end - flock->fl_start;
>> =9A =9A =9A struct cifsFileInfo *cfile =3D (struct cifsFileInfo *)fi=
le->private_data;
>> =9A =9A =9A struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
>> - =9A =9A struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->d_i=
node);
>> =9A =9A =9A __u16 netfid =3D cfile->netfid;
>>
>> =9A =9A =9A if (posix_lck) {
>> @@ -1164,8 +1190,7 @@ cifs_getlk(struct file *file, struct file_lock=
 *flock, __u8 type,
>> =9A =9A =9A =9A =9A =9A =9A return rc;
>> =9A =9A =9A }
>>
>> - =9A =9A rc =3D cifs_lock_test(cinode, flock->fl_start, length, typ=
e, netfid,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A flock);
>> + =9A =9A rc =3D cifs_lock_test(cfile, flock->fl_start, length, type=
, flock);
>> =9A =9A =9A if (!rc)
>> =9A =9A =9A =9A =9A =9A =9A return rc;
>>
>> @@ -1252,15 +1277,13 @@ cifs_unlock_range(struct cifsFileInfo *cfile=
, struct file_lock *flock, int xid)
>> =9A =9A =9A for (i =3D 0; i < 2; i++) {
>> =9A =9A =9A =9A =9A =9A =9A cur =3D buf;
>> =9A =9A =9A =9A =9A =9A =9A num =3D 0;
>> - =9A =9A =9A =9A =9A =9A list_for_each_entry_safe(li, tmp, &cinode-=
>llist, llist) {
>> + =9A =9A =9A =9A =9A =9A list_for_each_entry_safe(li, tmp, &cfile->=
llist, llist) {
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (flock->fl_start > li=
->offset ||
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A (flock->fl_start=
 + length) <
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A (li->offset + li=
->length))
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue=
;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (current->tgid !=3D l=
i->pid)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue=
;
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (cfile->netfid !=3D li-=
>netfid)
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (types[i] !=3D li->ty=
pe)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue=
;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (!cinode->can_cache_b=
rlcks) {
>> @@ -1273,7 +1296,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, =
struct file_lock *flock, int xid)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9A cpu_to_le32((u32)(li->offset>>32));
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A /*
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* We =
need to save a lock here to let us add
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* it ag=
ain to the inode list if the unlock
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* it ag=
ain to the file's list if the unlock
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* ran=
ge request fails on the server.
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A*/
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A list_mov=
e(&li->llist, &tmp_llist);
>> @@ -1287,10 +1310,10 @@ cifs_unlock_range(struct cifsFileInfo *cfile=
, struct file_lock *flock, int xid)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9A =9A =9A =9A =9A =9A* We failed on the unlock range
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9A =9A =9A =9A =9A =9A* request - add all locks from
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9A =9A =9A =9A =9A =9A* the tmp list to the head of
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9A =9A =9A =9A =9A* the inode list.
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9A =9A =9A =9A =9A* the file's list.
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9A =9A =9A =9A =9A =9A*/
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9A =9A =9A =9A =9A cifs_move_llist(&tmp_llist,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A &cinode->llist);
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A &cfile->llist);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9A =9A =9A =9A =9A rc =3D stored_rc;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9A } else
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9A =9A =9A =9A =9A /*
>> @@ -1305,7 +1328,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, =
struct file_lock *flock, int xid)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A } else {
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A /*
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* We =
can cache brlock requests - simply remove
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* a loc=
k from the inode list.
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* a loc=
k from the file's list.
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A*/
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A list_del=
(&li->llist);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_del=
_lock_waiters(li);
>> @@ -1316,7 +1339,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, =
struct file_lock *flock, int xid)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A stored_rc =3D cifs_lockv=
(xid, tcon, cfile->netfid,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9A =9A =9A =9A =9Atypes[i], num, 0, buf);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (stored_rc) {
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_move_=
llist(&tmp_llist, &cinode->llist);
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_move_=
llist(&tmp_llist, &cfile->llist);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A rc =3D s=
tored_rc;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A } else
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_fre=
e_llist(&tmp_llist);
>> @@ -1336,7 +1359,6 @@ cifs_setlk(struct file *file, =9Astruct file_l=
ock *flock, __u8 type,
>> =9A =9A =9A __u64 length =3D 1 + flock->fl_end - flock->fl_start;
>> =9A =9A =9A struct cifsFileInfo *cfile =3D (struct cifsFileInfo *)fi=
le->private_data;
>> =9A =9A =9A struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
>> - =9A =9A struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.dentr=
y->d_inode);
>> =9A =9A =9A __u16 netfid =3D cfile->netfid;
>>
>> =9A =9A =9A if (posix_lck) {
>> @@ -1363,11 +1385,11 @@ cifs_setlk(struct file *file, =9Astruct file=
_lock *flock, __u8 type,
>> =9A =9A =9A if (lock) {
>> =9A =9A =9A =9A =9A =9A =9A struct cifsLockInfo *lock;
>>
>> - =9A =9A =9A =9A =9A =9A lock =3D cifs_lock_init(flock->fl_start, l=
ength, type, netfid);
>> + =9A =9A =9A =9A =9A =9A lock =3D cifs_lock_init(flock->fl_start, l=
ength, type);
>> =9A =9A =9A =9A =9A =9A =9A if (!lock)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A return -ENOMEM;
>>
>> - =9A =9A =9A =9A =9A =9A rc =3D cifs_lock_add_if(cinode, lock, wait=
_flag);
>> + =9A =9A =9A =9A =9A =9A rc =3D cifs_lock_add_if(cfile, lock, wait_=
flag);
>> =9A =9A =9A =9A =9A =9A =9A if (rc < 0)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A kfree(lock);
>> =9A =9A =9A =9A =9A =9A =9A if (rc <=3D 0)
>> @@ -1380,7 +1402,7 @@ cifs_setlk(struct file *file, =9Astruct file_l=
ock *flock, __u8 type,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A goto out;
>> =9A =9A =9A =9A =9A =9A =9A }
>>
>> - =9A =9A =9A =9A =9A =9A cifs_lock_add(cinode, lock);
>> + =9A =9A =9A =9A =9A =9A cifs_lock_add(cfile, lock);
>> =9A =9A =9A } else if (unlock)
>> =9A =9A =9A =9A =9A =9A =9A rc =3D cifs_unlock_range(cfile, flock, x=
id);
>>
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Best regards,
Pavel Shilovsky.
