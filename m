From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/3] CIFS: Simplify setlk error handling for mandatory
 locking
Date: Tue, 1 Nov 2011 06:06:29 -0400
Message-ID: <20111101060629.3791aff1@tlielax.poochiereds.net>
References: <1319894279-7723-1-git-send-email-piastry@etersoft.ru>
	<1319894279-7723-2-git-send-email-piastry@etersoft.ru>
	<20111031065444.6214d49a@tlielax.poochiereds.net>
	<CAKywueR3FCDrM5emak5=JDY9Tj0HFTqHwXpNfP99-i76j_V6jw@mail.gmail.com>
	<CAKywueRQE1VNj_YQPVwp9j1bQPX_8zNoD4c3hKyC9e_7=LBhbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRQE1VNj_YQPVwp9j1bQPX_8zNoD4c3hKyC9e_7=LBhbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 31 Oct 2011 14:04:00 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/10/31 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> > 2011/10/31 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> >> On Sat, 29 Oct 2011 17:17:58 +0400
> >> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >>
> >>> Now we allocate a lock structure at first, then we request to the=
 server
> >>> and save the lock if server returned OK though void function - it=
 prevents
> >>> the situation when we locked a file on the server and then return=
 -ENOMEM
> >>> from setlk.
> >>>
> >>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >>> ---
> >>> =C2=A0fs/cifs/file.c | =C2=A0 64 ++++++++++++++++++++++++++++----=
------------------------
> >>> =C2=A01 files changed, 32 insertions(+), 32 deletions(-)
> >>>
> >>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >>> index c1f063c..d9cc07f 100644
> >>> --- a/fs/cifs/file.c
> >>> +++ b/fs/cifs/file.c
> >>> @@ -672,7 +672,7 @@ cifs_del_lock_waiters(struct cifsLockInfo *lo=
ck)
> >>> =C2=A0}
> >>>
> >>> =C2=A0static bool
> >>> -cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offs=
et,
> >>> +__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 of=
fset,
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 __u64 length, __u8 type, __u16 netfid,
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 struct cifsLockInfo **conf_lock)
> >>> =C2=A0{
> >>> @@ -694,6 +694,14 @@ cifs_find_lock_conflict(struct cifsInodeInfo=
 *cinode, __u64 offset,
> >>> =C2=A0 =C2=A0 =C2=A0 return false;
> >>> =C2=A0}
> >>>
> >>> +static bool
> >>> +cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cif=
sLockInfo *lock,
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 struct cifsLockInfo **conf_lock)
> >>> +{
> >>> + =C2=A0 =C2=A0 return __cifs_find_lock_conflict(cinode, lock->of=
fset, lock->length,
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lo=
ck->type, lock->netfid, conf_lock);
> >>> +}
> >>> +
> >>> =C2=A0static int
> >>> =C2=A0cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, =
__u64 length,
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u8 type, __u16 =
netfid, struct file_lock *flock)
> >>> @@ -704,8 +712,8 @@ cifs_lock_test(struct cifsInodeInfo *cinode, =
__u64 offset, __u64 length,
> >>>
> >>> =C2=A0 =C2=A0 =C2=A0 mutex_lock(&cinode->lock_mutex);
> >>>
> >>> - =C2=A0 =C2=A0 exist =3D cifs_find_lock_conflict(cinode, offset,=
 length, type, netfid,
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &conf_lo=
ck);
> >>> + =C2=A0 =C2=A0 exist =3D __cifs_find_lock_conflict(cinode, offse=
t, length, type, netfid,
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &=
conf_lock);
> >>> =C2=A0 =C2=A0 =C2=A0 if (exist) {
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 flock->fl_start =
=3D conf_lock->offset;
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 flock->fl_end =3D=
 conf_lock->offset + conf_lock->length - 1;
> >>> @@ -723,40 +731,27 @@ cifs_lock_test(struct cifsInodeInfo *cinode=
, __u64 offset, __u64 length,
> >>> =C2=A0 =C2=A0 =C2=A0 return rc;
> >>> =C2=A0}
> >>>
> >>> -static int
> >>> -cifs_lock_add(struct cifsInodeInfo *cinode, __u64 len, __u64 off=
set,
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __u8 type, __u16 netfid)
> >>> +static void
> >>> +cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo =
*lock)
> >>> =C2=A0{
> >>> - =C2=A0 =C2=A0 struct cifsLockInfo *li;
> >>> -
> >>> - =C2=A0 =C2=A0 li =3D cifs_lock_init(len, offset, type, netfid);
> >>> - =C2=A0 =C2=A0 if (!li)
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> >>> -
> >>> =C2=A0 =C2=A0 =C2=A0 mutex_lock(&cinode->lock_mutex);
> >>> - =C2=A0 =C2=A0 list_add_tail(&li->llist, &cinode->llist);
> >>> + =C2=A0 =C2=A0 list_add_tail(&lock->llist, &cinode->llist);
> >>> =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&cinode->lock_mutex);
> >>> - =C2=A0 =C2=A0 return 0;
> >>> =C2=A0}
> >>>
> >>> =C2=A0static int
> >>> -cifs_lock_add_if(struct cifsInodeInfo *cinode, __u64 offset, __u=
64 length,
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u8 type, __u1=
6 netfid, bool wait)
> >>> +cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockIn=
fo *lock,
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool wait)
> >>> =C2=A0{
> >>> - =C2=A0 =C2=A0 struct cifsLockInfo *lock, *conf_lock;
> >>> + =C2=A0 =C2=A0 struct cifsLockInfo *conf_lock;
> >>> =C2=A0 =C2=A0 =C2=A0 bool exist;
> >>> =C2=A0 =C2=A0 =C2=A0 int rc =3D 0;
> >>>
> >>> - =C2=A0 =C2=A0 lock =3D cifs_lock_init(length, offset, type, net=
fid);
> >>> - =C2=A0 =C2=A0 if (!lock)
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> >>> -
> >>> =C2=A0try_again:
> >>> =C2=A0 =C2=A0 =C2=A0 exist =3D false;
> >>> =C2=A0 =C2=A0 =C2=A0 mutex_lock(&cinode->lock_mutex);
> >>>
> >>> - =C2=A0 =C2=A0 exist =3D cifs_find_lock_conflict(cinode, offset,=
 length, type, netfid,
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &conf_lo=
ck);
> >>> + =C2=A0 =C2=A0 exist =3D cifs_find_lock_conflict(cinode, lock, &=
conf_lock);
> >>> =C2=A0 =C2=A0 =C2=A0 if (!exist && cinode->can_cache_brlcks) {
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_add_tail(&l=
ock->llist, &cinode->llist);
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ci=
node->lock_mutex);
> >>> @@ -781,7 +776,6 @@ try_again:
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >>> =C2=A0 =C2=A0 =C2=A0 }
> >>>
> >>> - =C2=A0 =C2=A0 kfree(lock);
> >>> =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&cinode->lock_mutex);
> >>> =C2=A0 =C2=A0 =C2=A0 return rc;
> >>> =C2=A0}
> >>> @@ -1254,20 +1248,26 @@ cifs_setlk(struct file *file, =C2=A0struc=
t file_lock *flock, __u8 type,
> >>> =C2=A0 =C2=A0 =C2=A0 }
> >>>
> >>> =C2=A0 =C2=A0 =C2=A0 if (lock) {
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_lock_add_=
if(cinode, flock->fl_start, length,
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 type, netfid, w=
ait_flag);
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cifsLockInfo *=
lock;
> >>> +
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lock =3D cifs_lock_in=
it(length, flock->fl_start, type, netfid);
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!lock)
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 return -ENOMEM;
> >>> +
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_lock_add_=
if(cinode, lock, wait_flag);
> >>
> >> Here, you're adding "lock" to the list...
> >
> > If we added the lock to the list cifs_lock_add_if returns 0 and we
> > will jump to out label.
> >
> >>
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc < 0)
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 return rc;
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (!rc)
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 kfree(lock);
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc <=3D 0)
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;
> >>>
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSSMBLo=
ck(xid, tcon, netfid, current->tgid, length,
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0flock->fl_start, 0, 1, typ=
e, wait_flag, 0);
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc =3D=3D 0) {
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /* For Windows locks we must store them. */
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 rc =3D cifs_lock_add(cinode, length, flock->fl_start,
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0type, netfid);
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 kfree(lock);
> >>
> >> ...and here you're freeing "lock" without removing it from the lis=
t.
> >> Isn't that like to cause a problem?
> >
> > So, if CIFSSMBLock returns a error we free the lock that hasn't bee=
n
> > added to the list. If CIFSSMBLock returns ok, we will add it to the
> > list with cifs_lock_add void function.
> >
> > Seems no problem with it.
> >
> > --
> > Best regards,
> > Pavel Shilovsky.
> >
>=20
> So, to be clear - brlock cache function cifs_lock_add_if returns:
>=20
> "0" if we store the lock in the cache and have an oplock for batching
> brlocks - no need to request to the server.
>=20
> "1" if there is no locks preventing us to set this lock but we haven'=
t
> an oplock for batching brlocks - need to request to the server and
> then add the lock to the list if server accepts.
>=20
> "-EACCESS" if we have a lock on the client that prevent us and this
> call is non-blocked.
>=20

Ok, it looks like this patch is probably ok then, but it would be nice
to have the above explanation enshrined in a comment over
cifs_lock_add_if to ensure that other people working in this code
understand it.

Can you spin up a patch to add that when you get time? For this patch
though...


Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
