From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 2/3] CIFS: Simplify setlk error handling for mandatory locking
Date: Mon, 31 Oct 2011 13:59:34 +0300
Message-ID: <CAKywueR3FCDrM5emak5=JDY9Tj0HFTqHwXpNfP99-i76j_V6jw@mail.gmail.com>
References: <1319894279-7723-1-git-send-email-piastry@etersoft.ru>
	<1319894279-7723-2-git-send-email-piastry@etersoft.ru>
	<20111031065444.6214d49a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111031065444.6214d49a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/31 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Sat, 29 Oct 2011 17:17:58 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Now we allocate a lock structure at first, then we request to the se=
rver
>> and save the lock if server returned OK though void function - it pr=
events
>> the situation when we locked a file on the server and then return -E=
NOMEM
>> from setlk.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/file.c | =A0 64 ++++++++++++++++++++++++++++-------------=
---------------
>> =A01 files changed, 32 insertions(+), 32 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index c1f063c..d9cc07f 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -672,7 +672,7 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
>> =A0}
>>
>> =A0static bool
>> -cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
>> +__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offse=
t,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u8 type,=
 __u16 netfid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo **co=
nf_lock)
>> =A0{
>> @@ -694,6 +694,14 @@ cifs_find_lock_conflict(struct cifsInodeInfo *c=
inode, __u64 offset,
>> =A0 =A0 =A0 return false;
>> =A0}
>>
>> +static bool
>> +cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsLo=
ckInfo *lock,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo **conf=
_lock)
>> +{
>> + =A0 =A0 return __cifs_find_lock_conflict(cinode, lock->offset, loc=
k->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0lock->type, lock->netfid, conf_lock);
>> +}
>> +
>> =A0static int
>> =A0cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 =
length,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0__u8 type, __u16 netfid, struct file_lock=
 *flock)
>> @@ -704,8 +712,8 @@ cifs_lock_test(struct cifsInodeInfo *cinode, __u=
64 offset, __u64 length,
>>
>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>>
>> - =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, offset, length, =
type, netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &conf_lock);
>> + =A0 =A0 exist =3D __cifs_find_lock_conflict(cinode, offset, length=
, type, netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &conf_lock);
>> =A0 =A0 =A0 if (exist) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_start =3D conf_lock->offset;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_end =3D conf_lock->offset + co=
nf_lock->length - 1;
>> @@ -723,40 +731,27 @@ cifs_lock_test(struct cifsInodeInfo *cinode, _=
_u64 offset, __u64 length,
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -static int
>> -cifs_lock_add(struct cifsInodeInfo *cinode, __u64 len, __u64 offset=
,
>> - =A0 =A0 =A0 =A0 =A0 __u8 type, __u16 netfid)
>> +static void
>> +cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *lo=
ck)
>> =A0{
>> - =A0 =A0 struct cifsLockInfo *li;
>> -
>> - =A0 =A0 li =3D cifs_lock_init(len, offset, type, netfid);
>> - =A0 =A0 if (!li)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> -
>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>> - =A0 =A0 list_add_tail(&li->llist, &cinode->llist);
>> + =A0 =A0 list_add_tail(&lock->llist, &cinode->llist);
>> =A0 =A0 =A0 mutex_unlock(&cinode->lock_mutex);
>> - =A0 =A0 return 0;
>> =A0}
>>
>> =A0static int
>> -cifs_lock_add_if(struct cifsInodeInfo *cinode, __u64 offset, __u64 =
length,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0__u8 type, __u16 netfid, bool wait)
>> +cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo =
*lock,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0bool wait)
>> =A0{
>> - =A0 =A0 struct cifsLockInfo *lock, *conf_lock;
>> + =A0 =A0 struct cifsLockInfo *conf_lock;
>> =A0 =A0 =A0 bool exist;
>> =A0 =A0 =A0 int rc =3D 0;
>>
>> - =A0 =A0 lock =3D cifs_lock_init(length, offset, type, netfid);
>> - =A0 =A0 if (!lock)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> -
>> =A0try_again:
>> =A0 =A0 =A0 exist =3D false;
>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>>
>> - =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, offset, length, =
type, netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &conf_lock);
>> + =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, lock, &conf_lock=
);
>> =A0 =A0 =A0 if (!exist && cinode->can_cache_brlcks) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&lock->llist, &cinode->lli=
st);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&cinode->lock_mutex);
>> @@ -781,7 +776,6 @@ try_again:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 kfree(lock);
>> =A0 =A0 =A0 mutex_unlock(&cinode->lock_mutex);
>> =A0 =A0 =A0 return rc;
>> =A0}
>> @@ -1254,20 +1248,26 @@ cifs_setlk(struct file *file, =A0struct file=
_lock *flock, __u8 type,
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 if (lock) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add_if(cinode, flock->fl_=
start, length,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 type, netfid, wait_flag);
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo *lock;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 lock =3D cifs_lock_init(length, flock->fl_=
start, type, netfid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!lock)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add_if(cinode, lock, wait=
_flag);
>
> Here, you're adding "lock" to the list...

If we added the lock to the list cifs_lock_add_if returns 0 and we
will jump to out label.

>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> - =A0 =A0 =A0 =A0 =A0 =A0 else if (!rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc <=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, cu=
rrent->tgid, length,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock=
->fl_start, 0, 1, type, wait_flag, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* For Windows locks we mu=
st store them. */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add(cinod=
e, length, flock->fl_start,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0type, netfid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(lock);
>
> ...and here you're freeing "lock" without removing it from the list.
> Isn't that like to cause a problem?

So, if CIFSSMBLock returns a error we free the lock that hasn't been
added to the list. If CIFSSMBLock returns ok, we will add it to the
list with cifs_lock_add void function.

Seems no problem with it.

--=20
Best regards,
Pavel Shilovsky.
