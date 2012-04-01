From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] CIFS: Fix VFS lock usage for oplocked files
Date: Sun, 1 Apr 2012 13:56:36 -0500
Message-ID: <CAH2r5mt8L6O7Y3yGgQEyAmKMgR+6cLCaL-GQG2vPa=nAX6BSEw@mail.gmail.com>
References: <1332957379-5922-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332957379-5922-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks correct.

=46YI - I accidentally merged version 2 of the patch into my
cifs-2.6.git tree, but
just reverted it and merged this latest version (3) of the patch.

On Wed, Mar 28, 2012 at 12:56 PM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>=
 wrote:
> We can deadlock if we have a write oplock and two processes
> use the same file handle. In this case the first process can't
> unlock its lock if the second process blocked on the lock in the
> same time.
>
> Fix it by using posix_lock_file rather than posix_lock_file_wait
> under cinode->lock_mutex. If we request a blocking lock and
> posix_lock_file indicates that there is another lock that prevents
> us, wait untill that lock is released and restart our call.
>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/file.c =A0 =A0 | =A0 10 +++++++++-
> =A0fs/locks.c =A0 =A0 =A0 =A0 | =A0 =A03 ++-
> =A0include/linux/fs.h | =A0 =A05 +++++
> =A03 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 460d87b..fae765d 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -835,13 +835,21 @@ cifs_posix_lock_set(struct file *file, struct f=
ile_lock *flock)
> =A0 =A0 =A0 =A0if ((flock->fl_flags & FL_POSIX) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> +try_again:
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
> =A0 =A0 =A0 =A0if (!cinode->can_cache_brlcks) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 rc =3D posix_lock_file_wait(file, flock);
> +
> + =A0 =A0 =A0 rc =3D posix_lock_file(file, flock, NULL);
> =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> + =A0 =A0 =A0 if (rc =3D=3D FILE_LOCK_DEFERRED) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_event_interruptible(flock->=
fl_wait, !flock->fl_next);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto try_again;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 locks_delete_block(flock);
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> diff --git a/fs/locks.c b/fs/locks.c
> index 637694b..0d68f1f 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -510,12 +510,13 @@ static void __locks_delete_block(struct file_lo=
ck *waiter)
>
> =A0/*
> =A0*/
> -static void locks_delete_block(struct file_lock *waiter)
> +void locks_delete_block(struct file_lock *waiter)
> =A0{
> =A0 =A0 =A0 =A0lock_flocks();
> =A0 =A0 =A0 =A0__locks_delete_block(waiter);
> =A0 =A0 =A0 =A0unlock_flocks();
> =A0}
> +EXPORT_SYMBOL(locks_delete_block);
>
> =A0/* Insert waiter into blocker's block list.
> =A0* We use a circular list so that processes can be easily woken up =
in
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index fa63f1b..d8fd8df 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1211,6 +1211,7 @@ extern int vfs_setlease(struct file *, long, st=
ruct file_lock **);
> =A0extern int lease_modify(struct file_lock **, int);
> =A0extern int lock_may_read(struct inode *, loff_t start, unsigned lo=
ng count);
> =A0extern int lock_may_write(struct inode *, loff_t start, unsigned l=
ong count);
> +extern void locks_delete_block(struct file_lock *waiter);
> =A0extern void lock_flocks(void);
> =A0extern void unlock_flocks(void);
> =A0#else /* !CONFIG_FILE_LOCKING */
> @@ -1355,6 +1356,10 @@ static inline int lock_may_write(struct inode =
*inode, loff_t start,
> =A0 =A0 =A0 =A0return 1;
> =A0}
>
> +static inline void locks_delete_block(struct file_lock *waiter)
> +{
> +}
> +
> =A0static inline void lock_flocks(void)
> =A0{
> =A0}
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
