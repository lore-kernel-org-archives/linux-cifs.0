From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v4 1/5] CIFS: Move locks to cifsFileInfo structure
Date: Wed, 16 May 2012 22:56:24 +0400
Message-ID: <CAKywueSk_49zwnS0ayYXojZAdrk_upGfh-1a3cEPPA42a5N-cQ@mail.gmail.com>
References: <1337162254-13121-1-git-send-email-piastry@etersoft.ru>
	<1337162254-13121-2-git-send-email-piastry@etersoft.ru>
	<20120516141949.48f9de86@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120516141949.48f9de86-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/16 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, 16 May 2012 13:57:30 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> CIFS brlock cache can be used by several file handles if we have a
>> write-caching lease on the file that is supported by SMB2 protocol.
>> Prepate the code to handle this situation correctly by sorting brloc=
ks
>> by a fid to easily push them in portions when lease break comes.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c =A0 | =A0 =A01 -
>> =A0fs/cifs/cifsglob.h | =A0 12 +++++--
>> =A0fs/cifs/file.c =A0 =A0 | =A0 89 ++++++++++++++++++++++++++++-----=
------------------
>> =A03 files changed, 58 insertions(+), 44 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index ada9f07..50c603e 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -955,7 +955,6 @@ cifs_init_once(void *inode)
>> =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D inode;
>>
>> =A0 =A0 =A0 inode_init_once(&cifsi->vfs_inode);
>> - =A0 =A0 INIT_LIST_HEAD(&cifsi->llist);
>> =A0 =A0 =A0 mutex_init(&cifsi->lock_mutex);
>> =A0}
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index c41bf6d..03d24a5 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -568,7 +568,6 @@ struct cifsLockInfo {
>> =A0 =A0 =A0 __u64 length;
>> =A0 =A0 =A0 __u32 pid;
>> =A0 =A0 =A0 __u8 type;
>> - =A0 =A0 __u16 netfid;
>> =A0};
>>
>> =A0/*
>> @@ -593,6 +592,10 @@ struct cifs_search_info {
>> =A0struct cifsFileInfo {
>> =A0 =A0 =A0 struct list_head tlist; /* pointer to next fid owned by =
tcon */
>> =A0 =A0 =A0 struct list_head flist; /* next fid (file instance) for =
this inode */
>> + =A0 =A0 struct list_head llist; /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* brloc=
ks held by this fid, protected by
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* lock_=
mutex from cifsInodeInfo structure
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 unsigned int uid; =A0 =A0 =A0 /* allows finding which Fi=
leInfo structure */
>> =A0 =A0 =A0 __u32 pid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* process id who =
opened file */
>> =A0 =A0 =A0 __u16 netfid; =A0 =A0 =A0 =A0 =A0 /* file id from remote=
 */
