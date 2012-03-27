From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix VFS lock usage for oplocked files
Date: Tue, 27 Mar 2012 22:02:58 +0400
Message-ID: <CAKywueRejLxV-8rFBKSbXjMhPrZDD5p7D0gF+fdW0_+hh1yRhw@mail.gmail.com>
References: <1332848175-6441-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=14dae9340d450838cf04bc3d4dc4
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332848175-6441-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--14dae9340d450838cf04bc3d4dc4
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: quoted-printable

27 =CD=C1=D2=D4=C1 2012=9A=C7. 15:36 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8 P=
avel Shilovsky
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
> =9Afs/cifs/file.c | =9A 56 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++----
> =9A1 files changed, 52 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 159fcc5..2bf04e9 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -671,6 +671,21 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
> =9A =9A =9A =9A}
> =9A}
>
> +/*
> + * Copied from fs/locks.c with small changes.
> + * Remove waiter from blocker's block list.
> + * When blocker ends up pointing to itself then the list is empty.
> + */
> +static void
> +cifs_locks_delete_block(struct file_lock *waiter)
> +{
> + =9A =9A =9A lock_flocks();
> + =9A =9A =9A list_del_init(&waiter->fl_block);
> + =9A =9A =9A list_del_init(&waiter->fl_link);
> + =9A =9A =9A waiter->fl_next =3D NULL;
> + =9A =9A =9A unlock_flocks();
> +}
> +
> =9Astatic bool
> =9A__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A__u64 length, __u8 type, _=
_u16 netfid,
> @@ -820,6 +835,39 @@ cifs_posix_lock_test(struct file *file, struct file_=
lock *flock)
> =9A =9A =9A =9Areturn rc;
> =9A}
>
> +/* Called with locked lock_mutex, return with unlocked. */
> +static int
> +cifs_posix_lock_file_wait_locked(struct file *file, struct file_lock *fl=
ock)
> +{
> + =9A =9A =9A struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.dentry=
->d_inode);
> + =9A =9A =9A int rc;
> +
> + =9A =9A =9A while (true) {
> + =9A =9A =9A =9A =9A =9A =9A rc =3D posix_lock_file(file, flock, NULL);
> + =9A =9A =9A =9A =9A =9A =9A mutex_unlock(&cinode->lock_mutex);
> + =9A =9A =9A =9A =9A =9A =9A if (rc !=3D FILE_LOCK_DEFERRED)
> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A break;
> + =9A =9A =9A =9A =9A =9A =9A rc =3D wait_event_interruptible(flock->fl_w=
ait, !flock->fl_next);
> + =9A =9A =9A =9A =9A =9A =9A if (!rc) {
> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A mutex_lock(&cinode->lock_mu=
tex);
> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue;
> + =9A =9A =9A =9A =9A =9A =9A }
> + =9A =9A =9A =9A =9A =9A =9A cifs_locks_delete_block(flock);
> + =9A =9A =9A =9A =9A =9A =9A break;
> + =9A =9A =9A }
> + =9A =9A =9A return rc;
> +}
> +
> +static int
> +cifs_posix_lock_file_wait(struct file *file, struct file_lock *flock)
> +{
> + =9A =9A =9A struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.dentry=
->d_inode);
> +
> + =9A =9A =9A mutex_lock(&cinode->lock_mutex);
> + =9A =9A =9A /* lock_mutex will be released by the function below */
> + =9A =9A =9A return cifs_posix_lock_file_wait_locked(file, flock);
> +}
> +
> =9A/*
> =9A* Set the byte-range lock (posix style). Returns:
> =9A* 1) 0, if we set the lock and don't need to request to the server;
> @@ -840,9 +888,9 @@ cifs_posix_lock_set(struct file *file, struct file_lo=
ck *flock)
> =9A =9A =9A =9A =9A =9A =9A =9Amutex_unlock(&cinode->lock_mutex);
> =9A =9A =9A =9A =9A =9A =9A =9Areturn rc;
> =9A =9A =9A =9A}
> - =9A =9A =9A rc =3D posix_lock_file_wait(file, flock);
> - =9A =9A =9A mutex_unlock(&cinode->lock_mutex);
> - =9A =9A =9A return rc;
> +
> + =9A =9A =9A /* lock_mutex will be released by the function below */
> + =9A =9A =9A return cifs_posix_lock_file_wait_locked(file, flock);
> =9A}
>
> =9Astatic int
> @@ -1338,7 +1386,7 @@ cifs_setlk(struct file *file, =9Astruct file_lock *=
flock, __u8 type,
>
> =9Aout:
> =9A =9A =9A =9Aif (flock->fl_flags & FL_POSIX)
> - =9A =9A =9A =9A =9A =9A =9A posix_lock_file_wait(file, flock);
> + =9A =9A =9A =9A =9A =9A =9A cifs_posix_lock_file_wait(file, flock);
> =9A =9A =9A =9Areturn rc;
> =9A}
>
> --
> 1.7.1
>

