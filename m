From: Damjan Dimitrov <damjan.dimitrov-vkGj3nKBv86B+jHODAdFcQ@public.gmane.org>
Subject: cifs multiuser mount issue
Date: Thu, 24 Mar 2016 09:29:45 +0000 (UTC)
Message-ID: <loom.20160324T094958-103@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

We're having a strange issue with a krb5 cifs multiuser mount.
The share is mounted on boot with the computer account keytab.
When a user logs in over SSH everything works perfectly, the share is
accessible and a kerberos ticket is properly requested for the user.

We also use x2go to access the server, where we have long-living xterm
sessions. When a initial such x2go+xterm session is established, the
multiuser cifs mount works ok and a kerberos ticket for the fileserver is
requested. The problem appears when one connects to such a session the next
day. Then the user cannot access the mount and this is logged:
CIFS VFS: Send error in SessSetup = -128

To me it somehow looks like that the krb5 upcall does not work and the cifs
does not try to get a kerberos ticket for the file server.
It's difficult to debug this, I try debugging the cifs module but I cannot
really see anything in the log which can point to the issue.
If needed I can post the CIFS debug messages from a working SSH session and
non-working xterm session.

The OS is: CentOS Linux release 7.1.1503 (3.10.0-229.1.2.el7.x86_64)
Fileserver is Hitachi with Windows AD as user back-end.
mount.cifs version: 6.2

Any hints are greatly appreciated.

Thanks,
Damjan.