>> @@ -635,9 +638,12 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs=
_file);
>> =A0 */
>>
>> =A0struct cifsInodeInfo {
>> - =A0 =A0 struct list_head llist; =A0 =A0 =A0 =A0 /* brlocks for thi=
s inode */
>> =A0 =A0 =A0 bool can_cache_brlcks;
>> - =A0 =A0 struct mutex lock_mutex; =A0 =A0 =A0 =A0/* protect two fie=
lds above */
>> + =A0 =A0 struct mutex lock_mutex; =A0 =A0 =A0 =A0/*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0* protect the field above and llist
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0* from every cifsFileInfo structure
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0* from openFileList
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0*/
>
> It seems rather ugly to have this mutex at the inode level. Given tha=
t
> most of what it protects hang off the cifsFileInfo, wouldn't it make
> more sense (and probably perform better) to have a per cifsFileInfo
> lock instead?
>
> That does mean that you'd need to reconsider how to handle this
> can_cache_brlocks flag though -- maybe atomic bitops are a possibilit=
y.

The idea of this lock is to protect locking on the inode. Moving locks
from inode structure to file structure only helps us to handle locking
easier when SMB2 comes: when lease break comes we need to flush all
brlocks to the server and we should flush them in groups to make this
process faster; if we have brlocks from one file handle in one place -
it's easier to flush them this way.

But there is another thing we should solve before getting it work:
several processes can obtain brlocks on the same file handle - so, we
need to group file handle's locks by pid too. That's why we will need
to sort locks by pid for every file handle - the work for further
patches.

>
>> =A0 =A0 =A0 /* BB add in lists for dirty pages i.e. write caching in=
fo for oplock */
>> =A0 =A0 =A0 struct list_head openFileList;
>> =A0 =A0 =A0 __u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compre=
ssed, system */
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 4b5fe39..fc45cd9 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -264,6 +264,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file =
*file,
>> =A0 =A0 =A0 pCifsFile->tlink =3D cifs_get_tlink(tlink);
>> =A0 =A0 =A0 mutex_init(&pCifsFile->fh_mutex);
>> =A0 =A0 =A0 INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
>> + =A0 =A0 INIT_LIST_HEAD(&pCifsFile->llist);
>>
>> =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
>> =A0 =A0 =A0 list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFil=
eList));
>> @@ -334,9 +335,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_=
file)
>> =A0 =A0 =A0 =A0* is closed anyway.
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 mutex_lock(&cifsi->lock_mutex);
>> - =A0 =A0 list_for_each_entry_safe(li, tmp, &cifsi->llist, llist) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (li->netfid !=3D cifs_file->netfid)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 list_for_each_entry_safe(li, tmp, &cifs_file->llist, llist=
) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&li->llist);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_del_lock_waiters(li);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(li);
>> @@ -645,7 +644,7 @@ int cifs_closedir(struct inode *inode, struct fi=
le *file)
>> =A0}
>>
>> =A0static struct cifsLockInfo *
>> -cifs_lock_init(__u64 offset, __u64 length, __u8 type, __u16 netfid)
>> +cifs_lock_init(__u64 offset, __u64 length, __u8 type)
>> =A0{
>> =A0 =A0 =A0 struct cifsLockInfo *lock =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kmalloc(sizeof(struct cifsLockInfo), GFP=
_KERNEL);
>> @@ -654,7 +653,6 @@ cifs_lock_init(__u64 offset, __u64 length, __u8 =
type, __u16 netfid)
>> =A0 =A0 =A0 lock->offset =3D offset;
>> =A0 =A0 =A0 lock->length =3D length;
>> =A0 =A0 =A0 lock->type =3D type;
>> - =A0 =A0 lock->netfid =3D netfid;
>> =A0 =A0 =A0 lock->pid =3D current->tgid;
>> =A0 =A0 =A0 INIT_LIST_HEAD(&lock->blist);
>> =A0 =A0 =A0 init_waitqueue_head(&lock->block_q);
>> @@ -672,19 +670,19 @@ cifs_del_lock_waiters(struct cifsLockInfo *loc=
k)
>> =A0}
>>
>> =A0static bool
>> -__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offse=
t,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u8 type, _=
_u16 netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo **conf=
_lock)
>> +cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offse=
t,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u8=
 type, __u16 netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInf=
