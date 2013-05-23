From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 18/19] cifs: clean up the SecurityFlags write handler
Date: Thu, 23 May 2013 11:06:02 -0400
Message-ID: <1369321563-16893-19-git-send-email-jlayton@redhat.com>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369321563-16893-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The SecurityFlags handler uses an obsolete simple_strtoul() call, and
doesn't really handle the bounds checking well. Fix it to use
kstrtouint() instead. Clean up the error messages as well and fix a
bogus check for an unsigned int to be less than 0.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index d597483..856f8f5 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -598,6 +598,7 @@ static int cifs_security_flags_proc_open(struct inode *inode, struct file *file)
 static ssize_t cifs_security_flags_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
+	int rc;
 	unsigned int flags;
 	char flags_string[12];
 	char c;
@@ -620,26 +621,33 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 			global_secflags = CIFSSEC_MAX;
 			return count;
 		} else if (!isdigit(c)) {
-			cifs_dbg(VFS, "invalid flag %c\n", c);
+			cifs_dbg(VFS, "Invalid SecurityFlags: %s\n",
+					flags_string);
 			return -EINVAL;
 		}
 	}
-	/* else we have a number */
 
-	flags = simple_strtoul(flags_string, NULL, 0);
+	/* else we have a number */
+	rc = kstrtouint(flags_string, 0, &flags);
+	if (rc) {
+		cifs_dbg(VFS, "Invalid SecurityFlags: %s\n",
+				flags_string);
+		return rc;
+	}
 
 	cifs_dbg(FYI, "sec flags 0x%x\n", flags);
 
-	if (flags <= 0)  {
-		cifs_dbg(VFS, "invalid security flags %s\n", flags_string);
+	if (flags == 0)  {
+		cifs_dbg(VFS, "Invalid SecurityFlags: %s\n", flags_string);
 		return -EINVAL;
 	}
 
 	if (flags & ~CIFSSEC_MASK) {
-		cifs_dbg(VFS, "attempt to set unsupported security flags 0x%x\n",
+		cifs_dbg(VFS, "Unsupported security flags: 0x%x\n",
 			 flags & ~CIFSSEC_MASK);
 		return -EINVAL;
 	}
+
 	/* flags look ok - update the global security flags for cifs module */
 	global_secflags = flags;
 	if (global_secflags & CIFSSEC_MUST_SIGN) {
-- 
1.8.1.4
