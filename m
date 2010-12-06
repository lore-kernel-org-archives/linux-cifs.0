From: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Mon, 6 Dec 2010 05:34:54 +0100
Message-ID: <E1PPSnw-00DDbs-Va@intern.SerNet.DE>
References: <20101203212811.17594274@tlielax.poochiereds.net>
 <E1POnFL-00BKfp-6h@intern.SerNet.DE>
 <AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>
 <20101205210634.602b076b@corrin.poochiereds.net>
 <AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>
Reply-To: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Mon, 6 Dec 2010 05:34:54 +0100
Content-Disposition: inline
In-Reply-To: <AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi!

On Sun, Dec 05, 2010 at 08:16:46PM -0600, Steve French wrote:
> I am more worried about firewall rule changes and similar events
> than about broken servers - but the idea of waiting forever on stat
> to a server that is never going to respond seems odd.

That would be a strange fw rule that allows SMBEcho but not
other SMB requests. I think if someone puts up such a silly
rule, some pain is deserved :-)

Volker
