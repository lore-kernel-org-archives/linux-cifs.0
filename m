From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: Adjustable timeout
Date: Tue, 13 Jul 2010 08:29:16 -0400
Message-ID: <20100713082916.03767113@corrin.poochiereds.net>
References: <20100713104810.GA3001@localhost.localdomain>
	<20100713082151.3d231b8b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ladislav Michl <ladis-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Ladislav.Michl-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100713082151.3d231b8b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 13 Jul 2010 08:21:51 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Tue, 13 Jul 2010 12:48:10 +0200
> Ladislav Michl <Ladislav.Michl-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org> wrote:
> 
> > Hello,
> > 
> > I'm using network storage for voicemail recording, which works pretty well
> > on responsive servers. However in case of server crash on malfunction even
> > open syscall takes ages to return error, which is just unfortunate.
> > 
> > Situation was described in thread "Timeout waaay too long"
> > http://lists.samba.org/archive/linux-cifs-client/2006-February/001203.html
> > and now, afer more than four years, it is not any better.
> > 
> > My very problem could be probably solved in userspace with "guard" thread
> > killing stuck open or write syscall and moving to next storage available,
> > but I found such a solution unly.
> > 
> > There is interesting notion in post "[PATCH] cifs: hard mount option
> > behaviour" http://lists.samba.org/archive/linux-cifs-client/2010-June/006291.html
> > about what is considered a responsive server today.
> > 
> > For now I modified timeouts in SendReceive(2), which improved situation for
> > me, but the real qustion is, how should widely acceptable solution look like.
> > 
> > Thanks for your suggestions,
> > 	ladis
> 
> Agreed that the situation still sucks and it's high time we start this
> discussion from first principles.
> 
> cifs always uses reliable transport (TCP primarily, but there has been
> some discussion of using SCTP in the past). With a reliable transport
> the kernel knows when the server has received the packet (it's ACK'ed).
> 
> Here's how I think it ought to work (at least, it's a starting point for
> discussion):
> 
> When the client sends a call to the server, the thread waits
> indefinitely for a reply. That wait is generally interruptible via
> signal, however.

I should clarify too that wait only comes into play when the packet
is ACK'ed. If it's not received by the server, then we'll need to
determine what to do.

I think we need to be very careful about returning errors by default
due to network partition. Apps generally don't expect it, so cifs ought
to aggressively retry rather than returning errors to syscalls just
because the server isn't responding.

> 
> If the socket changes state (possibly indicating that the server
> crashed before a reply could be sent to the call), then any calls in
> flight should be reissued once the socket is set back up.
> 
> Now, what to do in the situation where the client sends a call, the
> server crashes and no further calls are sent? The client might block
> indefinitely in that case since there is no more network traffic on the
> socket.
> 
> The sockets should do some sort of keepalive. A normal TCP keepalive
> might be ok, or we could consider doing SMB "pings" for this. That
> should make sure that we notice state changes in a timely fashion and
> should also help prevent disconnection on low-traffic sockets.
> 
> Thoughts?


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
