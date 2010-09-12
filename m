From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Sun, 12 Sep 2010 11:40:55 -0400
Message-ID: <20100912114055.55520f0c@tlielax.poochiereds.net>
References: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k@mail.gmail.com>
	<AANLkTi=_eMSC99K1a2zWpgW5nc8UArzKj2MWHaRmCXzK@mail.gmail.com>
	<20100908063224.240b0419@corrin.poochiereds.net>
	<AANLkTinYFe6O-4ANt1VYcvEMukiis-11cDuMP2GSKZ7j@mail.gmail.com>
	<AANLkTin+qiQsF_hOCvdBKtCh0n0bcd82RDOUz=h3K6gu@mail.gmail.com>
	<AANLkTikOR_HU934L6FKq8q2ZwcaTTOTPfaSofimK6OFH@mail.gmail.com>
	<AANLkTi=zc7G847VHqVjO7LRfLkzzSGsJURvJmH1C8gOQ@mail.gmail.com>
	<AANLkTikXWGNtuOjPbG0wAdHLuVQOVuouaUaBi4HRwSR-@mail.gmail.com>
	<20100910081549.41de32d1@corrin.poochiereds.net>
	<AANLkTi=5YgKzG=rXJ5MuV+R_MGkEd+2ERouUiEc8K5B8@mail.gmail.com>
	<20100910185002.73e61b8b@tlielax.poochiereds.net>
	<AANLkTik_=xi5Engkm4Xcrk_WUaXSsSAsWUhh=M8VYWer@mail.gmail.com>
	<20100912091659.73ef9cdb@tlielax.poochiereds.net>
	<AANLkTi=gSm+=djrj796Gfjx9FiRQ7s==6DSV=DhYOk7U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=gSm+=djrj796Gfjx9FiRQ7s==6DSV=DhYOk7U-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 12 Sep 2010 18:55:05 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/9/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> >> We can write a data in write_end call all the time when we don't have
> >> an oplock for writing. If we get an error we simply returned it in
> >> from write_end and an application gets it.
> >>
> >
> > I don't understand the above statement. Can you clarify it?
> 
> Yesterday, I sent the patch to the list, that clarifies my idea. I
> mean we use do_file_aio_write instead of cifs_file_aio_write call but
> in cifs_write_end call (that should actually write data to the
> storage) we check for an oplock. If we have the Exclusive oplock for
> this file id, we don't write to the server and mark page as dirty. In
> other cases we write to the server in cifs_write_end call. You can
> find the code that does it in my patch.
> 

This should probably be a set of patches that outlines each change.
There are 3, AFAICT:

1) it bypasses the cache for reads when we have no oplock. Seems
straightforward.

2) the cache is invalidated on close. So, no caching of data between
open and close. Again ugly for performance but good for strict cache
consistency.

3) write_end is doing a single page synchronous write when there is no
oplock. This is going to be really ugly. Anytime you don't have an
oplock, you'll be doing PAGE_SIZE writes to the server. Why not instead
simply have cifs_file_aio_write do a filemap_write_and_wait or
something if it there is no oplock?

> > That's just because our client is primitive in this regard. When an
> > oplock break comes in, it always drops the entire oplock rather than
> > trying to downgrade it.
> >
> > Notice that when the client sends the "reply" that it's actually a
> > request. The client never sends an actual "response" to an oplock
> > break. What it does is send a new LOCKING_ANDX request to the server
> > with a Lock Type of oplock break (0x02) and an oplock level of 0.
> >
> > My interpretation has always been that this "response" from the client
> > tells the server what new oplock level the client has elected to take.
> > In this case, it elected to drop the lock altogether so the server has
> > no need to send a new oplock break.
> >
> 
> You can find the code (misc.c, is_valid_oplock_break call) that
> downgrades the oplock for the client according to the field
> NewOplockLevel in Oplock Break sent by the server. But then you can
> see that in cifs_oplock_break call (file.c) the client simply sends
> acknowledge without setting any OplockLevel specific things.
> 

Yeah, that looks like a bug. We probably ought to be sending back the
correct oplock break level in the response there.

> > I'll concede though that the spec is nebulous here. It might be
> > worthwhile to make a dochelp request to MS on this point.
> >
> 
> I agree - without special point in spec it's the open question.
> 


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
