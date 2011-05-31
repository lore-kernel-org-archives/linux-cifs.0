From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: CIFS endless console spammage in 2.6.38.7
Date: Tue, 31 May 2011 11:50:04 -0700
Message-ID: <4DE5385C.1030808@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Kernel is somewhat hacked, but no changes to CIFS.


While doing failover testing, we managed to get the cifs client
spewing endless serial console spammage.  We can ping the system, but
otherwise cannot seem to interact with it.  I tried serial-console sysrq
commands (blind, spewage makes it impossible to see any real results) to
turn logging to 0, but that didn't help (yet..going to let it run in case
there is just a huge backlog of messages).

The file-server cluster is in a bad state, but still not excuse
for the clients machine to become useless.

The spewage is at least primarily:

CIFS VFS: Send error in SessSetup = -88
CIFS VFS: Send error in SessSetup = -88
CIFS VFS: Send error in SessSetup = -88
CIFS VFS: Send error in SessSetup = -88
CIFS VFS: Send error in SessSetup = -88
CIFS VFS: Send error in SessSetup = -88
CIFS VFS: Send error in SessSetup = -88
CIFS VFS: Send error in SessSetup = -88
CIFS VFS: Send error in SessSetup = -88

Seems -88 probably means -ENOTSOCK.

At the least, perhaps the cERROR() messages
should be rate limitted?

This one is hard and slow to reproduce, but we'll
keep testing..and will try pertinent patches if someone
has some suggestions.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
