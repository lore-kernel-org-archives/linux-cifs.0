From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Introduce credit-based flow control
Date: Sat, 18 Feb 2012 06:54:48 -0500
Message-ID: <20120218065448.5c3a6d79@tlielax.poochiereds.net>
References: <1328776890-4190-1-git-send-email-piastry@etersoft.ru>
	<20120212075309.7368d89b@tlielax.poochiereds.net>
	<CAKywueRHe7_s2TCaHuthm6m8kQ4zjKkmtf_SLNT0RMvJgPaqJw@mail.gmail.com>
	<20120215101107.32befdc6@tlielax.poochiereds.net>
	<CAKywueTh2Y4uuLr+2W9Rrv+rtNM6xtbq+3M7gL41hpUZd5is1Q@mail.gmail.com>
	<CAKywueQvD+jG_b+38Aw_YW8OA4TeOYE3O11KYXAq-UUMQA4C2w@mail.gmail.com>
	<CAH2r5mu=JpGa6xC8p96THOXLhyeRZ3=aFhpD4quYP+G+in_dUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mu=JpGa6xC8p96THOXLhyeRZ3=aFhpD4quYP+G+in_dUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Feb 2012 23:58:41 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I am not convinced that we need to keep enough echo retries ... probably ok
> to be able to send one echo if we have 49 other requests pending, but don't
> think it makes sense to reserve more - if the first echo times out, we can
> probably simply exceed negotiated mpxcount - the session would be going
> down anyway.  Why would we have to save more than one for oplock - if we
> receive multiple breaks, we simply process them serially.
> 

I agree to a point. I think the code that does echoes and handles
reconnects based on it could use some work. There's virtually no reason
to resend an echo request if the server didn't respond to the last one.
We are using TCP after all, so presumably the echo request won't get
dropped by the networking layer. That probably means we can just
hardcode echo_retries to 1 and get rid of that module parm.

Keeping one slot open to handle echoes is probably reasonable in most
cases. In the event that maxmpx is 1 though we can't reasonably send an
echo when the server goes unresponsive since we won't have a slot. In
that case, I suggest we just don't send any echoes, and simply
reconnect if there is an outstanding call to which the server hasn't
responded in a certain amount of time.

Exceeding the maxmpx though is not a good idea. Servers send that value
for a reason and we shouldn't ignore it. Some may handle it gracefully,
but there are a lot of crappy CIFS servers in the field and many of them
don't handle exceeding the maxmpx well. Best not to do that even if it
seems expedient.

Oplock breaks are a bigger problem. When we get an oplock break, we
have to do more than just send the response to that. We often have to
initiate writeback as well. We need to keep at least one slot open for
that so we don't deadlock, but how best to ensure that the writeback
can proceed?

If only the oplock break response is allowed to use the reserved slot,
then that potentially leaves writeback hung waiting for a slot. What
may make sense is to allow writes to dip into the emergency credit
"pool" too if we're writing out of the cache and the inode doesn't have
an oplock that allows caching of writes.

In practice, it might even make sense to disable writing to the cache
when the number of slots is low but still more than 2 (maybe less than
5 or so?). Writable oplocks aren't terribly helpful when the throughput
to the server is low since it can take a long time to do writeback.
Probably that threshold could be made tunable somehow.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
