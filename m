From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Do not kmalloc under the flocks spinlock
Date: Thu, 23 Feb 2012 06:49:31 -0500
Message-ID: <20120223064931.23539689@tlielax.poochiereds.net>
References: <1329901855-11683-1-git-send-email-piastry@etersoft.ru>
	<20120222073446.1fbdddac@tlielax.poochiereds.net>
	<CAKywueRMobe5OEm4K2Xrh3KwTDKXk4Uh-68gM==UnHXvQNBonQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRMobe5OEm4K2Xrh3KwTDKXk4Uh-68gM==UnHXvQNBonQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 23 Feb 2012 10:56:40 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2012/2/22 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> >
> > Hmm...looking at my machine:
> >
> > (gdb) p sizeof(struct cifsLockInfo)
> > $1 =3D 144
> >
> > So that's 144 bytes per struct...what's the upper limit on "count"?
> >
> > It seems like that could potentially be a large allocation, and we =
have
> > to do this in the oplock break codepath.
> >
> > Instead of doing this, would it be better to allocate these when
> > the VFS first calls ->lock, and attach them to a new member of
> > file_lock.fl_u?
>=20
> Every time we can have a different number of locks - so, can't
> pre-allocate it.=20

You could preallocate these:

1/ Do the allocation in cifs_setlk
2/ Attach it to a new fl_u member in the file_lock struct
3/ Add a fl_release_private op to free that object

Of course, you will need to consider how to deal with lock splitting
and merging if you do that...

> I can create new struct for this only - without extra
> llist, blist, block_q fields, that can save enough memory.
>

That sounds preferable. We really don't want to allocate more memory
than is needed. Plus, anytime you duplicate information at least one
copy is going to be wrong at some point in time.

> >
> >> =C2=A0 =C2=A0 =C2=A0 lock_flocks();
> >> =C2=A0 =C2=A0 =C2=A0 cifs_for_each_lock(cfile->dentry->d_inode, be=
fore) {
> >> @@ -950,35 +962,38 @@ cifs_push_posix_locks(struct cifsFileInfo *c=
file)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 type =3D CIFS_RDLCK;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 type =3D CIFS_WRLCK;
> >> -
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck =3D cifs_lock_init=
(flock->fl_start, length, type,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cfile->netfid);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!lck) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D -ENOMEM;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto send_locks;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck =3D &lcks[i];
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck->pid =3D floc=
k->fl_pid;
> >> -
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_add_tail(&lck->ll=
ist, &locks_to_send);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck->netfid =3D cfile-=
>netfid;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck->length =3D length=
;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck->type =3D type;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lck->offset =3D flock-=
>fl_start;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (i =3D=3D count)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> -
> >> -send_locks:
> >> =C2=A0 =C2=A0 =C2=A0 unlock_flocks();
> >>
> >> - =C2=A0 =C2=A0 list_for_each_entry_safe(lck, tmp, &locks_to_send,=
 llist) {
> >> + =C2=A0 =C2=A0 if (i =3D=3D count)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "Can't push =
all brlocks!");
> >> +
> >
> > This sort of thing always makes me a little worried. Sure, you're
> > allocating a bunch of extra locks, but what's the potential effect
> > of not being able to push all the locks here? The user is going to
> > see this message and have no clue of what it means.
> >
> > Even I'm not sure what this means in practice. The VFS will have a
> > record of this lock, but the server won't...
> >
>=20
> I really think that there will be no such situations, because we hold
> inode->lock_mutex - the locking state should leave the same.
>=20

I don't share that optimism.

The lock_mutex protects the cinode->llist, but here you're walking the
inode->i_flock list. It's certainly possible that it could change in
between unlock_flocks and lock_flocks.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
