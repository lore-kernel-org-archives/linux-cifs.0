From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Problems with CVS on CIFS since kernel 2.6.30
Date: Mon, 2 Aug 2010 13:14:40 -0400
Message-ID: <20100802131440.5b16a86b@tlielax.poochiereds.net>
References: <AANLkTingdjU-KKW3=KboAnR0pNeiE7aEje0nXhM6bYbe@mail.gmail.com>
	<4C56DBDD.4070501@suse.de>
	<AANLkTin9uwwDaw+nvAiDKnPxPbbBXycVS3rLvhCaoJxQ@mail.gmail.com>
	<4C56E564.3020508@suse.de>
	<AANLkTikqgFHX=9quJmJyQvkX-3ZreLGoF0k5YKCFq+WW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikqgFHX=9quJmJyQvkX-3ZreLGoF0k5YKCFq+WW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2 Aug 2010 16:56:10 +0100
Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Just checked on a colleagues machine, and uname -r reports 2.6.32-24-generic
> 
> Also checked the dmesg on the Ubuntu 10.04 box:
> 
> [  964.362027]  CIFS VFS: Autodisabling the use of server inode
> numbers on \\shared.openbet\shared. This server doesn't seem to
> support them properly. Hardlinks will not be recognized on this mount.
> Consider mounting with the "noserverino" option to silence this
> message.
> [  964.368470]  CIFS VFS: server 10.194.0.105 of type Samba 3.0.28a
> returned unexpected error on SMB posix open, disabling posix open
> support. Check if server update available.
> 
> The exact same errors that I get appear, which leads me to believe
> that this in itself is not the cause of my issue.
> 
> Any other ideas to debug further?
> 

Yes, I agree that the above warnings may have nothing to do with the
problem. We need to understand what the problem is. The strace shows
this:

write(2, "cvs [update aborted]: cannot get"..., 78cvs [update aborted]: cannot get working directory: No such file or directory) = 78

...but I don't see any system calls that returned -ENOENT. Maybe it
occurred in another thread or something?

So I'm a little unclear as to what cvs is complaining about. It's quite
possible that it's ultimately a bug in cifs, but without more info I
really can't guess as to what the problem is. What we really need is a
description of the problem couched in terms of the system call
interface.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
