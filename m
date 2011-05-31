From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Tue, 31 May 2011 15:51:05 -0500
Message-ID: <BANLkTinyb=tekDwPLqxuSqyQfrgc8MykCw@mail.gmail.com>
References: <4DE5385C.1030808@candelatech.com>
	<BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>
	<4DE54561.1090906@candelatech.com>
	<20110531164408.178eeebf@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110531164408.178eeebf-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, May 31, 2011 at 3:44 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 31 May 2011 12:45:37 -0700
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
>
>> On 05/31/2011 12:36 PM, Steve French wrote:
>> > This is on setting up a session, so could be something like:
>> > - mount
>> > - do write
>> > - server crash
>> > - attempt to reconnect
>> > - socket returns ENOSOCK
>> > - attempt to reconnect ...
>> > - repeat
>> >
>> > Is this repeatable enough that we could modify the client to stop =
on
>> > the reconnect to see what is causing the socket to go bad and whic=
h
>> > operation we are repeating the reconnect on.
>>
>> Well, ENOTSOCK sounds like a pretty serious coding problem. =A0Maybe
>> a use-after-close or something?
>>
>> At the least, we could look for some particular errors (such as ENOT=
SOCK)
>> and print more info and do a more thorough job of cleaning up.
>>
>> Maybe a WARN_ON_ONCE() when the rv is ENOTSOCK as well?
>>
>> Seems we can reproduce this only when our open-filer HA system
>> craps itself during failover, but we can get that to happen usually
>> within hours, sometimes maybe about a day. =A0And, CIFS errors don't=
 always
>> happen when the HA cluster goes bad.
>>
>> So, I'm happy to test patches, but since it's a bit tricky to
>> reproduce this...I'm hoping to get the best info possible with
>> each patch iteration!
>>
>
> I had a report of a similar problem on a RHEL5 (2.6.18) kernel:
>
> =A0 =A0https://bugzilla.redhat.com/show_bug.cgi?id=3D704921
>
> In this case, it caused an oops as well. Your problem may or may not =
be
> the same, but if it is, I suspect that the root cause is a lack of
> clear locking rules for the TCP_Server_Info->tcpStatus.
>
> What I think happened in that case was that the client was in the
> middle of a NEGOTIATE request and got a response, and another reconne=
ct
> occurred while it was processing it. While the client was tearing dow=
n
> and creating a new socket, the thread that issued the NEGOTIATE on th=
e
> previous socket marked the tcpStatus as CifsGood.
>
> Fixing it looks to be anything but trivial. I'm not even quite sure h=
ow
> to approach it at this point. Suggestions welcome.

I thought the kernel was more recent than that - how recent is the kern=
el here?

I think something related to cifs_sendv returning ENOTSOCK immediately
when not reconnected could be related.



--=20
Thanks,

Steve
