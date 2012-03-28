From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix VFS lock usage for oplocked files
Date: Wed, 28 Mar 2012 13:41:33 -0400
Message-ID: <20120328134133.0d255c37@corrin.poochiereds.net>
References: <1332848175-6441-1-git-send-email-piastry@etersoft.ru>
	<20120327173032.5bd6b60d@tlielax.poochiereds.net>
	<CAKywueSvhFT=PQSLZ=AFs6v3+Bz1-vT=9WGz5SJs8j9dajpMKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSvhFT=PQSLZ=AFs6v3+Bz1-vT=9WGz5SJs8j9dajpMKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 28 Mar 2012 09:33:47 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 28 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2012=C2=A0=D0=B3. 1:30 =D0=BF=D0=BE=
=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Jeff Layto=
n <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> > On Tue, 27 Mar 2012 15:36:15 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> We can deadlock if we have a write oplock and two processes
> >> use the same file handle. In this case the first process can't
> >> unlock its lock if another process blocked on the lock in the
> >> same time.
> >>
> >> Fix this by removing lock_mutex protection from waiting on a
> >> blocked lock and protect only posix_lock_file call.
> >>
> >
> > Perhaps this means that the model of using a giant mutex around all=
 of
> > this code needs a fundamental rethink?
> >
> > Any time you wrap a large section of code under a giant lock (like =
the
> > lock_mutex here), then you invite a whole host of problems --
> > scalability issues for one, and there's also the problem of ensurin=
g
> > that you understand what the lock is intended to protect. Witness t=
he
> > pain and agony that accompanied the BKL removal effort for the last
> > decade...
> >
> >> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/file.c | =C2=A0 56 +++++++++++++++++++++++++++++++++=
+++++++++++++++++++----
> >> =C2=A01 files changed, 52 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index 159fcc5..2bf04e9 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -671,6 +671,21 @@ cifs_del_lock_waiters(struct cifsLockInfo *lo=
ck)
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0}
> >>
> >> +/*
> >> + * Copied from fs/locks.c with small changes.
> >> + * Remove waiter from blocker's block list.
> >> + * When blocker ends up pointing to itself then the list is empty=
=2E
> >> + */
> >> +static void
> >> +cifs_locks_delete_block(struct file_lock *waiter)
> >> +{
> >> + =C2=A0 =C2=A0 lock_flocks();
> >> + =C2=A0 =C2=A0 list_del_init(&waiter->fl_block);
> >> + =C2=A0 =C2=A0 list_del_init(&waiter->fl_link);
> >> + =C2=A0 =C2=A0 waiter->fl_next =3D NULL;
> >> + =C2=A0 =C2=A0 unlock_flocks();
> >> +}
> >> +
> >
> > This is the same exact function as locks_delete_block. What is the
> > point of copying it here instead of using that? It will of course n=
eed
> > to be exported...
> >
> >> =C2=A0static bool
> >> =C2=A0__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u6=
4 offset,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 __u64 length, __u8 type, __u16 netfid,
> >> @@ -820,6 +835,39 @@ cifs_posix_lock_test(struct file *file, struc=
t file_lock *flock)
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0}
> >>
> >> +/* Called with locked lock_mutex, return with unlocked. */
> >> +static int
> >> +cifs_posix_lock_file_wait_locked(struct file *file, struct file_l=
ock *flock)
> >> +{
> >> + =C2=A0 =C2=A0 struct cifsInodeInfo *cinode =3D CIFS_I(file->f_pa=
th.dentry->d_inode);
> >> + =C2=A0 =C2=A0 int rc;
> >> +
> >> + =C2=A0 =C2=A0 while (true) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D posix_lock_file=
(file, flock, NULL);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&cinode->=
lock_mutex);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc !=3D FILE_LOCK_=
DEFERRED)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D wait_event_inte=
rruptible(flock->fl_wait, !flock->fl_next);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 mutex_lock(&cinode->lock_mutex);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 continue;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_locks_delete_bloc=
k(flock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> >> + =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 return rc;
> >> +}
> >> +
> >> +static int
> >> +cifs_posix_lock_file_wait(struct file *file, struct file_lock *fl=
ock)
> >> +{
> >> + =C2=A0 =C2=A0 struct cifsInodeInfo *cinode =3D CIFS_I(file->f_pa=
th.dentry->d_inode);
> >> +
> >> + =C2=A0 =C2=A0 mutex_lock(&cinode->lock_mutex);
> >> + =C2=A0 =C2=A0 /* lock_mutex will be released by the function bel=
ow */
> >> + =C2=A0 =C2=A0 return cifs_posix_lock_file_wait_locked(file, floc=
k);
> >> +}
> >> +
> >
> > lock handling that crosses function boundaries is almost always a r=
ed
> > flag that something is not well-designed and will end up broken or
> > being rewritten at some point in the future. I'd urge you not to
> > establish this sort of API.
> >
> >> =C2=A0/*
> >> =C2=A0 * Set the byte-range lock (posix style). Returns:
> >> =C2=A0 * 1) 0, if we set the lock and don't need to request to the=
 server;
> >> @@ -840,9 +888,9 @@ cifs_posix_lock_set(struct file *file, struct =
file_lock *flock)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&cin=
ode->lock_mutex);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> - =C2=A0 =C2=A0 rc =3D posix_lock_file_wait(file, flock);
> >> - =C2=A0 =C2=A0 mutex_unlock(&cinode->lock_mutex);
> >> - =C2=A0 =C2=A0 return rc;
> >
> > Ok, so the original bug was here. When one thread is blocked here a=
nd
> > waiting for the lock then you can't get the mutex in order to relea=
se
> > it...
> >
> > This patch looks like it'll "fix" the immediate problem, but I'm
> > concerned that the purpose of the lock_mutex is not entirely clear.
> >
> > What data structures does it protect? A better solution probably wi=
ll
> > involve moving more of this code outside of it by determining which
> > data structures are protected by it.
> >
> >> +
> >> + =C2=A0 =C2=A0 /* lock_mutex will be released by the function bel=
ow */
> >> + =C2=A0 =C2=A0 return cifs_posix_lock_file_wait_locked(file, floc=
k);
> >> =C2=A0}
> >>
> >> =C2=A0static int
> >> @@ -1338,7 +1386,7 @@ cifs_setlk(struct file *file, =C2=A0struct f=
ile_lock *flock, __u8 type,
> >>
> >> =C2=A0out:
> >> =C2=A0 =C2=A0 =C2=A0 if (flock->fl_flags & FL_POSIX)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 posix_lock_file_wait(f=
ile, flock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_posix_lock_file_w=
ait(file, flock);
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0}
> >>
> >
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
>=20
> So, to be clear:
>=20
> the main purpose of lock_mutex is protecting _all_ lock operations on
> the inode as well as can_cache_brlocks flag. We have to deal with
> simultaneous oplock break and fcntl requests to be sure that:
>=20

> we push all the lock we have in the cache when oplock break comes. Al=
l
> other locks that comes after that will be sent to the server.
>=20
> This is the main problem I tried to solve when designing brlock cache
> - races with oplock breaks.
>=20
> The posix locking is slightly more complex than mandatory one because
> it has its own protection - lock/unlock_flocks(). But I really don't
> think we have problems using two protection mechanism at the same
> time: lock_mutex is always surrounds flocks.
>=20
> As for the bug that this patch fixes, it was my fault of not
> understanding fluently how posix_lock_file_wait works - not a design
> problem.
>=20
> As for cross-locking function, I suggest to drop this change from the
> patch because it is not directly related to the problem it solves (I
> made this change to be more safe, but seems it needs more thoughts):
> >> =C2=A0 =C2=A0 =C2=A0 if (flock->fl_flags & FL_POSIX)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 posix_lock_file_wait(f=
ile, flock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_posix_lock_file_w=
ait(file, flock);
>=20
> in this case we don't need cifs_posix_lock_file_wait/locked variants
> and the code can be moved into
> cifs_posix_lock_set function that not introduces new API.
>=20


That's exactly what I'm talking about. You're using the lock to
serialize a vague set of "lock operations", instead of using it to
protect data. That's almost always a recipe for problems as it's almost
impossible to get it provably correct.

Sometimes doing that sort of thing is justified. The mutex that
serializes access to the socket that we use to communicate with the
server for example. In that case we have a single stream of data that
to and from the server, and access to it must be serialized. We also
use it to protect the signature. Even that lock surrounds more code
than I'm comfortable with, but I don't see a better way to handle it.

The generic VFS level locking code does something similar with
lock_flocks(). Why? Because it was originally protected by the BKL, and
*no one* understood how the locking was intended to work well enough to
do anything but wrap it in a similar spinlock in order to finish up the
BKL removal.

Here, you're repeating many of those same mistakes and it's already
proving to be problematic. I think you really ought to take a step back
and determine what _data_ this lock is intended to protect and ensure
that the locking does what you expect.

The patch you're proposing may be an expedient fix in the interim, but
you're almost certainly going to have to revisit this locking in the
future.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
