From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mounting share on non-standard ports
Date: Sun, 14 Nov 2010 20:31:12 -0500
Message-ID: <20101114203112.5d901619@corrin.poochiereds.net>
References: <1289321425-7860-1-git-send-email-piastryyy@gmail.com>
	<20101113070012.760cf09d@tlielax.poochiereds.net>
	<AANLkTinb-A4kdumURzhkVb9oNojtfW94LPL99GwOr9MU@mail.gmail.com>
	<AANLkTim+SO4TfTJnXHnvaSjbPaoHt4k63hbVbs0gtbn9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim+SO4TfTJnXHnvaSjbPaoHt4k63hbVbs0gtbn9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 14 Nov 2010 12:38:18 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/11/13 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > 2010/11/13 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> >>
> >> I don't think this patch deals correctly with servers that are
> >> listening on RFC1001_PORT but not CIFS_PORT. With two mounts to the
> >> same server that don't specify a port, you'll end up with two sockets,
> >> right?
> >
> 
> And from another hand: If user doesn't specify the port we should
> think that it means the 445 port. If user wants to mount 139 port, he
> should specify this port manually. So, there is no error with the
> patch in this case.
> 
> From this point of view we should remove trying with 139 port if we
> failed with 445 port. What do you think about it?
> 

That sounds like a regression. The mount.cifs manpage says:

       port=arg
           sets the port number on the server to attempt to contact to
           negotiate CIFS support. If the CIFS server is not listening on this
           port or if it is not specified, the default ports will be tried
           i.e. port 445 is tried and if no response then port 139 is tried.


I think we ought to preserve that behavior. Perhaps if no port is
specified then match any TCP session that is on port 445 or port 139?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
