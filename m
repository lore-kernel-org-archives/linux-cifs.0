From: Jarno Malmari <jarno.malmari-qk6XLmcB7GT1KXRcyAk9cg@public.gmane.org>
Subject: Problems using mounted Windows 8.1 share
Date: Mon, 13 Jan 2014 21:55:49 +0200
Message-ID: <CAAM7ENkPpcDRya0T6H06tKSC17pmVRLLq8P9wsD0sUXA+qAgsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Windows 8.1 and Server 2012 R2 shipped with SMB v3.02 and that's the
only relevant part I can see what can be the cause that my CIFS mount
stopped working properly. Problems showed up after upgrade from
Windows 8 to 8.1. (SMB v3.0 -> v3.02)

What use to be smooth user experience is now laggy. Copying 250KB or
1MB file with cp can take 60 seconds, consisting of multiple ~10
second pauses between reads. This applies to other commands as well,
even to those that do not read too much data like "file". Sometimes I
see weird errors from system (translated error message: "machine is
down") in stdout or stderr. No idea where they come from. To make
things difficult, sometimes the commands work ok, although I'm quite
sure they used to be faster.

No errors in syslog, even with CIFS debug output enabled. At least to
my unexperienced eye.

Any experiences with this?


In case it matters, my fstab says:
//server/share                   /mnt                 cifs
user,noauto,soft,credentials=/path/to/credsfile,rw   0       0

Also probably worth noticing is that the Windows lives in a virtual
machine and communicating via dedicated vmware private network
(vmnet1).

Thanks!

-- 
Jarno