o **conf_lock)
>> =A0{
>> - =A0 =A0 struct cifsLockInfo *li, *tmp;
>> + =A0 =A0 struct cifsLockInfo *li;
>>
>> - =A0 =A0 list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
>> + =A0 =A0 list_for_each_entry(li, &cfile->llist, llist) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (offset + length <=3D li->offset ||
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset >=3D li->offset + li->len=
gth)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if ((type & LOCKING_ANDX_SHARED_LOC=
K) &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((netfid =3D=3D li->net=
fid && current->tgid =3D=3D li->pid) ||
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 type =3D=3D li->type))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((netfid =3D=3D cfile->=
netfid && current->tgid =3D=3D li->pid)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|| type =3D=3D li->type=
))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *conf_lock =3D li;
>> @@ -695,11 +693,23 @@ __cifs_find_lock_conflict(struct cifsInodeInfo=
 *cinode, __u64 offset,
>> =A0}
>>
>> =A0static bool
>> -cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsLo=
ckInfo *lock,
>> +cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u8 type, _=
_u16 netfid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo **co=
nf_lock)
>> =A0{
>> - =A0 =A0 return __cifs_find_lock_conflict(cinode, lock->offset, loc=
k->length,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0lock->type, lock->netfid, conf_lock);
>> + =A0 =A0 bool rc =3D false;
>> + =A0 =A0 struct cifsFileInfo *fid, *tmp;
>> +
>> + =A0 =A0 spin_lock(&cifs_file_list_lock);
>> + =A0 =A0 list_for_each_entry_safe(fid, tmp, &cinode->openFileList, =
flist) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_find_fid_lock_conflict(fid, of=
fset, length, type,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0netfid, conf_lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 }
>> + =A0 =A0 spin_unlock(&cifs_file_list_lock);
>> +
>> + =A0 =A0 return rc;
>> =A0}
>>
>> =A0/*
>> @@ -710,17 +720,18 @@ cifs_find_lock_conflict(struct cifsInodeInfo *=
cinode, struct cifsLockInfo *lock,
>> =A0 * the server or 1 otherwise.
>> =A0 */
>> =A0static int
>> -cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 le=
ngth,
>> - =A0 =A0 =A0 =A0 =A0 =A0__u8 type, __u16 netfid, struct file_lock *=
flock)
>> +cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 leng=
th,
>> + =A0 =A0 =A0 =A0 =A0 =A0__u8 type, struct file_lock *flock)
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 struct cifsLockInfo *conf_lock;
>> + =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->d_i=
node);
>> =A0 =A0 =A0 bool exist;
>>
>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>>
>> - =A0 =A0 exist =3D __cifs_find_lock_conflict(cinode, offset, length=
, type, netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &conf_lock);
>> + =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, offset, length, =
type,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cfile->netfid, &conf_lock);
>> =A0 =A0 =A0 if (exist) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_start =3D conf_lock->offset;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_end =3D conf_lock->offset + co=
nf_lock->length - 1;
>> @@ -739,10 +750,11 @@ cifs_lock_test(struct cifsInodeInfo *cinode, _=
_u64 offset, __u64 length,
>> =A0}
>>
>> =A0static void
>> -cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *lo=
ck)
>> +cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock=
)
>> =A0{
>> + =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->d_i=
node);
>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>> - =A0 =A0 list_add_tail(&lock->llist, &cinode->llist);
>> + =A0 =A0 list_add_tail(&lock->llist, &cfile->llist);
>> =A0 =A0 =A0 mutex_unlock(&cinode->lock_mutex);
>> =A0}
>>
>> @@ -753,10 +765,11 @@ cifs_lock_add(struct cifsInodeInfo *cinode, st=
ruct cifsLockInfo *lock)
>> =A0 * 3) -EACCESS, if there is a lock that prevents us and wait is f=
alse.
>> =A0 */
>> =A0static int
>> -cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo =
*lock,
>> +cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *l=
ock,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool wait)
>> =A0{
>> =A0 =A0 =A0 struct cifsLockInfo *conf_lock;
>> + =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->d_i=
node);
>> =A0 =A0 =A0 bool exist;
>> =A0 =A0 =A0 int rc =3D 0;
>>
>> @@ -764,9 +777,10 @@ try_again:
>> =A0 =A0 =A0 exist =3D false;
>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>>
>> - =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, lock, &conf_lock=
);
>> + =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, lock->offset, lo=
ck->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 lock->type, cfile->netfid, &conf_lock);
>> =A0 =A0 =A0 if (!exist && cinode->can_cache_brlcks) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&lock->llist, &cinode->llist=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&lock->llist, &cfile->llist)=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&cinode->lock_mutex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>> @@ -888,7 +902,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *c=
file)
>> =A0 =A0 =A0 for (i =3D 0; i < 2; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur =3D buf;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 num =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(li, tmp, &cinode-=
>llist, llist) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(li, tmp, &cfile->=
llist, llist) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (li->type !=3D types[=
i])
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur->Pid =3D cpu_to_le16=
(li->pid);
>> @@ -1104,7 +1118,6 @@ cifs_getlk(struct file *file, struct file_lock=
 *flock, __u8 type,
>> =A0 =A0 =A0 __u64 length =3D 1 + flock->fl_end - flock->fl_start;
>> =A0 =A0 =A0 struct cifsFileInfo *cfile =3D (struct cifsFileInfo *)fi=
le->private_data;
>> =A0 =A0 =A0 struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
>> - =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry->d_i=
node);
>> =A0 =A0 =A0 __u16 netfid =3D cfile->netfid;
>>
>> =A0 =A0 =A0 if (posix_lck) {
>> @@ -1124,8 +1137,7 @@ cifs_getlk(struct file *file, struct file_lock=
 *flock, __u8 type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D cifs_lock_test(cinode, flock->fl_start, length, typ=
e, netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock);
>> + =A0 =A0 rc =3D cifs_lock_test(cfile, flock->fl_start, length, type=
, flock);
>> =A0 =A0 =A0 if (!rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> @@ -1212,15 +1224,13 @@ cifs_unlock_range(struct cifsFileInfo *cfile=
, struct file_lock *flock, int xid)
>> =A0 =A0 =A0 for (i =3D 0; i < 2; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur =3D buf;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 num =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(li, tmp, &cinode-=
>llist, llist) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(li, tmp, &cfile->=
llist, llist) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flock->fl_start > li=
->offset ||
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (flock->fl_start=
 + length) <
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (li->offset + li=
->length))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (current->tgid !=3D l=
i->pid)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cfile->netfid !=3D li-=
>netfid)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (types[i] !=3D li->ty=
pe)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!cinode->can_cache_b=
rlcks) {
>> @@ -1233,7 +1243,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, =
struct file_lock *flock, int xid)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cpu_to_le32((u32)(li->offset>>32));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We =
need to save a lock here to let us add
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* it ag=
ain to the inode list if the unlock
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* it ag=
ain to the file's list if the unlock
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ran=
ge request fails on the server.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_mov=
e(&li->llist, &tmp_llist);
>> @@ -1247,10 +1257,10 @@ cifs_unlock_range(struct cifsFileInfo *cfile=
, struct file_lock *flock, int xid)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0* We failed on the unlock range
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0* request - add all locks from
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0* the tmp list to the head of
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0* the inode list.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0* the file's list.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 cifs_move_llist(&tmp_llist,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &cinode->llist);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &cfile->llist);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 rc =3D stored_rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 /*
>> @@ -1265,7 +1275,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, =
struct file_lock *flock, int xid)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We =
can cache brlock requests - simply remove
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* a loc=
k from the inode list.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* a loc=
k from the file's list.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del=
(&li->llist);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_del=
_lock_waiters(li);
>> @@ -1276,7 +1286,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, =
struct file_lock *flock, int xid)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stored_rc =3D cifs_lockv=
(xid, tcon, cfile->netfid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0types[i], num, 0, buf);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (stored_rc) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_move_=
llist(&tmp_llist, &cinode->llist);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_move_=
llist(&tmp_llist, &cfile->llist);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D s=
tored_rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_fre=
e_llist(&tmp_llist);
>> @@ -1296,7 +1306,6 @@ cifs_setlk(struct file *file, =A0struct file_l=
ock *flock, __u8 type,
>> =A0 =A0 =A0 __u64 length =3D 1 + flock->fl_end - flock->fl_start;
>> =A0 =A0 =A0 struct cifsFileInfo *cfile =3D (struct cifsFileInfo *)fi=
le->private_data;
>> =A0 =A0 =A0 struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
>> - =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.dentr=
y->d_inode);
>> =A0 =A0 =A0 __u16 netfid =3D cfile->netfid;
>>
>> =A0 =A0 =A0 if (posix_lck) {
>> @@ -1323,11 +1332,11 @@ cifs_setlk(struct file *file, =A0struct file=
_lock *flock, __u8 type,
>> =A0 =A0 =A0 if (lock) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo *lock;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 lock =3D cifs_lock_init(flock->fl_start, l=
ength, type, netfid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 lock =3D cifs_lock_init(flock->fl_start, l=
ength, type);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!lock)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add_if(cinode, lock, wait=
_flag);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add_if(cfile, lock, wait_=
flag);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(lock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc <=3D 0)
>> @@ -1340,7 +1349,7 @@ cifs_setlk(struct file *file, =A0struct file_l=
ock *flock, __u8 type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_lock_add(cinode, lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_lock_add(cfile, lock);
>> =A0 =A0 =A0 } else if (unlock)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_unlock_range(cfile, flock, x=
id);
>>
>
> Regardless, I'm inclined to ACK this just so that we can move this
> along. Perhaps we can clean up the locking to be more granular later?
>
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Yes, I think it may be easier and we will try several approaches
before getting it clean. Thanks for the review!

--=20
Best regards,
Pavel Shilovsky.
