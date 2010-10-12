From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: initial stab at a design document for SMB transport layer overhaul
Date: Tue, 12 Oct 2010 13:43:17 -0400
Message-ID: <20101012134317.78a3ecea@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Many of the problems that we have with cifs I think come down to the
fact that we have a very ad-hoc approach to the transport layer. It's
been hacked on for years with no real clear goal in mind for its
behavior.

To complicate matters further, there's also a smb2fs in the works that
uses a cut-and-pasted version of the socket handling code from cifs.
For some time now, I've wanted to rip and replace much of the transport
layer in cifs.

About a year ago, I spent some time on a patchset to add the ability
for the sunrpc layer to talk SMB. I got it working, but the patchset
was pretty invasive and it wasn't a great fit for CIFS. I still think
the overall idea of an SMB layer with well-defined behavior is the right
approach however.

The following document is a first stab at outlining the behavior and
overall design for such a beast. I think also that a well-defined SMB
layer in the kernel may have use beyond just cifs and smb2fs. Please
take a look at it as you are able and comment.

It's still very rough but I want to get this out there and have people
start thinking about the design before I start coding. Once I have some
feedback on the overall design then I'll plan to sit down and start
working on an implementation.

Questions, concerns and comments appreciated...

--------------------------[snip]------------------------------

		Proposal for A Unified SMB Layer for Linux

Overview:
=========
The kernel has had two different SMB/CIFS implementations. One (smbfs)
is now deprecated, in favor of the later one (cifs). Additionally, there
is at the time of this writing a new filesystem being developed for the
smb2 protocol. Much of that implementation was done via cut-and-paste
from cifs. Obviously, this is less than ideal. Each of these
implementations however has implemented its own transport code -- also
less than ideal.

This document is a proposal to add a new unified transport layer that
will work for SMB and SMB2. I intend to loosely model this layer after the
sunrpc layer in the kernel.

Implementation:
===============
The smb layer code will act as the mediator between the upper-layer
filesystem code and the socket layer. The filesystem will request the
creation of an smb "client". The smb layer will search for a suitable
one and increase the refcount on the existing socket if one is
available.

If one isn't available then a new socket will be opened and the SMB
layer will do a NEGOTIATE_PROTOCOL request and wait for the response.
The caller is responsible for specifying the upper and lower bound of
the SMB version that should be used. In general, we'll attempt a
negprot for higher versions before lower versions. Once the
NEGOTIATE_PROTOCOL exchange is completed, the results from it will be
stored in the smb_client structure for use by the upper layers.

The code will use a state machine to manage the socket's receive path,
and will overload the sk_* functions to handle the socket without
needing a dedicated thread for this. When the sk_data_ready callback
fires, data will be recevied off the socket in interrupt context until
we can get down to the MID in the header. At that point, we'll be able
to wake up whatever thread is waiting for the reply to do the rest. If
it's an async request, a workqueue task will be queued to a smbiod
workqueue to handle it.

To handle a truly async request from the server to the client (i.e. an
oplock break or similar), the upper layer will need to register a
callback that will be queued to the workqueue.

Calls will be issued to the SMB layer in a similar fashion to how it
works with the kernel's sunrpc layer. The upper function will create
SMB "tasks" and those will be run using a smb_run_task function. This
will allow for async requests as well, with async replies being handled
by the smbiod workqueue.

Tasks (processes) that are waiting for replies will be put to sleep in
TASK_KILLABLE sleep. Fatal signals will stop the sleeping and return an
error back to the upper layer.

Reconnect behavior:
===================
If the server issues a TCP RST on the socket, or the client decides that
the kernel will call the sk_state_change callback for the socket.

At this point, sending of new SMBs will be suspended and any calls in
flight will be cancelled and waiters woken back up to reissue those
calls.

The SMB layer will then reconnect the socket (probably via a
connect_worker workqueue task) and then re-do the
NEGOTIATE_PROTOCOL request. Once that's complete, the smb client will be
marked as being active again, and the smb layer will call back the upper
layers to let them know that they should redo SESSION_SETUPs etc.

Timeout behavior:
=================
Whenever a request is sent to the server, then a timer will be set, and
the upper layer will need to specify whether it wants "hard" or "soft"
semantics for dealing with timeouts.

If the server does not respond within a certain amount of time, then SMB
layer will begin sending SMB echo requests to the server at a set
interval (FIXME: stop sending these when send buffer is full?)

If the server responds to the echo requests, then the client will wait
indefinitely for the response to the original call. If the server is not
responding to those requests, then there are two cases:

hard: the client will wait indefinitely for a response from the server.
If the server eventually starts responding to the echo requests, then
things will proceed normally. If the server instead issues a TCP RST
then we'll handle a reconnect. Otherwise, we'll keep sending SMB echoes
(at least until we no longer have send buffers for the socket).

soft: the client will wait for the server to respond for a certain
period of time. If it doesn't respond within that interval, it will
disconnect the socket and attempt to reconnect. If that reconnect fails
(ETIMEDOUT or ECONNREFUSED, ENETUNREACH, etc...) then it will return an
error back to the upper layer.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
