From: Jeff Blaine <jblaine-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org>
Subject: Read speed
Date: Mon, 04 Feb 2013 20:23:34 -0500
Message-ID: <51105F16.8070603@kickflop.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

On a RHEL 6.3 box talking to a Windows 7 Enterprise box,
I am seeing approximately 1/4th the speed with mount.cifs
as I am with smbclient 'get'. RHEL 6.3 currently has
CIFS 1.68.

After about a half hour of reading forum threads for the
last few years, it seems this is very well known and has
been the case for a long time.

I have tried using CIFSMaxBufSize=61440 with rsize=61140
at mount-time and it doesn't really buy me much.

Is there any sort of public-facing summary of the state of
the read performance issues. I saw no mention of it in the
BUGS section of the mount.cifs man page or in the README for
the kernel module.

Is the cause known?

Has already been fixed since 1.68 by chance? If so,
what assembly of pieces will overcome the issue? Should
I just open a RHEL bug through our support channel and
get them involved in this effort somehow?

Any guidance would be welcome at this point.

Jeff
