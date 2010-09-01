From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs bindaddr v3] cifs: Allow binding to local IP address.
Date: Wed, 1 Sep 2010 11:46:44 -0500
Message-ID: <AANLkTim+LHHW3CNt+JrLPPNM6GyihH-enn3xS8=5+UZZ@mail.gmail.com>
References: <1283284514-25588-1-git-send-email-greearb@candelatech.com>
	<20100901084147.4aa66e9d@corrin.poochiereds.net>
	<4C7E7FDC.7060606@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C7E7FDC.7060606-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 9/1/10, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
> On 09/01/2010 05:41 AM, Jeff Layton wrote:
>> On Tue, 31 Aug 2010 12:55:14 -0700
>> Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:
>>
>>> When using multi-homed machines, it's nice to be able to specify
>>> the local IP to use for outbound connections.  This patch gives
>>> cifs the ability to bind to a particular IP address.
>>>
>>>     Usage:  mount -t cifs -o srcaddr=192.168.1.50,user=foo, ...
>>>     Usage:  mount -t cifs -o srcaddr=2002::100:1,user=foo, ...
<snip>
>>> +			if (saddr6->sin6_family == AF_INET6)
>>> +				printk(KERN_WARNING "cifs: "
>>> +				       "Failed to bind to: %pI6c, error: %d\n",
>>> +				&saddr6->sin6_addr, rc);
>>> +			else
>>> +				printk(KERN_WARNING "cifs: "
>>> +				       "Failed to bind to: %pI4, error: %d\n",
>>> +				&saddr4->sin_addr.s_addr, rc);
>>> +		}
>> 			^^^^^^^^^^^
>> For better or worse, the CIFS code uses the cFYI and cERROR macros for
>> printk's. You should probably do the same here.
>
> If I make these cERROR, will they be printed to /var/log/messages
> and/or dmesg by default if the error case hits?  I definately want this
> visible in the logs by default so users have a chance of figuring out why
> the bind failed.

Use cERROR if you want it to be logged always, cFYI if you only want
it logged when cifs debugging is enabled at run time.

cFYI messages will not be logged unless /proc/fs/cifs/cifsFYI is set
to 1 (it is a flag, CIFS_INFO, so setting cifsFYI to 3, 5, or 7 will
also turn it on these log messages on.  The other flags 0x02 is used
to log entry/exit from cifs functions, and 0x04 for timing related
logging of slow responses).

cERRORs will always be logged (although it could be changed via a
debugger to disable it, users would not disable it)


>> ^^^^
>> The printk's are nice and all, but shouldn't you fail the
>> ipv[4,6]_connect if the socket can't be bound?
>
> Either way is fine with me.  It would be possible for the actual
> connection to still work in the bind-failure case, but it might not
> be what the user would expect.

-- 
Thanks,

Steve
