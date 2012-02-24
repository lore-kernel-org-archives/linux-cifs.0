From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Do not kmalloc under the flocks spinlock
Date: Fri, 24 Feb 2012 07:47:51 -0500
Message-ID: <20120224074751.608947b3@tlielax.poochiereds.net>
References: <1329901855-11683-1-git-send-email-piastry@etersoft.ru>
	<20120222073446.1fbdddac@tlielax.poochiereds.net>
	<CAKywueRMobe5OEm4K2Xrh3KwTDKXk4Uh-68gM==UnHXvQNBonQ@mail.gmail.com>
	<20120223064931.23539689@tlielax.poochiereds.net>
	<CAKywueRJHQiAjkqDgX=ZmSKcc1bAi7o4AuyFzCj0Grjq0HSE9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRJHQiAjkqDgX=ZmSKcc1bAi7o4AuyFzCj0Grjq0HSE9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 24 Feb 2012 15:32:32 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2012/2/23 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > On Thu, 23 Feb 2012 10:56:40 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> 2012/2/22 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> >> >
> >> > Hmm...looking at my machine:
> >> >
> >> > (gdb) p sizeof(struct cifsLockInfo)
> >> > $1 =3D 144
> >> >
> >> > So that's 144 bytes per struct...what's the upper limit on "coun=
t"?
> >> >
> >> > It seems like that could potentially be a large allocation, and =
we have
> >> > to do this in the oplock break codepath.
> >> >
> >> > Instead of doing this, would it be better to allocate these when
> >> > the VFS first calls ->lock, and attach them to a new member of
> >> > file_lock.fl_u?
> >>
> >> Every time we can have a different number of locks - so, can't
> >> pre-allocate it.
> >
> > You could preallocate these:
> >
> > 1/ Do the allocation in cifs_setlk
> > 2/ Attach it to a new fl_u member in the file_lock struct
>=20
> I am sure I got the idea. Do you mean to allocate the memory in inode=
->i_flock?
>=20

Well, no...I meant that you would want to add a new file_lock->fl_u
union member and stick the pointer there and do the allocation earlier
in cifs_setlk.

> > 3/ Add a fl_release_private op to free that object
> >
> > Of course, you will need to consider how to deal with lock splittin=
g
> > and merging if you do that...
>=20
> Yes, how can we deal with this sort of things? We can calculate the
> lock number after every cifs_setlk but it's rather time consumption.
>=20
> If we use this struct:
>=20
> struct lock_to_push {
>         __u64 offset;
>         __u64 length;
>         __u32 pid;
>         __u16 netfid;
>         __u8 type;
> };
>=20
> it's sizeof is 24 bytes. If we have e.g 10^5 locks we end up with
> 2400000 bytes =3D 2.4 megabyte - don't think allocating this plays an=
y
> big role in whole time we need to push 10^5 locks to the server.
> What's the problem with allocating it here?
>=20

2.4 M would be an enormous allocation in the kernel and would almost
certainly fail. :)

In order to do a large allocation in the kernel via kmem_cache_alloc,
you need contiguous physical memory. Over time, memory gets fragmented.
The page allocator may need to do things like initiate writeback or
migrate pages in order to satisfy your request. That can be very slow
and creates extra load on the box.

It's best to avoid that if possible, especially in codepaths like this
where you're doing this in workqueue context and reporting an error
back to the user is pretty much impossible.

If you do these allocations up front, when you set the lock the caller
can get back an ENOMEM or whatever on the fcntl call. At this point,
recovering from an allocation error will always be problematic.

> >
> >> I can create new struct for this only - without extra
> >> llist, blist, block_q fields, that can save enough memory.
> >>
> >
> > That sounds preferable. We really don't want to allocate more memor=
y
> > than is needed. Plus, anytime you duplicate information at least on=
e
> > copy is going to be wrong at some point in time.
> >
> >> >
> >> >> =C2=A0 =C2=A0 =C2=A0 lock_flocks();
> >> >> =C2=A0 =C2=A0 =C2=A0 cifs_for_each_lock(cfile->dentry->d_inode,=
 before) {
> >> >> @@ -950,35 +962,38 @@ cifs_push_posix_locks(struct cifsFileInfo=
 *cfile)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 type =3D CIFS_RDLCK;
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 type =3D CIFS_WRLCK;
> >> >> -
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck =3D cifs_lock_i=
nit(flock->fl_start, length, type,
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cfile->netfid);
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!lck) {
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 rc =3D -ENOMEM;
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto send_locks;
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck =3D &lcks[i];
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck->pid =3D f=
lock->fl_pid;
> >> >> -
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_add_tail(&lck-=
>llist, &locks_to_send);
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck->netfid =3D cfi=
le->netfid;
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck->length =3D len=
gth;
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck->type =3D type;
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck->offset =3D flo=
ck->fl_start;
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (i =3D=3D count)
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> >> >> =C2=A0 =C2=A0 =C2=A0 }
> >> >> -
> >> >> -send_locks:
> >> >> =C2=A0 =C2=A0 =C2=A0 unlock_flocks();
> >> >>
> >> >> - =C2=A0 =C2=A0 list_for_each_entry_safe(lck, tmp, &locks_to_se=
nd, llist) {
> >> >> + =C2=A0 =C2=A0 if (i =3D=3D count)
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "Can't pu=
sh all brlocks!");
> >> >> +
> >> >
> >> > This sort of thing always makes me a little worried. Sure, you'r=
e
> >> > allocating a bunch of extra locks, but what's the potential effe=
ct
> >> > of not being able to push all the locks here? The user is going =
to
> >> > see this message and have no clue of what it means.
> >> >
> >> > Even I'm not sure what this means in practice. The VFS will have=
 a
> >> > record of this lock, but the server won't...
> >> >
> >>
> >> I really think that there will be no such situations, because we h=
old
> >> inode->lock_mutex - the locking state should leave the same.
> >>
> >
> > I don't share that optimism.
> >
> > The lock_mutex protects the cinode->llist, but here you're walking =
the
> > inode->i_flock list. It's certainly possible that it could change i=
n
> > between unlock_flocks and lock_flocks.
> >
>=20
> The lock_mutex now protects not only cinode->llist, but locks from th=
e
> inode structure reached from cifs code as well. The only thing I
> missed is posix_lock_file_wait in the end of the cifs_setlk function =
-
> it should be surrounded with lock_mutex as well. According to this,
> there is no other way to increase POSIX lock number from the inode
> except locking/unlocking lock_mutex.
>=20

Ok, that will probably cover it this for now. Here's what I'd suggest:

1/ that locking needs to be documented, or were almost certain to break
it later.

2/ don't allocate more structs than you need. If you know that the list
won't change while you're holding the lock_mutex then there's no reason
to do so.

That said...this whole scheme seems quite fragile. I wonder if there's
a better way to do this that doesn't require quite so much to happen at
oplock break time...

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
