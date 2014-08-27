From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v4 1/3] cifs: call strtobool instead of custom implementation
Date: Wed, 27 Aug 2014 16:49:42 +0300
Message-ID: <1409147384-20389-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409147384-20389-1-git-send-email-andriy.shevchenko@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>,
	Alexander Bokovoy <ab-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409147384-20389-1-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Meanwhile it cleans up the code, the behaviour is slightly changed. In case of
providing non-boolean value it will fails with corresponding error. In the
original code the attempt of an update was just ignored in such case.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Acked-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Reviewed-by: Alexander Bokovoy <ab-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifs_debug.c | 51 +++++++++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 44ec726..7c50bfa 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -274,6 +274,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
+	bool bv;
 	int rc;
 	struct list_head *tmp1, *tmp2, *tmp3;
 	struct TCP_Server_Info *server;
@@ -284,7 +285,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 	if (rc)
 		return rc;
 
-	if (c == '1' || c == 'y' || c == 'Y' || c == '0') {
+	if (strtobool(&c, &bv) == 0) {
 #ifdef CONFIG_CIFS_STATS2
 		atomic_set(&totBufAllocCount, 0);
 		atomic_set(&totSmBufAllocCount, 0);
@@ -451,15 +452,14 @@ static ssize_t cifsFYI_proc_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
 	char c;
+	bool bv;
 	int rc;
 
 	rc = get_user(c, buffer);
 	if (rc)
 		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		cifsFYI = 0;
-	else if (c == '1' || c == 'y' || c == 'Y')
-		cifsFYI = 1;
+	if (strtobool(&c, &bv) == 0)
+		cifsFYI = bv;
 	else if ((c > '1') && (c <= '9'))
 		cifsFYI = (int) (c - '0'); /* see cifs_debug.h for meanings */
 
@@ -490,15 +490,18 @@ static ssize_t cifs_linux_ext_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
+	bool bv;
 	int rc;
 
 	rc = get_user(c, buffer);
 	if (rc)
 		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		linuxExtEnabled = 0;
-	else if (c == '1' || c == 'y' || c == 'Y')
-		linuxExtEnabled = 1;
+
+	rc = strtobool(&c, &bv);
+	if (rc)
+		return rc;
+
+	linuxExtEnabled = bv;
 
 	return count;
 }
@@ -527,15 +530,18 @@ static ssize_t cifs_lookup_cache_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
+	bool bv;
 	int rc;
 
 	rc = get_user(c, buffer);
 	if (rc)
 		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		lookupCacheEnabled = 0;
-	else if (c == '1' || c == 'y' || c == 'Y')
-		lookupCacheEnabled = 1;
+
+	rc = strtobool(&c, &bv);
+	if (rc)
+		return rc;
+
+	lookupCacheEnabled = bv;
 
 	return count;
 }
@@ -564,15 +570,18 @@ static ssize_t traceSMB_proc_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
 	char c;
+	bool bv;
 	int rc;
 
 	rc = get_user(c, buffer);
 	if (rc)
 		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		traceSMB = 0;
-	else if (c == '1' || c == 'y' || c == 'Y')
-		traceSMB = 1;
+
+	rc = strtobool(&c, &bv);
+	if (rc)
+		return rc;
+
+	traceSMB = bv;
 
 	return count;
 }
@@ -630,6 +639,7 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	unsigned int flags;
 	char flags_string[12];
 	char c;
+	bool bv;
 
 	if ((count < 1) || (count > 11))
 		return -EINVAL;
@@ -642,11 +652,8 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	if (count < 3) {
 		/* single char or single char followed by null */
 		c = flags_string[0];
-		if (c == '0' || c == 'n' || c == 'N') {
-			global_secflags = CIFSSEC_DEF; /* default */
-			return count;
-		} else if (c == '1' || c == 'y' || c == 'Y') {
-			global_secflags = CIFSSEC_MAX;
+		if (strtobool(&c, &bv) == 0) {
+			global_secflags = bv ? CIFSSEC_MAX : CIFSSEC_DEF;
 			return count;
 		} else if (!isdigit(c)) {
 			cifs_dbg(VFS, "Invalid SecurityFlags: %s\n",
-- 
2.1.0
