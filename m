From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [Samba] mount.cifs ms dfs and failover
Date: Mon, 3 Sep 2012 17:18:06 -0700
Message-ID: <20120903171806.3375f21b@corrin.poochiereds.net>
References: <BLU167-W53498C0F715676FA922716C1DA0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sam Abed <samsabed-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BLU167-W53498C0F715676FA922716C1DA0-MsuGFMq8XAE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 18 Jul 2012 17:31:28 +1000
Sam Abed <samsabed-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org> wrote:

> 
> Hello,
>   I can't find any reference on if linux understands multiple targets when it mounts a MS dfs share, specifically if it can failover.
> I can mount a MS dfs share fine, however if the server "picked" is shutdow the mount hangs. I tried it on a recent ubuntu to discount the "enterprise" lag.
> 
> am I missing something or is it not working
> 

(cc'ing linux-cifs)

No, there's currently no support for failover with Linux CIFS DFS code.
Once it picks the server, it stays with it.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
