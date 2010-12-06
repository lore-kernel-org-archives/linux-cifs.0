From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Mon, 6 Dec 2010 10:28:15 -0600
Message-ID: <AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<E1POnFL-00BKfp-6h@intern.SerNet.DE>
	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>
	<20101205210634.602b076b@corrin.poochiereds.net>
	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>
	<E1PPSnw-00DDbs-Va@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1PPSnw-00DDbs-Va-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Dec 5, 2010 at 10:34 PM, Volker Lendecke
<Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:
> Hi!
>
> On Sun, Dec 05, 2010 at 08:16:46PM -0600, Steve French wrote:
>> I am more worried about firewall rule changes and similar events
>> than about broken servers - but the idea of waiting forever on stat
>> to a server that is never going to respond seems odd.
>
> That would be a strange fw rule that allows SMBEcho but not
> other SMB requests. I think if someone puts up such a silly
> rule, some pain is deserved :-)

Aaah - remember the proxies that cut out "chatty" smb traffic by
responding on behalf of remote servers in the interest of optimizing
traffic over slow links :)


-- 
Thanks,

Steve
