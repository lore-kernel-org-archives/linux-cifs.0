From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: cifs client timeouts and hard/soft mounts
Date: Fri, 3 Dec 2010 21:28:11 -0500
Message-ID: <20101203212811.17594274@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Introduction:
=============
Apologies for the wide distribution of this email, but I think this
topic is something that is something that is fundamental to anyone
attempting to implement a CIFS client. I also apologize in advance for
its long-windedness, but I've given this a lot of thought and want to
make sure that I communicate my rationale clearly.

We've begun a discussion concerning this on the cifs-protocol and pfif
lists, but I'm not sure this is of great interest to Microsoft but
probably is of wider interest to the readers of the mailing lists to
which I'm sending.

I'd like to use this email as a starting point for discussion to nail
down exactly how the transport layer in the Linux CIFS client should
behave. It may also be of interest for others implementing SMB clients.
I'll also point out that I recently sent a patchset to the linux-cifs
list that implements this design (for the most part) for the Linux CIFS
client, so I have a real interest in getting this behavior right.

The main questions boil down to:

1) When should a CIFS client give up on pending requests and reconnect
the socket?

2) What does "hard" and "soft" mean in the context of CIFS?

These are separate questions but the the answer to one affects the
other...

Timeouts:
=========
It's tempting to think of SMB as being very similar to NFS/RPC, but
when it comes to low-level transport, there are significant
differences. ONC-RPC was designed for connectionless transports and has
the concept of a retransmission. SMB however does not -- it was
originally layered on NetBIOS sessions and so has always been assumed
to run on a connection-based transport.

For that reason, we can never retransmit a SMB request on the same
connection. Our only recourse in the event of a communication breakdown
is to close the transport layer (aka the socket) and start over from
scratch.

OTOH, this design has some benefits. Because SMB is always on a
connection-oriented transport layer, we can generally assume that as
long as the server is responding to requests on the transport that it
received any previous request to which we haven't received a reply.

A significant design concern to consider is that reconnects for cifs
clients are horrifically expensive. Much of the state of the client is
intertwined with the socket. If we reconnect, we lose filesystem state
and have to reclaim it -- sessions, tree connects, open files, locks --
all of it.

Doing all of that is extremely costly, and in the case of locks we can
never be sure that another client hasn't raced in and stolen the lock
while we were reconnecting. That's a data-integrity issue -- there is
no lock reclaim grace period like with NLM. Thus, we should attempt to
avoid reconnects as much as we possibly can.

So, what does this mean for CIFS clients? I believe that the best
behavior for the client is to *never* time out an individual request,
aside from SMB echoes. When we haven't received a reply from the server
for some time (on the order of 30-60s), the client should issue an SMB
echo request. If the server doesn't reply within a reasonable amount of
time (maybe another 30-60s), we should close down the socket and
attempt to reconnect.

If the server is responding to the echo requests however, we should
assume that it's working on our earlier requests and continue to wait
for the reply indefinitely. That waiting should be interruptible by
fatal signals so that there is a "failsafe" for clients communicating
with misbehaving servers.

In short, timeouts should be a property of the socket as a whole and
not a property of individual requests on the wire. MS-CIFS and Windows'
behavior contradicts this to some degree, but MS isn't trying to
shoehorn a CIFS client into a unix-like OS either. They have their own
design concerns and they aren't necessarily the same as ours.

Hard and Soft mounts:
=====================

If we're not ever going to time out individual requests, what does this
mean for the "hard" and "soft" mount options?

I think that "hard" and "soft" should basically govern what happens to
outstanding requests once we've decided to try and reconnect the
socket. IOW, a socket disconnection should be treated more or less like
a major RPC timeout on NFS.

So in practical terms, let's assume for a moment that a server has
stopped responding at all while the client has outstanding requests. The
client then disconnects the socket and begins an attempt to reconnect.

If the mount is a hard mount, it should attempt to reissue the request
once the socket has been reconnected. Of course, open filehandles may
have changed, etc...so we may have to reencode requests but that's CIFS
for you. Callers should block until the socket has been reconnected and
the call reissued, but fatal signals should allow one to break out that
wait and return an error.

If the mount is a soft mount, we should return an error to the calling
application before or while attempting to reconnect the socket. That
allows the application to get the errors in timely fashion and deal
with them regardless of whether the reconnection is successful.

Soft mounts should also allow callers to tear down stateful objects
(files and locks, in particular) while the server is still down, so
that umounts can proceed in that case.

Open question here -- what should be done with new syscalls issued on
soft mounts while the socket is still unconnected? Should they block
until the socket is connected or should they return an immediate error?
I can see arguments for both. Maybe there should be a 3rd option?
(hard/soft/squishy)

Anyone have thoughts or comments?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
