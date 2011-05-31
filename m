From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Tue, 31 May 2011 13:51:58 -0700
Message-ID: <4DE554EE.3010402@candelatech.com>
References: <4DE5385C.1030808@candelatech.com>	<BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>	<4DE54561.1090906@candelatech.com> <20110531164408.178eeebf@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110531164408.178eeebf-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 05/31/2011 01:44 PM, Jeff Layton wrote:
> On Tue, 31 May 2011 12:45:37 -0700
> Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:
>
>> On 05/31/2011 12:36 PM, Steve French wrote:
>>> This is on setting up a session, so could be something like:
>>> - mount
>>> - do write
>>> - server crash
>>> - attempt to reconnect
>>> - socket returns ENOSOCK
>>> - attempt to reconnect ...
>>> - repeat
>>>
>>> Is this repeatable enough that we could modify the client to stop on
>>> the reconnect to see what is causing the socket to go bad and which
>>> operation we are repeating the reconnect on.
>>
>> Well, ENOTSOCK sounds like a pretty serious coding problem.  Maybe
>> a use-after-close or something?
>>
>> At the least, we could look for some particular errors (such as ENOTSOCK)
>> and print more info and do a more thorough job of cleaning up.
>>
>> Maybe a WARN_ON_ONCE() when the rv is ENOTSOCK as well?
>>
>> Seems we can reproduce this only when our open-filer HA system
>> craps itself during failover, but we can get that to happen usually
>> within hours, sometimes maybe about a day.  And, CIFS errors don't always
>> happen when the HA cluster goes bad.
>>
>> So, I'm happy to test patches, but since it's a bit tricky to
>> reproduce this...I'm hoping to get the best info possible with
>> each patch iteration!
>>
>
> I had a report of a similar problem on a RHEL5 (2.6.18) kernel:
>
>      https://bugzilla.redhat.com/show_bug.cgi?id=704921
>
> In this case, it caused an oops as well. Your problem may or may not be
> the same, but if it is, I suspect that the root cause is a lack of
> clear locking rules for the TCP_Server_Info->tcpStatus.
>
> What I think happened in that case was that the client was in the
> middle of a NEGOTIATE request and got a response, and another reconnect
> occurred while it was processing it. While the client was tearing down
> and creating a new socket, the thread that issued the NEGOTIATE on the
> previous socket marked the tcpStatus as CifsGood.
>
> Fixing it looks to be anything but trivial. I'm not even quite sure how
> to approach it at this point. Suggestions welcome.

Well, I grepped through 2GB of console logs and found no oopses
in my case.

Seems to me that the retry logic either isn't being properly done,
or maybe it's just trying too often and stuck in basically a tight
loop writing logs to the console.  (My HA server cluster is still hosed,
left it busted while debugging this, so there is no way that CIFS can
actually recover the connection as of now.)

If it's just a log-spam tight loop, then rate-limitting the messages
should help, and some timeouts or backoffs should be added to CIFS.

Building new kernels now, and we'll try to reproduce with the
extra debugging code.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
