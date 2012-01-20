From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Trouble accessing Buffalo NAS with CIFSFS
Date: Fri, 20 Jan 2012 13:42:17 -0600
Message-ID: <CAH2r5mt5KPtK_5Abz8nz_sKH3vT2h=1d7DHHBvX4BSRd37auug@mail.gmail.com>
References: <20120119090752.9b7aea6c.ralda@gmx.de>
	<20120119070543.662a3c56@tlielax.poochiereds.net>
	<20120120113042.0fdfea5f.ralda@gmx.de>
	<20120120101938.7ca7464d@tlielax.poochiereds.net>
	<20120120165657.00042c72.ralda@gmx.de>
	<20120120111936.5329cbb4@tlielax.poochiereds.net>
	<20120120200626.b04b1d40.ralda@gmx.de>
	<20120120143235.1d4d811e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120120143235.1d4d811e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jan 20, 2012 at 1:32 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On Fri, 20 Jan 2012 20:06:26 +0100
> "ralda-Mmb7MZpHnFY@public.gmane.org" <ralda-Mmb7MZpHnFY@public.gmane.org> wrote:
>
>> Hallo Jeff!
>>
>> > At this point, I'd suggest just setting the cifs_max_pending modul=
e
>> > parm low =A0(1 or 2) and seeing if that helps. If it does, then th=
at
>> > should basically emulate the effect of steve's eventual patch. If =
it
>> > doesn't then we'll probably need to have a closer look at why it i=
sn't.
>>
>> I have set cifs_max_pending to 2 (setting it 1 results in value 2).
>> Giving interesting results:
>>
>> Normal mount/cp of single file works (same mount parameter as before=
).
>>
>> Copying several files with midnight commander showed me a copy speed=
 of
>> 4.5 to 5.6 MByte per second - start at 4.5 and raising quickly to 5.=
6).
>> This speed is higher then ever received on copying to the same NAS
>> station from same hardware installation. Formerly (kernel 2.6.18
>> SMBFS) copies startet below 3.5 MBps and raised slowly up to about 4
>> MBps (or slightly above - only at very big files). So reducing the
>> setting of cifs_max_pendig not only let the drive work it additional=
ly
>> gave me a big step in speed optimization.
>>
>
> Not sure why that would be unless requests were sometimes getting
> dropped on the floor and the client was occasionally able to recover.
>
>> ... but: Switching virtual console during copy process let the copy
>> stop with a stuck mc as before. The only difference: After killing t=
he
>> process and a delay of about 2 minutes (felt, not measured) the proc=
ess
>> disappeared and NAS drive returned to a working state without system
>> reboot.
>>
>> If you like/need I may catch more data for diagnosis tomorrow. Just =
let
>> me know what you need and how I shall test. I'm willing to give you =
all
>> data for diagnosis I'm able to collect.
>>
>
> This is certainly a very troublesome device :)
>
> I think the existing code is wrong in that it sets the floor value to=
o
> high (2 when it should be 1). The problem we get into however is that
> when the server can't handle concurrent requests, we must disable
> certain features.
>
> We've discussed this on the list before, but we probably ought to do
> something like this depending on what the server sends for the maxmpx
> value:
>
> maxmpx >=3D 3: normal operation
>
> maxmpx =3D 2: disable oplocks, since doing writes while there's still=
 an
> outstanding open is problematic
>
> maxmpx =3D 1: disable sending smb echoes. This does mean that we can'=
t do
> detection of unresponsive servers correctly, but there's not much els=
e
> we can do at that point.
>
> Steve, what's going on with that patch? It's been many months since w=
e
> discussed it last. Do you have anything that Harald can test?

I thought I put an earlier version of this on list, but I did run
into problems with it and async write.   I do want to combine
this with bumping the global value of maximum requests so
we use the minimum of the server value and what we set
but servers which handle more simultaneous requests
benefit.

As you note, a server device which can't handle 3 simultaneous requests
is basically broken, but if it lowers support cost for us on the
client to stumble through with
oplock off and echo off (to those ancient servers), it may be better
than failing mount
or setting the value to a "reasonable minimum" (2 or 3).  There may be =
servers
which just have a bug and set it to 1, when in fact they would allow th=
e case
you describe, pending open, write and echo - but we may be able to get =
away with
an implied minimum value of 2 (where we always assume the server can ha=
ndle echo
plus one other request).   In any case we need to warn on this.  I will=
 code up
something this weekend.  IIRC Samba and Windows don't enforce maxmpx  (=
and
it gets really complicated for Windows as a server due to their queuing=
 problems
as we saw from the delayed response on the dochelp request).  By far th=
e
biggest issue is throttling our requests back to some versions of
Windows (XP or Vista?)
which set it to 10 and although more than 10 works, they have strange
problems when
it hits 25 or so simultaneous (and these servers are far more common).

Ideas how to test this (since I don't have one of the ancient NAS that =
have
this 1 request limit).
requests


--=20
Thanks,

Steve
