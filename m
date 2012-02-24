From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Do not kmalloc under the flocks spinlock
Date: Fri, 24 Feb 2012 15:32:32 +0400
Message-ID: <CAKywueRJHQiAjkqDgX=ZmSKcc1bAi7o4AuyFzCj0Grjq0HSE9g@mail.gmail.com>
References: <1329901855-11683-1-git-send-email-piastry@etersoft.ru>
	<20120222073446.1fbdddac@tlielax.poochiereds.net>
	<CAKywueRMobe5OEm4K2Xrh3KwTDKXk4Uh-68gM==UnHXvQNBonQ@mail.gmail.com>
	<20120223064931.23539689@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120223064931.23539689-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/23 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Thu, 23 Feb 2012 10:56:40 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2012/2/22 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> >
>> > Hmm...looking at my machine:
>> >
>> > (gdb) p sizeof(struct cifsLockInfo)
>> > $1 =3D 144
>> >
>> > So that's 144 bytes per struct...what's the upper limit on "count"=
?
>> >
>> > It seems like that could potentially be a large allocation, and we=
 have
>> > to do this in the oplock break codepath.
>> >
>> > Instead of doing this, would it be better to allocate these when
>> > the VFS first calls ->lock, and attach them to a new member of
>> > file_lock.fl_u?
>>
>> Every time we can have a different number of locks - so, can't
>> pre-allocate it.
>
> You could preallocate these:
>
> 1/ Do the allocation in cifs_setlk
> 2/ Attach it to a new fl_u member in the file_lock struct

I am sure I got the idea. Do you mean to allocate the memory in inode->=
i_flock?

> 3/ Add a fl_release_private op to free that object
>
> Of course, you will need to consider how to deal with lock splitting
> and merging if you do that...

Yes, how can we deal with this sort of things? We can calculate the
lock number after every cifs_setlk but it's rather time consumption.

If we use this struct:

struct lock_to_push {
        __u64 offset;
        __u64 length;
        __u32 pid;
        __u16 netfid;
        __u8 type;
};

it's sizeof is 24 bytes. If we have e.g 10^5 locks we end up with
2400000 bytes =3D 2.4 megabyte - don't think allocating this plays any
big role in whole time we need to push 10^5 locks to the server.
What's the problem with allocating it here?

>
>> I can create new struct for this only - without extra
>> llist, blist, block_q fields, that can save enough memory.
>>
>
> That sounds preferable. We really don't want to allocate more memory
> than is needed. Plus, anytime you duplicate information at least one
> copy is going to be wrong at some point in time.
>
>> >
>> >> =A0 =A0 =A0 lock_flocks();
>> >> =A0 =A0 =A0 cifs_for_each_lock(cfile->dentry->d_inode, before) {
>> >> @@ -950,35 +962,38 @@ cifs_push_posix_locks(struct cifsFileInfo *=
cfile)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 type =3D CIFS_RDLCK;
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 type =3D CIFS_WRLCK;
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 lck =3D cifs_lock_init(flock->fl_start,=
 length, type,
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0cfile->netfid);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (!lck) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto send_locks;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 lck =3D &lcks[i];
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck->pid =3D flock->fl_pid;
>> >> -
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&lck->llist, &locks_to_se=
nd);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 lck->netfid =3D cfile->netfid;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 lck->length =3D length;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 lck->type =3D type;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 lck->offset =3D flock->fl_start;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 i++;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (i =3D=3D count)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> >> =A0 =A0 =A0 }
>> >> -
>> >> -send_locks:
>> >> =A0 =A0 =A0 unlock_flocks();
>> >>
>> >> - =A0 =A0 list_for_each_entry_safe(lck, tmp, &locks_to_send, llis=
t) {
>> >> + =A0 =A0 if (i =3D=3D count)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Can't push all brlocks!");
>> >> +
>> >
>> > This sort of thing always makes me a little worried. Sure, you're
>> > allocating a bunch of extra locks, but what's the potential effect
>> > of not being able to push all the locks here? The user is going to
>> > see this message and have no clue of what it means.
>> >
>> > Even I'm not sure what this means in practice. The VFS will have a
>> > record of this lock, but the server won't...
>> >
>>
>> I really think that there will be no such situations, because we hol=
d
>> inode->lock_mutex - the locking state should leave the same.
>>
>
> I don't share that optimism.
>
> The lock_mutex protects the cinode->llist, but here you're walking th=
e
> inode->i_flock list. It's certainly possible that it could change in
> between unlock_flocks and lock_flocks.
>

The lock_mutex now protects not only cinode->llist, but locks from the
inode structure reached from cifs code as well. The only thing I
missed is posix_lock_file_wait in the end of the cifs_setlk function -
it should be surrounded with lock_mutex as well. According to this,
there is no other way to increase POSIX lock number from the inode
except locking/unlocking lock_mutex.

--=20
Best regards,
Pavel Shilovsky.
