From: Ladislav Michl <Ladislav.Michl-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org>
Subject: Re: Adjustable timeout
Date: Thu, 15 Jul 2010 00:10:57 +0200
Message-ID: <20100714221057.GA2444@localhost.localdomain>
References: <20100713104810.GA3001@localhost.localdomain> <20100713082151.3d231b8b@corrin.poochiereds.net> <20100713082916.03767113@corrin.poochiereds.net> <20100713221750.GA2471@localhost.localdomain> <20100714081222.35b998ce@corrin.poochiereds.net>
Reply-To: Ladislav Michl <ladis-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100714081222.35b998ce-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jul 14, 2010 at 08:12:22AM -0400, Jeff Layton wrote:
> Well, it means that "hard" should be the default. I think that makes
> sense since that's better for data and application integrity in the
> face of network partitions. I'm not opposed to keeping some sort of
> "soft" semantics, but I don't think it ought to be the default.

Ok then. NFS defaults to "hard" as well, but CIFS defaults to "soft".
With regard to session state lose on reconnect, changing default makes
sense.

> Many applications don't deal well with getting EIO back on a file
> operation. The vast majority will crash in the face of it. I think
> "soft" semantics really make the most sense when you have an
> interactive application and in that situation, the user can generally
> signal to break out of a program that's stuck.
> 
> We have to take note however that SMB is not RPC. Much of the state of
> a SMB session is tied up with the socket. When the socket is
> reconnected, open files and (more importantly) file locks are lost and
> must be reclaimed.
> 
> There is also no concept of a grace period like with NFS/NLM so when
> this is done, other clients can race in and steal your file locks.
> Linux has no SIGLOST or anything so the application isn't aware when
> this occurs.
> 
> > I'd go for SMB echo, just because it proves server side is still alive
> > more reliably. It would be also nice to have some way to let userspace
> > know that server didn't reply to echo request for last n seconds.
> 
> Personally, I think TCP keepalive makes much more sense. It's easier to
> implement, and at least some older samba servers didn't return SMB
> echoes when they were stuck on blocking I/O. Again, we need to take
> great care not to give up and reconnect the socket unnecessarily as so
> much of the client's state is bound to it.

Okay, you conviced me.

> I don't think we should return error if the socket still seems to be
> working but the application bound to it is just not responding. A
> printk in this situation to alert the admin that the server is stuck is
> ok though.
> 
> Also, the syscall interface doesn't really provide a way to tell the
> application info about server responsiveness, but we could display it
> with a /proc or /sys file or something, or maybe display it as part of
> the "not responding" printk.

I'm not against _also_ displaying this information as a part of printk,
but having it somewhere in /sys or /proc makes obtaining it more
scripting friendly.
