From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: initial stab at a design document for SMB transport layer
 overhaul
Date: Wed, 13 Oct 2010 16:45:05 -0400
Message-ID: <20101013164505.193b8074@corrin.poochiereds.net>
References: <20101012134317.78a3ecea@corrin.poochiereds.net>
	<AANLkTi=6_WKDH9uz4rCTW+BdWf=g91ygdj2N9JOYTima@mail.gmail.com>
	<20101012143942.4370777a@corrin.poochiereds.net>
	<AANLkTik5cX0iy7DgDDiWii6iew7xL51cKwFzV5AiGDB9@mail.gmail.com>
	<20101013075502.2bd625ce@corrin.poochiereds.net>
	<AANLkTingkc+X6w=GoTBCLutsqVBx5_tid5u13Zhd8vxP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTingkc+X6w=GoTBCLutsqVBx5_tid5u13Zhd8vxP-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 13 Oct 2010 15:30:40 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/10/13 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > On Wed, 13 Oct 2010 10:04:05 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> 2010/10/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> >> > In interrupt context, we'll read the header down to the MID and =
look up
> >> > the request in a table (similar to how we do today in CIFS). For=
 sync
> >> > requests, we'll wake up the waiting thread which would copy the =
header
> >> > info read so far into the buffer, and read the rest of the reply=
 off
> >> > the socket. The smb layer will provide functions that the upper =
layers
> >> > can use to read in the rest of the reply (not 100% sure of the b=
est way
> >> > to do that yet).
> >>
> >> So, CIFS and SMB2 have the different headers and the different
> >> locations of MID fileld. Do you mean that sk_data_ready will be
> >> different for them too? Or it will be a common part that reads
> >> protocol id from the socket and then move the handling of another =
part
> >> (before MID - included) to a protocol specific fun=D3tion?
> >>
> >
> > There are a couple of different ways to do this. The main thing to
> > consider is that SMB1 and SMB2 can't coexist on the same socket, so=
 if
> > packet comes in and the protocol id looks wrong we can throw that
> > packet out.
> >
> > Essentially though, the goal will be to have as much common code as
> > possible. Receiving will be done in stages:
> >
> > 1) Read in the transport header, get the length of packet
> > 2) Read in in the SMB header to a buffer hanging from the socket
> > 3) Verify the protocol type and mid, and wake up the process waitin=
g on it
> > 4) That process will copy the header data received so far to its bu=
ffer
> > =9A and then read in the rest of the data
>=20
> There are quite a few differences in SMB2 and CIFS in protocol parsin=
g
> so we have to be careful.
>=20
> For example, mids are not necessarily unique in cifs, but have been
> replaced with an new form of identifier which is large enough in smb2=
,
> there is no cifs equivalent of SMB2 async response, there are packet
> signing differences, and SMB2 has a fixed 64 byte header, and SMB2
> does not support older style error codes, and SMB2 maximum frame size=
s
> are much larger.
>=20

MID's aren't really a problem...you just need a reservation scheme that
makes sure you don't have conflicts with any that are in flight.

Much of the rest of the things you mention don't need to be dealt with
at the transport layer. That really ought to be solely concerned with
getting packets onto and off of the wire.

> The read response processing in SMB2 has to support reading into a
> page list (due to the very large read sizes that we have to support),
> so if we want to move to some common handler code in smb2/cifs then w=
e
> still have to have preparsers unique to smb2 and cifs.=20

Sure, not really a problem. In general, I'd like to see less reliance
on large buffer allocations so we aren't hit with problems like this:

    https://bugzilla.redhat.com/show_bug.cgi?id=3D617795


> Generally I
> like the model where only a single process reads from the socket, but
> the demultiplex process logic clearly could be simplified.
>=20

I don't think that buys us much, other than extra context switches. It
also has a number of problems -- for instance, you aren't aware of
state changes to the socket until you try to read or write to it. We
might as well take advantage of being in the kernel and not pretend
that we're a userspace process, limited by send/recvmsg api.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
