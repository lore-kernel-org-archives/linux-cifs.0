From: Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>
Subject: "mount error(122): Disk quota exceeded" whenever trying to mount.cifs with sec=krb5
Date: Tue, 13 Aug 2013 12:43:53 -0700
Message-ID: <E2CF8DBA-59BE-4113-8854-E3C788238540@dashbox.com>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I am having some trouble with mount.cifs and kerberos.  After a reboot the share will mount via autofs using kerberos and function correctly.  However within 24 hours it will stop working displaying this error in the syslog:

CIFS VFS: Send error in SessSetup = -122
CIFS VFS: cifs_mount failed w/return code = -122

After that happens, if I try to remount it from the command line using mount.cifs and these options I get an error.  The mount command I use is:

mount.cifs -o fstype=cifs,actimeo=0,sec=krb5,cruid=0,uid=0,gid=0,file_mode=0644,dir_mode=0755 //dfs.mydomain.com/backups test --verbose

The error I receive is:

mount error(122): Disk quota exceeded

At any time I can mount using the default non-krb5 sec method and the mount will succeed.  But I can't get sec=krb5 mount to work again until I reboot the machine.

Thank you kindly for any advice,

- Doug
