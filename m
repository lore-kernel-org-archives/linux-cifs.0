From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix VFS lock usage for oplocked files
Date: Wed, 28 Mar 2012 09:33:47 +0400
Message-ID: <CAKywueSvhFT=PQSLZ=AFs6v3+Bz1-vT=9WGz5SJs8j9dajpMKg@mail.gmail.com>
References: <1332848175-6441-1-git-send-email-piastry@etersoft.ru>
	<20120327173032.5bd6b60d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120327173032.5bd6b60d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

28 =CD=C1=D2=D4=C1 2012=9A=C7. 1:30 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Tue, 27 Mar 2012 15:36:15 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> We can deadlock if we have a write oplock and two processes
>> use the same file handle. In this case the first process can't
>> unlock its lock if another process blocked on the lock in the
>> same time.
>>
>> Fix this by removing lock_mutex protection from waiting on a
>> blocked lock and protect only posix_lock_file call.
>>
>
> Perhaps this means that the model of using a giant mutex around all o=
f
> this code needs a fundamental rethink?
>
> Any time you wrap a large section of code under a giant lock (like th=
e
> lock_mutex here), then you invite a whole host of problems --
> scalability issues for one, and there's also the problem of ensuring
> that you understand what the lock is intended to protect. Witness the
> pain and agony that accompanied the BKL removal effort for the last
> decade...
>
>> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =9Afs/cifs/file.c | =9A 56 +++++++++++++++++++++++++++++++++++++++++=
+++++++++++----
>> =9A1 files changed, 52 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 159fcc5..2bf04e9 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -671,6 +671,21 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock=
)
>> =9A =9A =9A }
>> =9A}
>>
>> +/*
>> + * Copied from fs/locks.c with small changes.
>> + * Remove waiter from blocker's block list.
>> + * When blocker ends up pointing to itself then the list is empty.
>> + */
>> +static void
>> +cifs_locks_delete_block(struct file_lock *waiter)
>> +{
>> + =9A =9A lock_flocks();
>> + =9A =9A list_del_init(&waiter->fl_block);
>> + =9A =9A list_del_init(&waiter->fl_link);
>> + =9A =9A waiter->fl_next =3D NULL;
>> + =9A =9A unlock_flocks();
>> +}
>> +
>
> This is the same exact function as locks_delete_block. What is the
> point of copying it here instead of using that? It will of course nee=
d
> to be exported...
>
>> =9Astatic bool
>> =9A__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 off=
set,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A __u64 length, __u8 type,=
 __u16 netfid,