Include the posix_lock_bug.c file that reproduces the problem.

--=20
Best regards,
Pavel Shilovsky.

--14dae9340d450838cf04bc3d4dc4
Content-Type: text/x-csrc; charset=US-ASCII; name="posix_lock_bug.c"
Content-Disposition: attachment; filename="posix_lock_bug.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h0b970w40

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPGZjbnRsLmg+
CgppbnQgbWFpbihpbnQgYXJncywgY2hhciAqKmFyZ3YpIHsKCWludCBmZCwgcmMsIHBpZDsKCXN0
cnVjdCBmbG9jayBmbG9jazsKCWNoYXIgKm5hbWU7CgoJaWYgKGFyZ3MgPT0gMikKCQluYW1lID0g
YXJndlsxXTsKCWVsc2UgewoJCXBlcnJvcigibm8gZmlsZSBuYW1lXG4iKTsKCQlyZXR1cm4gMTsK
CX0KCglmZCA9IG9wZW4obmFtZSwgT19DUkVBVCB8IE9fUkRXUik7CglpZiAoIWZkKSB7CgkJcGVy
cm9yKCJjYW4ndCBvcGVuIGEgZmlsZVxuIik7CgkJcmV0dXJuIDE7Cgl9CgoJZmxvY2subF9zdGFy
dCA9IDA7CglmbG9jay5sX2xlbiA9IDE7CglmbG9jay5sX3R5cGUgPSBGX1dSTENLOwoJZmxvY2su
bF93aGVuY2UgPSAwOwoKCXJjID0gZmNudGwoZmQsIEZfU0VUTEssICZmbG9jayk7CglpZiAocmMp
IHsKCQlwZXJyb3IoImNhbid0IGxvY2tcbiIpOwoJCXJldHVybiAxOwoJfQoKCXBpZCA9IGZvcmso
KTsKCWlmIChwaWQpIHsKCQkvKiBwYXJlbnQgcHJvY2VzcyAqLwoJCXByaW50ZigicGFyZW50IHBy
b2Nlc3Mgc3RhcnRlZFxuIik7CgkJc2xlZXAoMik7CgkJZmxvY2subF90eXBlID0gRl9VTkxDSzsK
CQlyYyA9IGZjbnRsKGZkLCBGX1NFVExLLCAmZmxvY2spOwoJCWlmIChyYykgewoJCQlwZXJyb3Io
ImNhbid0IGxvY2tcbiIpOwoJCQlyZXR1cm4gMTsKCQl9CgkJcHJpbnRmKCJwYXJlbnQgcHJvY2Vz
cyBlbmRlZFxuIik7Cgl9IGVsc2UgewoJCS8qIGNoaWxkIHByb2Nlc3MgKi8KCQlwcmludGYoImNo
aWxkIHByb2Nlc3Mgc3RhcnRlZFxuIik7CgkJcmMgPSBmY250bChmZCwgRl9TRVRMS1csICZmbG9j
ayk7CgkJaWYgKHJjKSB7CgkJCXBlcnJvcigiY2FuJ3QgbG9ja1xuIik7CgkJCXJldHVybiAxOwoJ
CX0KCQlwcmludGYoImNoaWxkIHByb2Nlc3MgZW5kZWRcbiIpOwoJfQoKCXJldHVybiAwOwp9Cg==
--14dae9340d450838cf04bc3d4dc4--
