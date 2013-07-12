From: Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>
Subject: CIFS mounts become inaccessible with "Send error in SessSetup = -128"
Date: Fri, 12 Jul 2013 13:38:18 -0700
Message-ID: <6FF853BB-C6F5-41E4-8310-04BE652F4633@dashbox.com>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I am having some trouble with using krb5, autofs, and cifs together.  I have my credentials set to auto-renew using k5start and when I ssh to the machine I can mount the share after restarting autofs.  The principal used is the computer from Active Directory ie "hostname$".  I've verifed my tgt is always fresh.  However, my scheduled cron job to do rsync to that share always fails.  Often with the error "Key has been revoked".  In my syslog there is the message "CIFS VFS: cifs_mount failed w/return code = -128".  After doing some Googling, I found this link:

https://access.redhat.com/site/solutions/275933

I'm on CentOS (6.4) so I don't have access to the posting.  If you have an idea for a fix I would very much appreciate it.

Thanks,
Doug
