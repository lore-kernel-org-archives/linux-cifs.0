From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Adjustable timeout
Date: Wed, 14 Jul 2010 08:12:22 -0400
Message-ID: <20100714081222.35b998ce@corrin.poochiereds.net>
References: <20100713104810.GA3001@localhost.localdomain>
	<20100713082151.3d231b8b@corrin.poochiereds.net>
	<20100713082916.03767113@corrin.poochiereds.net>
	<20100713221750.GA2471@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ladislav.Michl-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ladislav Michl <ladis-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100713221750.GA2471-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 14 Jul 2010 00:17:50 +0200
Ladislav Michl <Ladislav.Michl-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org> wrote:

> On Tue, Jul 13, 2010 at 08:29:16AM -0400, Jeff Layton wrote:
> > On Tue, 13 Jul 2010 08:21:51 -0400
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > > Agreed that the situation still sucks and it's high time we start this
> > > discussion from first principles.
> > > 
> > > cifs always uses reliable transport (TCP primarily, but there has been
> > > some discussion of using SCTP in the past). With a reliable transport
> > > the kernel knows when the server has received the packet (it's ACK'ed).
> > > 
> > > Here's how I think it ought to work (at least, it's a starting point for
> > > discussion):
> > > 
> > > When the client sends a call to the server, the thread waits
> > > indefinitely for a reply. That wait is generally interruptible via
> > > signal, however.
> > 
> > I should clarify too that wait only comes into play when the packet
> > is ACK'ed. If it's not received by the server, then we'll need to
> > determine what to do.
> > 
> > I think we need to be very careful about returning errors by default
> > due to network partition. Apps generally don't expect it, so cifs ought
> > to aggressively retry rather than returning errors to syscalls just
> > because the server isn't responding.
> 
> Here we probably want to distinguish 'soft' and 'hard' mount option.
> While 'hard' should do the best to get data written (and man page states
> syscall block until server comes back), which is perfectly okay, 'soft'
> is allowed to return error on server unresponsiveness. So, if above
> describes 'hard' mount case, I do agree. 'Soft' mount option currently
> poses a limit how long to wait and I'd like to see this timeout adjustable
> (something like timeo parameter is okay).
> 
> Or does your proposal generally mean to stop distinguishing between 'soft'
> and 'hard' mounts and make 'hard' default?
> 

Well, it means that "hard" should be the default. I think that makes
sense since that's better for data and application integrity in the
face of network partitions. I'm not opposed to keeping some sort of
"soft" semantics, but I don't think it ought to be the default.

Many applications don't deal well with getting EIO back on a file
operation. The vast majority will crash in the face of it. I think
"soft" semantics really make the most sense when you have an
interactive application and in that situation, the user can generally
signal to break out of a program that's stuck.

We have to take note however that SMB is not RPC. Much of the state of
a SMB session is tied up with the socket. When the socket is
reconnected, open files and (more importantly) file locks are lost and
must be reclaimed.

There is also no concept of a grace period like with NFS/NLM so when
this is done, other clients can race in and steal your file locks.
Linux has no SIGLOST or anything so the application isn't aware when
this occurs.

> > > If the socket changes state (possibly indicating that the server
> > > crashed before a reply could be sent to the call), then any calls in
> > > flight should be reissued once the socket is set back up.
> > > 
> > > Now, what to do in the situation where the client sends a call, the
> > > server crashes and no further calls are sent? The client might block
> > > indefinitely in that case since there is no more network traffic on the
> > > socket.
> > > 
> > > The sockets should do some sort of keepalive. A normal TCP keepalive
> > > might be ok, or we could consider doing SMB "pings" for this. That
> > > should make sure that we notice state changes in a timely fashion and
> > > should also help prevent disconnection on low-traffic sockets.
> 
> I'd go for SMB echo, just because it proves server side is still alive
> more reliably. It would be also nice to have some way to let userspace
> know that server didn't reply to echo request for last n seconds.

Personally, I think TCP keepalive makes much more sense. It's easier to
implement, and at least some older samba servers didn't return SMB
echoes when they were stuck on blocking I/O. Again, we need to take
great care not to give up and reconnect the socket unnecessarily as so
much of the client's state is bound to it.

I don't think we should return error if the socket still seems to be
working but the application bound to it is just not responding. A
printk in this situation to alert the admin that the server is stuck is
ok though.

Also, the syscall interface doesn't really provide a way to tell the
application info about server responsiveness, but we could display it
with a /proc or /sys file or something, or maybe display it as part of
the "not responding" printk.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
