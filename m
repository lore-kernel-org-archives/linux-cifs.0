From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: setuids/setgids by default
Date: Sat, 28 Apr 2012 08:02:30 -0400
Message-ID: <20120428080230.160c6b38@tlielax.poochiereds.net>
References: <CAKywueSQQfzwkWgE33+w=y2pnQQd4nxhvJX71NaAa0E_BLAcbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSQQfzwkWgE33+w=y2pnQQd4nxhvJX71NaAa0E_BLAcbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 28 Apr 2012 14:42:35 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi!
> 
> Now CIFS client doesn't enforce uid and gid permission from the
> process that create file by default (new files are created with mount
> user permission) and it can be 'fixed' by setuids/setgids mount
> option. Why this options should not be by default? I think it
> contradict POSIX.
> 

Welcome to the morass that we call "the cifs.ko permissions model".

The reason we don't do that by default is because it doesn't work. What
happens is that the client does a unix SetPathInfo call to try and
chown the file, but in  order to chown() a file on unix, you need
superuser permissions.

Once the session setup is done, the server daemon will usually setuid()
itself to the user you're mounting as, and at that point you don't have
permissions to chown anymore.

What "setuids" also does is to "fake up" the ownership of the inode
temporarily just after creation. That's just a hack though -- as soon as
the attributes are fetched from the server again, that goes away, so
results with that are inconsistent.

Ha, and it looks like "setuids" is broken when you create files in
cifs_lookup anyway! Maybe someone should fix that sometime...

In any case, I maintain that the only *real* fix for all of these
permissions problems is to both:

1) have users use the correct credentials when they talk to the server.
Files get created with the correct ownership this way.

2) stop trying to enforce permissions on the client. It's racy and just
gets in the way. Permissions can only be correctly enforced by the
server.

This is what the "multiuser" mount option does. If anything, I'd rather
see a transition to that being the default. It's the only sane
solution, IMO.

That said, if you want to do some cleanup work on the permissions mount
options mess model, I'll be happy to help review it...

FWIW, I gave a talk at sambaxp a couple of years ago that covered a lot
of the problems. I'd advise you to have a look at that before you spend
too much time looking at this...

    http://sambaxp.org/index.php?id=38

...see the talk on "Multi-session Linux CIFS".

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
