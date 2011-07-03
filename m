From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: pull request
Date: Sun, 3 Jul 2011 12:59:10 -0500
Message-ID: <CAH2r5mu0uQGO0TiWzv6oeC-wEOsC_7MQ59Wo1mJWHALt1r5Tog@mail.gmail.com>
References: <20110703094631.0b816582@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110703094631.0b816582-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There is only one in my tree that I see that I had not requested Linus
to pull yet.

cifs: set socket send and receive timeouts before attempting connect

Looking at your tree there is one left to merge.

I hadn't merged 	"cifs: simplify refcounting for oplock breaks" because I wanted
to check it carefully (IIRC it wasn't "reviewed-by" anyone else) - but
it looked fine.

On "	cifs: advertise the right receive buffer size to the... " it
looks fine but didn't have
a bug associated with it so prefer to wait for 3.0.1.

On "cifs: demote DFS referral lookup errors to cFYI cifs-3.0" - before
making this
change I want to make sure that a misconfigured cifs.upcall will cause
(ie at least
one log entry to be logged until the client is rebooted) a kernel warning and
that we don't make it harder to debug the case where cifs.upcall
is missing or misconfigured by changing the error to a cFYI.

I don't think the "unneeded variable initialization patch makes the code clearer
and it doesn't fix a bug or warning - but don't have strong feelings
about it either
way.

On Sun, Jul 3, 2011 at 8:46 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Steve,
>
> I notice that there are a number of patches that are still sitting in
> your tree and that aren't yet in mainline. Do you have plans to ask
> Linus to pull them? Also, it would be helpful if you would start cc'ing
> linux-cifs when you send pull requests to him.

I checked my email log I have cc:ed linux-cifs on pull requests
for all but a few where I accidentally left off the email.

> Thanks,
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



-- 
Thanks,

Steve
