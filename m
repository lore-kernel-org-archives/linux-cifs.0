From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Question on IPv6 failover.
Date: Thu, 3 Oct 2013 21:41:53 -0400
Message-ID: <20131003214153.791c1a7c@corrin.poochiereds.net>
References: <524DDBF7.5050709@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <524DDBF7.5050709-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 03 Oct 2013 14:04:55 -0700
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:

> One of our users is reporting that the CIFS failover case is not working
> properly.  They have a cluster of CIFS servers that migrate an IPv6 addr
> to the active system.
> 
> Evidently, our client-side CIFS connection follows the first migration,
> but fails to go back to the original on a second failover.
> 
> It could be any number of things, but I wanted first to see if anyone
> knows how long client-side CIFS will keep attempting to regain contact with it's
> server?  Forever?
> 

Yep, forever. The address to connect to is determined by the mount
helper and passed down to the kernel at mount time. This is the same
for IPv4 and IPv6. If the address is floating between servers then
it'll just look like the server rebooted when you fail over, and the
client should just keep trying to reconnect indefinitely.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