>> @@ -820,6 +835,39 @@ cifs_posix_lock_test(struct file *file, struct =
file_lock *flock)
>> =9A =9A =9A return rc;
>> =9A}
>>
>> +/* Called with locked lock_mutex, return with unlocked. */
>> +static int
>> +cifs_posix_lock_file_wait_locked(struct file *file, struct file_loc=
k *flock)
>> +{
>> + =9A =9A struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.dentr=
y->d_inode);
>> + =9A =9A int rc;
>> +
>> + =9A =9A while (true) {
>> + =9A =9A =9A =9A =9A =9A rc =3D posix_lock_file(file, flock, NULL);
>> + =9A =9A =9A =9A =9A =9A mutex_unlock(&cinode->lock_mutex);
>> + =9A =9A =9A =9A =9A =9A if (rc !=3D FILE_LOCK_DEFERRED)
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A break;
>> + =9A =9A =9A =9A =9A =9A rc =3D wait_event_interruptible(flock->fl_=
wait, !flock->fl_next);
>> + =9A =9A =9A =9A =9A =9A if (!rc) {
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A mutex_lock(&cinode->lock_m=
utex);
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue;
>> + =9A =9A =9A =9A =9A =9A }
>> + =9A =9A =9A =9A =9A =9A cifs_locks_delete_block(flock);
>> + =9A =9A =9A =9A =9A =9A break;
>> + =9A =9A }
>> + =9A =9A return rc;
>> +}
>> +
>> +static int
>> +cifs_posix_lock_file_wait(struct file *file, struct file_lock *floc=
k)
>> +{
>> + =9A =9A struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.dentr=
y->d_inode);
>> +
>> + =9A =9A mutex_lock(&cinode->lock_mutex);
>> + =9A =9A /* lock_mutex will be released by the function below */
>> + =9A =9A return cifs_posix_lock_file_wait_locked(file, flock);
>> +}
>> +
>
> lock handling that crosses function boundaries is almost always a red
> flag that something is not well-designed and will end up broken or
> being rewritten at some point in the future. I'd urge you not to
> establish this sort of API.
>
>> =9A/*
>> =9A * Set the byte-range lock (posix style). Returns:
>> =9A * 1) 0, if we set the lock and don't need to request to the serv=
er;
>> @@ -840,9 +888,9 @@ cifs_posix_lock_set(struct file *file, struct fi=
le_lock *flock)
>> =9A =9A =9A =9A =9A =9A =9A mutex_unlock(&cinode->lock_mutex);
>> =9A =9A =9A =9A =9A =9A =9A return rc;
>> =9A =9A =9A }
>> - =9A =9A rc =3D posix_lock_file_wait(file, flock);
>> - =9A =9A mutex_unlock(&cinode->lock_mutex);
>> - =9A =9A return rc;
>
> Ok, so the original bug was here. When one thread is blocked here and
> waiting for the lock then you can't get the mutex in order to release
> it...
>
> This patch looks like it'll "fix" the immediate problem, but I'm
> concerned that the purpose of the lock_mutex is not entirely clear.
>
> What data structures does it protect? A better solution probably will
> involve moving more of this code outside of it by determining which
> data structures are protected by it.
>
>> +
>> + =9A =9A /* lock_mutex will be released by the function below */
>> + =9A =9A return cifs_posix_lock_file_wait_locked(file, flock);
>> =9A}
>>
>> =9Astatic int
>> @@ -1338,7 +1386,7 @@ cifs_setlk(struct file *file, =9Astruct file_l=
ock *flock, __u8 type,
>>
>> =9Aout:
>> =9A =9A =9A if (flock->fl_flags & FL_POSIX)
>> - =9A =9A =9A =9A =9A =9A posix_lock_file_wait(file, flock);
>> + =9A =9A =9A =9A =9A =9A cifs_posix_lock_file_wait(file, flock);
>> =9A =9A =9A return rc;
>> =9A}
>>
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


So, to be clear:

the main purpose of lock_mutex is protecting _all_ lock operations on
the inode as well as can_cache_brlocks flag. We have to deal with
simultaneous oplock break and fcntl requests to be sure that:

we push all the lock we have in the cache when oplock break comes. All
other locks that comes after that will be sent to the server.

This is the main problem I tried to solve when designing brlock cache
- races with oplock breaks.

The posix locking is slightly more complex than mandatory one because
it has its own protection - lock/unlock_flocks(). But I really don't
think we have problems using two protection mechanism at the same
time: lock_mutex is always surrounds flocks.

As for the bug that this patch fixes, it was my fault of not
understanding fluently how posix_lock_file_wait works - not a design
problem.

As for cross-locking function, I suggest to drop this change from the
patch because it is not directly related to the problem it solves (I
made this change to be more safe, but seems it needs more thoughts):
>> =9A =9A =9A if (flock->fl_flags & FL_POSIX)
>> - =9A =9A =9A =9A =9A =9A posix_lock_file_wait(file, flock);
>> + =9A =9A =9A =9A =9A =9A cifs_posix_lock_file_wait(file, flock);

in this case we don't need cifs_posix_lock_file_wait/locked variants
and the code can be moved into
cifs_posix_lock_set function that not introduces new API.

--=20
Best regards,
Pavel Shilovsky.
