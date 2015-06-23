From: Alex Bligh <alex-rWA27mgs/Jz10XsdtD+oqA@public.gmane.org>
Subject: cifs.ko client failover with CSVFS Windows 2012 R2 server
Date: Tue, 23 Jun 2015 12:54:23 +0100
Message-ID: <558948EF.9010008@alex.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm trying to establish to what extent a cifs.ko linux client will
support failover with a Windows 2012 R2 server, sharing a CSVFS
backend. The symptom a user is seeing here is that the share
works, but the file system does not fail over if the server it
initially mounts goes down (kernel 3.13.0-49-generic, on
Ubuntu 14.04).

This link:
 https://wiki.samba.org/index.php/SMB3_kernel_status#Witness_Notification_Protocol
implies that Witness Notification Protocol should work for a
client if vers=3.02 is passed to mount.cifs. However, the user
seems unable to get failover to work at all (transparently or
otherwise).

Questions:

* Is failover supported on cifs.ko, and if so do I need a newer
  kernel version than 3.13? Are there any special commands needed
  to enable it other than mounting with vers=3?

* Is transparent failover supported on cifs.ko, and do I need
  need a newer version than 3.13? Are there areny special commands
  needed to enable it other than mounting with vers=3.02?

* Is there a 'HOWTO' to debug this? It seems to be hard to search
  for client stuff that works with failover.

-- 
Alex Bligh
