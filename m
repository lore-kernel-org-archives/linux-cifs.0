From: Michael <mk-cifs-447iRfOSxQ4@public.gmane.org>
Subject: packet signing and DFS referrals
Date: Tue, 3 Dec 2013 10:11:00 +0000 (UTC)
Message-ID: <loom.20131203T105355-222@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dear cifs experts,

I tried to find some more information about my issue but was unsuccesful so far.
We have a mixed Microsoft/Netapp environment with a number of linux clients
were DFS was recently enabled. Kerberos Single-Sign-On is broken here
because of what I believe are incosistencies with packet signing
requirements. The server responsible for the DFS ROOT is requiring signing:

mount -t cifs //master/share mnt -o cruid=someid,sec=krb5,...

mount error(95): Operation not supported
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

[21866613.989219] CIFS VFS: Server requires packet signing to be enabled in
/proc/fs/cifs/SecurityFlags.
[21866613.989401] CIFS VFS: cifs_mount failed w/return code = -95


So I enabled it with krb5i:

mount -t cifs //master/share mnt -o cruid=someid,sec=krb5i,...

But when accessing a dfs referral the next server has no packet signing
enabled (I believe this is the netapp default).

ls mnt/share2
[...]
dmesg | tail -n 2

[21866657.445227] CIFS VFS: signing required but server lacks support
[21866657.445441] CIFS VFS: cifs_mount failed w/return code = -95

Kernel version is 3.2.39-2 and cifs-utils 5.2-1.

My questions are:

 + might this incosistency really be the problem here?
 + are deferral-based security flags supported by the protocol?
 + how to proceed? (besides fixing the environment)

kind regards,
  Michael
