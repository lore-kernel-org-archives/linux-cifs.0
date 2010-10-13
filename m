From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: initial stab at a design document for SMB transport layer
 overhaul
Date: Wed, 13 Oct 2010 07:55:02 -0400
Message-ID: <20101013075502.2bd625ce@corrin.poochiereds.net>
References: <20101012134317.78a3ecea@corrin.poochiereds.net>
	<AANLkTi=6_WKDH9uz4rCTW+BdWf=g91ygdj2N9JOYTima@mail.gmail.com>
	<20101012143942.4370777a@corrin.poochiereds.net>
	<AANLkTik5cX0iy7DgDDiWii6iew7xL51cKwFzV5AiGDB9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik5cX0iy7DgDDiWii6iew7xL51cKwFzV5AiGDB9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 13 Oct 2010 10:04:05 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2010/10/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > In interrupt context, we'll read the header down to the MID and loo=
k up
> > the request in a table (similar to how we do today in CIFS). For sy=
nc
> > requests, we'll wake up the waiting thread which would copy the hea=
der
> > info read so far into the buffer, and read the rest of the reply of=
f
> > the socket. The smb layer will provide functions that the upper lay=
ers
> > can use to read in the rest of the reply (not 100% sure of the best=
 way
> > to do that yet).
>=20
> So, CIFS and SMB2 have the different headers and the different
> locations of MID fileld. Do you mean that sk_data_ready will be
> different for them too? Or it will be a common part that reads
> protocol id from the socket and then move the handling of another par=
t
> (before MID - included) to a protocol specific fun=D3tion?
>=20

There are a couple of different ways to do this. The main thing to
consider is that SMB1 and SMB2 can't coexist on the same socket, so if
packet comes in and the protocol id looks wrong we can throw that
packet out.

Essentially though, the goal will be to have as much common code as
possible. Receiving will be done in stages:

1) Read in the transport header, get the length of packet
2) Read in in the SMB header to a buffer hanging from the socket
3) Verify the protocol type and mid, and wake up the process waiting on=
 it
4) That process will copy the header data received so far to its buffer
   and then read in the rest of the data

If the header doesn't pass inspection, we'll keep reading the frame off
the socket in interrupt context and discard the contents until we've
read the correct length.

If things are really screwed up (say we got a length that was way
too big), then we may want to reconnect the socket. One goal of this
will be to attempt to minimize reconnects.

Reconnecting the socket means losing a lot of state for CIFS. SMB2 is
better in this regard with durable filehandles, but it's still not
something you want to do if you can avoid it.


> > async requests will require the caller to set up a callback functio=
n to
> > handle the reply. That callback function will be queued to the
> > workqueue. It'll need to read in the rest of the reply off the sock=
et
> > and then process the result.
> >
> > I think this is a cleaner and more efficient approach than having m=
ore
> > threads.
>=20
> I found the example of using sk_* functions in Ceph filesystem code -
> is it what you mean?
> (http://git.kernel.org/?p=3Dlinux/kernel/git/sfrench/cifs-2.6.git;a=3D=
blob;f=3Dfs/ceph/messenger.c;h=3D2502d76fcec175ddb8500bcd1863c52add1208=
e5;hb=3Dd7c86ff8cd00abc730fe5d031f43dc9138b6324e#l186)
>=20

Yes. You can see examples of it in the sunrpc code too.

> > Thanks for looking. I'm trying to make sure I have the design at le=
ast
> > somewhat finalized before I start coding.
>=20
> No problem. I think that transport layer isn't only the place that we
> can pick up to do i common between CIFS and SMB2. For example, many
> file and inode operations is almost the same and different in protoco=
l
> message structures.
>=20

Definitely. It may also be plausible to eventually build this into a
"redirector" for linux and allow userspace to have access to this socke=
t
via some mechanism (maybe netlink sockets?).

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
