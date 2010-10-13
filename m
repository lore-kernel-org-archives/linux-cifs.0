From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: initial stab at a design document for SMB transport layer overhaul
Date: Wed, 13 Oct 2010 10:04:05 +0400
Message-ID: <AANLkTik5cX0iy7DgDDiWii6iew7xL51cKwFzV5AiGDB9@mail.gmail.com>
References: <20101012134317.78a3ecea@corrin.poochiereds.net>
	<AANLkTi=6_WKDH9uz4rCTW+BdWf=g91ygdj2N9JOYTima@mail.gmail.com>
	<20101012143942.4370777a@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101012143942.4370777a-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/10/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> In interrupt context, we'll read the header down to the MID and look =
up
> the request in a table (similar to how we do today in CIFS). For sync
> requests, we'll wake up the waiting thread which would copy the heade=
r
> info read so far into the buffer, and read the rest of the reply off
> the socket. The smb layer will provide functions that the upper layer=
s
> can use to read in the rest of the reply (not 100% sure of the best w=
ay
> to do that yet).

So, CIFS and SMB2 have the different headers and the different
locations of MID fileld. Do you mean that sk_data_ready will be
different for them too? Or it will be a common part that reads
protocol id from the socket and then move the handling of another part
(before MID - included) to a protocol specific fun=D3tion?

> async requests will require the caller to set up a callback function =
to
> handle the reply. That callback function will be queued to the
> workqueue. It'll need to read in the rest of the reply off the socket
> and then process the result.
>
> I think this is a cleaner and more efficient approach than having mor=
e
> threads.

I found the example of using sk_* functions in Ceph filesystem code -
is it what you mean?
(http://git.kernel.org/?p=3Dlinux/kernel/git/sfrench/cifs-2.6.git;a=3Db=
lob;f=3Dfs/ceph/messenger.c;h=3D2502d76fcec175ddb8500bcd1863c52add1208e=
5;hb=3Dd7c86ff8cd00abc730fe5d031f43dc9138b6324e#l186)

> Thanks for looking. I'm trying to make sure I have the design at leas=
t
> somewhat finalized before I start coding.

No problem. I think that transport layer isn't only the place that we
can pick up to do i common between CIFS and SMB2. For example, many
file and inode operations is almost the same and different in protocol
message structures.

> I may move it to the samba wiki once it's a bit more finalized. I'm n=
ot
> a huge fan of google docs ;).

Samba wiki is ok too.

--=20
Best regards,
Pavel Shilovsky.
