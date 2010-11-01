From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: New read logic
Date: Mon, 1 Nov 2010 13:07:24 -0500
Message-ID: <AANLkTin3WmGcoTEF0Edg5k3e5dx4Z6o9esCUSgXC2kJZ@mail.gmail.com>
References: <AANLkTimbGk9zKbVBU+Fd-d4XwQdFyEJFzcxi84dVEjQx@mail.gmail.com>
	<20101101131930.18d35c34@tlielax.poochiereds.net>
	<AANLkTinyh5zxKsyZetpN4WwiDMWQ-Y9E-1uu9_dzDQTY@mail.gmail.com>
	<20101101140019.166be768@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101101140019.166be768-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Nov 1, 2010 at 1:00 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 1 Nov 2010 12:41:31 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> My reaction is that over modern networks 1 second attribute timeout =
is
>> probably ok and 60 seconds is too slow (certainly slowing it down
>> beyond 5 seconds could be noticeable to user, not just create a high=
er
>> data integrity risk) - but the obvious exception is over slow
>> networks. =A0 Since we can get the SMB echo times - we could base th=
e
>> value of actimeout 1 second vs 60 second based on what we estimate
>> round trip delay is.
>>
>
> I don't see any connection between the ac timeout and round trip time=
=2E
> The ac timeout needs to be set according to how often you expect file=
s
> to change, and that has no real relation to the RTT between client an=
d
> server.

If a qpathinfo/qfileinfo is not returned in 1 or 2 milliseconds - I can
see your point - but that is why you might want to use round trip
time as a factor in deciding to make attribute timeout visible.
At 1 second, a user rarely notices the timestamp being
"incorrect" (stale due to update of file on other system) - at 60second=
s
it would be very easy for a user to get puzzled why the timestamp
was wrong.   The choice of 1 second was chosen partly to match
ext3 - with the common server file system having 1 second time granular=
ity
always doing queryfileinfo for stat on non-cached files was unnecessary=
=2E
Applications that relied on reflecting subsecond time granularity would=
 be
broken on ext3 anyway.   Going beyond 4 or 5 seconds though, the user
would notice file changes and there is plenty of time for user to go to
one machine change a file, and then get confused why the change
is not reflected on the other.


--=20
Thanks,

Steve
