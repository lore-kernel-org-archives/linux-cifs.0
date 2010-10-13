From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: initial stab at a design document for SMB transport layer overhaul
Date: Wed, 13 Oct 2010 15:30:40 -0500
Message-ID: <AANLkTingkc+X6w=GoTBCLutsqVBx5_tid5u13Zhd8vxP@mail.gmail.com>
References: <20101012134317.78a3ecea@corrin.poochiereds.net>
	<AANLkTi=6_WKDH9uz4rCTW+BdWf=g91ygdj2N9JOYTima@mail.gmail.com>
	<20101012143942.4370777a@corrin.poochiereds.net>
	<AANLkTik5cX0iy7DgDDiWii6iew7xL51cKwFzV5AiGDB9@mail.gmail.com>
	<20101013075502.2bd625ce@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101013075502.2bd625ce-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/10/13 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Wed, 13 Oct 2010 10:04:05 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2010/10/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> > In interrupt context, we'll read the header down to the MID and lo=
ok up
>> > the request in a table (similar to how we do today in CIFS). For s=
ync
>> > requests, we'll wake up the waiting thread which would copy the he=
ader
>> > info read so far into the buffer, and read the rest of the reply o=
ff
>> > the socket. The smb layer will provide functions that the upper la=
yers
>> > can use to read in the rest of the reply (not 100% sure of the bes=
t way
>> > to do that yet).
>>
>> So, CIFS and SMB2 have the different headers and the different
>> locations of MID fileld. Do you mean that sk_data_ready will be
>> different for them too? Or it will be a common part that reads
>> protocol id from the socket and then move the handling of another pa=
rt
>> (before MID - included) to a protocol specific fun=D3tion?
>>
>
> There are a couple of different ways to do this. The main thing to
> consider is that SMB1 and SMB2 can't coexist on the same socket, so i=
f
> packet comes in and the protocol id looks wrong we can throw that
> packet out.
>
> Essentially though, the goal will be to have as much common code as
> possible. Receiving will be done in stages:
>
> 1) Read in the transport header, get the length of packet
> 2) Read in in the SMB header to a buffer hanging from the socket
> 3) Verify the protocol type and mid, and wake up the process waiting =
on it
> 4) That process will copy the header data received so far to its buff=
er
> =9A and then read in the rest of the data

There are quite a few differences in SMB2 and CIFS in protocol parsing
so we have to be careful.

=46or example, mids are not necessarily unique in cifs, but have been
replaced with an new form of identifier which is large enough in smb2,
there is no cifs equivalent of SMB2 async response, there are packet
signing differences, and SMB2 has a fixed 64 byte header, and SMB2
does not support older style error codes, and SMB2 maximum frame sizes
are much larger.

The read response processing in SMB2 has to support reading into a
page list (due to the very large read sizes that we have to support),
so if we want to move to some common handler code in smb2/cifs then we
still have to have preparsers unique to smb2 and cifs.  Generally I
like the model where only a single process reads from the socket, but
the demultiplex process logic clearly could be simplified.

--=20
Thanks,

Steve
