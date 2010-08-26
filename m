From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: [cifs] cifs: Allow binding to local IP address.
Date: Wed, 25 Aug 2010 20:17:56 -0700
Message-ID: <4C75DCE4.2090100@candelatech.com>
References: <1282777235-20218-1-git-send-email-greearb@candelatech.com> <AANLkTi=m800LPdE47tiPGPT3qfQG7YXC0Q6nh+EXhnx=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=m800LPdE47tiPGPT3qfQG7YXC0Q6nh+EXhnx=@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/25/2010 05:35 PM, Steve French wrote:
> On Wed, Aug 25, 2010 at 6:00 PM, Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:
>> When using multi-homed machines, it's nice to be able to specify
>> the local IP to use for outbound connections.  This patch gives
>> cifs the ability to bind to a particular IP address.
>>
>> Usage:  mount -t cifs -o bindaddr=192.168.1.50,user=foo, ...
>
> Seems like a reasonable idea, but I have a few questions.
> Is there a similar named mount option for other network
> file systems on other operating systems?

I have patches for NFS as well, but they are a bit more complex,
so I was going to start with cifs.

It *seems* that bindaddr is sort of half way expected to work,
for nfs, (but does not on linux, last I checked, without my additional patches).

I've never tried this on any other platform.

> Also don't IPv6 address strings already allow you to specify the local
> interface to use?

I think you still have to do the bind() call somewhere, and I don't
think that is happening in the current cifs code.

If/when I can get the ipv4 stuff in acceptable shape for inclusion,
I'll work on ipv6 (it shouldn't be much additional work).

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
