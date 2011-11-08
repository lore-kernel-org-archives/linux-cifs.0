From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Add support for flock over a cifs mount.
Date: Tue, 08 Nov 2011 17:26:41 +0000
Message-ID: <1320773203.1690.35.camel@sprabhu.fab.redhat.com>
References: <1320696342.1690.19.camel@sprabhu.fab.redhat.com>
	 <CAKywueTSqckM1iVsrEu47RwBA3GnpfZU17QrrNineJBVOcZdvQ@mail.gmail.com>
	 <1320751612.2941.10.camel@localhost>
	 <CAKywueQ65EgLz9iDd2exq85jBMGrBFLiq=mq2dOY9poy3_1h0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQ65EgLz9iDd2exq85jBMGrBFLiq=mq2dOY9poy3_1h0g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2011-11-08 at 16:21 +0400, Pavel Shilovsky wrote:

> >> > @@ -1231,12 +1248,27 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
> >> >        struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
> >> >        struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
> >> >        __u16 netfid = cfile->netfid;
> >> > +       unsigned char fl_flags = flock->fl_flags;
> >> > +
> >> > +       if (unlock) {
> >> > +               /*Check for existance of lock*/
> >> > +               flock->fl_flags |= FL_EXISTS;
> >> > +               if (do_vfs_lock(flock->fl_file, flock) == -ENOENT)
> >> > +                       goto out;
> >> > +       } else {
> >> > +               /*Check if we can obtain lock*/
> >> > +               flock->fl_flags |= FL_ACCESS;
> >> > +               rc = do_vfs_lock(flock->fl_file, flock);
> >> > +               if (rc < 0)
> >> > +                       goto out;
> >> > +       }
> >> > +       flock->fl_flags = fl_flags;
> >>
> >> I think this should be skipped for non-posix locks. These locks have
> >> their own cache (cifs_lock_* functions) associated with cifsInodeInfo
> >> structure - so, we can't make a solution to 'goto out;' without
> >> looking at this cache.
> >
> > I could follow Jeff's suggestion here and take the BUG out of
> > do_vfs_lock(). In case of non posix/non flocks, the do_vfs_lock will
> > simply return 0 and not trigger the goto out and proceed normally.
> 
> Sorry, I think I wasn't clear. In CIFS we have two locks variant
> according to whether we use POSIX extensions or not. In the case of
> POSIX extensions enabled we use VFS brlock cache and it is mirrors the
> locks we have on the remote side. So, everything is good in this case.
> 
> Let's look at the case when POSIX extensions are disabled - Windows
> locking style. The brlocks behavior changes and we use our own cache
> for them but we need to call posix_file_lock_wait at the end of
> cifs_setlk  to make some use-cases work (e.g. unlock locks of the
> child process when it finishes, etc) . And these locks are still
> FL_POSIX locks from VFS point of view.

Pavel,

The code behaves in a similar manner to the previous versions of the
code in case of non posix locks. This simply adds support for FL_FLOCK
in addition to Posix lock. 

Let me explain what has to happen for the goto out to be called in the 2
if conditions which seem to be the problem.

1) 
        if (unlock) {
                /*Check for existance of lock*/
                flock->fl_flags |= FL_EXISTS; 
                if (do_vfs_lock(flock->fl_file, flock) == -ENOENT)
                        goto out;

The comment associated with FL_EXISTS in include/linux/fs.h is 
#define FL_EXISTS       16      /* when unlocking, test for existence */

If this was an unlock request and the call to unlock the file reports
that the lock doesn't exists then goto out and exit with -ENOENT. This
is correct since there is no lock on this file to unlock.

If the lock did exist, then it unlocks the lock, proceeds normally and
calls cifs_unlock_range(cfile, flock, xid) further below which unlocks
the lock held in the local brlocks cache.

2)        
	 } else {
                /*Check if we can obtain lock*/
                flock->fl_flags |= FL_ACCESS;
                rc = do_vfs_lock(flock->fl_file, flock);
                if (rc < 0)
                        goto out;


The comment associated with FL_ACCESS in include/linux/fs.h is 
#define FL_ACCESS       8       /* not trying to lock, just looking */

It attempts to lock the file. If this attempt fails, it refuses to do
the remote lock call since we will not be able to get a local lock in
this case. In this case, exit with the error message returned by
do_vfs_lock().

If it face no problems obtaining a lock locally then proceed to perform
normal locking operations as before and finally obtain a lock on the
local system with 

out_lock:
        if (rc == 0 && lock) {
                /*We have to sleep here*/
                flock->fl_flags |= FL_SLEEP;
                do_vfs_lock(file, flock);
        }

We have to use do_vfs_lock() in this case since we are now dealing with
both flocks as well as posix locks. The same use case you explained
earlier holds where any existing flocks and posix locks on the file have
to be cleared when the file is closed. The old call to
posix_lock_file_wait will only end up adding a posix lock to the file
when we instead need a flock.


Sachin Prabhu
