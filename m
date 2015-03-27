From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Problem with mount.cifs in Fedora 19.
Date: Fri, 27 Mar 2015 10:18:18 -0700
Message-ID: <551590DA.8040402@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello!

A user of our CIFS test gear reported a problem when testing against
a filer that is not using a password.

A Fedora-14 machine has a mount.cifs on it that just mounts fine and does
not ask for password.

But, Fedora 19's mount.cifs will ask for password (and fail the mount anyway
if you enter a blank password).

Any idea what might be the issue?

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
