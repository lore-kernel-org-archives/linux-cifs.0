From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] cifs: don't perform SMB echoes on un-negotiated socket
Date: Mon, 7 Feb 2011 12:36:22 -0600
Message-ID: <AANLkTikD-Q9A5VxfkbkL-Yg9CjwCTNSoyA9W2biHCOA2@mail.gmail.com>
References: <1297086876-19165-1-git-send-email-jlayton@redhat.com>
	<AANLkTi=zs7KZjTnysqxpnGam+2Mv3FRTCKZcY8fB0uFU@mail.gmail.com>
	<20110207132036.7af97f8f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jg-9fI4heB6ewM@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110207132036.7af97f8f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 7, 2011 at 12:20 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 7 Feb 2011 11:42:05 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, Feb 7, 2011 at 7:54 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> > Commit 247ec9b4 makes the SMB echo workqueue job skip doing echoes
>> > unless the tcpStatus =3D=3D CifsGood. Problem: tcpStatus =3D=3D Ci=
fsGood is not
>> > a reliable indicator of whether the socket has had a NEGOTIATE don=
e on
>> > it. This fixes that by adding a new tcpStatus of CifsNeedNegotiate=
 that
>> > indicates this. It also cleans up cifs_reconnect_tcon a bit.
>> >
>> > This is not the only way to fix this issue. As Steve pointed out t=
o me,
>> > we could also check to see whether there's a valid SMB session on =
the
>> > list as an indicator of whether a NEGOTIATE has been done. I think=
 the
>> > approach I'm proposing clarifies the code better, but I'm willing =
to go
>> > with his approach if that's the general concensus.
>>
>> Jeff may be right that the code is clearer with this approach (I may=
 try
>> to code the alternative to check) but ... we really shouldn't be sen=
ding
>> an SMBecho between negprot and sessionsetup anyway (so checking for
>> sessionsetup may make sense).
>> =A0If a negprot times out or
>> sessionsetup times out we don't need to be sending SMBecho
>> (on the other hand perhaps a really slow krb5 sessionsetup?)
>> Once a sessionsetup is sent, SMBechos make more sense.
>>
>
> Why shouldn't we send one between the negotiate and session setup? Th=
e
> MS-CIFS spec makes no mention that a session setup is required prior =
to
> doing an echo. You may be correct, but that's not really what the spe=
c
> says.

I don't remember ever having seen one between negprot and sessionsetup
from other clients - but the broader point is that an SMBecho doesn't
serve any purpose in between negprot/sessionsetup (once at least one
session is setup, checking if the server stays up is more interesting)


--=20
Thanks,

Steve
