From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Question on IPv6 failover.
Date: Thu, 03 Oct 2013 14:04:55 -0700
Message-ID: <524DDBF7.5050709@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

One of our users is reporting that the CIFS failover case is not working
properly.  They have a cluster of CIFS servers that migrate an IPv6 addr
to the active system.

Evidently, our client-side CIFS connection follows the first migration,
but fails to go back to the original on a second failover.

It could be any number of things, but I wanted first to see if anyone
knows how long client-side CIFS will keep attempting to regain contact with it's
server?  Forever?

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
