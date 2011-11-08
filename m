From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] Add support for flock over a cifs mount.
Date: Tue, 8 Nov 2011 16:21:14 +0400
Message-ID: <CAKywueQ65EgLz9iDd2exq85jBMGrBFLiq=mq2dOY9poy3_1h0g@mail.gmail.com>
References: <1320696342.1690.19.camel@sprabhu.fab.redhat.com>
	<CAKywueTSqckM1iVsrEu47RwBA3GnpfZU17QrrNineJBVOcZdvQ@mail.gmail.com>
	<1320751612.2941.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320751612.2941.10.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/11/8 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 2011-11-08 at 11:57 +0400, Pavel Shilovsky wrote:
>> 2011/11/8 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > Allow flock over a cifs mount.
>> >
>> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >
>> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> > index 8f1fe32..56d3b36 100644
>> > --- a/fs/cifs/cifsfs.c
>> > +++ b/fs/cifs/cifsfs.c
>> > @@ -830,6 +830,7 @@ const struct file_operations cifs_file_ops =3D=
 {
>> > =A0 =A0 =A0 =A0.open =3D cifs_open,
>> > =A0 =A0 =A0 =A0.release =3D cifs_close,
>> > =A0 =A0 =A0 =A0.lock =3D cifs_lock,
>> > + =A0 =A0 =A0 .flock =3D cifs_flock,
>> > =A0 =A0 =A0 =A0.fsync =3D cifs_fsync,
>> > =A0 =A0 =A0 =A0.flush =3D cifs_flush,
>> > =A0 =A0 =A0 =A0.mmap =A0=3D cifs_file_mmap,
>> > @@ -849,6 +850,7 @@ const struct file_operations cifs_file_strict_=
ops =3D {
>> > =A0 =A0 =A0 =A0.open =3D cifs_open,
>> > =A0 =A0 =A0 =A0.release =3D cifs_close,
>> > =A0 =A0 =A0 =A0.lock =3D cifs_lock,
>> > + =A0 =A0 =A0 .flock =3D cifs_flock,
>> > =A0 =A0 =A0 =A0.fsync =3D cifs_strict_fsync,
>> > =A0 =A0 =A0 =A0.flush =3D cifs_flush,
>> > =A0 =A0 =A0 =A0.mmap =3D cifs_file_strict_mmap,
>> > @@ -869,6 +871,7 @@ const struct file_operations cifs_file_direct_=
ops =3D {
>> > =A0 =A0 =A0 =A0.open =3D cifs_open,
>> > =A0 =A0 =A0 =A0.release =3D cifs_close,
>> > =A0 =A0 =A0 =A0.lock =3D cifs_lock,
>> > + =A0 =A0 =A0 .flock =3D cifs_flock,
>> > =A0 =A0 =A0 =A0.fsync =3D cifs_fsync,
>> > =A0 =A0 =A0 =A0.flush =3D cifs_flush,
>> > =A0 =A0 =A0 =A0.mmap =3D cifs_file_mmap,
>> > diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
>> > index 30ff560..e119e9d 100644
>> > --- a/fs/cifs/cifsfs.h
>> > +++ b/fs/cifs/cifsfs.h
>> > @@ -87,6 +87,7 @@ extern ssize_t cifs_user_writev(struct kiocb *io=
cb, const struct iovec *iov,
>> > =A0extern ssize_t cifs_strict_writev(struct kiocb *iocb, const str=
uct iovec *iov,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
unsigned long nr_segs, loff_t pos);
>> > =A0extern int cifs_lock(struct file *, int, struct file_lock *);
>> > +extern int cifs_flock(struct file *, int, struct file_lock *);
>> > =A0extern int cifs_fsync(struct file *, loff_t, loff_t, int);
>> > =A0extern int cifs_strict_fsync(struct file *, loff_t, loff_t, int=
);
>> > =A0extern int cifs_flush(struct file *, fl_owner_t id);
>> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> > index c1f063c..dd34f0b 100644
>> > --- a/fs/cifs/file.c
>> > +++ b/fs/cifs/file.c
>> > @@ -43,6 +43,23 @@
>> > =A0#include "cifs_fs_sb.h"
>> > =A0#include "fscache.h"
>> >
>> > +static int do_vfs_lock(struct file *file, struct file_lock *fl)
>> > +{
>> > + =A0 =A0 =A0 int res =3D 0;
>> > +
>> > + =A0 =A0 =A0 switch (fl->fl_flags & (FL_POSIX|FL_FLOCK)) {
>> > + =A0 =A0 =A0 case FL_POSIX:
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 res =3D posix_lock_file_wait(file, f=
l);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > + =A0 =A0 =A0 case FL_FLOCK:
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 res =3D flock_lock_file_wait(file, f=
l);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > + =A0 =A0 =A0 default:
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG();
>> > + =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 return res;
>> > +}
>> > +
>> > =A0static inline int cifs_convert_flags(unsigned int flags)
>> > =A0{
>> > =A0 =A0 =A0 =A0if ((flags & O_ACCMODE) =3D=3D O_RDONLY)
>> > @@ -814,7 +831,7 @@ cifs_posix_lock_set(struct file *file, struct =
file_lock *flock)
>> > =A0 =A0 =A0 =A0struct cifsInodeInfo *cinode =3D CIFS_I(file->f_pat=
h.dentry->d_inode);
>> > =A0 =A0 =A0 =A0int rc =3D 1;
>> >
>> > - =A0 =A0 =A0 if ((flock->fl_flags & FL_POSIX) =3D=3D 0)
>> > + =A0 =A0 =A0 if ((flock->fl_flags & (FL_POSIX | FL_FLOCK)) =3D=3D=
 0)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>> >
>> > =A0 =A0 =A0 =A0mutex_lock(&cinode->lock_mutex);
>> > @@ -822,7 +839,7 @@ cifs_posix_lock_set(struct file *file, struct =
file_lock *flock)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>> > =A0 =A0 =A0 =A0}
>> > - =A0 =A0 =A0 rc =3D posix_lock_file_wait(file, flock);
>> > + =A0 =A0 =A0 rc =3D do_vfs_lock(file, flock);
>> > =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
>> > =A0 =A0 =A0 =A0return rc;
>> > =A0}
>> > @@ -1231,12 +1248,27 @@ cifs_setlk(struct file *file, =A0struct fi=
le_lock *flock, __u8 type,
>> > =A0 =A0 =A0 =A0struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink)=
;
>> > =A0 =A0 =A0 =A0struct cifsInodeInfo *cinode =3D CIFS_I(file->f_pat=
h.dentry->d_inode);
>> > =A0 =A0 =A0 =A0__u16 netfid =3D cfile->netfid;
>> > + =A0 =A0 =A0 unsigned char fl_flags =3D flock->fl_flags;
>> > +
>> > + =A0 =A0 =A0 if (unlock) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*Check for existance of lock*/
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_flags |=3D FL_EXISTS;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (do_vfs_lock(flock->fl_file, floc=
k) =3D=3D -ENOENT)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 } else {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*Check if we can obtain lock*/
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_flags |=3D FL_ACCESS;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D do_vfs_lock(flock->fl_file, f=
lock);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 flock->fl_flags =3D fl_flags;
>>
>> I think this should be skipped for non-posix locks. These locks have
>> their own cache (cifs_lock_* functions) associated with cifsInodeInf=
o
>> structure - so, we can't make a solution to 'goto out;' without
>> looking at this cache.
>
> I could follow Jeff's suggestion here and take the BUG out of
> do_vfs_lock(). In case of non posix/non flocks, the do_vfs_lock will
> simply return 0 and not trigger the goto out and proceed normally.

Sorry, I think I wasn't clear. In CIFS we have two locks variant
according to whether we use POSIX extensions or not. In the case of
POSIX extensions enabled we use VFS brlock cache and it is mirrors the
locks we have on the remote side. So, everything is good in this case.

Let's look at the case when POSIX extensions are disabled - Windows
locking style. The brlocks behavior changes and we use our own cache
for them but we need to call posix_file_lock_wait at the end of
cifs_setlk  to make some use-cases work (e.g. unlock locks of the
child process when it finishes, etc) . And these locks are still
=46L_POSIX locks from VFS point of view.

So, I am ok with your changes for POSIX extensions enabled case. Let's =
move
>> > + =A0 =A0 =A0 if (unlock) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*Check for existance of lock*/
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_flags |=3D FL_EXISTS;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (do_vfs_lock(flock->fl_file, floc=
k) =3D=3D -ENOENT)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 } else {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*Check if we can obtain lock*/
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_flags |=3D FL_ACCESS;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D do_vfs_lock(flock->fl_file, f=
lock);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 flock->fl_flags =3D fl_flags;

to the beginning of 'if (posix_lck) {}' and

> > +       if (rc =3D=3D 0 && lock) {
> > +               /*We have to sleep here*/
> > +               flock->fl_flags |=3D FL_SLEEP;
> > +               do_vfs_lock(file, flock);
> > +       }
> > + =A0 =A0 =A0 flock->fl_flags =3D fl_flags;
              return rc;

to the end of it.

>
>
>>
>> >
>> > =A0 =A0 =A0 =A0if (posix_lck) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int posix_lock_type;
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_posix_lock_set(file, fl=
ock);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc || rc < 0)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc <=3D 0)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (type & LOCKING_ANDX_SHARED_LOCK=
)
>> > @@ -1250,7 +1282,7 @@ cifs_setlk(struct file *file, =A0struct file=
_lock *flock, __u8 type,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBPosixLock(xid, tcon, =
netfid, current->tgid,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00 /* set */, length, flock,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0posix_lock_type, wait_flag);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_lock;
>> > =A0 =A0 =A0 =A0}
>> >
>> > =A0 =A0 =A0 =A0if (lock) {
>> > @@ -1259,7 +1291,7 @@ cifs_setlk(struct file *file, =A0struct file=
_lock *flock, __u8 type,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc < 0)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (!rc)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_lock;
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBLock(xid, tcon, netfi=
d, current->tgid, length,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fl=
ock->fl_start, 0, 1, type, wait_flag, 0);
>> > @@ -1271,9 +1303,14 @@ cifs_setlk(struct file *file, =A0struct fil=
e_lock *flock, __u8 type,
>> > =A0 =A0 =A0 =A0} else if (unlock)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_unlock_range(cfile, flo=
ck, xid);
>> >
>> > +out_lock:
>> > + =A0 =A0 =A0 if (rc =3D=3D 0 && lock) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*We have to sleep here*/
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flock->fl_flags |=3D FL_SLEEP;
>>
>> It's not clear why we should sleep here - the patch description
>> doesn't tell anything about it.
>
> At this stage you have a lock on the remote server. You need to make
> sure you have a lock on the local machine before you proceed. This ch=
eck
> is similar to the NFS client code.
>
>>
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_vfs_lock(file, flock);
>> > + =A0 =A0 =A0 }
>>
>> What's about unlock case here?
>
> Unlock is done in the lines above in the if(unlock) case. We set flag
> FL_EXISTS and then do a unlock. In case the lock to be unlocked doesn=
't
> exist, we error with a ENOENT and exit. If it does find a lock, it
> unlocks and then proceeds to unlock on the remote server too.
>
> This is required because the file close routine will call unlock call=
s
> for both posix and flock without actually determining what sort of lo=
ck
> is held. Without this code, my test module was making 2 unlock reques=
ts
> ie. one for posix locks and one for flocks for same same flock to the
> remote server.
>
>>
>> > =A0out:
>> > - =A0 =A0 =A0 if (flock->fl_flags & FL_POSIX)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_lock_file_wait(file, flock);

And simply call do_vfs_lock() rather than posix_lock_file_wait() here
for Windows locking case.

>> > + =A0 =A0 =A0 flock->fl_flags =3D fl_flags;
>> > =A0 =A0 =A0 =A0return rc;
>> > =A0}
>> >
>> > @@ -1334,6 +1371,22 @@ int cifs_lock(struct file *file, int cmd, s=
truct file_lock *flock)
>> > =A0 =A0 =A0 =A0return rc;
>> > =A0}
>> >
>> > +int cifs_flock(struct file *file, int cmd, struct file_lock *floc=
k)
>> > +{
>> > + =A0 =A0 =A0 int rc;
>> > +
>> > + =A0 =A0 =A0 rc =3D cifs_lock(file, cmd, flock);
>> > +
>> > + =A0 =A0 =A0 /*
>> > + =A0 =A0 =A0 =A0* flock requires -EWOULDBLOCK in case of conflict=
ing locks
>> > + =A0 =A0 =A0 =A0* and LOCK_NB is used
>> > + =A0 =A0 =A0 =A0*/
>> > + =A0 =A0 =A0 if ((rc =3D=3D -EACCES) && !(flock->fl_flags & FL_SL=
EEP))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EWOULDBLOCK;
>> > +
>> > + =A0 =A0 =A0 return rc;
>> > +}
>> > +
>> > =A0/* update the file size (if needed) after a write */
>> > =A0void
>> > =A0cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
>> >
>> >
>> >
>>
>> In general, I think that this patch does much more than it's mention=
ed
>> in the description and brings a lot of changes in the existing lock
>> code.
>>
>> It seems like we should only change posix_file_lock_wait to your
>> do_vfs_lock in 'out' label and cifs_posix_lock_set for posix_lck cas=
e
>> and map flock to brlock from 0 to INF for !posix_lck case.
>>
>
> When coding this, I followed the NFS client code which adds more chec=
ks
> and balances to ensure that the local and remote locks do not go out =
of
> sync.
>
> Sachin Prabhu
>
>



--=20
Best regards,
Pavel Shilovsky.
