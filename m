From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: check_newline returns EX_USAGE on error, not -1
Date: Fri, 29 Jul 2011 07:14:30 -0400
Message-ID: <1311938070-885-1-git-send-email-jlayton@samba.org>
Cc: jlieskov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reported-by: Jan Lieskovsky <jlieskov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 107a5a5..aa4581f 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1419,8 +1419,7 @@ static int check_newline(const char *progname, const char *name)
 static int check_mtab(const char *progname, const char *devname,
 		      const char *dir)
 {
-	if (check_newline(progname, devname) == -1 ||
-	    check_newline(progname, dir) == -1)
+	if (check_newline(progname, devname) || check_newline(progname, dir))
 		return EX_USAGE;
 	return 0;
 }
-- 
1.7.6
