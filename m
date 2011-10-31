From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 2/3] CIFS: Simplify setlk error handling for mandatory locking
Date: Mon, 31 Oct 2011 14:04:00 +0300
Message-ID: <CAKywueRQE1VNj_YQPVwp9j1bQPX_8zNoD4c3hKyC9e_7=LBhbg@mail.gmail.com>
References: <1319894279-7723-1-git-send-email-piastry@etersoft.ru>
	<1319894279-7723-2-git-send-email-piastry@etersoft.ru>
	<20111031065444.6214d49a@tlielax.poochiereds.net>
	<CAKywueR3FCDrM5emak5=JDY9Tj0HFTqHwXpNfP99-i76j_V6jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueR3FCDrM5emak5=JDY9Tj0HFTqHwXpNfP99-i76j_V6jw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/31 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> 2011/10/31 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
>> On Sat, 29 Oct 2011 17:17:58 +0400
>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>
>>> Now we allocate a lock structure at first, then we request to the s=
erver
>>> and save the lock if server returned OK though void function - it p=
revents
>>> the situation when we locked a file on the server and then return -=
ENOMEM
>>> from setlk.
>>>
>>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>> ---
>>> =A0fs/cifs/file.c | =A0 64 ++++++++++++++++++++++++++++------------=
----------------
>>> =A01 files changed, 32 insertions(+), 32 deletions(-)
>>>
>>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>>> index c1f063c..d9cc07f 100644
>>> --- a/fs/cifs/file.c
>>> +++ b/fs/cifs/file.c
>>> @@ -672,7 +672,7 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock=
)
>>> =A0}
>>>
>>> =A0static bool
>>> -cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset=
,
>>> +__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offs=
et,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 length, __u8 type=
, __u16 netfid,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo **c=
onf_lock)
>>> =A0{
>>> @@ -694,6 +694,14 @@ cifs_find_lock_conflict(struct cifsInodeInfo *=
cinode, __u64 offset,
>>> =A0 =A0 =A0 return false;
>>> =A0}
>>>
>>> +static bool
>>> +cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsL=
ockInfo *lock,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo **con=
f_lock)
>>> +{
>>> + =A0 =A0 return __cifs_find_lock_conflict(cinode, lock->offset, lo=
ck->length,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0lock->type, lock->netfid, conf_lock);
>>> +}
>>> +
>>> =A0static int
>>> =A0cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64=
 length,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0__u8 type, __u16 netfid, struct file_loc=
k *flock)
>>> @@ -704,8 +712,8 @@ cifs_lock_test(struct cifsInodeInfo *cinode, __=
u64 offset, __u64 length,
>>>
>>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>>>
>>> - =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, offset, length,=
 type, netfid,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &conf_lock);
>>> + =A0 =A0 exist =3D __cifs_find_lock_conflict(cinode, offset, lengt=
h, type, netfid,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &conf_lock);
>>> =A0 =A0 =A0 if (exist) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_start =3D conf_lock->offset;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_end =3D conf_lock->offset + c=
onf_lock->length - 1;
>>> @@ -723,40 +731,27 @@ cifs_lock_test(struct cifsInodeInfo *cinode, =
__u64 offset, __u64 length,
>>> =A0 =A0 =A0 return rc;
>>> =A0}
>>>
>>> -static int
>>> -cifs_lock_add(struct cifsInodeInfo *cinode, __u64 len, __u64 offse=
t,
>>> - =A0 =A0 =A0 =A0 =A0 __u8 type, __u16 netfid)
>>> +static void
>>> +cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *l=
ock)
>>> =A0{
>>> - =A0 =A0 struct cifsLockInfo *li;
>>> -
>>> - =A0 =A0 li =3D cifs_lock_init(len, offset, type, netfid);
>>> - =A0 =A0 if (!li)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>>> -
>>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>>> - =A0 =A0 list_add_tail(&li->llist, &cinode->llist);
>>> + =A0 =A0 list_add_tail(&lock->llist, &cinode->llist);
>>> =A0 =A0 =A0 mutex_unlock(&cinode->lock_mutex);
>>> - =A0 =A0 return 0;
>>> =A0}
>>>
>>> =A0static int
>>> -cifs_lock_add_if(struct cifsInodeInfo *cinode, __u64 offset, __u64=
 length,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0__u8 type, __u16 netfid, bool wait)
>>> +cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo=
 *lock,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0bool wait)
>>> =A0{
>>> - =A0 =A0 struct cifsLockInfo *lock, *conf_lock;
>>> + =A0 =A0 struct cifsLockInfo *conf_lock;
>>> =A0 =A0 =A0 bool exist;
>>> =A0 =A0 =A0 int rc =3D 0;
>>>
>>> - =A0 =A0 lock =3D cifs_lock_init(length, offset, type, netfid);
>>> - =A0 =A0 if (!lock)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>>> -
>>> =A0try_again:
>>> =A0 =A0 =A0 exist =3D false;
>>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>>>
>>> - =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, offset, length,=
 type, netfid,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &conf_lock);
>>> + =A0 =A0 exist =3D cifs_find_lock_conflict(cinode, lock, &conf_loc=
k);
>>> =A0 =A0 =A0 if (!exist && cinode->can_cache_brlcks) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&lock->llist, &cinode->ll=
ist);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&cinode->lock_mutex);
>>> @@ -781,7 +776,6 @@ try_again:
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>> =A0 =A0 =A0 }
>>>
>>> - =A0 =A0 kfree(lock);
>>> =A0 =A0 =A0 mutex_unlock(&cinode->lock_mutex);
>>> =A0 =A0 =A0 return rc;
>>> =A0}
>>> @@ -1254,20 +1248,26 @@ cifs_setlk(struct file *file, =A0struct fil=
e_lock *flock, __u8 type,
>>> =A0 =A0 =A0 }
>>>
>>> =A0 =A0 =A0 if (lock) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add_if(cinode, flock->fl=
_start, length,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 type, netfid, wait_flag);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo *lock;
>>> +
>>> + =A0 =A0 =A0 =A0 =A0 =A0 lock =3D cifs_lock_init(length, flock->fl=
_start, type, netfid);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!lock)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>>> +
>>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add_if(cinode, lock, wai=
t_flag);
>>
>> Here, you're adding "lock" to the list...
>
> If we added the lock to the list cifs_lock_add_if returns 0 and we
> will jump to out label.
>
>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>> - =A0 =A0 =A0 =A0 =A0 =A0 else if (!rc)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(lock);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc <=3D 0)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, c=
urrent->tgid, length,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0floc=
k->fl_start, 0, 1, type, wait_flag, 0);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* For Windows locks we m=
ust store them. */
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add(cino=
de, length, flock->fl_start,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0type, netfid);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(lock);
>>
>> ...and here you're freeing "lock" without removing it from the list.
>> Isn't that like to cause a problem?
>
> So, if CIFSSMBLock returns a error we free the lock that hasn't been
> added to the list. If CIFSSMBLock returns ok, we will add it to the
> list with cifs_lock_add void function.
>
> Seems no problem with it.
>
> --
> Best regards,
> Pavel Shilovsky.
>

So, to be clear - brlock cache function cifs_lock_add_if returns:

"0" if we store the lock in the cache and have an oplock for batching
brlocks - no need to request to the server.

"1" if there is no locks preventing us to set this lock but we haven't
an oplock for batching brlocks - need to request to the server and
then add the lock to the list if server accepts.

"-EACCESS" if we have a lock on the client that prevent us and this
call is non-blocked.

--=20
Best regards,
Pavel Shilovsky.
