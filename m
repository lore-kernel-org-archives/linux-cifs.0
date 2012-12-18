From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: eliminate cifsERROR variable
Date: Tue, 18 Dec 2012 06:48:37 -0500
Message-ID: <1355831317-21985-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's always set to "1" and there's no way to change it to anything else.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.h | 6 +-----
 fs/cifs/cifsfs.c     | 1 -
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 86e92ef..69ae3d3 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -37,7 +37,6 @@ void dump_smb(void *, int);
 #define CIFS_TIMER	0x04
 
 extern int cifsFYI;
-extern int cifsERROR;
 
 /*
  *	debug ON
@@ -64,10 +63,7 @@ do {									\
 
 /* error event message: e.g., i/o error */
 #define cifserror(fmt, ...)						\
-do {									\
-	if (cifsERROR)							\
-		printk(KERN_ERR "CIFS VFS: " fmt "\n", ##__VA_ARGS__);	\
-} while (0)
+	printk(KERN_ERR "CIFS VFS: " fmt "\n", ##__VA_ARGS__);		\
 
 #define cERROR(set, fmt, ...)						\
 do {									\
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ce9f3c5..f653835 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -54,7 +54,6 @@
 #endif
 
 int cifsFYI = 0;
-int cifsERROR = 1;
 int traceSMB = 0;
 bool enable_oplocks = true;
 unsigned int linuxExtEnabled = 1;
-- 
1.7.11.7
