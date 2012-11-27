From: "Matthew M. DeLoera" <mdeloera-CERpylIU+L8AvxtiuMwx3w@public.gmane.org>
Subject: Terminate 5 minute timeout for CIFS mount to missing server in stab?
Date: Mon, 26 Nov 2012 22:06:02 -0500
Message-ID: <1296DFE4-00F0-43E0-A554-1414D53F077D@exacq.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I searched the archive but only found some discussion regarding "wait indefinitely for responses" from 2010. I hope this isn't a redundant question!

I have a CIFS entry in my fstab to a remote server on my VPN, so it's not available when I'm not connected to my VPN. When not connected, mount -a hangs for about 5 minutes before finally failing with "connection timed out". If I connect my VPN in the middle of that wait, and verify it's connected, mount still hangs for that entire timeout before failing. If I try again, it succeeds.

Is there any issue with kill -9 for the mount -a process, in order to more quickly retry? I was planning to automate it, and to keep retrying until mount succeeds.

Basically, I need quicker failure than 5 minutes, and I can't find any CIFS timeout settings. Any suggestions would be greatly appreciated!

Thanks,
- Matthew
