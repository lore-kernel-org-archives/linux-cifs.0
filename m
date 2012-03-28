From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Fix VFS lock usage for oplocked files
Date: Wed, 28 Mar 2012 14:06:35 +0400
Message-ID: <CAKywueSydqWZ895seRiQR-v93hwHKVYSMGS6ampdwLbMgK_WVw@mail.gmail.com>
References: <1332928489-12455-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332928489-12455-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

28 =CD=C1=D2=D4=C1 2012=9A=C7. 13:54 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Pavel Shilovsky
<piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> We can deadlock if we have a write oplock and two processes
> use the same file handle. In this case the first process can't
> unlock its lock if another process blocked on the lock in the
> same time.
>
> Fix this by removing lock_mutex protection from waiting on a
> blocked lock and protect only posix_lock_file call.
>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =9Afs/cifs/file.c =9A =9A | =9A 16 ++++++++++++++--
> =9Afs/locks.c =9A =9A =9A =9A | =9A =9A3 ++-
> =9Ainclude/linux/fs.h | =9A =9A5 +++++
> =9A3 files changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 460d87b..89e4feb 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -840,8 +840,20 @@ cifs_posix_lock_set(struct file *file, struct fi=
le_lock *flock)
> =9A =9A =9A =9A =9A =9A =9A =9Amutex_unlock(&cinode->lock_mutex);
> =9A =9A =9A =9A =9A =9A =9A =9Areturn rc;
> =9A =9A =9A =9A}
> - =9A =9A =9A rc =3D posix_lock_file_wait(file, flock);
> - =9A =9A =9A mutex_unlock(&cinode->lock_mutex);
> +
> + =9A =9A =9A while (true) {
> + =9A =9A =9A =9A =9A =9A =9A rc =3D posix_lock_file(file, flock, NUL=
L);
> + =9A =9A =9A =9A =9A =9A =9A mutex_unlock(&cinode->lock_mutex);
> + =9A =9A =9A =9A =9A =9A =9A if (rc !=3D FILE_LOCK_DEFERRED)
> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A break;
> + =9A =9A =9A =9A =9A =9A =9A rc =3D wait_event_interruptible(flock->=
fl_wait, !flock->fl_next);
> + =9A =9A =9A =9A =9A =9A =9A if (rc) {
> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A locks_delete_block(floc=
k);
> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A break;
> + =9A =9A =9A =9A =9A =9A =9A }
> + =9A =9A =9A =9A =9A =9A =9A mutex_lock(&cinode->lock_mutex);
> + =9A =9A =9A }

We need to check if we can cache brlocks after
wait_event_interruptible ends (similar to the code we have for
mandatory locking case) - will respin this.

> +
> =9A =9A =9A =9Areturn rc;
> =9A}
>
> diff --git a/fs/locks.c b/fs/locks.c
> index 637694b..0d68f1f 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -510,12 +510,13 @@ static void __locks_delete_block(struct file_lo=
ck *waiter)
>
> =9A/*
> =9A*/
> -static void locks_delete_block(struct file_lock *waiter)
> +void locks_delete_block(struct file_lock *waiter)
> =9A{
> =9A =9A =9A =9Alock_flocks();
> =9A =9A =9A =9A__locks_delete_block(waiter);
> =9A =9A =9A =9Aunlock_flocks();
> =9A}
> +EXPORT_SYMBOL(locks_delete_block);
>
> =9A/* Insert waiter into blocker's block list.
> =9A* We use a circular list so that processes can be easily woken up =
in
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index fa63f1b..d8fd8df 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1211,6 +1211,7 @@ extern int vfs_setlease(struct file *, long, st=
ruct file_lock **);
> =9Aextern int lease_modify(struct file_lock **, int);
> =9Aextern int lock_may_read(struct inode *, loff_t start, unsigned lo=
ng count);
> =9Aextern int lock_may_write(struct inode *, loff_t start, unsigned l=
ong count);
> +extern void locks_delete_block(struct file_lock *waiter);
> =9Aextern void lock_flocks(void);
> =9Aextern void unlock_flocks(void);
> =9A#else /* !CONFIG_FILE_LOCKING */
> @@ -1355,6 +1356,10 @@ static inline int lock_may_write(struct inode =
*inode, loff_t start,
> =9A =9A =9A =9Areturn 1;
> =9A}
>
> +static inline void locks_delete_block(struct file_lock *waiter)
> +{
> +}
> +
> =9Astatic inline void lock_flocks(void)
> =9A{
> =9A}
> --
> 1.7.1
>



--=20
Best regards,
Pavel Shilovsky.
