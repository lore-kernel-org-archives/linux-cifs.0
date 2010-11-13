From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mounting share on non-standard ports
Date: Sat, 13 Nov 2010 21:28:26 +0300
Message-ID: <AANLkTinb-A4kdumURzhkVb9oNojtfW94LPL99GwOr9MU@mail.gmail.com>
References: <1289321425-7860-1-git-send-email-piastryyy@gmail.com>
	<20101113070012.760cf09d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101113070012.760cf09d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/13 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>
> I don't think this patch deals correctly with servers that are
> listening on RFC1001_PORT but not CIFS_PORT. With two mounts to the
> same server that don't specify a port, you'll end up with two sockets,
> right?

Yes, you are right. I don't think that it is a big problem im
comparison with what we have today. Today we have totally broken code
- when I have two servers on the one host with different ports (e.x.
the first on one host and the second on the second but can be accesed
through the first with ssh forwarded port) and user wants to mount
both. In results, user mount only the first share twice - it can break
a lot of things!

>
> Also, the logic in match_address is getting to be rather convoluted. It
> might be good to break that out into a match_port function.
>
> ipv4_connect and ipv6_connect ought to be sharing a lot of code. It
> would be good to do some cleanup here and try to consolidate these
> functions more than they are today.
>
> I envision a function that just handles setting up the socket and
> leaves the caller to determine the port to use. Also, breaking out the
> RFC1001 stuff into a separate function would be good too.
>

You are absolutely right. I agree with you about copy-and-past code
for ipv4(v6)_connect function - good chance for cleanup. I am going to
do it as soon as I finished with strict cache mode. But for a while -
I don't think we can leave such a bug I described above.

-- 
Best regards,
Pavel Shilovsky.
