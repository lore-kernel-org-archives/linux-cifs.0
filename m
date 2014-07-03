From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 01/16] CIFS: Fix async reading on reconnects
Date: Thu, 3 Jul 2014 20:12:57 +0400
Message-ID: <CAKywueSH2GLmzcVbeUbq5X4h7K_yfMawv+-sisXPF5g3hheYeQ@mail.gmail.com>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
	<1403863073-19526-2-git-send-email-pshilovsky@samba.org>
	<20140627065222.434cd5ea@tlielax.poochiereds.net>
	<CAKywueSpPjEpyQYLvrSixf4tasxd5v4a51EBKhBboaTXcs5O1A@mail.gmail.com>
	<20140703064549.7f6913f3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140703064549.7f6913f3-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-07-03 14:45 GMT+04:00 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Fri, 27 Jun 2014 20:06:48 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> 2014-06-27 14:52 GMT+04:00 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
>> > On Fri, 27 Jun 2014 13:57:38 +0400
>> > Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>> >
>> >> If we get into read_into_pages() from cifs_readv_receive() and then
>> >> loose a network, we issue cifs_reconnect that moves all mids to
>> >> a private list and issue their callbacks. The callback of the async
>> >> read request sets a mid to retry, frees it and wakes up a process
>> >> that waits on the rdata completion.
>> >>
>> >> After the connection is established we return from read_into_pages()
>> >> with a short read, use the mid that was freed before and try to read
>> >> the remaining data from the a newly created socket. Both actions are
>> >> not what we want to do. In reconnect cases (-EAGAIN) we should not
>> >> mask off the error with a short read but should return the error
>> >> code instead.
>> >>
>> >
>> > I'm not sure I understand what problem this solves. Why is returning a
>> > short read wrong here?
>> >
>>
>> This patch solves several problems in cifs_readv_receive() when
>> read_into_pages() call ended up with cifs_reconnect inside it:
>>
>> 1) prevents use-after-free and a possible double free for "mid"
>> variable; this can cause kernel oopses.
>>
>> 2) prevents updating rdata->bytes with a short read length that causes
>> the cifs_async_readv() caller to retry write request with a shorten
>> wrong length; this can cause data coherency problems.
>>
>> 3) prevents reading an actual data from a newly created socket through
>> cifs_readv_discard() -- this data can be a part of a negotiate
>> response received from the server; this can cause the client to retry
>> negotiate or hang.
>>
>> Oopses from the 1st scenario was not observed since
>> cifs_readv_discard() returns negative value while trying to get a
>> remaining data. The 2nd and 3rd one were caught during testing: issue
>> reading with "dd", then switch off network on the server, wait 120 sec
>> and switch on network. The bug is caught when we are lucky enough to
>> stop the link while the client is in read_into_pages().
>>
>> The patch fixes all these problems for me. It stays on the following
>> logic if a reconnect has happened:
>> 1) all mids are already marked to retry and their callbacks are issued
>> - we shouldn't do anything with our mid/rdata since the requests will
>> be retried anyway.
>> 2) the socket is newly created - we shouldn't try to get any remaining
>> data of the previous connection.
>>
>> While -EAGAIN error code will be able to indicate something else in
>> possible future patches I prefer to leave it that way since the patch
>> is small and easy to apply that is critical for stable series. More
>> accurate way is to add a flag that is passed through
>> cifs_readv_from_socket() and switched on if cifs_reconnect() was
>> issued (like Steve suggested).
>>
>
> Hmm, ok. I think the best fix would be to use a different error code
> than -EAGAIN for the case where we have or are going to reconnect the
> socket.
>
> My main concern here is that you may end up doing 99% of a valid read
> into the set of pages, only to get a disconnect right at the end. If
> you eventually end up returning a non-retryable error back to userland,
> it may not expect that the pages it passed in were written to. If you
> don't return a short read in that situation then you're potentially not
> communicating what actually happened to userland.

In that case we should prevent cifs_reconnect from removing the MID we
are actually using in cifs_readv_receive() from the mid list. For
example by calling dequeue_mid() before read_into_pages() and then
returning a short read if reconnect happened?


-- 
Best regards,
Pavel Shilovsky.
