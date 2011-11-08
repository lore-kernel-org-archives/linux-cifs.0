From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] Add support for flock over a cifs mount.
Date: Tue, 8 Nov 2011 11:57:51 +0400
Message-ID: <CAKywueTSqckM1iVsrEu47RwBA3GnpfZU17QrrNineJBVOcZdvQ@mail.gmail.com>
References: <1320696342.1690.19.camel@sprabhu.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320696342.1690.19.camel-yuq4rhG59MBosH8Q1Ye95IGKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/11/8 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Allow flock over a cifs mount.
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 8f1fe32..56d3b36 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -830,6 +830,7 @@ const struct file_operations cifs_file_ops =3D {
> =A0 =A0 =A0 =A0.open =3D cifs_open,
> =A0 =A0 =A0 =A0.release =3D cifs_close,
> =A0 =A0 =A0 =A0.lock =3D cifs_lock,
> + =A0 =A0 =A0 .flock =3D cifs_flock,
> =A0 =A0 =A0 =A0.fsync =3D cifs_fsync,
> =A0 =A0 =A0 =A0.flush =3D cifs_flush,
> =A0 =A0 =A0 =A0.mmap =A0=3D cifs_file_mmap,
> @@ -849,6 +850,7 @@ const struct file_operations cifs_file_strict_ops=
 =3D {
> =A0 =A0 =A0 =A0.open =3D cifs_open,
> =A0 =A0 =A0 =A0.release =3D cifs_close,
> =A0 =A0 =A0 =A0.lock =3D cifs_lock,
> + =A0 =A0 =A0 .flock =3D cifs_flock,
> =A0 =A0 =A0 =A0.fsync =3D cifs_strict_fsync,
> =A0 =A0 =A0 =A0.flush =3D cifs_flush,
> =A0 =A0 =A0 =A0.mmap =3D cifs_file_strict_mmap,
> @@ -869,6 +871,7 @@ const struct file_operations cifs_file_direct_ops=
 =3D {
> =A0 =A0 =A0 =A0.open =3D cifs_open,
> =A0 =A0 =A0 =A0.release =3D cifs_close,
> =A0 =A0 =A0 =A0.lock =3D cifs_lock,
> + =A0 =A0 =A0 .flock =3D cifs_flock,
> =A0 =A0 =A0 =A0.fsync =3D cifs_fsync,
> =A0 =A0 =A0 =A0.flush =3D cifs_flush,
> =A0 =A0 =A0 =A0.mmap =3D cifs_file_mmap,
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 30ff560..e119e9d 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -87,6 +87,7 @@ extern ssize_t cifs_user_writev(struct kiocb *iocb,=
 const struct iovec *iov,
> =A0extern ssize_t cifs_strict_writev(struct kiocb *iocb, const struct=
 iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0un=
signed long nr_segs, loff_t pos);
> =A0extern int cifs_lock(struct file *, int, struct file_lock *);
> +extern int cifs_flock(struct file *, int, struct file_lock *);
> =A0extern int cifs_fsync(struct file *, loff_t, loff_t, int);
> =A0extern int cifs_strict_fsync(struct file *, loff_t, loff_t, int);
> =A0extern int cifs_flush(struct file *, fl_owner_t id);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index c1f063c..dd34f0b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -43,6 +43,23 @@
> =A0#include "cifs_fs_sb.h"
> =A0#include "fscache.h"
>
> +static int do_vfs_lock(struct file *file, struct file_lock *fl)
> +{
> + =A0 =A0 =A0 int res =3D 0;
> +
> + =A0 =A0 =A0 switch (fl->fl_flags & (FL_POSIX|FL_FLOCK)) {
> + =A0 =A0 =A0 case FL_POSIX:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 res =3D posix_lock_file_wait(file, fl);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case FL_FLOCK:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 res =3D flock_lock_file_wait(file, fl);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG();
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return res;
> +}
> +
> =A0static inline int cifs_convert_flags(unsigned int flags)
> =A0{
> =A0 =A0 =A0 =A0if ((flags & O_ACCMODE) =3D=3D O_RDONLY)
> @@ -814,7 +831,7 @@ cifs_posix_lock_set(struct file *file, struct fil=
e_lock *flock)
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.d=
entry->d_inode);
> =A0 =A0 =A0 =A0int rc =3D 1;
>
> - =A0 =A0 =A0 if ((flock->fl_flags & FL_POSIX) =3D=3D 0)
> + =A0 =A0 =A0 if ((flock->fl_flags & (FL_POSIX | FL_FLOCK)) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
> @@ -822,7 +839,7 @@ cifs_posix_lock_set(struct file *file, struct fil=
e_lock *flock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 rc =3D posix_lock_file_wait(file, flock);
> + =A0 =A0 =A0 rc =3D do_vfs_lock(file, flock);
> =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -1231,12 +1248,27 @@ cifs_setlk(struct file *file, =A0struct file_=
lock *flock, __u8 type,
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.d=
entry->d_inode);
> =A0 =A0 =A0 =A0__u16 netfid =3D cfile->netfid;
> + =A0 =A0 =A0 unsigned char fl_flags =3D flock->fl_flags;
> +
> + =A0 =A0 =A0 if (unlock) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*Check for existance of lock*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_flags |=3D FL_EXISTS;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (do_vfs_lock(flock->fl_file, flock) =
=3D=3D -ENOENT)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*Check if we can obtain lock*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_flags |=3D FL_ACCESS;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D do_vfs_lock(flock->fl_file, floc=
k);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 flock->fl_flags =3D fl_flags;

I think this should be skipped for non-posix locks. These locks have
their own cache (cifs_lock_* functions) associated with cifsInodeInfo
structure - so, we can't make a solution to 'goto out;' without
looking at this cache.

>
> =A0 =A0 =A0 =A0if (posix_lck) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int posix_lock_type;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_posix_lock_set(file, flock=
);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc || rc < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc <=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (type & LOCKING_ANDX_SHARED_LOCK)
> @@ -1250,7 +1282,7 @@ cifs_setlk(struct file *file, =A0struct file_lo=
ck *flock, __u8 type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBPosixLock(xid, tcon, net=
fid, current->tgid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A00 /* set */, length, flock,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0posix_lock_type, wait_flag);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_lock;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (lock) {
> @@ -1259,7 +1291,7 @@ cifs_setlk(struct file *file, =A0struct file_lo=
ck *flock, __u8 type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (!rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_lock;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBLock(xid, tcon, netfid, =
current->tgid, length,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock=
->fl_start, 0, 1, type, wait_flag, 0);
> @@ -1271,9 +1303,14 @@ cifs_setlk(struct file *file, =A0struct file_l=
ock *flock, __u8 type,
> =A0 =A0 =A0 =A0} else if (unlock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_unlock_range(cfile, flock,=
 xid);
>
> +out_lock:
> + =A0 =A0 =A0 if (rc =3D=3D 0 && lock) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*We have to sleep here*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_flags |=3D FL_SLEEP;

It's not clear why we should sleep here - the patch description
doesn't tell anything about it.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_vfs_lock(file, flock);
> + =A0 =A0 =A0 }

What's about unlock case here?

> =A0out:
> - =A0 =A0 =A0 if (flock->fl_flags & FL_POSIX)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_lock_file_wait(file, flock);
> + =A0 =A0 =A0 flock->fl_flags =3D fl_flags;
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> @@ -1334,6 +1371,22 @@ int cifs_lock(struct file *file, int cmd, stru=
ct file_lock *flock)
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +int cifs_flock(struct file *file, int cmd, struct file_lock *flock)
> +{
> + =A0 =A0 =A0 int rc;
> +
> + =A0 =A0 =A0 rc =3D cifs_lock(file, cmd, flock);
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* flock requires -EWOULDBLOCK in case of conflicting=
 locks
> + =A0 =A0 =A0 =A0* and LOCK_NB is used
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if ((rc =3D=3D -EACCES) && !(flock->fl_flags & FL_SLEEP=
))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EWOULDBLOCK;
> +
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0/* update the file size (if needed) after a write */
> =A0void
> =A0cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
>
>
>

In general, I think that this patch does much more than it's mentioned
in the description and brings a lot of changes in the existing lock
code.

It seems like we should only change posix_file_lock_wait to your
do_vfs_lock in 'out' label and cifs_posix_lock_set for posix_lck case
and map flock to brlock from 0 to INF for !posix_lck case.

--=20
Best regards,
Pavel Shilovsky.
