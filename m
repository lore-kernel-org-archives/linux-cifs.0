From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] Add support for flock over a cifs mount.
Date: Tue, 8 Nov 2011 23:08:26 +0400
Message-ID: <CAKywueSRYxizd+mKw8p93Os0Aqij+R2Dh=2hu6JuJ+bv7S+uWw@mail.gmail.com>
References: <1320696342.1690.19.camel@sprabhu.fab.redhat.com>
	<CAKywueTSqckM1iVsrEu47RwBA3GnpfZU17QrrNineJBVOcZdvQ@mail.gmail.com>
	<1320751612.2941.10.camel@localhost>
	<CAKywueQ65EgLz9iDd2exq85jBMGrBFLiq=mq2dOY9poy3_1h0g@mail.gmail.com>
	<1320773203.1690.35.camel@sprabhu.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320773203.1690.35.camel-yuq4rhG59MBosH8Q1Ye95IGKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/11/8 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Pavel,
>
> The code behaves in a similar manner to the previous versions of the
> code in case of non posix locks. This simply adds support for FL_FLOC=
K
> in addition to Posix lock.
>
> Let me explain what has to happen for the goto out to be called in th=
e 2
> if conditions which seem to be the problem.
>
> 1)
> =A0 =A0 =A0 =A0if (unlock) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*Check for existance of lock*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_flags |=3D FL_EXISTS;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (do_vfs_lock(flock->fl_file, flock)=
 =3D=3D -ENOENT)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> The comment associated with FL_EXISTS in include/linux/fs.h is
> #define FL_EXISTS =A0 =A0 =A0 16 =A0 =A0 =A0/* when unlocking, test f=
or existence */
>
> If this was an unlock request and the call to unlock the file reports
> that the lock doesn't exists then goto out and exit with -ENOENT. Thi=
s
> is correct since there is no lock on this file to unlock.
>
> If the lock did exist, then it unlocks the lock, proceeds normally an=
d
> calls cifs_unlock_range(cfile, flock, xid) further below which unlock=
s
> the lock held in the local brlocks cache.

Let's predict the following situation:

1) f1 =3D open(filename)
2) f2 =3D open(filename) # the same process
3) f1.lock(0, 1) # lock file from 0 to 1
4) f2.lock(1, 2) # lock file from 1 to 2
5) f1.unlock(0, 2)

it unlocks both locks (3) and (4) from the VFS cache but unlock only
(3) lock from CIFS-lock cache and server side (see cifs_unlock_range -
it unlocks only locks held by the same fd, not the same process) - the
lock (4) is still there.

6) f2.unlock(1, 2)

it appears into if (unlock) {}, fails on FL_EXISTS with -ENOENT and
goto out. The result we can't unlock the existing lock - the problem!

>
> 2)
> =A0 =A0 =A0 =A0 } else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*Check if we can obtain lock*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_flags |=3D FL_ACCESS;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D do_vfs_lock(flock->fl_file, flo=
ck);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
>
> The comment associated with FL_ACCESS in include/linux/fs.h is
> #define FL_ACCESS =A0 =A0 =A0 8 =A0 =A0 =A0 /* not trying to lock, ju=
st looking */
>
> It attempts to lock the file. If this attempt fails, it refuses to do
> the remote lock call since we will not be able to get a local lock in
> this case. In this case, exit with the error message returned by
> do_vfs_lock().
>
> If it face no problems obtaining a lock locally then proceed to perfo=
rm
> normal locking operations as before and finally obtain a lock on the
> local system with
>
> out_lock:
> =A0 =A0 =A0 =A0if (rc =3D=3D 0 && lock) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*We have to sleep here*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->fl_flags |=3D FL_SLEEP;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do_vfs_lock(file, flock);
> =A0 =A0 =A0 =A0}
>
> We have to use do_vfs_lock() in this case since we are now dealing wi=
th
> both flocks as well as posix locks. The same use case you explained
> earlier holds where any existing flocks and posix locks on the file h=
ave
> to be cleared when the file is closed. The old call to
> posix_lock_file_wait will only end up adding a posix lock to the file
> when we instead need a flock.
>
>
> Sachin Prabhu
>
>



--=20
Best regards,
Pavel Shilovsky.
