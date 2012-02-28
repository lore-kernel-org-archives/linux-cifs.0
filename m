From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Tue, 28 Feb 2012 11:42:49 -0600
Message-ID: <CAH2r5mvFyw8Cn8nXN9ZBZogBGVr5L5T9aX7Zs8DOiZgDUqGp1Q@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
	<20120228114341.1629ed85@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120228114341.1629ed85-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I think the best way to handle this is to do the special casing
(limiting retries, turning off byte range blocking locks, turning off
oplock) for the servers which do limit maxmpx to small values.   For
maxmpx=3D50 or higher (or if you wish to narrow this, distinguish
servers like Samba more narrowly by check for the unix extensions that
is fine) which shouldn't be stricter than windows (whose client will
exceed 50 simultaneous requests for various cases Chris described).
There is a significant chance of deadlock if we don't allow writes
through due to counting blocking byte range locks against maxmpx too
strictly.   We do have to fix the case of maxmpx =3D 1 or 2 (disable
oplock and possibly echo) and enforce maxmpx for those which set it
lower than 50 - but the byte range lock issue has never come up, and
fixing it the way pavel describes would be stricter than windows and
risk deadlock by chewing up slots.

Another issue is that we are significantly underutilizes Samba by
setting maxmpx so low, but if we expect to move to SMB2 soon, it may
not matter.

On Tue, Feb 28, 2012 at 10:43 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Mon, 27 Feb 2012 18:01:04 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> This is going to be more complicated than it seems.
>>
>> Apparently (according to Chris), Windows will often allow mapmpx sim=
ultaneous
>> requests per process for various handle based requests. =A0 In addit=
ion according
>> to JRA, Samba server does not care if you go beyond maxmpx (and ther=
e is
>> a big performance advantage of that). =A0 On the other hand - if the=
 server
>> sets maxmpx to less than 10, these kind of changes probably make sen=
se
>> (those servers are probably broken otherwise), but for normal server=
s
>> this will end up restricting more than windows (for more than than t=
he
>> maxmpx per pid). =A0 Generally, for servers like Samba that support
>> simultaneous requests reasonably we have to be careful about killing
>> performance especially now that with Jeff's async reads and writes
>> we will frequently get up to 50 (and should probably make it easier
>> to have more than 50 to servers like Samba).
>>
>> Quoting JRA and Volker - "You should be able to queue
>> thousands of simultaneous requests from one client to Samba"
>> (as long as the client doesn't time out. =A0The server keeps
>> responding to the earlier requests, so with our client timeout
>> code weshould be fine).
>>
>
> The problem here though is that we have to code for the lowest common
> denominator. While many servers handle exceeding the maxmpx gracefull=
y,
> a lot don't. The only safe course here is to respect the MaxMpx by
> default since we can't reliably predict what the effect will be if we
> exceed it.
>
> That said, if you want to add some sort of knob (mount option?) later
> that allows the client to override the server-provided maxmpx, then I=
'd
> be ok with that.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>



--=20
Thanks,

Steve
