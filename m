From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: [cifs] cifs:  Allow binding to local IP address.
Date: Mon, 30 Aug 2010 22:42:27 -0700
Message-ID: <4C7C9643.4090409@candelatech.com>
References: <1283233222-8702-1-git-send-email-greearb@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283233222-8702-1-git-send-email-greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/30/2010 10:40 PM, Ben Greear wrote:
> When using multi-homed machines, it's nice to be able to specify
> the local IP to use for outbound connections.  This patch gives
> cifs the ability to bind to a particular IP address.
>
>    Usage:  mount -t cifs -o srcaddr=192.168.1.50,user=foo, ...
>    Usage:  mount -t cifs -o srcaddr=2002::100:1,user=foo, ...

I tested IPv6 and IPv4 and it seems to work as designed.

checkpatch warns of a few long lines, but I saw no way to
break them up w/out adding even worse (IMO) cruft.  But,
I can change that if it's important.

Please let me know if any other changes are needed.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
