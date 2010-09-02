From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: [cifs srcaddr-v4] cifs:  Allow binding to local IP address.
Date: Wed, 01 Sep 2010 22:07:29 -0700
Message-ID: <4C7F3111.80808@candelatech.com>
References: <1283367606-14030-1-git-send-email-greearb@candelatech.com>	<20100901171418.44685b74@tlielax.poochiereds.net>	<4C7EC614.6020505@candelatech.com> <20100901203836.2628ce57@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100901203836.2628ce57-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/01/2010 05:38 PM, Jeff Layton wrote:

>> No warning, it always returns something since the default case catches
>> all others.  If I did put the return at the end, then the compiler wouldn't
>> catch a case where I forgot to return from one of the case statements,
>> but it's not overly complex code, so I don't care so much either way.
>> Plz let me know if you still want it at the end.
>>
>> I also think the WARN_ON is valid, because it can only be a coding bug
>> that hits that state, and I'd like it to be as loud as possible while
>> still allowing the user to continue.  There are automated tools that
>> catch WARN_ON output and post to kernel bug trackers, for instance.
>>
>> If you still want a cERROR, I can do that..but I prefer to not waste
>> the space.
>>
>
> It's definitely a coding bug if that fires, but a WARN_ON will mean
> nothing to users. It looks scary and is virtually indistinguishable
> from an oops. We'll get a stack trace, but it's unlikely to tell us
> much.
>
> At that point, you might as well make it a BUG(). At least that way,
> we might get a core dump if it fires.

I'd like to wrap this up.  Please let me know exactly what you want there
and I'll make it so.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
