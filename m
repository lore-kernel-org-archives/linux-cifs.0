From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: show "acl" in DebugData Features when it's compiled in
Date: Fri, 10 Dec 2010 10:26:44 -0500
Message-ID: <1291994804-1634-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and while we're at it, reduce the number of calls into the seq_*
functions by prepending spaces to strings.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 37f7534..bd76527 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -119,29 +119,27 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		    "Display Internal CIFS Data Structures for Debugging\n"
 		    "---------------------------------------------------\n");
 	seq_printf(m, "CIFS Version %s\n", CIFS_VERSION);
-	seq_printf(m, "Features: ");
+	seq_printf(m, "Features:");
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	seq_printf(m, "dfs");
-	seq_putc(m, ' ');
+	seq_printf(m, " dfs");
 #endif
 #ifdef CONFIG_CIFS_FSCACHE
-	seq_printf(m, "fscache");
-	seq_putc(m, ' ');
+	seq_printf(m, " fscache");
 #endif
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
-	seq_printf(m, "lanman");
-	seq_putc(m, ' ');
+	seq_printf(m, " lanman");
 #endif
 #ifdef CONFIG_CIFS_POSIX
-	seq_printf(m, "posix");
-	seq_putc(m, ' ');
+	seq_printf(m, " posix");
 #endif
 #ifdef CONFIG_CIFS_UPCALL
-	seq_printf(m, "spnego");
-	seq_putc(m, ' ');
+	seq_printf(m, " spnego");
 #endif
 #ifdef CONFIG_CIFS_XATTR
-	seq_printf(m, "xattr");
+	seq_printf(m, " xattr");
+#endif
+#ifdef CONFIG_CIFS_ACL
+	seq_printf(m, " acl");
 #endif
 	seq_putc(m, '\n');
 	seq_printf(m, "Active VFS Requests: %d\n", GlobalTotalActiveXid);
-- 
1.7.3.2
