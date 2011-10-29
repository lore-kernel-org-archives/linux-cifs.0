From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Use the vfs brlock cache for posix locking in
 FL_POSIX case only
Date: Sat, 29 Oct 2011 12:42:19 +0400
Message-ID: <CAKywueSaijRgBoDFubW-MyotOhrK0dxVOO9=G0NKsWO7648XHg@mail.gmail.com>
References: <1319657208-15659-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319657208-15659-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/26 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> and simplify the error handling.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 23 ++++++++++++++++++++---
> =A01 files changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index a43856a..6bf14ed 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -920,6 +920,9 @@ cifs_posix_lock_test(struct file *file, struct fi=
le_lock *flock)
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.d=
entry->d_inode);
> =A0 =A0 =A0 =A0unsigned char saved_type =3D flock->fl_type;
>
> + =A0 =A0 =A0 if ((flock->fl_flags & FL_POSIX) =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> +
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
> =A0 =A0 =A0 =A0posix_test_lock(file, flock);
>
> @@ -936,12 +939,15 @@ static int
> =A0cifs_posix_lock_set(struct file *file, struct file_lock *flock)
> =A0{
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.d=
entry->d_inode);
> - =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 int rc =3D 1;
> +
> + =A0 =A0 =A0 if ((flock->fl_flags & FL_POSIX) =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
> =A0 =A0 =A0 =A0if (!cinode->can_cache_brlcks) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0rc =3D posix_lock_file_wait(file, flock);
> =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> @@ -1371,7 +1377,18 @@ cifs_setlk(struct file *file, =A0struct file_l=
ock *flock, __u8 type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBPosixLock(xid, tcon, net=
fid, current->tgid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A00 /* set */, length, flock,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0posix_lock_type, wait_flag);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flock->fl_flags & FL_POSIX) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D posix_lock_file_=
wait(file, flock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "Error occurs in posix_lock_file_wait"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 " after we send the request to the "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 "server");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;

Seems like we haven't return rc from posix_lock_file_wait, because we
have already set a lock on the server - will respin this patch.

--=20
Best regards,
Pavel Shilovsky.
