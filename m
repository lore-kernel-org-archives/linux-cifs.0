From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/4] cifs: warn about impending deprecation of legacy MultiuserMount code
Date: Fri,  6 Jan 2012 14:30:47 -0500
Message-ID: <1325878247-12030-5-git-send-email-jlayton@redhat.com>
References: <1325878247-12030-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325878247-12030-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We'll allow a grace period of 2 releases (3.3 and 3.4) and then remove
the legacy code in 3.5.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 84e8c07..24b3dfc 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -676,14 +676,23 @@ static ssize_t cifs_multiuser_mount_proc_write(struct file *file,
 {
 	char c;
 	int rc;
+	static bool warned;
 
 	rc = get_user(c, buffer);
 	if (rc)
 		return rc;
 	if (c == '0' || c == 'n' || c == 'N')
 		multiuser_mount = 0;
-	else if (c == '1' || c == 'y' || c == 'Y')
+	else if (c == '1' || c == 'y' || c == 'Y') {
 		multiuser_mount = 1;
+		if (!warned) {
+			warned = true;
+			printk(KERN_WARNING "CIFS VFS: The legacy multiuser "
+				"mount code is scheduled to be deprecated in "
+				"3.5. Please switch to using the multiuser "
+				"mount option.");
+		}
+	}
 
 	return count;
 }
-- 
1.7.7.4
