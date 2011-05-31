From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Tue, 31 May 2011 12:45:37 -0700
Message-ID: <4DE54561.1090906@candelatech.com>
References: <4DE5385C.1030808@candelatech.com> <BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 05/31/2011 12:36 PM, Steve French wrote:
> This is on setting up a session, so could be something like:
> - mount
> - do write
> - server crash
> - attempt to reconnect
> - socket returns ENOSOCK
> - attempt to reconnect ...
> - repeat
>
> Is this repeatable enough that we could modify the client to stop on
> the reconnect to see what is causing the socket to go bad and which
> operation we are repeating the reconnect on.

Well, ENOTSOCK sounds like a pretty serious coding problem.  Maybe
a use-after-close or something?

At the least, we could look for some particular errors (such as ENOTSOCK)
and print more info and do a more thorough job of cleaning up.

Maybe a WARN_ON_ONCE() when the rv is ENOTSOCK as well?

Seems we can reproduce this only when our open-filer HA system
craps itself during failover, but we can get that to happen usually
within hours, sometimes maybe about a day.  And, CIFS errors don't always
happen when the HA cluster goes bad.

So, I'm happy to test patches, but since it's a bit tricky to
reproduce this...I'm hoping to get the best info possible with
each patch iteration!

Thanks,
Ben

>
>
>
> On Tue, May 31, 2011 at 1:50 PM, Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:
>> Kernel is somewhat hacked, but no changes to CIFS.
>>
>>
>> While doing failover testing, we managed to get the cifs client
>> spewing endless serial console spammage.  We can ping the system, but
>> otherwise cannot seem to interact with it.  I tried serial-console sysrq
>> commands (blind, spewage makes it impossible to see any real results) to
>> turn logging to 0, but that didn't help (yet..going to let it run in case
>> there is just a huge backlog of messages).
>>
>> The file-server cluster is in a bad state, but still not excuse
>> for the clients machine to become useless.
>>
>> The spewage is at least primarily:
>>
>> CIFS VFS: Send error in SessSetup = -88
>> CIFS VFS: Send error in SessSetup = -88
>> CIFS VFS: Send error in SessSetup = -88
>> CIFS VFS: Send error in SessSetup = -88
>> CIFS VFS: Send error in SessSetup = -88
>> CIFS VFS: Send error in SessSetup = -88
>> CIFS VFS: Send error in SessSetup = -88
>> CIFS VFS: Send error in SessSetup = -88
>> CIFS VFS: Send error in SessSetup = -88
>>
>> Seems -88 probably means -ENOTSOCK.
>>
>> At the least, perhaps the cERROR() messages
>> should be rate limitted?
>>
>> This one is hard and slow to reproduce, but we'll
>> keep testing..and will try pertinent patches if someone
>> has some suggestions.
>>
>> Thanks,
>> Ben
>>
>> --
>> Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
>> Candela Technologies Inc  http://www.candelatech.com
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>


-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
