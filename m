From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 01/16] CIFS: Fix async reading on reconnects
Date: Mon, 21 Jul 2014 19:41:58 +0400
Message-ID: <CAKywueSwJN2FiTTbcur8pzfvUJ7jqA5pA7sHhDA=eoNGT_bo+g@mail.gmail.com>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
	<1403863073-19526-2-git-send-email-pshilovsky@samba.org>
	<20140627065222.434cd5ea@tlielax.poochiereds.net>
	<CAKywueSpPjEpyQYLvrSixf4tasxd5v4a51EBKhBboaTXcs5O1A@mail.gmail.com>
	<20140703064549.7f6913f3@tlielax.poochiereds.net>
	<20140703123930.5feb046f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140703123930.5feb046f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-07-03 20:39 GMT+04:00 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> After chatting with Pavel, I'll go ahead and Ack this patch. I think
> it's probably the lesser evil...
>
> It does seem to me though it seems to me that if you got part of a read
> request and then hit an error, then it would be:
>
> a) more efficient to not reissue the reads that were successful
>
> ...and...
>
> b) more correct to go ahead and return a short read. There's no
> guarantee that you'll be able to reach the server in order to do the
> reconnect, so it seems like it would be better to go ahead and return
> what we have than keep retrying in the kernel.
>
> So...with that in mind...
>
> Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

I think the patch [01/16] of the series should go to stable since it
fixes the existing problem. Thoughts?

-- 
Best regards,
Pavel Shilovsky.
