From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Sat, 3 Mar 2012 21:14:19 -0600
Message-ID: <CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
	<CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com>
	<20120303070921.5ce2bb10@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120303070921.5ce2bb10-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Echo is fairly minor - we rarely send them when mpxcount is "full",
and when we do, usually send only one unless the server is broken.
=46or the case where server has an mpxcount fewer than 4, I can see the
logic of turning off (e.g. turn off oplock, blocking lock and echo if
mpxcount 1, blocking lock and echo if only 2, disable echo if mpxcount
is only 3) similar to the way you described, but sending an echo on a
dead session with a "full" mpx count can't hurt so I don't feel as
strongly about echo as I do about making sure that we disable oplock
and blocking locks if mpxcount is 1.

Making sure that we don't send too many blocking locks should be easy
because there is a posix rc that we can use if we have too many
pending (so for example we can limit to something like 25, and not
hurt Jeff's async read/write perf much).

On the issue of why Samba didn't up maxmpx, I expect it is simply that
until Jeff fixed async read/write, it was rare for a client to send 50
requests in parallel.

On the SMB2 credits vs. CIFS maxmpx topic ...  more than once at the
MS Plugfest I heard pushback on treating SMB2 credits and CIFS maxmpx
similarly - they are totally unrelated.  SMB2 credits are pretty
straightforward - we get them back on every request so they are
constantly changing, but the rules are easier to understand (and are
well documented, where the CIFS maxmpx behavior is only partially
documented).

On Sat, Mar 3, 2012 at 6:09 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Sat, 3 Mar 2012 12:35:50 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2012/2/28 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> > This is going to be more complicated than it seems.
>> >
>> > Apparently (according to Chris), Windows will often allow mapmpx s=
imultaneous
>> > requests per process for various handle based requests. =A0 In add=
ition according
>> > to JRA, Samba server does not care if you go beyond maxmpx (and th=
ere is
>> > a big performance advantage of that). =A0 On the other hand - if t=
he server
>> > sets maxmpx to less than 10, these kind of changes probably make s=
ense
>> > (those servers are probably broken otherwise), but for normal serv=
ers
>> > this will end up restricting more than windows (for more than than=
 the
>> > maxmpx per pid). =A0 Generally, for servers like Samba that suppor=
t
>> > simultaneous requests reasonably we have to be careful about killi=
ng
>> > performance especially now that with Jeff's async reads and writes
>> > we will frequently get up to 50 (and should probably make it easie=
r
>> > to have more than 50 to servers like Samba).
>> >
>> > Quoting JRA and Volker - "You should be able to queue
>> > thousands of simultaneous requests from one client to Samba"
>> > (as long as the client doesn't time out. =A0The server keeps
>> > responding to the earlier requests, so with our client timeout
>> > code weshould be fine).
>> >
>>
>> If Samba supports more than 50 requests on fly why it doens't set
>> MaxMpx count value appropriately (higher that 50). If some servers
>> respect this value, some - not, why this value needs anyway? I reall=
y
>> think that if it exists in the spec we must follow it's logic -
>> support all servers that follow the CIFS/SMB spec.
>>
>
> Yeah, that seems crazy to me too. Why not simply have samba advertise=
 a
> more realistic value of MaxMpx if it's able to support one?
>
>> From another hand, we won't kill the nowdays performance if we
>> substract only 1 slot for echos and 1 slot for oplocks from maxmpx
>> value (we have 48 for Samba anyway). But it helps us to make the cod=
e
>> more common and easily shareble between existing cifs code and new
>> smb2 one (for smb2 we should reserve these 2 slots too).
>>
>> I really think we shouldn't fix all the problems with one patch. Thi=
s
>> patch doesn't make things worse but better: it solves the problem wi=
th
>> 3rd party servers and doesn't make the performance worse (there is n=
o
>> much difference between 48 and 50 simultaneous requests for io
>> operations).
>>
>> While we can change the behavior for some special cases (Samba,
>> Windows) later to make them faster, etc, I think we shouldn't stop o=
n
>> the current patch - it fixes the existing bug and it is the essentia=
l
>> step we should do before SMB2 comes to the tree.
>>
>
> I agree wholeheartedly. Let's code to the spec we have first and only
> afterward worry about adding hacks for servers that deviate from it.
>
> FWIW, I feel that it is absolutely essential that we clean this code =
up
> and get it right before we can merge any further SMB2 code as it's
> fundamental.
>
> Now that said, I think Steve's objection is more related to blocking
> locks than oplock breaks or echoes. The existing code does this in
> wait_for_free_request:
>
> =A0 =A0 =A0 =A0/* update # of requests on the wire to server */
> =A0 =A0 =A0 =A0if (long_op !=3D CIFS_BLOCKING_OP)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_inc(&server->inFlight);
>
> ...so blocking locks are not currently counted against "inFlight". Th=
e
> big question is whether windows clients do something similar here.
>
> If they do then we can probably reasonably assume that most servers
> are designed to deal with that fact. If not, then we'll need to come =
up
> with some way to deal with pessimal cases like this:
>
> Suppose I have a MaxMpx of 50, and a task on the client locks a file.
> Then, 50 more threads go to lock the same file with blocking lock
> calls. At that point all of the slots are presumably consumed. How do
> we ensure that the thread holding the lock can issue an unlock call s=
o
> we can make progress?
>
> Also, suppose we have maxmpx =3D=3D 1. Can we even do blocking locks =
at
> all? A single blocking lock will consume our only slot...
>
> One thing we could consider is to stop using blocking locks at all. O=
r,
> use the Timeout field with a reasonable value of a few seconds and ju=
st
> loop to emulate blocking. It would suck for lock "fairness", but we
> could be reasonably sure that we won't end up sucking up the entire
> maxmpx for long periods of time that way.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Thanks,

Steve
