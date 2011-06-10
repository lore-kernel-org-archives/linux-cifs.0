From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Fri, 10 Jun 2011 11:55:07 -0700
Message-ID: <4DF2688B.7070604@candelatech.com>
References: <4DE5385C.1030808@candelatech.com>	<BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>	<4DE54561.1090906@candelatech.com>	<20110531164408.178eeebf@tlielax.poochiereds.net>	<BANLkTinyb=tekDwPLqxuSqyQfrgc8MykCw@mail.gmail.com>	<4DE55537.5040705@candelatech.com>	<BANLkTimNgW-Ff_50HeuFqmS7PXXjuLmYVw@mail.gmail.com>	<20110601140139.079287da@tlielax.poochiereds.net>	<4DE67FFE.3040907@candelatech.com>	<20110601150621.7b465941@tlielax.poochiereds.net>	<4DE69041.5070802@candelatech.com>	<4DE94B97.8090302@candelatech.com>	<20110603214204.318602e8@corrin.poochiereds.net>	<4DE9BCAF.10303@candelatech.com>	<20110604071923.777c666f@corrin.poochiereds.net>	<20110606094547.0c04d1c5@tlielax.poochiereds.net>	<4DED04AC.7090508@candelatech.com>	<20110606125143.56da1fdb@tlielax.poochiereds.net>	<4D
 ED0CCA.6090305@candelatech.com> <BANLkTimkinsfojB0=Sf5=o5HBOfiTWTsAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimkinsfojB0=Sf5=o5HBOfiTWTsAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/06/2011 06:00 PM, Steve French wrote:
> Ben,
> Thanks - this may be a very rare case - hard to prove without your testing
> but it looks like Jeff's patch makes sense.

We've had 3+ days of clean failover testing, so I think that
patch did solve the problem.

You are welcome to add my tested-by if you want.

Thanks,
Ben

>
> On Mon, Jun 6, 2011 at 12:22 PM, Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:
>> On 06/06/2011 09:51 AM, Jeff Layton wrote:
>>>
>>> On Mon, 06 Jun 2011 09:47:40 -0700
>>> Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>    wrote:
>>>
>>>> On 06/06/2011 06:45 AM, Jeff Layton wrote:
>>>>>
>>>>> On Sat, 4 Jun 2011 07:19:23 -0400
>>
>>>>> [PATCH] cifs: don't allow cifs_reconnect to exit with NULL socket
>>>>>   pointer
>>>>>
>>>>> It's possible for the following set of events to happen:
>>>>>
>>>>> cifsd calls cifs_reconnect which reconnects the socket. A userspace
>>>>> process then calls cifs_negotiate_protocol to handle the NEGOTIATE and
>>>>> gets a reply. But, while processing the reply, cifsd calls
>>>>> cifs_reconnect again.  Eventually the GlobalMid_Lock is dropped and the
>>>>> reply from the earlier NEGOTIATE completes and the tcpStatus is set to
>>>>> CifsGood. cifs_reconnect then goes through and closes the socket and
>>>>> sets the
>>>>> pointer to zero, but because the status is now CifsGood, the new socket
>>>>> is not created and cifs_reconnect exits with the socket pointer set to
>>>>> NULL.
>>>>>
>>>>> Fix this by only setting the tcpStatus to CifsGood if the tcpStatus is
>>>>> CifsNeedNegotiate, and by making sure that generic_ip_connect is always
>>>>> called at least once in cifs_reconnect.
>>>>>
>>>>> Note that this is not a perfect fix for this issue. It's still possible
>>>>> that the NEGOTIATE reply is handled after the socket has been closed and
>>>>> reconnected. In that case, the socket state will look correct but it no
>>>>> NEGOTIATE was performed on it. In that situation though the server
>>>>> should just shut down the socket on the next attempted send, rather
>>>>> than causing the oops that occurs today.
>>>>>
>>>>> Reported-by: Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
>>>>> Signed-off-by: Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>> ---
>>>>>    fs/cifs/connect.c |    6 +++---
>>>>>    1 files changed, 3 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>>>> index 84c7307..8bb55bc 100644
>>>>> --- a/fs/cifs/connect.c
>>>>> +++ b/fs/cifs/connect.c
>>>>> @@ -152,7 +152,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>>>>>                 mid_entry->callback(mid_entry);
>>>>>         }
>>>>>
>>>>> -       while (server->tcpStatus == CifsNeedReconnect) {
>>>>> +       do {
>>>>>                 try_to_freeze();
>>>>>
>>>>>                 /* we should try only the port we connected to before */
>>>>> @@ -167,7 +167,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>>>>>                                 server->tcpStatus = CifsNeedNegotiate;
>>>>>                         spin_unlock(&GlobalMid_Lock);
>>>>>                 }
>>>>> -       }
>>>>> +       } while (server->tcpStatus == CifsNeedReconnect);
>>>>>
>>>>>         return rc;
>>>>>    }
>>>>> @@ -3371,7 +3371,7 @@ int cifs_negotiate_protocol(unsigned int xid,
>>>>> struct cifs_ses *ses)
>>>>>         }
>>>>>         if (rc == 0) {
>>>>>                 spin_lock(&GlobalMid_Lock);
>>>>> -               if (server->tcpStatus != CifsExiting)
>>>>> +               if (server->tcpStatus == CifsNeedNegotiate)
>>>>>                         server->tcpStatus = CifsGood;
>>>>>                 else
>>>>>                         rc = -EHOSTDOWN;
>>>>
>>>>
>>>> This has some merge issues on 3.6.38.8:
>>>>
>>>>
>>>> <<<<<<<
>>>>         while ((server->tcpStatus != CifsExiting)&&
>>>>         (server->tcpStatus != CifsGood)) {
>>>> =======
>>>>         do {
>>>>   >>>>>>>
>>>>
>>>> Should I keep your comparison for tcpStatus == CifsNeedReconnect
>>>> instead of these != comparisons above?
>>>>
>>>>
>>>> Thanks,
>>>> Ben
>>>>
>>>
>>> No, I think you probably just want to take patch fd88ce9313 too, which
>>> should fix up the merge conflict.
>>
>> Ok, I've applied those two..we'll start testing with these patches
>> today.  Might take a while before we are certain the fix works, as
>> this isn't usually easy or fast to reproduce.
>>
>> Thanks,
>> Ben
>>
>> --
>> Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
>> Candela Technologies Inc  http://www.candelatech.com
>>
>>
>
>
>


-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
