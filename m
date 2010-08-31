From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: [cifs] cifs:  Allow binding to local IP address.
Date: Tue, 31 Aug 2010 12:21:12 -0700
Message-ID: <4C7D5628.5070808@candelatech.com>
References: <1283233222-8702-1-git-send-email-greearb@candelatech.com>	<20100831100649.3c9121df@corrin.poochiereds.net>	<4C7D3177.7070906@candelatech.com> <20100831145023.09253a26@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100831145023.09253a26-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/31/2010 11:50 AM, Jeff Layton wrote:
> On Tue, 31 Aug 2010 09:44:39 -0700

> What may be best instead is to just set sa_family to AF_UNSPEC when
> it's not specified. An sa_family that was AF_INET or AF_INET6 would
> imply that it had been specified. That way someone could reasonably
> force a ->bind to occur to INADDR_ANY (as silly as that sounds).

Ok, I'll do that.

>> It just seems cleaner in general to set it to known value in case errors
>> later in that method keep us from setting it to a proper new value.
>> And, certainly useful if it can be set twice somehow..but not sure if that's
>> currently the case or not.
>>
>
> Fair enough. There's probably no need to zero this out entirely though.
> Setting the family to AF_UNSPEC should be sufficient.

Will do that in next patch.

>>>> -match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
>>>> +srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
>>>> +{
>>>> +	if (cifs_addr_is_specified(srcaddr)) {
>>>
>>> 	Just wondering what the expected behavior would be here...
>>>
>>> 	Suppose I have a clustered IP address set up, and I want to
>>> 	ensure that one of my CIFS mounts use that as the srcaddr. Now,
>>> 	suppose I make another mount to the same server, but don't
>>> 	specify the srcaddr there. That mount uses the same socket as
>>> 	the first one (that is bound to the srcaddr). Now, suppose I
>>> 	unmount the first mount and then fail over the IP address. What
>>> 	happens to the second one? (Nothing good, I'd wager...)
>>>
>>> 	Perhaps we should consider using a different socket when the
>>> 	srcaddr isn't specified?
>>
>> The idea is that each mount with unique source addr gets it's own
>> cifs session.  They will not be shared even if the server is the
>> same.  If srcaddr isn't specified, then you get today's behaviour
>> (shared so long as server is the same).
>>
>> In your example, the bound and the un-bound shouldn't share anything,
>> but it's possible my code doesn't fully do that.  If so, I would
>> consider that a bug.
>>
>
> Ok, I think that is a bug here. srcip_matches returns true when
> cifs_addr_is_specified returns false. So if you don't specify a
> srcaddr= option, you'll match any session, right?

Ok, I think you're right, I'll work on a fix and post a new
patch shortly.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
