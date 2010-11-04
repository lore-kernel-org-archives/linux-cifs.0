From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: New write logic
Date: Thu, 4 Nov 2010 14:08:48 +0300
Message-ID: <AANLkTikp5fvgvo+AM-jgqP7q_sfkjdPVKzNdRv5tDpNN@mail.gmail.com>
References: <AANLkTinegdugrKiMn4rErSyfp-t7HK6pYxumAS5DDiya@mail.gmail.com>
	<20101102114350.59f41db2@tlielax.poochiereds.net>
	<AANLkTi=HMTsqLXoVPkE=0CitmyXTV110KPDNSZ6fOp=w@mail.gmail.com>
	<20101103071456.27ed871b@tlielax.poochiereds.net>
	<20101103073403.04e8fc02@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101103073403.04e8fc02-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> To elaborate...
>
> Rather than calling down into generic_file_aio_write, I think you'd be
> better served by simply invalidating the pages in the range that the
> write touched, or possibly just invalidating the entire cached inode.

This can make sense only if we don't have oplock for reading. If we
have it - why do wee need to read from the server the data that we can
store and read from the cache? I don't think it's good for oplock
level II situation.

So, in this case we can check if we have oplock level II and call
generic_file_aio_write only in this case - otherwise simply invalidate
the region of the file write call affects. What do you think about
this idea?

> Also, I still haven't seen a description of what the semantics for mmap
> will be in this case. If I'm using strict caching and mmap a file, it
> obviously isn't going to read/write through every time userspace
> touches the memory. What can I expect to happen when I read or write to
> that mmap? How can I ensure that new data will be faulted in or data
> that I write will be synced out?

Good point about mmap. Thanks!

In mmap call we can invalidate inode pages if we don't have an oplock
for reading. As for mandatory locks problem - I don't think we can
deal with this problem without large code changes. So, I suggest to
leave it the same. Do you have any other ideas?

-- 
Best regards,
Pavel Shilovsky.
