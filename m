From: Uri Simchoni <urisimchoni-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cifs-utils: clarify use of backupuid and backupgid
Date: Thu, 19 Nov 2015 21:48:14 +0200
Message-ID: <1447962495-14738-1-git-send-email-uri@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Uri Simchoni <uri-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,
Attached pls find a patch which, I hope, clarifies the use of  backupuid
and backupgid mount options. On reading the current manpage, it seemed to
me like backup intent is always attempted and only specifying those options
would restrict the use of backup intent, where as the behavior, I believe,
is quite the reverse - only if those parameters are specified, users matching
those parameters (and only those users) will open files with backup intent.

Uri Simchoni (1):
  manpage: clarify use of backupuid and backupgid in mount.cifs.8

 mount.cifs.8 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.4.3
